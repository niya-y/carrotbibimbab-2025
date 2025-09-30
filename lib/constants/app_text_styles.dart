// lib/constants/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:initial_bf/constants/app_colors.dart'; // 프로젝트명에 맞춰 경로 수정

// 앱 전체에서 사용될 텍스트 스타일을 정의합니다.
class AppTextStyles {
  // 예시: headline1 (가장 큰 제목)
  static const TextStyle headline1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // 예시: headline2 (큰 제목)
  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // 예시: headline3 (중간 제목)
  static const TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  // 예시: headline4 (작은 제목/섹션 제목)
  static const TextStyle headline4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  // 예시: body (일반 본문 텍스트)
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  // 예시: button (버튼 텍스트)
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // 필요에 따라 다른 텍스트 스타일들을 추가할 수 있습니다.
  // 예: caption, subtitle, errorText 등
}
