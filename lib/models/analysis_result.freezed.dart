// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analysis_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnalysisResult _$AnalysisResultFromJson(Map<String, dynamic> json) {
  return _AnalysisResult.fromJson(json);
}

/// @nodoc
mixin _$AnalysisResult {
  String get personalColor =>
      throw _privateConstructorUsedError; // 퍼스널 컬러 진단 결과 (예: "가을 웜 뮤트")
  String get skinTone =>
      throw _privateConstructorUsedError; // 상세 스킨톤 분석 (예: "22호 뉴트럴 톤")
  List<SkinConcern> get skinConcerns => throw _privateConstructorUsedError;

  /// Serializes this AnalysisResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalysisResultCopyWith<AnalysisResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalysisResultCopyWith<$Res> {
  factory $AnalysisResultCopyWith(
          AnalysisResult value, $Res Function(AnalysisResult) then) =
      _$AnalysisResultCopyWithImpl<$Res, AnalysisResult>;
  @useResult
  $Res call(
      {String personalColor, String skinTone, List<SkinConcern> skinConcerns});
}

/// @nodoc
class _$AnalysisResultCopyWithImpl<$Res, $Val extends AnalysisResult>
    implements $AnalysisResultCopyWith<$Res> {
  _$AnalysisResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? personalColor = null,
    Object? skinTone = null,
    Object? skinConcerns = null,
  }) {
    return _then(_value.copyWith(
      personalColor: null == personalColor
          ? _value.personalColor
          : personalColor // ignore: cast_nullable_to_non_nullable
              as String,
      skinTone: null == skinTone
          ? _value.skinTone
          : skinTone // ignore: cast_nullable_to_non_nullable
              as String,
      skinConcerns: null == skinConcerns
          ? _value.skinConcerns
          : skinConcerns // ignore: cast_nullable_to_non_nullable
              as List<SkinConcern>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnalysisResultImplCopyWith<$Res>
    implements $AnalysisResultCopyWith<$Res> {
  factory _$$AnalysisResultImplCopyWith(_$AnalysisResultImpl value,
          $Res Function(_$AnalysisResultImpl) then) =
      __$$AnalysisResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String personalColor, String skinTone, List<SkinConcern> skinConcerns});
}

/// @nodoc
class __$$AnalysisResultImplCopyWithImpl<$Res>
    extends _$AnalysisResultCopyWithImpl<$Res, _$AnalysisResultImpl>
    implements _$$AnalysisResultImplCopyWith<$Res> {
  __$$AnalysisResultImplCopyWithImpl(
      _$AnalysisResultImpl _value, $Res Function(_$AnalysisResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? personalColor = null,
    Object? skinTone = null,
    Object? skinConcerns = null,
  }) {
    return _then(_$AnalysisResultImpl(
      personalColor: null == personalColor
          ? _value.personalColor
          : personalColor // ignore: cast_nullable_to_non_nullable
              as String,
      skinTone: null == skinTone
          ? _value.skinTone
          : skinTone // ignore: cast_nullable_to_non_nullable
              as String,
      skinConcerns: null == skinConcerns
          ? _value._skinConcerns
          : skinConcerns // ignore: cast_nullable_to_non_nullable
              as List<SkinConcern>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalysisResultImpl implements _AnalysisResult {
  const _$AnalysisResultImpl(
      {required this.personalColor,
      required this.skinTone,
      required final List<SkinConcern> skinConcerns})
      : _skinConcerns = skinConcerns;

  factory _$AnalysisResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalysisResultImplFromJson(json);

  @override
  final String personalColor;
// 퍼스널 컬러 진단 결과 (예: "가을 웜 뮤트")
  @override
  final String skinTone;
// 상세 스킨톤 분석 (예: "22호 뉴트럴 톤")
  final List<SkinConcern> _skinConcerns;
// 상세 스킨톤 분석 (예: "22호 뉴트럴 톤")
  @override
  List<SkinConcern> get skinConcerns {
    if (_skinConcerns is EqualUnmodifiableListView) return _skinConcerns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skinConcerns);
  }

  @override
  String toString() {
    return 'AnalysisResult(personalColor: $personalColor, skinTone: $skinTone, skinConcerns: $skinConcerns)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisResultImpl &&
            (identical(other.personalColor, personalColor) ||
                other.personalColor == personalColor) &&
            (identical(other.skinTone, skinTone) ||
                other.skinTone == skinTone) &&
            const DeepCollectionEquality()
                .equals(other._skinConcerns, _skinConcerns));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, personalColor, skinTone,
      const DeepCollectionEquality().hash(_skinConcerns));

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalysisResultImplCopyWith<_$AnalysisResultImpl> get copyWith =>
      __$$AnalysisResultImplCopyWithImpl<_$AnalysisResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalysisResultImplToJson(
      this,
    );
  }
}

abstract class _AnalysisResult implements AnalysisResult {
  const factory _AnalysisResult(
      {required final String personalColor,
      required final String skinTone,
      required final List<SkinConcern> skinConcerns}) = _$AnalysisResultImpl;

  factory _AnalysisResult.fromJson(Map<String, dynamic> json) =
      _$AnalysisResultImpl.fromJson;

  @override
  String get personalColor; // 퍼스널 컬러 진단 결과 (예: "가을 웜 뮤트")
  @override
  String get skinTone; // 상세 스킨톤 분석 (예: "22호 뉴트럴 톤")
  @override
  List<SkinConcern> get skinConcerns;

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalysisResultImplCopyWith<_$AnalysisResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SkinConcern _$SkinConcernFromJson(Map<String, dynamic> json) {
  return _SkinConcern.fromJson(json);
}

/// @nodoc
mixin _$SkinConcern {
  String get name => throw _privateConstructorUsedError; // 고민 이름 (예: "모공")
  int get score => throw _privateConstructorUsedError; // 점수 (예: 85)
  String get description => throw _privateConstructorUsedError;

  /// Serializes this SkinConcern to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SkinConcern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SkinConcernCopyWith<SkinConcern> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkinConcernCopyWith<$Res> {
  factory $SkinConcernCopyWith(
          SkinConcern value, $Res Function(SkinConcern) then) =
      _$SkinConcernCopyWithImpl<$Res, SkinConcern>;
  @useResult
  $Res call({String name, int score, String description});
}

/// @nodoc
class _$SkinConcernCopyWithImpl<$Res, $Val extends SkinConcern>
    implements $SkinConcernCopyWith<$Res> {
  _$SkinConcernCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SkinConcern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? score = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SkinConcernImplCopyWith<$Res>
    implements $SkinConcernCopyWith<$Res> {
  factory _$$SkinConcernImplCopyWith(
          _$SkinConcernImpl value, $Res Function(_$SkinConcernImpl) then) =
      __$$SkinConcernImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int score, String description});
}

/// @nodoc
class __$$SkinConcernImplCopyWithImpl<$Res>
    extends _$SkinConcernCopyWithImpl<$Res, _$SkinConcernImpl>
    implements _$$SkinConcernImplCopyWith<$Res> {
  __$$SkinConcernImplCopyWithImpl(
      _$SkinConcernImpl _value, $Res Function(_$SkinConcernImpl) _then)
      : super(_value, _then);

  /// Create a copy of SkinConcern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? score = null,
    Object? description = null,
  }) {
    return _then(_$SkinConcernImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SkinConcernImpl implements _SkinConcern {
  const _$SkinConcernImpl(
      {required this.name, required this.score, required this.description});

  factory _$SkinConcernImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkinConcernImplFromJson(json);

  @override
  final String name;
// 고민 이름 (예: "모공")
  @override
  final int score;
// 점수 (예: 85)
  @override
  final String description;

  @override
  String toString() {
    return 'SkinConcern(name: $name, score: $score, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkinConcernImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, score, description);

  /// Create a copy of SkinConcern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkinConcernImplCopyWith<_$SkinConcernImpl> get copyWith =>
      __$$SkinConcernImplCopyWithImpl<_$SkinConcernImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkinConcernImplToJson(
      this,
    );
  }
}

abstract class _SkinConcern implements SkinConcern {
  const factory _SkinConcern(
      {required final String name,
      required final int score,
      required final String description}) = _$SkinConcernImpl;

  factory _SkinConcern.fromJson(Map<String, dynamic> json) =
      _$SkinConcernImpl.fromJson;

  @override
  String get name; // 고민 이름 (예: "모공")
  @override
  int get score; // 점수 (예: 85)
  @override
  String get description;

  /// Create a copy of SkinConcern
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkinConcernImplCopyWith<_$SkinConcernImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
