// lib/screens/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:initial_bf/constants/app_colors.dart';
import 'package:initial_bf/constants/app_text_styles.dart';
import 'package:initial_bf/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // 알림 설정 상태 (실제로는 SharedPreferences나 DB에 저장해야 함)
  bool _pushNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          // 계정 섹션
          _buildSectionHeader('계정'),
          _buildMenuTile(
            context: context,
            title: '프로필 수정',
            onTap: () {
              // TODO: 프로필 수정 화면으로 이동
              print('프로필 수정 클릭');
            },
          ),

          // 알림 섹션
          _buildSectionHeader('알림'),
          SwitchListTile(
            title: const Text('푸시 알림', style: AppTextStyles.body),
            value: _pushNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _pushNotificationsEnabled = value;
                // TODO: 실제 알림 설정 상태 저장 로직
              });
            },
            activeColor: AppColors.primary,
          ),

          // 앱 정보 섹션
          _buildSectionHeader('앱 정보'),
          _buildMenuTile(
            context: context,
            title: '공지사항',
            onTap: () {
              // TODO: 공지사항 화면으로 이동
              print('공지사항 클릭');
            },
          ),
          _buildMenuTile(
            context: context,
            title: '이용약관',
            onTap: () {
              // TODO: 이용약관 웹뷰 또는 화면으로 이동
              print('이용약관 클릭');
            },
          ),
          _buildMenuTile(
            context: context,
            title: '개인정보처리방침',
            onTap: () {
              // TODO: 개인정보처리방침 웹뷰 또는 화면으로 이동
              print('개인정보처리방침 클릭');
            },
          ),
          ListTile(
            title: const Text('버전 정보', style: AppTextStyles.body),
            trailing: const Text('1.0.0',
                style: AppTextStyles.body), // TODO: package_info_plus로 동적 표시
          ),
        ],
      ),
    );
  }

  // 섹션 제목 UI
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: AppTextStyles.body
            .copyWith(color: AppColors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 일반 메뉴 타일 UI
  Widget _buildMenuTile({
    required BuildContext context,
    required String title,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title, style: AppTextStyles.body),
      trailing: onTap != null
          ? const Icon(Icons.chevron_right, color: AppColors.grey)
          : null,
      onTap: onTap,
    );
  }
}
