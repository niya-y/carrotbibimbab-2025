import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io'; // File 클래스 사용
import 'dart:convert'; // JSON 인코딩/디코딩
import 'package:http/http.dart'
    as http; // HTTP 요청 (현재는 시뮬레이션용이지만, 실제 API 연동 시 사용)
import 'package:initial_bf/constants/app_colors.dart';
import 'package:initial_bf/constants/app_text_styles.dart';
import 'package:initial_bf/models/analysis_result.dart'; // ⭐ 데이터 모델 임포트

// 백엔드 URL 설정 (실제 AI 분석 API 엔드포인트로 변경하세요)
// 현재는 시뮬레이션 중이므로 이 변수는 직접 사용되지 않습니다.
// 실제 API 연동 시 http.MultipartRequest('POST', Uri.parse(_analysisApiUrl)); 와 같이 사용됩니다.
const String _analysisApiUrl = 'YOUR_BACKEND_AI_ANALYSIS_API_ENDPOINT_HERE';

class AnalysisLoadingScreen extends StatefulWidget {
  final String imagePath; // 분석할 이미지 파일의 경로

  const AnalysisLoadingScreen({super.key, required this.imagePath});

  @override
  State<AnalysisLoadingScreen> createState() => _AnalysisLoadingScreenState();
}

class _AnalysisLoadingScreenState extends State<AnalysisLoadingScreen> {
  String _statusMessage = '사진을 서버로 전송 중...'; // 현재 진행 상태 메시지
  double _progress = 0.0; // 진행률 (선택 사항, API가 진행률을 제공하는 경우)

  @override
  void initState() {
    super.initState();
    _startAnalysis(); // 화면이 처음 로드될 때 분석 시작
  }

  // 💡 [핵심 로직] AI 분석 시작
  Future<void> _startAnalysis() async {
    try {
      setState(() {
        _statusMessage = 'AI가 사진을 분석 중입니다...';
        _progress = 0.3; // 진행률 업데이트 (임시)
      });

      // ----- [시작] 백엔드 API 호출 시뮬레이션 로직 (실제 API 연동 전까지 사용) -----
      print('백엔드 API 호출 시뮬레이션 시작...');
      await Future.delayed(const Duration(seconds: 3)); // 3초간 로딩 시뮬레이션

      // 백엔드로부터 받았다고 가정하는 더미 JSON 데이터
      final dummyJsonResponse = {
        "personalColor": "가을 웜 뮤트",
        "skinTone": "22호 뉴트럴 톤",
        "skinConcerns": [
          {
            "name": "모공",
            "score": 85,
            "description": "T존 부위의 모공이 다소 넓은 편입니다. 꾸준한 클렌징이 중요해요."
          },
          {
            "name": "주름",
            "score": 70,
            "description": "눈가에 옅은 주름이 관찰됩니다. 아이크림 사용을 추천합니다."
          },
          {
            "name": "붉은기",
            "score": 90,
            "description": "볼 주변에 붉은기가 많아 진정 관리가 필요합니다."
          },
        ]
      };
      // ----- [끝] 백엔드 API 호출 시뮬레이션 로직 -----

      // ⭐ 이 부분은 실제 API 연동 시 아래 주석 처리된 코드로 교체해야 합니다.
      // 1. 이미지 파일 준비
      // File imageFile = File(widget.imagePath);
      // if (!await imageFile.exists()) {
      //   throw Exception('이미지 파일을 찾을 수 없습니다: ${widget.imagePath}');
      // }
      //
      // // 2. 백엔드 API 호출
      // var request = http.MultipartRequest('POST', Uri.parse(_analysisApiUrl));
      // request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      // // 필요한 경우 헤더 추가
      // // request.headers['Authorization'] = 'Bearer YOUR_AUTH_TOKEN';
      // // request.headers['x-api-key'] = 'YOUR_API_KEY';
      //
      // var response = await request.send();
      //
      // if (response.statusCode == 200) {
      //   String responseBody = await response.stream.bytesToString();
      //   var analysisJson = jsonDecode(responseBody);
      //   final analysisResult = AnalysisResult.fromJson(analysisJson); // 실제 API 응답을 모델로 변환
      //
      //   setState(() {
      //     _statusMessage = '분석이 완료되었습니다!';
      //     _progress = 1.0;
      //   });
      //
      //   if (mounted) {
      //     context.go('/analysis/result', extra: analysisResult);
      //   }
      // } else {
      //   String errorBody = await response.stream.bytesToString();
      //   throw Exception('분석 실패: 서버 응답 ${response.statusCode}, 메시지: $errorBody');
      // }

      // 1. 받은 JSON 데이터를 AnalysisResult 모델 객체로 변환 (시뮬레이션 데이터 사용)
      final analysisResult = AnalysisResult.fromJson(dummyJsonResponse);

      setState(() {
        _statusMessage = '분석이 완료되었습니다!';
        _progress = 1.0;
      });

      // 2. 분석 결과 객체를 다음 화면으로 전달하며 이동
      if (mounted) {
        context.go('/analysis/result', extra: analysisResult);
      }
    } catch (e) {
      // 예외 처리 (네트워크 오류, 파일 없음 등)
      setState(() {
        _statusMessage = '분석 중 오류가 발생했습니다: $e';
        _progress = 0.0;
      });
      _showErrorAndNavigateBack(context, '분석 실패: $e');
    }
  }

  void _showErrorAndNavigateBack(BuildContext context, String errorMessage) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      Future.delayed(const Duration(seconds: 3), () {
        if (context.mounted) {
          context.pop(); // 현재 화면을 닫고 이전 화면으로 돌아감
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // 배경색 지정
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 로딩 애니메이션
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                strokeWidth: 5,
              ),
              const SizedBox(height: 30),
              // 진행 상황 텍스트
              Text(
                _statusMessage,
                style:
                    AppTextStyles.headline4.copyWith(color: AppColors.textDark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // 진행률 바 (선택 사항)
              // API가 정확한 진행률을 제공한다면 _progress 값을 사용하여 표시할 수 있습니다.
              // LinearProgressIndicator(
              //   value: _progress,
              //   backgroundColor: AppColors.lightGrey,
              //   valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
