// lib/widgets/cards/recent_analysis_card_skeleton.dart
import 'package:flutter/material.dart';
import 'package:initial_bf/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class RecentAnalysisCardSkeleton extends StatelessWidget {
  const RecentAnalysisCardSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      // ⭐ Shimmer.fromColors는 const가 될 수 없음
      baseColor: AppColors.grey.withOpacity(0.1), // withOpacity() 때문에 const 불가
      highlightColor:
          AppColors.grey.withOpacity(0.05), // withOpacity() 때문에 const 불가
      child: Card(
        // Card도 child가 const가 아니므로 const 불가
        margin: EdgeInsets.zero,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          // ⭐ 여기 const 제거
          width: double.infinity,
          height: 150,
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Padding은 const 가능
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ⭐ Container 앞의 const 제거
                Container(width: 120, height: 16, color: Colors.white), // 제목
                const SizedBox(height: 10), // ⭐ SizedBox는 const 가능
                Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.white), // 내용 1
                const SizedBox(height: 8), // ⭐ SizedBox는 const 가능
                Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.white), // 내용 2
              ],
            ),
          ),
        ),
      ),
    );
  }
}
