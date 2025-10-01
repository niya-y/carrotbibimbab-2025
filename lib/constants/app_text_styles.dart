// lib/constants/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:initial_bf/constants/app_colors.dart'; // AppColors 임포트

// 앱 전체에서 사용될 텍스트 스타일을 정의합니다.
class AppTextStyles {
  // 헤드라인 스타일
  static const TextStyle headline1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark, // 직접 지정 대신 AppColors 사용
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600, // Semi-bold
    color: AppColors.textDark,
  );

  static const TextStyle headline4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textDark,
  );

  // 바디 스타일
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.text, // 직접 지정 대신 AppColors 사용
  );

  static const TextStyle bodyBold = TextStyle(
    // 유용하게 사용할 수 있는 bodyBold 추가
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  // ⭐ [수정] bodySmall 스타일 추가 (오류 해결)
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.grey, // 보조 텍스트에 어울리는 회색 사용
  );

  // 버튼 스타일
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight, // 직접 지정 대신 AppColors 사용
  );
}
