// lib/screens/settings/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:initial_bf/constants/app_colors.dart';
import 'package:initial_bf/constants/app_text_styles.dart';
import 'package:initial_bf/models/app_notification.dart'; // 알림 모델
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = true;
  List<AppNotification> _notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  // 💡 [핵심 로직] Supabase에서 알림 데이터 가져오기 (시뮬레이션)
  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1)); // 1초 로딩 시뮬레이션

    // TODO: 실제 Supabase 연동 코드
    /*
    final response = await supabase.from('notifications').select().order('created_at', ascending: false);
    final notifications = (response as List).map((json) => AppNotification.fromJson(json)).toList();
    */

    // 더미 데이터
    final dummyNotifications = [
      AppNotification(
          id: '1',
          title: '분석 완료!',
          body: '요청하신 피부 분석이 완료되었습니다. 결과를 확인해보세요.',
          createdAt: DateTime.now(),
          isRead: false),
      AppNotification(
          id: '2',
          title: '새로운 추천 제품',
          body: '가을 웜톤을 위한 신제품이 추가되었어요.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true),
      AppNotification(
          id: '3',
          title: '[이벤트] 뷰파와 함께하는 가을',
          body: '10월 한 달간 진행되는 특별 이벤트를 놓치지 마세요.',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          isRead: true),
    ];

    setState(() {
      _notifications = dummyNotifications;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const Center(child: Text('새로운 알림이 없습니다.'))
              : ListView.separated(
                  itemCount: _notifications.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return ListTile(
                      leading: Icon(
                        Icons.circle,
                        color: notification.isRead
                            ? Colors.transparent
                            : AppColors.primary,
                        size: 12,
                      ),
                      title: Text(
                        notification.title,
                        style: AppTextStyles.bodyBold.copyWith(
                          color: notification.isRead
                              ? AppColors.grey
                              : AppColors.textDark,
                        ),
                      ),
                      subtitle: Text(
                        '${notification.body}\n${DateFormat('yyyy.MM.dd HH:mm').format(notification.createdAt)}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      isThreeLine: true,
                      onTap: () {
                        setState(() {
                          // TODO: 실제로는 DB에 isRead 상태를 업데이트해야 합니다.
                          final originalIndex = _notifications
                              .indexWhere((n) => n.id == notification.id);
                          if (originalIndex != -1) {
                            _notifications[originalIndex] =
                                notification.copyWith(isRead: true);
                          }
                        });
                        // TODO: 알림 내용에 따라 특정 페이지로 이동
                        // 예: 분석 완료 알림 -> 해당 분석 결과 페이지로 이동
                      },
                      tileColor: notification.isRead
                          ? Colors.white
                          : AppColors.primary.withOpacity(0.05),
                    );
                  },
                ),
    );
  }
}
