// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analysis_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnalysisHistory _$AnalysisHistoryFromJson(Map<String, dynamic> json) {
  return _AnalysisHistory.fromJson(json);
}

/// @nodoc
mixin _$AnalysisHistory {
  String get id => throw _privateConstructorUsedError; // Supabase에 저장된 고유 ID
  DateTime get createdAt => throw _privateConstructorUsedError; // 분석 생성 일시
  String get personalColor =>
      throw _privateConstructorUsedError; // 퍼스널 컬러 진단 결과
  String get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this AnalysisHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalysisHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalysisHistoryCopyWith<AnalysisHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalysisHistoryCopyWith<$Res> {
  factory $AnalysisHistoryCopyWith(
          AnalysisHistory value, $Res Function(AnalysisHistory) then) =
      _$AnalysisHistoryCopyWithImpl<$Res, AnalysisHistory>;
  @useResult
  $Res call(
      {String id, DateTime createdAt, String personalColor, String imageUrl});
}

/// @nodoc
class _$AnalysisHistoryCopyWithImpl<$Res, $Val extends AnalysisHistory>
    implements $AnalysisHistoryCopyWith<$Res> {
  _$AnalysisHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalysisHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? personalColor = null,
    Object? imageUrl = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      personalColor: null == personalColor
          ? _value.personalColor
          : personalColor // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnalysisHistoryImplCopyWith<$Res>
    implements $AnalysisHistoryCopyWith<$Res> {
  factory _$$AnalysisHistoryImplCopyWith(_$AnalysisHistoryImpl value,
          $Res Function(_$AnalysisHistoryImpl) then) =
      __$$AnalysisHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, DateTime createdAt, String personalColor, String imageUrl});
}

/// @nodoc
class __$$AnalysisHistoryImplCopyWithImpl<$Res>
    extends _$AnalysisHistoryCopyWithImpl<$Res, _$AnalysisHistoryImpl>
    implements _$$AnalysisHistoryImplCopyWith<$Res> {
  __$$AnalysisHistoryImplCopyWithImpl(
      _$AnalysisHistoryImpl _value, $Res Function(_$AnalysisHistoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalysisHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? personalColor = null,
    Object? imageUrl = null,
  }) {
    return _then(_$AnalysisHistoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      personalColor: null == personalColor
          ? _value.personalColor
          : personalColor // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalysisHistoryImpl implements _AnalysisHistory {
  const _$AnalysisHistoryImpl(
      {required this.id,
      required this.createdAt,
      required this.personalColor,
      required this.imageUrl});

  factory _$AnalysisHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalysisHistoryImplFromJson(json);

  @override
  final String id;
// Supabase에 저장된 고유 ID
  @override
  final DateTime createdAt;
// 분석 생성 일시
  @override
  final String personalColor;
// 퍼스널 컬러 진단 결과
  @override
  final String imageUrl;

  @override
  String toString() {
    return 'AnalysisHistory(id: $id, createdAt: $createdAt, personalColor: $personalColor, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.personalColor, personalColor) ||
                other.personalColor == personalColor) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, createdAt, personalColor, imageUrl);

  /// Create a copy of AnalysisHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalysisHistoryImplCopyWith<_$AnalysisHistoryImpl> get copyWith =>
      __$$AnalysisHistoryImplCopyWithImpl<_$AnalysisHistoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalysisHistoryImplToJson(
      this,
    );
  }
}

abstract class _AnalysisHistory implements AnalysisHistory {
  const factory _AnalysisHistory(
      {required final String id,
      required final DateTime createdAt,
      required final String personalColor,
      required final String imageUrl}) = _$AnalysisHistoryImpl;

  factory _AnalysisHistory.fromJson(Map<String, dynamic> json) =
      _$AnalysisHistoryImpl.fromJson;

  @override
  String get id; // Supabase에 저장된 고유 ID
  @override
  DateTime get createdAt; // 분석 생성 일시
  @override
  String get personalColor; // 퍼스널 컬러 진단 결과
  @override
  String get imageUrl;

  /// Create a copy of AnalysisHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalysisHistoryImplCopyWith<_$AnalysisHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
