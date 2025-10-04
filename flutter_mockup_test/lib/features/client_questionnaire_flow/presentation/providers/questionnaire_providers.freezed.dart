// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'questionnaire_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QuestionnaireState {
  QuestionnaireConfig? get config => throw _privateConstructorUsedError;
  Map<String, SectionResponse> get sectionResponses =>
      throw _privateConstructorUsedError;
  String? get currentQuestionId => throw _privateConstructorUsedError;
  int get currentSectionIndex => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  bool get isSubmitted => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of QuestionnaireState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionnaireStateCopyWith<QuestionnaireState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionnaireStateCopyWith<$Res> {
  factory $QuestionnaireStateCopyWith(
          QuestionnaireState value, $Res Function(QuestionnaireState) then) =
      _$QuestionnaireStateCopyWithImpl<$Res, QuestionnaireState>;
  @useResult
  $Res call(
      {QuestionnaireConfig? config,
      Map<String, SectionResponse> sectionResponses,
      String? currentQuestionId,
      int currentSectionIndex,
      bool isCompleted,
      bool isSubmitted,
      bool isLoading,
      String? error});

  $QuestionnaireConfigCopyWith<$Res>? get config;
}

/// @nodoc
class _$QuestionnaireStateCopyWithImpl<$Res, $Val extends QuestionnaireState>
    implements $QuestionnaireStateCopyWith<$Res> {
  _$QuestionnaireStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionnaireState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? config = freezed,
    Object? sectionResponses = null,
    Object? currentQuestionId = freezed,
    Object? currentSectionIndex = null,
    Object? isCompleted = null,
    Object? isSubmitted = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      config: freezed == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as QuestionnaireConfig?,
      sectionResponses: null == sectionResponses
          ? _value.sectionResponses
          : sectionResponses // ignore: cast_nullable_to_non_nullable
              as Map<String, SectionResponse>,
      currentQuestionId: freezed == currentQuestionId
          ? _value.currentQuestionId
          : currentQuestionId // ignore: cast_nullable_to_non_nullable
              as String?,
      currentSectionIndex: null == currentSectionIndex
          ? _value.currentSectionIndex
          : currentSectionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitted: null == isSubmitted
          ? _value.isSubmitted
          : isSubmitted // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of QuestionnaireState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuestionnaireConfigCopyWith<$Res>? get config {
    if (_value.config == null) {
      return null;
    }

    return $QuestionnaireConfigCopyWith<$Res>(_value.config!, (value) {
      return _then(_value.copyWith(config: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuestionnaireStateImplCopyWith<$Res>
    implements $QuestionnaireStateCopyWith<$Res> {
  factory _$$QuestionnaireStateImplCopyWith(_$QuestionnaireStateImpl value,
          $Res Function(_$QuestionnaireStateImpl) then) =
      __$$QuestionnaireStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {QuestionnaireConfig? config,
      Map<String, SectionResponse> sectionResponses,
      String? currentQuestionId,
      int currentSectionIndex,
      bool isCompleted,
      bool isSubmitted,
      bool isLoading,
      String? error});

  @override
  $QuestionnaireConfigCopyWith<$Res>? get config;
}

/// @nodoc
class __$$QuestionnaireStateImplCopyWithImpl<$Res>
    extends _$QuestionnaireStateCopyWithImpl<$Res, _$QuestionnaireStateImpl>
    implements _$$QuestionnaireStateImplCopyWith<$Res> {
  __$$QuestionnaireStateImplCopyWithImpl(_$QuestionnaireStateImpl _value,
      $Res Function(_$QuestionnaireStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuestionnaireState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? config = freezed,
    Object? sectionResponses = null,
    Object? currentQuestionId = freezed,
    Object? currentSectionIndex = null,
    Object? isCompleted = null,
    Object? isSubmitted = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$QuestionnaireStateImpl(
      config: freezed == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as QuestionnaireConfig?,
      sectionResponses: null == sectionResponses
          ? _value._sectionResponses
          : sectionResponses // ignore: cast_nullable_to_non_nullable
              as Map<String, SectionResponse>,
      currentQuestionId: freezed == currentQuestionId
          ? _value.currentQuestionId
          : currentQuestionId // ignore: cast_nullable_to_non_nullable
              as String?,
      currentSectionIndex: null == currentSectionIndex
          ? _value.currentSectionIndex
          : currentSectionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitted: null == isSubmitted
          ? _value.isSubmitted
          : isSubmitted // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$QuestionnaireStateImpl implements _QuestionnaireState {
  const _$QuestionnaireStateImpl(
      {this.config,
      final Map<String, SectionResponse> sectionResponses = const {},
      this.currentQuestionId,
      this.currentSectionIndex = 0,
      this.isCompleted = false,
      this.isSubmitted = false,
      this.isLoading = false,
      this.error})
      : _sectionResponses = sectionResponses;

  @override
  final QuestionnaireConfig? config;
  final Map<String, SectionResponse> _sectionResponses;
  @override
  @JsonKey()
  Map<String, SectionResponse> get sectionResponses {
    if (_sectionResponses is EqualUnmodifiableMapView) return _sectionResponses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_sectionResponses);
  }

  @override
  final String? currentQuestionId;
  @override
  @JsonKey()
  final int currentSectionIndex;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  @JsonKey()
  final bool isSubmitted;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'QuestionnaireState(config: $config, sectionResponses: $sectionResponses, currentQuestionId: $currentQuestionId, currentSectionIndex: $currentSectionIndex, isCompleted: $isCompleted, isSubmitted: $isSubmitted, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionnaireStateImpl &&
            (identical(other.config, config) || other.config == config) &&
            const DeepCollectionEquality()
                .equals(other._sectionResponses, _sectionResponses) &&
            (identical(other.currentQuestionId, currentQuestionId) ||
                other.currentQuestionId == currentQuestionId) &&
            (identical(other.currentSectionIndex, currentSectionIndex) ||
                other.currentSectionIndex == currentSectionIndex) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.isSubmitted, isSubmitted) ||
                other.isSubmitted == isSubmitted) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      config,
      const DeepCollectionEquality().hash(_sectionResponses),
      currentQuestionId,
      currentSectionIndex,
      isCompleted,
      isSubmitted,
      isLoading,
      error);

  /// Create a copy of QuestionnaireState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionnaireStateImplCopyWith<_$QuestionnaireStateImpl> get copyWith =>
      __$$QuestionnaireStateImplCopyWithImpl<_$QuestionnaireStateImpl>(
          this, _$identity);
}

abstract class _QuestionnaireState implements QuestionnaireState {
  const factory _QuestionnaireState(
      {final QuestionnaireConfig? config,
      final Map<String, SectionResponse> sectionResponses,
      final String? currentQuestionId,
      final int currentSectionIndex,
      final bool isCompleted,
      final bool isSubmitted,
      final bool isLoading,
      final String? error}) = _$QuestionnaireStateImpl;

  @override
  QuestionnaireConfig? get config;
  @override
  Map<String, SectionResponse> get sectionResponses;
  @override
  String? get currentQuestionId;
  @override
  int get currentSectionIndex;
  @override
  bool get isCompleted;
  @override
  bool get isSubmitted;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of QuestionnaireState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionnaireStateImplCopyWith<_$QuestionnaireStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ProgressInfo {
  int get currentSection => throw _privateConstructorUsedError;
  int get totalSections => throw _privateConstructorUsedError;
  double get overallProgress => throw _privateConstructorUsedError;
  double get sectionProgress => throw _privateConstructorUsedError;

  /// Create a copy of ProgressInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProgressInfoCopyWith<ProgressInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressInfoCopyWith<$Res> {
  factory $ProgressInfoCopyWith(
          ProgressInfo value, $Res Function(ProgressInfo) then) =
      _$ProgressInfoCopyWithImpl<$Res, ProgressInfo>;
  @useResult
  $Res call(
      {int currentSection,
      int totalSections,
      double overallProgress,
      double sectionProgress});
}

/// @nodoc
class _$ProgressInfoCopyWithImpl<$Res, $Val extends ProgressInfo>
    implements $ProgressInfoCopyWith<$Res> {
  _$ProgressInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProgressInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentSection = null,
    Object? totalSections = null,
    Object? overallProgress = null,
    Object? sectionProgress = null,
  }) {
    return _then(_value.copyWith(
      currentSection: null == currentSection
          ? _value.currentSection
          : currentSection // ignore: cast_nullable_to_non_nullable
              as int,
      totalSections: null == totalSections
          ? _value.totalSections
          : totalSections // ignore: cast_nullable_to_non_nullable
              as int,
      overallProgress: null == overallProgress
          ? _value.overallProgress
          : overallProgress // ignore: cast_nullable_to_non_nullable
              as double,
      sectionProgress: null == sectionProgress
          ? _value.sectionProgress
          : sectionProgress // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProgressInfoImplCopyWith<$Res>
    implements $ProgressInfoCopyWith<$Res> {
  factory _$$ProgressInfoImplCopyWith(
          _$ProgressInfoImpl value, $Res Function(_$ProgressInfoImpl) then) =
      __$$ProgressInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentSection,
      int totalSections,
      double overallProgress,
      double sectionProgress});
}

/// @nodoc
class __$$ProgressInfoImplCopyWithImpl<$Res>
    extends _$ProgressInfoCopyWithImpl<$Res, _$ProgressInfoImpl>
    implements _$$ProgressInfoImplCopyWith<$Res> {
  __$$ProgressInfoImplCopyWithImpl(
      _$ProgressInfoImpl _value, $Res Function(_$ProgressInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProgressInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentSection = null,
    Object? totalSections = null,
    Object? overallProgress = null,
    Object? sectionProgress = null,
  }) {
    return _then(_$ProgressInfoImpl(
      currentSection: null == currentSection
          ? _value.currentSection
          : currentSection // ignore: cast_nullable_to_non_nullable
              as int,
      totalSections: null == totalSections
          ? _value.totalSections
          : totalSections // ignore: cast_nullable_to_non_nullable
              as int,
      overallProgress: null == overallProgress
          ? _value.overallProgress
          : overallProgress // ignore: cast_nullable_to_non_nullable
              as double,
      sectionProgress: null == sectionProgress
          ? _value.sectionProgress
          : sectionProgress // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$ProgressInfoImpl implements _ProgressInfo {
  const _$ProgressInfoImpl(
      {required this.currentSection,
      required this.totalSections,
      required this.overallProgress,
      required this.sectionProgress});

  @override
  final int currentSection;
  @override
  final int totalSections;
  @override
  final double overallProgress;
  @override
  final double sectionProgress;

  @override
  String toString() {
    return 'ProgressInfo(currentSection: $currentSection, totalSections: $totalSections, overallProgress: $overallProgress, sectionProgress: $sectionProgress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressInfoImpl &&
            (identical(other.currentSection, currentSection) ||
                other.currentSection == currentSection) &&
            (identical(other.totalSections, totalSections) ||
                other.totalSections == totalSections) &&
            (identical(other.overallProgress, overallProgress) ||
                other.overallProgress == overallProgress) &&
            (identical(other.sectionProgress, sectionProgress) ||
                other.sectionProgress == sectionProgress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentSection, totalSections,
      overallProgress, sectionProgress);

  /// Create a copy of ProgressInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressInfoImplCopyWith<_$ProgressInfoImpl> get copyWith =>
      __$$ProgressInfoImplCopyWithImpl<_$ProgressInfoImpl>(this, _$identity);
}

abstract class _ProgressInfo implements ProgressInfo {
  const factory _ProgressInfo(
      {required final int currentSection,
      required final int totalSections,
      required final double overallProgress,
      required final double sectionProgress}) = _$ProgressInfoImpl;

  @override
  int get currentSection;
  @override
  int get totalSections;
  @override
  double get overallProgress;
  @override
  double get sectionProgress;

  /// Create a copy of ProgressInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProgressInfoImplCopyWith<_$ProgressInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
