// lib/widgets/cards/daily_recommendation_card_skeleton.dart
import 'package:flutter/material.dart';
import 'package:initial_bf/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class DailyRecommendationCardSkeleton extends StatelessWidget {
  const DailyRecommendationCardSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    // Shimmer.fromColors 자체는 const가 될 수 없습니다. (run-time opacity 계산 때문)
    return Shimmer.fromColors(
      baseColor: AppColors.grey.withOpacity(0.1), // ⭐ 여기서 const를 제거
      highlightColor: AppColors.grey.withOpacity(0.05), // ⭐ 여기서 const를 제거
      child: Card(
        margin: EdgeInsets.zero,
        // 이 Card 자체도 const가 될 수 없습니다. (부모 위젯의 영향)
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          // ⭐ SizedBox 앞에 const를 제거
          width: double.infinity,
          height: 180,
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Padding은 const 가능
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이 Container들도 const를 제거
                Container(width: 150, height: 20, color: Colors.white),
                const SizedBox(height: 15), // SizedBox는 const 가능
                Container(
                    width: double.infinity, height: 14, color: Colors.white),
                const SizedBox(height: 10),
                Container(
                    width: double.infinity, height: 14, color: Colors.white),
                const SizedBox(height: 10),
                Container(width: 100, height: 14, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
