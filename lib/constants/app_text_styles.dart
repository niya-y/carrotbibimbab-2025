// lib/constants/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:initial_bf/constants/app_colors.dart'; // 프로젝트명에 맞춰 경로 수정

class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.text,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white, // 또는 AppColors.background
  );
}