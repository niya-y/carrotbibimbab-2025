import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:initial_bf/screens/onboarding_screen.dart';
import 'package:initial_bf/screens/permission_guide_screen.dart';
import 'package:initial_bf/screens/splash_screen.dart';
import 'package:initial_bf/screens/auth/auth_selection_screen.dart';
import 'package:initial_bf/screens/main/main_layout_screen.dart';
import 'package:initial_bf/screens/main/main_home_screen.dart';
import 'package:initial_bf/screens/main/my_page_screen.dart';

// 분석 관련 스크린 및 모델 임포트
import 'package:initial_bf/screens/analysis/photo_capture_screen.dart';
import 'package:initial_bf/screens/analysis/photo_confirm_screen.dart';
import 'package:initial_bf/screens/analysis/analysis_loading_screen.dart';
import 'package:initial_bf/models/analysis_result.dart';
import 'package:initial_bf/screens/result/analysis_report_screen.dart';

// 추천 제품 관련 스크린 임포트
import 'package:initial_bf/screens/recommendation/recommended_products_screen.dart';
import 'package:initial_bf/screens/recommendation/product_detail_screen.dart';

// 마이페이지 하위 메뉴 스크린 임포트
import 'package:initial_bf/screens/mypage/analysis_history_screen.dart';
import 'package:initial_bf/screens/mypage/bookmarks_screen.dart';

// ⭐ 설정 및 알림 스크린 임포트
import 'package:initial_bf/screens/settings/settings_screen.dart';
import 'package:initial_bf/screens/settings/notifications_screen.dart';

// Supabase 클라이언트 인스턴스
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
      builder: (_, __) => AuthSelectionScreen(),
    ),

    // 분석 관련 페이지 라우트
    GoRoute(
      path: '/analysis',
      builder: (context, state) => const PhotoCaptureScreen(),
    ),
    GoRoute(
      path: '/analysis/confirm',
      builder: (context, state) {
        final imagePath = state.extra as String?;
        if (imagePath == null) {
          return const Center(child: Text('이미지 경로를 찾을 수 없습니다.'));
        }
        return PhotoConfirmScreen(imagePath: imagePath);
      },
    ),
    GoRoute(
      path: '/analysis/loading',
      builder: (context, state) {
        final imagePath = state.extra as String?;
        if (imagePath == null) {
          return const Center(child: Text('분석할 이미지 경로를 찾을 수 없습니다.'));
        }
        return AnalysisLoadingScreen(imagePath: imagePath);
      },
    ),
    GoRoute(
      path: '/analysis/result',
      builder: (context, state) {
        final analysisResult = state.extra as AnalysisResult?;
        if (analysisResult == null) {
          return const Scaffold(
              body: Center(child: Text('분석 결과를 받아오지 못했습니다.')));
        }
        return AnalysisReportScreen(result: analysisResult);
      },
    ),

    // 추천 관련 페이지 라우트
    GoRoute(
      path: '/recommendations',
      builder: (context, state) {
        return const RecommendedProductsScreen();
      },
    ),
    GoRoute(
      path: '/product/:productId',
      builder: (context, state) {
        final productId = state.pathParameters['productId'];
        if (productId == null) {
          return const Scaffold(body: Center(child: Text('잘못된 접근입니다.')));
        }
        return ProductDetailScreen(productId: productId);
      },
    ),

    // 마이페이지 하위 메뉴 라우트
    GoRoute(
      path: '/history',
      builder: (context, state) => const AnalysisHistoryScreen(),
    ),
    GoRoute(
      path: '/bookmarks',
      builder: (context, state) => const BookmarksScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    // ⭐ 알림 페이지 라우트 추가
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),

    // 하단 탭 바를 포함하는 메인 화면 그룹
    ShellRoute(
      builder: (context, state, child) {
        return MainLayoutScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const MainHomeScreen(),
        ),
        GoRoute(
          path: '/mypage',
          builder: (context, state) => const MyPageScreen(),
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    final bool loggedIn = supabase.auth.currentUser != null;
    final bool goingToAuth = state.matchedLocation == '/auth';

    if (state.matchedLocation == '/') {
      return null;
    }

    if (!loggedIn &&
        !goingToAuth &&
        !state.matchedLocation.startsWith('/onboarding') &&
        !state.matchedLocation.startsWith('/permission')) {
      return '/auth';
    }

    if (loggedIn && goingToAuth) {
      return '/home';
    }

    return null;
  },
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Error: ${state.error}')),
  ),
);
