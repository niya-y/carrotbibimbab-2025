// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  // 2초 후에 온보딩 화면으로 이동하는 함수
  void _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) { // 위젯이 화면에 아직 있을 때만 실행 (안전장치)
      context.go('/onboarding'); // go_router를 사용해 /onboarding 경로로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: 나중에 피그마 디자인에 맞춰 로고 이미지로 교체
            Text(
              'Beaufa',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(), // 로딩 중임을 나타내는 동그란 아이콘
          ],
        ),
      ),
    );
  }
}