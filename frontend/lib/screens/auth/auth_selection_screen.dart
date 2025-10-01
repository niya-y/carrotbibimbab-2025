// lib/screens/auth/auth_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:initial_bf/constants/app_colors.dart';
import 'package:initial_bf/constants/app_text_styles.dart';
import 'package:initial_bf/services/auth_service.dart';

class AuthSelectionScreen extends StatelessWidget {
  AuthSelectionScreen({super.key});

  // AuthService 인스턴스 생성 (const가 아님)
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들의 가로를 꽉 채움
            children: [
              const Icon(
                Icons.person_pin_circle_rounded,
                size: 100,
                color: AppColors.primary,
              ),
              const SizedBox(height: 40),
              const Text(
                '뷰파에 오신 것을 환영합니다!',
                textAlign: TextAlign.center,
                style: AppTextStyles.headline1,
              ),
              const SizedBox(height: 12),
              Text(
                'Google 계정으로 간편하게 시작해보세요.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(color: AppColors.grey),
              ),
              const SizedBox(height: 80),

              // Google 로그인 버튼
              ElevatedButton.icon(
                icon: const Icon(Icons.g_mobiledata,
                    color: Colors.black87), // Google 아이콘
                label: Text(
                  'Google로 시작하기',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: AppColors.grey.withOpacity(0.3)),
                  ),
                ),
                onPressed: () async {
                  // Google 로그인 로직 호출
                  final response = await _authService.signInWithGoogle();

                  if (response != null && response.user != null) {
                    // 로그인 성공 시 메인 화면으로 이동
                    if (context.mounted) {
                      print('Google 로그인 성공, 사용자: ${response.user?.email}');
                      context.go('/home');
                    }
                  } else {
                    // 로그인 실패 또는 취소 시 메시지 표시
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Google 로그인에 실패했습니다. 다시 시도해주세요.')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
