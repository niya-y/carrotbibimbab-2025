// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalysisHistoryImpl _$$AnalysisHistoryImplFromJson(
        Map<String, dynamic> json) =>
    _$AnalysisHistoryImpl(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      personalColor: json['personalColor'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$$AnalysisHistoryImplToJson(
        _$AnalysisHistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'personalColor': instance.personalColor,
      'imageUrl': instance.imageUrl,
    };
