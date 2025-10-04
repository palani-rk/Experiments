// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'questionnaire_responses_submission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuestionnaireResponsesSubmission _$QuestionnaireResponsesSubmissionFromJson(
    Map<String, dynamic> json) {
  return _QuestionnaireResponsesSubmission.fromJson(json);
}

/// @nodoc
mixin _$QuestionnaireResponsesSubmission {
  String get questionnaireId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  List<SectionResponse> get sectionResponses =>
      throw _privateConstructorUsedError;
  DateTime? get submittedAt => throw _privateConstructorUsedError;
  bool get isComplete => throw _privateConstructorUsedError;

  /// Serializes this QuestionnaireResponsesSubmission to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionnaireResponsesSubmission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionnaireResponsesSubmissionCopyWith<QuestionnaireResponsesSubmission>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionnaireResponsesSubmissionCopyWith<$Res> {
  factory $QuestionnaireResponsesSubmissionCopyWith(
          QuestionnaireResponsesSubmission value,
          $Res Function(QuestionnaireResponsesSubmission) then) =
      _$QuestionnaireResponsesSubmissionCopyWithImpl<$Res,
          QuestionnaireResponsesSubmission>;
  @useResult
  $Res call(
      {String questionnaireId,
      String userId,
      List<SectionResponse> sectionResponses,
      DateTime? submittedAt,
      bool isComplete});
}

/// @nodoc
class _$QuestionnaireResponsesSubmissionCopyWithImpl<$Res,
        $Val extends QuestionnaireResponsesSubmission>
    implements $QuestionnaireResponsesSubmissionCopyWith<$Res> {
  _$QuestionnaireResponsesSubmissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionnaireResponsesSubmission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionnaireId = null,
    Object? userId = null,
    Object? sectionResponses = null,
    Object? submittedAt = freezed,
    Object? isComplete = null,
  }) {
    return _then(_value.copyWith(
      questionnaireId: null == questionnaireId
          ? _value.questionnaireId
          : questionnaireId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sectionResponses: null == sectionResponses
          ? _value.sectionResponses
          : sectionResponses // ignore: cast_nullable_to_non_nullable
              as List<SectionResponse>,
      submittedAt: freezed == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isComplete: null == isComplete
          ? _value.isComplete
          : isComplete // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionnaireResponsesSubmissionImplCopyWith<$Res>
    implements $QuestionnaireResponsesSubmissionCopyWith<$Res> {
  factory _$$QuestionnaireResponsesSubmissionImplCopyWith(
          _$QuestionnaireResponsesSubmissionImpl value,
          $Res Function(_$QuestionnaireResponsesSubmissionImpl) then) =
      __$$QuestionnaireResponsesSubmissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String questionnaireId,
      String userId,
      List<SectionResponse> sectionResponses,
      DateTime? submittedAt,
      bool isComplete});
}

/// @nodoc
class __$$QuestionnaireResponsesSubmissionImplCopyWithImpl<$Res>
    extends _$QuestionnaireResponsesSubmissionCopyWithImpl<$Res,
        _$QuestionnaireResponsesSubmissionImpl>
    implements _$$QuestionnaireResponsesSubmissionImplCopyWith<$Res> {
  __$$QuestionnaireResponsesSubmissionImplCopyWithImpl(
      _$QuestionnaireResponsesSubmissionImpl _value,
      $Res Function(_$QuestionnaireResponsesSubmissionImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuestionnaireResponsesSubmission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionnaireId = null,
    Object? userId = null,
    Object? sectionResponses = null,
    Object? submittedAt = freezed,
    Object? isComplete = null,
  }) {
    return _then(_$QuestionnaireResponsesSubmissionImpl(
      questionnaireId: null == questionnaireId
          ? _value.questionnaireId
          : questionnaireId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sectionResponses: null == sectionResponses
          ? _value._sectionResponses
          : sectionResponses // ignore: cast_nullable_to_non_nullable
              as List<SectionResponse>,
      submittedAt: freezed == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isComplete: null == isComplete
          ? _value.isComplete
          : isComplete // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionnaireResponsesSubmissionImpl
    implements _QuestionnaireResponsesSubmission {
  const _$QuestionnaireResponsesSubmissionImpl(
      {required this.questionnaireId,
      required this.userId,
      required final List<SectionResponse> sectionResponses,
      this.submittedAt,
      this.isComplete = false})
      : _sectionResponses = sectionResponses;

  factory _$QuestionnaireResponsesSubmissionImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$QuestionnaireResponsesSubmissionImplFromJson(json);

  @override
  final String questionnaireId;
  @override
  final String userId;
  final List<SectionResponse> _sectionResponses;
  @override
  List<SectionResponse> get sectionResponses {
    if (_sectionResponses is EqualUnmodifiableListView)
      return _sectionResponses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sectionResponses);
  }

  @override
  final DateTime? submittedAt;
  @override
  @JsonKey()
  final bool isComplete;

  @override
  String toString() {
    return 'QuestionnaireResponsesSubmission(questionnaireId: $questionnaireId, userId: $userId, sectionResponses: $sectionResponses, submittedAt: $submittedAt, isComplete: $isComplete)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionnaireResponsesSubmissionImpl &&
            (identical(other.questionnaireId, questionnaireId) ||
                other.questionnaireId == questionnaireId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality()
                .equals(other._sectionResponses, _sectionResponses) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.isComplete, isComplete) ||
                other.isComplete == isComplete));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      questionnaireId,
      userId,
      const DeepCollectionEquality().hash(_sectionResponses),
      submittedAt,
      isComplete);

  /// Create a copy of QuestionnaireResponsesSubmission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionnaireResponsesSubmissionImplCopyWith<
          _$QuestionnaireResponsesSubmissionImpl>
      get copyWith => __$$QuestionnaireResponsesSubmissionImplCopyWithImpl<
          _$QuestionnaireResponsesSubmissionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionnaireResponsesSubmissionImplToJson(
      this,
    );
  }
}

abstract class _QuestionnaireResponsesSubmission
    implements QuestionnaireResponsesSubmission {
  const factory _QuestionnaireResponsesSubmission(
      {required final String questionnaireId,
      required final String userId,
      required final List<SectionResponse> sectionResponses,
      final DateTime? submittedAt,
      final bool isComplete}) = _$QuestionnaireResponsesSubmissionImpl;

  factory _QuestionnaireResponsesSubmission.fromJson(
          Map<String, dynamic> json) =
      _$QuestionnaireResponsesSubmissionImpl.fromJson;

  @override
  String get questionnaireId;
  @override
  String get userId;
  @override
  List<SectionResponse> get sectionResponses;
  @override
  DateTime? get submittedAt;
  @override
  bool get isComplete;

  /// Create a copy of QuestionnaireResponsesSubmission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionnaireResponsesSubmissionImplCopyWith<
          _$QuestionnaireResponsesSubmissionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
