// lib/models/analysis_history.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'analysis_history.freezed.dart';
part 'analysis_history.g.dart';

@freezed
class AnalysisHistory with _$AnalysisHistory {
  const factory AnalysisHistory({
    required String id, // Supabase에 저장된 고유 ID
    required DateTime createdAt, // 분석 생성 일시
    required String personalColor, // 퍼스널 컬러 진단 결과
    required String imageUrl, // 대표 이미지 URL (썸네일용)
  }) = _AnalysisHistory;

  factory AnalysisHistory.fromJson(Map<String, dynamic> json) =>
      _$AnalysisHistoryFromJson(json);
}
