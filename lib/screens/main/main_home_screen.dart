// lib/screens/main/main_home_screen.dart
import 'package:flutter/material.dart';
import 'package:initial_bf/constants/app_colors.dart';
import 'package:initial_bf/constants/app_text_styles.dart';
import 'package:initial_bf/services/auth_service.dart'; // 로그아웃 테스트용
import 'package:initial_bf/widgets/cards/recent_analysis_card_skeleton.dart';
import 'package:initial_bf/widgets/cards/daily_recommendation_card_skeleton.dart';
import 'package:initial_bf/widgets/cards/tracking_progress_card_skeleton.dart';
import 'package:go_router/go_router.dart'; // context.go() 사용을 위해 필요

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  final AuthService _authService = AuthService(); // 로그아웃 테스트용

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          '뷰파',
          style: AppTextStyles.headline2.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // ⭐ 알림 페이지로 이동하도록 수정
              context.go('/notifications');
            },
          ),
          // ⭐ 테스트용 로그아웃 버튼 (나중에 제거하거나 마이페이지로 이동)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              // 로그아웃 후 로그인 화면으로 이동 (redirect 로직에 의해 자동으로 처리될 것임)
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        // ⭐ Pull-to-Refresh 기능
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // 스크롤 가능하게 하여 RefreshIndicator 작동
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 환영 메시지
              Text(
                '안녕하세요, ${_authService.currentUser?.email ?? '사용자'}님!',
                style: AppTextStyles.headline3,
              ),
              const SizedBox(height: 20),

              // ⭐ 메인 CTA (분석 시작 버튼)
              _buildMainCtaButton(context),
              const SizedBox(height: 30),

              // ⭐ 최근 분석 결과 요약 카드 (스켈레톤)
              Text('최근 분석',
                  style: AppTextStyles.headline4
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              const RecentAnalysisCardSkeleton(), // 로딩 상태 스켈레톤
              const SizedBox(height: 30),

              // ⭐ 오늘의 추천 제품/팁 카드 (스켈레톤)
              Text('오늘의 뷰파',
                  style: AppTextStyles.headline4
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              const DailyRecommendationCardSkeleton(), // 로딩 상태 스켈레톤
              const SizedBox(height: 30),

              // ⭐ 7일 트래킹 진행 상황 카드 (스켈레톤)
              Text('나의 뷰파 트래킹',
                  style: AppTextStyles.headline4
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              const TrackingProgressCardSkeleton(), // 로딩 상태 스켈레톤
            ],
          ),
        ),
      ),
    );
  }

  // ⭐ Pull-to-Refresh 로직
  Future<void> _handleRefresh() async {
    print('데이터 새로고침 시작...');
    await Future.delayed(const Duration(seconds: 2)); // 데이터 로딩 시뮬레이션
    print('데이터 새로고침 완료.');
    // TODO: 실제 데이터 로딩 로직 (API 호출 등)을 여기에 추가합니다.
    // setState(() {}); // 데이터가 변경되었음을 UI에 알리기 위해 필요할 수 있습니다.
  }

  // ⭐ 메인 CTA 버튼 위젯
  Widget _buildMainCtaButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
      onPressed: () {
        // 분석 시작 페이지로 이동
        print('분석 시작 버튼 클릭');
        context.go('/analysis');
      },
      child: Text(
        '나의 퍼스널 컬러 분석하기',
        style: AppTextStyles.button.copyWith(fontSize: 18),
      ),
    );
  }
}
