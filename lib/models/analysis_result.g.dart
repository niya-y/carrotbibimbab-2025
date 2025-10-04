// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalysisResultImpl _$$AnalysisResultImplFromJson(Map<String, dynamic> json) =>
    _$AnalysisResultImpl(
      personalColor: json['personalColor'] as String,
      skinTone: json['skinTone'] as String,
      skinConcerns: (json['skinConcerns'] as List<dynamic>)
          .map((e) => SkinConcern.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AnalysisResultImplToJson(
        _$AnalysisResultImpl instance) =>
    <String, dynamic>{
      'personalColor': instance.personalColor,
      'skinTone': instance.skinTone,
      'skinConcerns': instance.skinConcerns,
    };

_$SkinConcernImpl _$$SkinConcernImplFromJson(Map<String, dynamic> json) =>
    _$SkinConcernImpl(
      name: json['name'] as String,
      score: (json['score'] as num).toInt(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$$SkinConcernImplToJson(_$SkinConcernImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'score': instance.score,
      'description': instance.description,
    };
