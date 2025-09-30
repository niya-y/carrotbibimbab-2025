// lib/screens/result/analysis_report_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:initial_bf/constants/app_colors.dart';
import 'package:initial_bf/constants/app_text_styles.dart';
import 'package:initial_bf/models/analysis_result.dart';

class AnalysisReportScreen extends StatelessWidget {
  final AnalysisResult result;

  const AnalysisReportScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('분석 결과 리포트'),
        actions: [
          IconButton(
              icon: const Icon(Icons.share), onPressed: () {/* TODO: 공유 기능 */}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 퍼스널 컬러 진단 결과 섹션
            _buildSectionTitle('퍼스널 컬러 진단 결과'),
            _buildPersonalColorSection(result.personalColor),
            const SizedBox(height: 30),

            // 2. 상세 스킨톤 분석 섹션
            _buildSectionTitle('상세 스킨톤 분석'),
            _buildSkinToneSection(result.skinTone),
            const SizedBox(height: 30),

            // 3. 피부 고민 섹션
            _buildSectionTitle('피부 고민 분석'),
            // skinConcerns 리스트를 순회하며 각 항목을 UI로 만듦
            for (var concern in result.skinConcerns) ...[
              _buildSkinConcernItem(concern),
              const SizedBox(height: 15),
            ],
            const SizedBox(height: 40),

            // 4. 맞춤 제품 추천 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // TODO: 맞춤 제품 추천 화면으로 이동
                  print('맞춤 제품 보러가기 클릭');
                  // context.go('/recommendations');
                },
                child:
                    const Text('나를 위한 맞춤 제품 보러가기', style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 섹션 제목을 만드는 헬퍼 위젯
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(title, style: AppTextStyles.headline3),
    );
  }

  // 퍼스널 컬러 섹션 UI
  Widget _buildPersonalColorSection(String personalColor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // TODO: 퍼스널 컬러 타입에 맞는 대표 이미지나 아이콘 추가
            const Icon(Icons.palette, size: 40, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(
              personalColor,
              style: AppTextStyles.headline2.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            const Text(
              '부드럽고 차분한 색상이 당신의 매력을 한층 더 돋보이게 합니다.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }

  // 상세 스킨톤 섹션 UI
  Widget _buildSkinToneSection(String skinTone) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.face_retouching_natural, size: 30),
        title: const Text('추천 베이스 호수', style: AppTextStyles.body),
        subtitle: Text(skinTone,
            style:
                AppTextStyles.headline4.copyWith(fontWeight: FontWeight.bold)),
      ),
    );
  }

  // 개별 피부 고민 항목 UI
  Widget _buildSkinConcernItem(SkinConcern concern) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(concern.name, style: AppTextStyles.headline4),
                Text('${concern.score}점',
                    style: AppTextStyles.headline4
                        .copyWith(color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 8),
            Text(concern.description,
                style: AppTextStyles.body.copyWith(color: AppColors.grey)),
          ],
        ),
      ),
    );
  }
}
