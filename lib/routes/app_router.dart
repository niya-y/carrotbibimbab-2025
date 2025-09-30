import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:initial_bf/screens/onboarding_screen.dart';
import 'package:initial_bf/screens/permission_guide_screen.dart';
import 'package:initial_bf/screens/splash_screen.dart';
import 'package:initial_bf/screens/auth/auth_selection_screen.dart';
import 'package:initial_bf/screens/main/main_layout_screen.dart';
import 'package:initial_bf/screens/main/main_home_screen.dart';
import 'package:initial_bf/screens/main/my_page_screen.dart'; // MyPageScreen 임포트 추가 (없다면 생성해주세요)

// ⭐ 새로 추가할 스크린 및 모델 임포트
import 'package:initial_bf/screens/analysis/photo_capture_screen.dart';
import 'package:initial_bf/screens/analysis/photo_confirm_screen.dart';
import 'package:initial_bf/screens/analysis/analysis_loading_screen.dart'; // ⭐ 분석 로딩 화면 임포트 (이전 단계에서 추가되었어야 함)
import 'package:initial_bf/models/analysis_result.dart'; // ⭐ 데이터 모델 임포트
import 'package:initial_bf/screens/result/analysis_report_screen.dart'; // ⭐ 결과 화면 임포트

// Supabase 클라이언트 인스턴스 (이 파일에서도 사용 가능하도록)
final supabase = Supabase.instance.client;

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(
      path: '/permission',
      builder: (_, __) => const PermissionGuideScreen(),
    ),
    GoRoute(
        path: '/auth',
        builder: (_, __) =>
            AuthSelectionScreen()), // AuthSelectionScreen은 const가 아님

    // ⭐ 분석 관련 페이지 라우트
    GoRoute(
      path: '/analysis', // 분석 시작 화면 (카메라/갤러리 선택)
      builder: (context, state) => const PhotoCaptureScreen(),
    ),
    GoRoute(
      path: '/analysis/confirm', // 촬영/선택된 사진 확인 화면
      builder: (context, state) {
        final imagePath = state.extra as String?;
        if (imagePath == null) {
          return const Center(child: Text('이미지 경로를 찾을 수 없습니다.'));
        }
        return PhotoConfirmScreen(imagePath: imagePath);
      },
    ),
    GoRoute(
      path: '/analysis/loading', // 분석 로딩 화면
      builder: (context, state) {
        final imagePath = state.extra as String?;
        if (imagePath == null) {
          return const Center(child: Text('분석할 이미지 경로를 찾을 수 없습니다.'));
        }
        return AnalysisLoadingScreen(imagePath: imagePath);
      },
    ),
    // ⭐ 분석 결과 화면 라우트 추가
    GoRoute(
      path: '/analysis/result', // AI 분석 결과 리포트 화면
      builder: (context, state) {
        // extra를 통해 전달된 분석 결과 데이터를 받습니다.
        final analysisResult = state.extra as AnalysisResult?;
        if (analysisResult == null) {
          // 데이터가 없으면 에러 화면 표시
          return const Scaffold(
              body: Center(child: Text('분석 결과를 받아오지 못했습니다.')));
        }
        return AnalysisReportScreen(result: analysisResult);
      },
    ),

    ShellRoute(
      builder: (context, state, child) {
        return MainLayoutScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/home', // 메인 대시보드
          builder: (context, state) => const MainHomeScreen(),
        ),
        GoRoute(
          path: '/mypage', // 마이 페이지
          builder: (context, state) => const MyPageScreen(),
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    final bool loggedIn = supabase.auth.currentUser != null;
    final bool goingToAuth = state.matchedLocation == '/auth';

    if (state.matchedLocation == '/') {
      return null; // 스플래시 화면에서는 리다이렉트 안 함
    }

    // 로그인하지 않았는데 로그인/온보딩/권한 페이지가 아니면 로그인 페이지로
    if (!loggedIn &&
        !goingToAuth &&
        !state.matchedLocation.startsWith('/onboarding') &&
        !state.matchedLocation.startsWith('/permission')) {
      return '/auth';
    }

    // 로그인했는데 로그인 페이지로 가려고 하면 홈으로
    if (loggedIn && goingToAuth) {
      return '/home';
    }

    return null; // 그 외에는 현재 경로 유지
  },
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Error: ${state.error}')),
  ),
);
