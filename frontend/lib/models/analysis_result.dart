// lib/models/analysis_result.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'analysis_result.freezed.dart';
part 'analysis_result.g.dart';

// 분석 결과 전체를 담는 모델
@freezed
class AnalysisResult with _$AnalysisResult {
  const factory AnalysisResult({
    required String personalColor, // 퍼스널 컬러 진단 결과 (예: "가을 웜 뮤트")
    required String skinTone, // 상세 스킨톤 분석 (예: "22호 뉴트럴 톤")
    required List<SkinConcern> skinConcerns, // 피부 고민 목록
  }) = _AnalysisResult;

  factory AnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$AnalysisResultFromJson(json);
}

// 개별 피부 고민을 담는 모델
@freezed
class SkinConcern with _$SkinConcern {
  const factory SkinConcern({
    required String name, // 고민 이름 (예: "모공")
    required int score, // 점수 (예: 85)
    required String description, // 상세 설명
  }) = _SkinConcern;

  factory SkinConcern.fromJson(Map<String, dynamic> json) =>
      _$SkinConcernFromJson(json);
}
