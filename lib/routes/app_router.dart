// lib/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:initial_bf/screens/onboarding_screen.dart';
import 'package:initial_bf/screens/permission_guide_screen.dart';
import 'package:initial_bf/screens/splash_screen.dart';
import 'package:initial_bf/screens/auth/auth_selection_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(
        path: '/permission', builder: (_, __) => const PermissionGuideScreen()),
    GoRoute(path: '/auth', builder: (_, __) => AuthSelectionScreen()),

    // TODO: 로그인 후 이동할 메인 홈 화면 구현 후 연결
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const Scaffold(
          body: Center(child: Text('로그인 성공! 메인 홈 화면입니다.')),
        );
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Error: ${state.error}')),
  ),
);
