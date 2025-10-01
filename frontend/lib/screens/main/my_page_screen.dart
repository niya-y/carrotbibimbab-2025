// lib/screens/main/my_page_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:initial_bf/constants/app_colors.dart';
import 'package:initial_bf/constants/app_text_styles.dart';
import 'package:initial_bf/services/auth_service.dart'; // 로그아웃 및 사용자 정보 확인용

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final currentUser = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지', style: AppTextStyles.headline4),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        // 스크롤 가능한 리스트
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: [
          const SizedBox(height: 20),

          // 1. 프로필 섹션
          _buildProfileSection(
            email: currentUser?.email ?? '로그인 정보 없음',
            onEdit: () {
              // TODO: 프로필 수정 화면으로 이동
              print('프로필 수정 버튼 클릭');
            },
          ),
          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 10),

          // 2. 주요 메뉴 리스트
          _buildMenuTile(
            icon: Icons.history,
            title: '분석 히스토리',
            onTap: () {
              context.go('/history');
            },
          ),
          _buildMenuTile(
            icon: Icons.bookmark_border,
            title: '북마크',
            onTap: () {
              context.go('/bookmarks');
            },
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),

          // 3. 기타 메뉴
          _buildMenuTile(
            icon: Icons.settings_outlined,
            title: '설정',
            onTap: () {
              context.go('/settings');
            },
          ),
          _buildMenuTile(
            icon: Icons.logout,
            title: '로그아웃',
            onTap: () async {
              // 로그아웃 처리
              await authService.signOut();
              // redirect 로직에 의해 자동으로 로그인 화면으로 이동됩니다.
            },
          ),
        ],
      ),
    );
  }

  // 프로필 섹션 UI를 만드는 헬퍼 위젯
  Widget _buildProfileSection(
      {required String email, required VoidCallback onEdit}) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.lightGrey,
          child: Icon(Icons.person, size: 50, color: Colors.white),
          // TODO: 사용자 프로필 이미지가 있다면 ImageProvider로 교체
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '사용자 이름', // TODO: Supabase DB에서 사용자 이름 가져오기
                style: AppTextStyles.headline4,
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: AppTextStyles.body.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: AppColors.grey),
          onPressed: onEdit,
        ),
      ],
    );
  }

  // 메뉴 타일 UI를 만드는 헬퍼 위젯 (코드 재사용)
  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.darkGrey),
      title: Text(title, style: AppTextStyles.bodyBold),
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey),
      onTap: onTap,
    );
  }
}
