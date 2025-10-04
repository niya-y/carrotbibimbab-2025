// lib/widgets/cards/tracking_progress_card_skeleton.dart
import 'package:flutter/material.dart';
import 'package:initial_bf/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class TrackingProgressCardSkeleton extends StatelessWidget {
  const TrackingProgressCardSkeleton({super.key});
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
          height: 120, // 원래 카드 높이와 동일하게 유지
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Padding은 const 가능
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ⭐ Container 앞의 const 제거
                Container(width: 100, height: 16, color: Colors.white), // 제목
                const SizedBox(height: 15), // ⭐ SizedBox는 const 가능
                Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.white), // 진행 바 흉내
                const SizedBox(height: 10), // ⭐ SizedBox는 const 가능
                Container(width: 80, height: 12, color: Colors.white), // 날짜
              ],
            ),
          ),
        ),
      ),
    );
  }
}
