// lib/widgets/primary_button.dart
import 'package:flutter/material.dart';
import 'package:initial_bf/constants/app_colors.dart'; // 프로젝트명에 맞춰 경로 수정
import 'package:initial_bf/constants/app_text_styles.dart'; // 프로젝트명에 맞춰 경로 수정

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.button,
      ),
    );
  }
}