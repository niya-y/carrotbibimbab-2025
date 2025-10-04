// lib/screens/mypage/analysis_history_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:initial_bf/constants/app_colors.dart';
import 'package:initial_bf/constants/app_text_styles.dart';
import 'package:initial_bf/models/analysis_history.dart'; // 데이터 모델
import 'package:intl/intl.dart'; // 날짜 포맷팅을 위해
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase

final supabase = Supabase.instance.client;

class AnalysisHistoryScreen extends StatefulWidget {
  const AnalysisHistoryScreen({super.key});

  @override
  State<AnalysisHistoryScreen> createState() => _AnalysisHistoryScreenState();
}

class _AnalysisHistoryScreenState extends State<AnalysisHistoryScreen> {
  bool _isLoading = true;
  List<AnalysisHistory> _historyList = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  // 💡 [핵심 로직] Supabase에서 분석 기록 데이터 가져오기 (시뮬레이션)
  Future<void> _fetchHistory() async {
    setState(() {
      _isLoading = true;
    });

    // 2초간 로딩 시뮬레이션
    await Future.delayed(const Duration(seconds: 2));

    // TODO: 실제 Supabase 연동 코드
    /*
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception("User not logged in");

      final response = await supabase
          .from('analyses') // 'analyses'는 Supabase에 만든 테이블 이름
          .select('id, created_at, personal_color, image_url')
          .eq('user_id', userId)
          .order('created_at', ascending: false); // 최신순으로 정렬

      final histories = (response as List)
          .map((json) => AnalysisHistory.fromJson(json))
          .toList();
      
      setState(() {
        _historyList = histories;
        _isLoading = false;
      });

    } catch (e) {
      print("Error fetching history: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('기록을 불러오는 데 실패했습니다: $e')),
        );
        setState(() { _isLoading = false; });
      }
    }
    */

    // 더미 데이터 생성 (날짜별 그룹핑 테스트를 위해)
    final dummyHistories = [
      AnalysisHistory(
          id: '1',
          createdAt: DateTime(2025, 10, 1, 14, 30),
          personalColor: '가을 웜 뮤트',
          imageUrl: 'https://picsum.photos/id/101/200/200'),
      AnalysisHistory(
          id: '2',
          createdAt: DateTime(2025, 9, 30, 9, 15),
          personalColor: '봄 웜 라이트',
          imageUrl: 'https://picsum.photos/id/102/200/200'),
      AnalysisHistory(
          id: '3',
          createdAt: DateTime(2025, 9, 30, 18, 45),
          personalColor: '여름 쿨 라이트',
          imageUrl: 'https://picsum.photos/id/103/200/200'),
      AnalysisHistory(
          id: '4',
          createdAt: DateTime(2025, 9, 28, 11, 0),
          personalColor: '겨울 쿨 브라이트',
          imageUrl: 'https://picsum.photos/id/104/200/200'),
    ];

    setState(() {
      _historyList = dummyHistories;
      _isLoading = false;
    });
  }

  // 두 날짜가 같은 날인지 확인하는 함수
  bool _isSameDay(DateTime dateA, DateTime dateB) {
    return dateA.year == dateB.year &&
        dateA.month == dateB.month &&
        dateA.day == dateB.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('분석 히스토리'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _historyList.isEmpty
              ? const Center(child: Text('분석 기록이 없습니다.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _historyList.length,
                  itemBuilder: (context, index) {
                    final currentItem = _historyList[index];
                    final bool showDateHeader = index == 0 ||
                        !_isSameDay(currentItem.createdAt,
                            _historyList[index - 1].createdAt);

                    if (showDateHeader) {
                      // 날짜 헤더와 히스토리 카드를 함께 표시
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, bottom: 8.0, left: 8.0),
                            child: Text(
                              DateFormat('yyyy년 MM월 dd일')
                                  .format(currentItem.createdAt),
                              style: AppTextStyles.bodyBold
                                  .copyWith(color: AppColors.grey),
                            ),
                          ),
                          _buildHistoryCard(currentItem),
                        ],
                      );
                    } else {
                      // 히스토리 카드만 표시
                      return _buildHistoryCard(currentItem);
                    }
                  },
                ),
    );
  }

  // 개별 히스토리 카드 UI
  Widget _buildHistoryCard(AnalysisHistory history) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            history.imageUrl,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(history.personalColor, style: AppTextStyles.bodyBold),
        subtitle: Text(DateFormat('HH:mm').format(history.createdAt)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.grey),
        onTap: () {
          // TODO: 실제로는 history.id를 사용하여 Supabase에서 전체 분석 데이터를 다시 가져온 후,
          // AnalysisResult 모델로 변환하여 '/analysis/result' 경로로 전달해야 합니다.
          print('상세 분석 결과 보기: ID - ${history.id}');
          // 예시: context.go('/analysis/result/${history.id}');
        },
      ),
    );
  }
}
