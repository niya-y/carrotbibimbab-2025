import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // 카메라 패키지
import 'package:image_picker/image_picker.dart'; // 갤러리 선택 패키지
import 'package:go_router/go_router.dart'; // 라우팅
import 'dart:io'; // File 클래스 사용
import 'package:path/path.dart' show join; // 경로 결합
import 'package:path_provider/path_provider.dart'; // 임시 디렉토리 경로

import 'package:initial_bf/constants/app_colors.dart'; // 디자인 시스템
import 'package:initial_bf/constants/app_text_styles.dart'; // 디자인 시스템
import 'package:initial_bf/screens/analysis/photo_confirm_screen.dart'; // 다음 페이지

// 전역 변수로 사용 가능한 카메라 목록
List<CameraDescription> cameras = [];

class PhotoCaptureScreen extends StatefulWidget {
  const PhotoCaptureScreen({super.key});

  @override
  State<PhotoCaptureScreen> createState() => _PhotoCaptureScreenState();
}

class _PhotoCaptureScreenState extends State<PhotoCaptureScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 앱 라이프사이클 옵저버 등록
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // 사용 가능한 카메라 목록 가져오기
    cameras = await availableCameras();
    if (cameras.isEmpty) {
      // 카메라가 없는 경우 처리
      _showErrorSnackBar('사용 가능한 카메라가 없습니다.');
      return;
    }

    // 보통 첫 번째 카메라(후면) 사용
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium, // 해상도 설정
      enableAudio: false, // 오디오는 퍼스널 컬러 분석에 필요 없으므로 비활성화
    );

    _initializeControllerFuture = _cameraController!.initialize();
    if (mounted) {
      setState(() {});
    }

    _initializeControllerFuture?.then((_) {
      if (!mounted) return;
      // 카메라 초기화 후 스트리밍 시작 (필요 시)
      // _cameraController!.startImageStream((image) => _processCameraImage(image));
    }).catchError((e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            _showErrorSnackBar('카메라 접근 권한이 거부되었습니다. 설정에서 허용해주세요.');
            break;
          default:
            _showErrorSnackBar('카메라 초기화 오류: ${e.description}');
            break;
        }
      } else {
        _showErrorSnackBar('알 수 없는 카메라 초기화 오류: $e');
      }
    });
  }

  // 앱 라이프사이클 변화 감지
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose(); // 앱이 비활성화되면 카메라 해제
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera(); // 앱이 다시 활성화되면 카메라 재초기화
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 옵저버 해제
    _cameraController?.dispose(); // 위젯이 dispose될 때 카메라 컨트롤러 해제
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  // 💡 [핵심 로직] 사진 촬영
  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) {
      _showErrorSnackBar('카메라가 준비되지 않았습니다.');
      return;
    }

    try {
      // 촬영 전에 컨트롤러 초기화가 완료되었는지 확인
      await _initializeControllerFuture;

      final XFile image = await _cameraController!.takePicture();
      _navigateToPhotoConfirmScreen(image.path); // 촬영된 사진 경로로 이동
    } on CameraException catch (e) {
      _showErrorSnackBar('사진 촬영 오류: ${e.description}');
    } catch (e) {
      _showErrorSnackBar('알 수 없는 사진 촬영 오류: $e');
    }
  }

  // 💡 [핵심 로직] 갤러리에서 이미지 선택
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _navigateToPhotoConfirmScreen(image.path); // 선택된 사진 경로로 이동
      }
    } catch (e) {
      _showErrorSnackBar('갤러리에서 이미지 선택 오류: $e');
    }
  }

  // 확인 화면으로 이동
  void _navigateToPhotoConfirmScreen(String imagePath) {
    if (mounted) {
      context.push('/analysis/confirm', extra: imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사진 촬영 및 선택', style: AppTextStyles.body),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // 카메라가 초기화되면 프리뷰를 표시
            if (_cameraController != null &&
                _cameraController!.value.isInitialized) {
              return Stack(
                children: [
                  // 1. 카메라 프리뷰 (화면 전체를 채움)
                  Positioned.fill(
                    child: AspectRatio(
                      aspectRatio: _cameraController!.value.aspectRatio,
                      child: CameraPreview(_cameraController!),
                    ),
                  ),
                  // 2. 가이드라인 오버레이 (퍼스널 컬러 분석에 필요한 얼굴 위치 등)
                  _buildGuidelineOverlay(),
                  // 3. 하단 컨트롤 영역
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildControlPanel(),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('카메라를 사용할 수 없습니다.'));
            }
          } else if (snapshot.hasError) {
            return Center(child: Text('카메라 초기화 오류: ${snapshot.error}'));
          } else {
            // 초기화 중에는 로딩 스피너 표시
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  // 가이드라인 오버레이 위젯
  Widget _buildGuidelineOverlay() {
    return IgnorePointer(
      // 이 오버레이는 터치 이벤트를 막지 않음
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70, width: 2),
                borderRadius: BorderRadius.circular(125), // 원형 가이드라인
              ),
              child: const Center(
                child: Text(
                  '얼굴을 원 안에 맞춰주세요',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '정확한 분석을 위해 밝은 곳에서 촬영해주세요.',
              style: AppTextStyles.body.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // 하단 컨트롤 패널 위젯
  Widget _buildControlPanel() {
    return Container(
      color: Colors.black54, // 반투명 검은색 배경
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 갤러리 버튼
          IconButton(
            icon:
                const Icon(Icons.photo_library, color: Colors.white, size: 30),
            onPressed: _pickImageFromGallery,
            tooltip: '갤러리에서 선택',
          ),
          // 촬영 버튼
          FloatingActionButton(
            heroTag: 'captureButton', // 같은 화면에 여러 FloatingActionButton이 있을 때 필요
            onPressed: _takePicture,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            child: const Icon(Icons.camera, size: 35),
          ),
          // 카메라 전환 버튼 (전면/후면)
          IconButton(
            icon: const Icon(Icons.flip_camera_ios,
                color: Colors.white, size: 30),
            onPressed: () async {
              if (cameras.length > 1) {
                final newCamera = _cameraController!.description == cameras[0]
                    ? cameras[1]
                    : cameras[0];
                if (_cameraController != null) {
                  await _cameraController!.dispose();
                }
                _cameraController = CameraController(
                  newCamera,
                  ResolutionPreset.medium,
                  enableAudio: false,
                );
                _initializeControllerFuture = _cameraController!.initialize();
                if (mounted) {
                  setState(() {});
                }
              } else {
                _showErrorSnackBar('전환할 카메라가 없습니다.');
              }
            },
            tooltip: '카메라 전환',
          ),
        ],
      ),
    );
  }
}
