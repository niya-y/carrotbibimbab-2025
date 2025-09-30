import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 라우팅
import 'dart:io'; // File 클래스 사용

import 'package:initial_bf/constants/app_colors.dart'; // 디자인 시스템
import 'package:initial_bf/constants/app_text_styles.dart'; // 디자인 시스템

class PhotoConfirmScreen extends StatelessWidget {
  final String imagePath; // 촬영되거나 선택된 이미지의 경로

  const PhotoConfirmScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final File imageFile = File(imagePath);

    return Scaffold(
      appBar: AppBar(
        title: const Text('사진 확인', style: AppTextStyles.body),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.file(imageFile),
              ),
            ),
            Container(
              color: AppColors.background,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    '이 사진으로 분석을 진행하시겠어요?',
                    style: AppTextStyles.headline4
                        .copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // 💡 [핵심 로직] 분석 시작 (이제 로딩 화면으로 이동)
                        print('분석 시작 버튼 클릭: $imagePath');
                        // ⭐ 변경: AnalysisLoadingScreen으로 이동
                        context.go('/analysis/loading', extra: imagePath);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('분석 시작', style: AppTextStyles.button),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        context.pop(); // 현재 화면을 닫고 이전 카메라 화면으로 돌아감
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('다시 찍기', style: AppTextStyles.button),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
