// lib/screens/main/my_page_screen.dart
import 'package:flutter/material.dart';
import 'package:initial_bf/constants/app_text_styles.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이 페이지', style: AppTextStyles.headline4),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              '마이 페이지 내용이 여기에 표시됩니다.',
              style: AppTextStyles.body,
            ),
            Text(
              '(아직 구현되지 않았습니다.)',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
