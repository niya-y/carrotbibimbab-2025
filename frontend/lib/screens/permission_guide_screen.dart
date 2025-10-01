// lib/screens/permission_guide_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart'; // ⭐ permission_handler 임포트

class PermissionGuideScreen extends StatelessWidget {
  const PermissionGuideScreen({super.key});

  // 💡 [핵심 로직] 권한을 요청하고 결과에 따라 다음 동작을 수행하는 함수
  Future<void> _requestPermissions(BuildContext context) async {
    // 1. 요청할 권한 목록을 정의합니다. (카메라, 사진 접근)
    // Permission.photos 대신 Permission.photosAddOnly를 사용할 수도 있습니다.
    // 이는 '사진 추가만 허용'할지 '모든 사진 접근 허용'할지에 따라 다릅니다.
    // 여기서는 일반적인 앱 사용을 위해 Permission.photos를 사용합니다.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission
          .photos, // 또는 Permission.mediaLibrary (iOS), Permission.storage (Android < R)
    ].request(); // 여러 권한을 동시에 요청합니다.

    // 2. 모든 요청된 권한이 허용되었는지 확인합니다.
    bool isAllGranted = statuses.values.every((status) => status.isGranted);

    if (isAllGranted) {
      // ✅ 모든 권한이 허용되었다면, 다음 화면(로그인/회원가입)으로 이동합니다.
      // '/auth' 경로는 app_router.dart에 임시로 정의해두었습니다.
      if (context.mounted) {
        // 위젯이 여전히 활성 상태인지 확인하는 안전장치
        context.go('/auth');
      }
    } else {
      // ❌ 하나라도 거부된 권한이 있다면, 사용자에게 알림 팝업을 띄웁니다.
      if (context.mounted) {
        // 위젯이 여전히 활성 상태인지 확인하는 안전장치
        _showPermissionDeniedDialog(context);
      }
    }
  }

  // 💡 [UI 로직] 권한이 거부되었을 때 사용자에게 보여줄 다이얼로그
  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('권한 필요'),
          content: const Text(
            '앱의 정상적인 사용을 위해 카메라와 사진 접근 권한이 반드시 필요합니다. '
            '앱 설정에서 수동으로 권한을 허용해주세요.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('앱 설정으로 이동'),
              onPressed: () {
                openAppSettings(); // 사용자가 직접 권한을 켤 수 있도록 앱 설정 화면으로 이동시킵니다.
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
            TextButton(
              child: const Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                // 권한이 없으므로 앱 사용을 제한하거나 다른 조치를 취할 수 있습니다.
                // 여기서는 단순히 닫고 현재 화면에 머무릅니다.
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60), // 상단 여백
              const Text(
                '정확한 분석을 위해\n권한이 필요해요',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              // 카메라 권한에 대한 UI 항목
              _buildPermissionItem(
                icon: Icons.camera_alt,
                title: '카메라 (필수)',
                description: '퍼스널 컬러 분석을 위해 피부를 촬영할 때 사용돼요.',
              ),
              const SizedBox(height: 20),
              // 사진/갤러리 권한에 대한 UI 항목
              _buildPermissionItem(
                icon: Icons.photo_library,
                title: '사진 (필수)',
                description: '앨범에 저장된 사진을 불러와 분석할 때 사용돼요.',
              ),
              const Spacer(), // 남은 공간을 모두 차지하여 아래 버튼을 하단으로 밀어냅니다.
              // [확인하고 계속하기] 버튼
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(
                    double.infinity,
                    50,
                  ), // 가로 가득 채우고 높이 지정
                ),
                onPressed: () {
                  _requestPermissions(context); // 버튼 클릭 시 권한 요청 함수 실행
                },
                child: const Text('확인하고 계속하기', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 💡 [UI 로직] 각 권한 항목의 UI를 재사용 가능하도록 분리한 위젯
  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Icon(icon, size: 40, color: Colors.grey[700]), // 권한 아이콘
        const SizedBox(width: 20), // 아이콘과 텍스트 사이 여백
        Expanded(
          // 텍스트가 길어져도 화면을 벗어나지 않도록 Expanded 사용
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4), // 제목과 설명 사이 여백
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
