// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'completed_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CompletedResponse _$CompletedResponseFromJson(Map<String, dynamic> json) {
  return _CompletedResponse.fromJson(json);
}

/// @nodoc
mixin _$CompletedResponse {
  /// Unique identifier for the question that was answered
  String get questionId => throw _privateConstructorUsedError;

  /// The actual text of the question
  String get questionText => throw _privateConstructorUsedError;

  /// The user's answer - can be String, number, List<String>, etc.
  dynamic get answer => throw _privateConstructorUsedError;

  /// ID of the section this question belongs to
  String get sectionId => throw _privateConstructorUsedError;

  /// Human-readable title of the section
  String get sectionTitle => throw _privateConstructorUsedError;

  /// Timestamp when the question was answered
  DateTime get answeredAt => throw _privateConstructorUsedError;

  /// Whether this response can be edited by the user
  bool get isEditable => throw _privateConstructorUsedError;

  /// Optional validation error message if answer is invalid
  String? get validationError => throw _privateConstructorUsedError;

  /// Optional confidence score for the answer (0.0 to 1.0)
  double? get confidenceScore => throw _privateConstructorUsedError;

  /// Serializes this CompletedResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompletedResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompletedResponseCopyWith<CompletedResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompletedResponseCopyWith<$Res> {
  factory $CompletedResponseCopyWith(
          CompletedResponse value, $Res Function(CompletedResponse) then) =
      _$CompletedResponseCopyWithImpl<$Res, CompletedResponse>;
  @useResult
  $Res call(
      {String questionId,
      String questionText,
      dynamic answer,
      String sectionId,
      String sectionTitle,
      DateTime answeredAt,
      bool isEditable,
      String? validationError,
      double? confidenceScore});
}

/// @nodoc
class _$CompletedResponseCopyWithImpl<$Res, $Val extends CompletedResponse>
    implements $CompletedResponseCopyWith<$Res> {
  _$CompletedResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompletedResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? questionText = null,
    Object? answer = freezed,
    Object? sectionId = null,
    Object? sectionTitle = null,
    Object? answeredAt = null,
    Object? isEditable = null,
    Object? validationError = freezed,
    Object? confidenceScore = freezed,
  }) {
    return _then(_value.copyWith(
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      questionText: null == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String,
      answer: freezed == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as dynamic,
      sectionId: null == sectionId
          ? _value.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String,
      sectionTitle: null == sectionTitle
          ? _value.sectionTitle
          : sectionTitle // ignore: cast_nullable_to_non_nullable
              as String,
      answeredAt: null == answeredAt
          ? _value.answeredAt
          : answeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isEditable: null == isEditable
          ? _value.isEditable
          : isEditable // ignore: cast_nullable_to_non_nullable
              as bool,
      validationError: freezed == validationError
          ? _value.validationError
          : validationError // ignore: cast_nullable_to_non_nullable
              as String?,
      confidenceScore: freezed == confidenceScore
          ? _value.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompletedResponseImplCopyWith<$Res>
    implements $CompletedResponseCopyWith<$Res> {
  factory _$$CompletedResponseImplCopyWith(_$CompletedResponseImpl value,
          $Res Function(_$CompletedResponseImpl) then) =
      __$$CompletedResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String questionId,
      String questionText,
      dynamic answer,
      String sectionId,
      String sectionTitle,
      DateTime answeredAt,
      bool isEditable,
      String? validationError,
      double? confidenceScore});
}

/// @nodoc
class __$$CompletedResponseImplCopyWithImpl<$Res>
    extends _$CompletedResponseCopyWithImpl<$Res, _$CompletedResponseImpl>
    implements _$$CompletedResponseImplCopyWith<$Res> {
  __$$CompletedResponseImplCopyWithImpl(_$CompletedResponseImpl _value,
      $Res Function(_$CompletedResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompletedResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? questionText = null,
    Object? answer = freezed,
    Object? sectionId = null,
    Object? sectionTitle = null,
    Object? answeredAt = null,
    Object? isEditable = null,
    Object? validationError = freezed,
    Object? confidenceScore = freezed,
  }) {
    return _then(_$CompletedResponseImpl(
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      questionText: null == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String,
      answer: freezed == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as dynamic,
      sectionId: null == sectionId
          ? _value.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String,
      sectionTitle: null == sectionTitle
          ? _value.sectionTitle
          : sectionTitle // ignore: cast_nullable_to_non_nullable
              as String,
      answeredAt: null == answeredAt
          ? _value.answeredAt
          : answeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isEditable: null == isEditable
          ? _value.isEditable
          : isEditable // ignore: cast_nullable_to_non_nullable
              as bool,
      validationError: freezed == validationError
          ? _value.validationError
          : validationError // ignore: cast_nullable_to_non_nullable
              as String?,
      confidenceScore: freezed == confidenceScore
          ? _value.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompletedResponseImpl extends _CompletedResponse {
  const _$CompletedResponseImpl(
      {required this.questionId,
      required this.questionText,
      required this.answer,
      required this.sectionId,
      required this.sectionTitle,
      required this.answeredAt,
      this.isEditable = true,
      this.validationError,
      this.confidenceScore})
      : super._();

  factory _$CompletedResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompletedResponseImplFromJson(json);

  /// Unique identifier for the question that was answered
  @override
  final String questionId;

  /// The actual text of the question
  @override
  final String questionText;

  /// The user's answer - can be String, number, List<String>, etc.
  @override
  final dynamic answer;

  /// ID of the section this question belongs to
  @override
  final String sectionId;

  /// Human-readable title of the section
  @override
  final String sectionTitle;

  /// Timestamp when the question was answered
  @override
  final DateTime answeredAt;

  /// Whether this response can be edited by the user
  @override
  @JsonKey()
  final bool isEditable;

  /// Optional validation error message if answer is invalid
  @override
  final String? validationError;

  /// Optional confidence score for the answer (0.0 to 1.0)
  @override
  final double? confidenceScore;

  @override
  String toString() {
    return 'CompletedResponse(questionId: $questionId, questionText: $questionText, answer: $answer, sectionId: $sectionId, sectionTitle: $sectionTitle, answeredAt: $answeredAt, isEditable: $isEditable, validationError: $validationError, confidenceScore: $confidenceScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompletedResponseImpl &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            const DeepCollectionEquality().equals(other.answer, answer) &&
            (identical(other.sectionId, sectionId) ||
                other.sectionId == sectionId) &&
            (identical(other.sectionTitle, sectionTitle) ||
                other.sectionTitle == sectionTitle) &&
            (identical(other.answeredAt, answeredAt) ||
                other.answeredAt == answeredAt) &&
            (identical(other.isEditable, isEditable) ||
                other.isEditable == isEditable) &&
            (identical(other.validationError, validationError) ||
                other.validationError == validationError) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      questionId,
      questionText,
      const DeepCollectionEquality().hash(answer),
      sectionId,
      sectionTitle,
      answeredAt,
      isEditable,
      validationError,
      confidenceScore);

  /// Create a copy of CompletedResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompletedResponseImplCopyWith<_$CompletedResponseImpl> get copyWith =>
      __$$CompletedResponseImplCopyWithImpl<_$CompletedResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompletedResponseImplToJson(
      this,
    );
  }
}

abstract class _CompletedResponse extends CompletedResponse {
  const factory _CompletedResponse(
      {required final String questionId,
      required final String questionText,
      required final dynamic answer,
      required final String sectionId,
      required final String sectionTitle,
      required final DateTime answeredAt,
      final bool isEditable,
      final String? validationError,
      final double? confidenceScore}) = _$CompletedResponseImpl;
  const _CompletedResponse._() : super._();

  factory _CompletedResponse.fromJson(Map<String, dynamic> json) =
      _$CompletedResponseImpl.fromJson;

  /// Unique identifier for the question that was answered
  @override
  String get questionId;

  /// The actual text of the question
  @override
  String get questionText;

  /// The user's answer - can be String, number, List<String>, etc.
  @override
  dynamic get answer;

  /// ID of the section this question belongs to
  @override
  String get sectionId;

  /// Human-readable title of the section
  @override
  String get sectionTitle;

  /// Timestamp when the question was answered
  @override
  DateTime get answeredAt;

  /// Whether this response can be edited by the user
  @override
  bool get isEditable;

  /// Optional validation error message if answer is invalid
  @override
  String? get validationError;

  /// Optional confidence score for the answer (0.0 to 1.0)
  @override
  double? get confidenceScore;

  /// Create a copy of CompletedResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompletedResponseImplCopyWith<_$CompletedResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ResponseGroup _$ResponseGroupFromJson(Map<String, dynamic> json) {
  return _ResponseGroup.fromJson(json);
}

/// @nodoc
mixin _$ResponseGroup {
  /// Unique identifier for the section
  String get sectionId => throw _privateConstructorUsedError;

  /// Human-readable title of the section
  String get sectionTitle => throw _privateConstructorUsedError;

  /// List of completed responses in this section
  List<CompletedResponse> get responses => throw _privateConstructorUsedError;

  /// Whether this group is expanded in the UI
  bool get isExpanded => throw _privateConstructorUsedError;

  /// Total number of questions in this section (for progress calculation)
  int? get totalQuestions => throw _privateConstructorUsedError;

  /// Optional section description
  String? get sectionDescription => throw _privateConstructorUsedError;

  /// Order index for sorting sections
  int get orderIndex => throw _privateConstructorUsedError;

  /// Serializes this ResponseGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResponseGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResponseGroupCopyWith<ResponseGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResponseGroupCopyWith<$Res> {
  factory $ResponseGroupCopyWith(
          ResponseGroup value, $Res Function(ResponseGroup) then) =
      _$ResponseGroupCopyWithImpl<$Res, ResponseGroup>;
  @useResult
  $Res call(
      {String sectionId,
      String sectionTitle,
      List<CompletedResponse> responses,
      bool isExpanded,
      int? totalQuestions,
      String? sectionDescription,
      int orderIndex});
}

/// @nodoc
class _$ResponseGroupCopyWithImpl<$Res, $Val extends ResponseGroup>
    implements $ResponseGroupCopyWith<$Res> {
  _$ResponseGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResponseGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sectionId = null,
    Object? sectionTitle = null,
    Object? responses = null,
    Object? isExpanded = null,
    Object? totalQuestions = freezed,
    Object? sectionDescription = freezed,
    Object? orderIndex = null,
  }) {
    return _then(_value.copyWith(
      sectionId: null == sectionId
          ? _value.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String,
      sectionTitle: null == sectionTitle
          ? _value.sectionTitle
          : sectionTitle // ignore: cast_nullable_to_non_nullable
              as String,
      responses: null == responses
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as List<CompletedResponse>,
      isExpanded: null == isExpanded
          ? _value.isExpanded
          : isExpanded // ignore: cast_nullable_to_non_nullable
              as bool,
      totalQuestions: freezed == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int?,
      sectionDescription: freezed == sectionDescription
          ? _value.sectionDescription
          : sectionDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResponseGroupImplCopyWith<$Res>
    implements $ResponseGroupCopyWith<$Res> {
  factory _$$ResponseGroupImplCopyWith(
          _$ResponseGroupImpl value, $Res Function(_$ResponseGroupImpl) then) =
      __$$ResponseGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sectionId,
      String sectionTitle,
      List<CompletedResponse> responses,
      bool isExpanded,
      int? totalQuestions,
      String? sectionDescription,
      int orderIndex});
}

/// @nodoc
class __$$ResponseGroupImplCopyWithImpl<$Res>
    extends _$ResponseGroupCopyWithImpl<$Res, _$ResponseGroupImpl>
    implements _$$ResponseGroupImplCopyWith<$Res> {
  __$$ResponseGroupImplCopyWithImpl(
      _$ResponseGroupImpl _value, $Res Function(_$ResponseGroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResponseGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sectionId = null,
    Object? sectionTitle = null,
    Object? responses = null,
    Object? isExpanded = null,
    Object? totalQuestions = freezed,
    Object? sectionDescription = freezed,
    Object? orderIndex = null,
  }) {
    return _then(_$ResponseGroupImpl(
      sectionId: null == sectionId
          ? _value.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String,
      sectionTitle: null == sectionTitle
          ? _value.sectionTitle
          : sectionTitle // ignore: cast_nullable_to_non_nullable
              as String,
      responses: null == responses
          ? _value._responses
          : responses // ignore: cast_nullable_to_non_nullable
              as List<CompletedResponse>,
      isExpanded: null == isExpanded
          ? _value.isExpanded
          : isExpanded // ignore: cast_nullable_to_non_nullable
              as bool,
      totalQuestions: freezed == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int?,
      sectionDescription: freezed == sectionDescription
          ? _value.sectionDescription
          : sectionDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResponseGroupImpl extends _ResponseGroup {
  const _$ResponseGroupImpl(
      {required this.sectionId,
      required this.sectionTitle,
      required final List<CompletedResponse> responses,
      this.isExpanded = false,
      this.totalQuestions,
      this.sectionDescription,
      this.orderIndex = 0})
      : _responses = responses,
        super._();

  factory _$ResponseGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResponseGroupImplFromJson(json);

  /// Unique identifier for the section
  @override
  final String sectionId;

  /// Human-readable title of the section
  @override
  final String sectionTitle;

  /// List of completed responses in this section
  final List<CompletedResponse> _responses;

  /// List of completed responses in this section
  @override
  List<CompletedResponse> get responses {
    if (_responses is EqualUnmodifiableListView) return _responses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_responses);
  }

  /// Whether this group is expanded in the UI
  @override
  @JsonKey()
  final bool isExpanded;

  /// Total number of questions in this section (for progress calculation)
  @override
  final int? totalQuestions;

  /// Optional section description
  @override
  final String? sectionDescription;

  /// Order index for sorting sections
  @override
  @JsonKey()
  final int orderIndex;

  @override
  String toString() {
    return 'ResponseGroup(sectionId: $sectionId, sectionTitle: $sectionTitle, responses: $responses, isExpanded: $isExpanded, totalQuestions: $totalQuestions, sectionDescription: $sectionDescription, orderIndex: $orderIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResponseGroupImpl &&
            (identical(other.sectionId, sectionId) ||
                other.sectionId == sectionId) &&
            (identical(other.sectionTitle, sectionTitle) ||
                other.sectionTitle == sectionTitle) &&
            const DeepCollectionEquality()
                .equals(other._responses, _responses) &&
            (identical(other.isExpanded, isExpanded) ||
                other.isExpanded == isExpanded) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.sectionDescription, sectionDescription) ||
                other.sectionDescription == sectionDescription) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sectionId,
      sectionTitle,
      const DeepCollectionEquality().hash(_responses),
      isExpanded,
      totalQuestions,
      sectionDescription,
      orderIndex);

  /// Create a copy of ResponseGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResponseGroupImplCopyWith<_$ResponseGroupImpl> get copyWith =>
      __$$ResponseGroupImplCopyWithImpl<_$ResponseGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResponseGroupImplToJson(
      this,
    );
  }
}

abstract class _ResponseGroup extends ResponseGroup {
  const factory _ResponseGroup(
      {required final String sectionId,
      required final String sectionTitle,
      required final List<CompletedResponse> responses,
      final bool isExpanded,
      final int? totalQuestions,
      final String? sectionDescription,
      final int orderIndex}) = _$ResponseGroupImpl;
  const _ResponseGroup._() : super._();

  factory _ResponseGroup.fromJson(Map<String, dynamic> json) =
      _$ResponseGroupImpl.fromJson;

  /// Unique identifier for the section
  @override
  String get sectionId;

  /// Human-readable title of the section
  @override
  String get sectionTitle;

  /// List of completed responses in this section
  @override
  List<CompletedResponse> get responses;

  /// Whether this group is expanded in the UI
  @override
  bool get isExpanded;

  /// Total number of questions in this section (for progress calculation)
  @override
  int? get totalQuestions;

  /// Optional section description
  @override
  String? get sectionDescription;

  /// Order index for sorting sections
  @override
  int get orderIndex;

  /// Create a copy of ResponseGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResponseGroupImplCopyWith<_$ResponseGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OverallProgress _$OverallProgressFromJson(Map<String, dynamic> json) {
  return _OverallProgress.fromJson(json);
}

/// @nodoc
mixin _$OverallProgress {
  /// List of all response groups
  List<ResponseGroup> get groups => throw _privateConstructorUsedError;

  /// Index of the currently active section
  int get currentSectionIndex => throw _privateConstructorUsedError;

  /// Index of the currently active question within the section
  int get currentQuestionIndex => throw _privateConstructorUsedError;

  /// Total number of questions across all sections
  int? get totalQuestions => throw _privateConstructorUsedError;

  /// Timestamp of last update
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this OverallProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OverallProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OverallProgressCopyWith<OverallProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OverallProgressCopyWith<$Res> {
  factory $OverallProgressCopyWith(
          OverallProgress value, $Res Function(OverallProgress) then) =
      _$OverallProgressCopyWithImpl<$Res, OverallProgress>;
  @useResult
  $Res call(
      {List<ResponseGroup> groups,
      int currentSectionIndex,
      int currentQuestionIndex,
      int? totalQuestions,
      DateTime? lastUpdated});
}

/// @nodoc
class _$OverallProgressCopyWithImpl<$Res, $Val extends OverallProgress>
    implements $OverallProgressCopyWith<$Res> {
  _$OverallProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OverallProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groups = null,
    Object? currentSectionIndex = null,
    Object? currentQuestionIndex = null,
    Object? totalQuestions = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      groups: null == groups
          ? _value.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<ResponseGroup>,
      currentSectionIndex: null == currentSectionIndex
          ? _value.currentSectionIndex
          : currentSectionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      currentQuestionIndex: null == currentQuestionIndex
          ? _value.currentQuestionIndex
          : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuestions: freezed == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OverallProgressImplCopyWith<$Res>
    implements $OverallProgressCopyWith<$Res> {
  factory _$$OverallProgressImplCopyWith(_$OverallProgressImpl value,
          $Res Function(_$OverallProgressImpl) then) =
      __$$OverallProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ResponseGroup> groups,
      int currentSectionIndex,
      int currentQuestionIndex,
      int? totalQuestions,
      DateTime? lastUpdated});
}

/// @nodoc
class __$$OverallProgressImplCopyWithImpl<$Res>
    extends _$OverallProgressCopyWithImpl<$Res, _$OverallProgressImpl>
    implements _$$OverallProgressImplCopyWith<$Res> {
  __$$OverallProgressImplCopyWithImpl(
      _$OverallProgressImpl _value, $Res Function(_$OverallProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of OverallProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groups = null,
    Object? currentSectionIndex = null,
    Object? currentQuestionIndex = null,
    Object? totalQuestions = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_$OverallProgressImpl(
      groups: null == groups
          ? _value._groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<ResponseGroup>,
      currentSectionIndex: null == currentSectionIndex
          ? _value.currentSectionIndex
          : currentSectionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      currentQuestionIndex: null == currentQuestionIndex
          ? _value.currentQuestionIndex
          : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuestions: freezed == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OverallProgressImpl extends _OverallProgress {
  const _$OverallProgressImpl(
      {required final List<ResponseGroup> groups,
      this.currentSectionIndex = 0,
      this.currentQuestionIndex = 0,
      this.totalQuestions,
      this.lastUpdated})
      : _groups = groups,
        super._();

  factory _$OverallProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$OverallProgressImplFromJson(json);

  /// List of all response groups
  final List<ResponseGroup> _groups;

  /// List of all response groups
  @override
  List<ResponseGroup> get groups {
    if (_groups is EqualUnmodifiableListView) return _groups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_groups);
  }

  /// Index of the currently active section
  @override
  @JsonKey()
  final int currentSectionIndex;

  /// Index of the currently active question within the section
  @override
  @JsonKey()
  final int currentQuestionIndex;

  /// Total number of questions across all sections
  @override
  final int? totalQuestions;

  /// Timestamp of last update
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'OverallProgress(groups: $groups, currentSectionIndex: $currentSectionIndex, currentQuestionIndex: $currentQuestionIndex, totalQuestions: $totalQuestions, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OverallProgressImpl &&
            const DeepCollectionEquality().equals(other._groups, _groups) &&
            (identical(other.currentSectionIndex, currentSectionIndex) ||
                other.currentSectionIndex == currentSectionIndex) &&
            (identical(other.currentQuestionIndex, currentQuestionIndex) ||
                other.currentQuestionIndex == currentQuestionIndex) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_groups),
      currentSectionIndex,
      currentQuestionIndex,
      totalQuestions,
      lastUpdated);

  /// Create a copy of OverallProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OverallProgressImplCopyWith<_$OverallProgressImpl> get copyWith =>
      __$$OverallProgressImplCopyWithImpl<_$OverallProgressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OverallProgressImplToJson(
      this,
    );
  }
}

abstract class _OverallProgress extends OverallProgress {
  const factory _OverallProgress(
      {required final List<ResponseGroup> groups,
      final int currentSectionIndex,
      final int currentQuestionIndex,
      final int? totalQuestions,
      final DateTime? lastUpdated}) = _$OverallProgressImpl;
  const _OverallProgress._() : super._();

  factory _OverallProgress.fromJson(Map<String, dynamic> json) =
      _$OverallProgressImpl.fromJson;

  /// List of all response groups
  @override
  List<ResponseGroup> get groups;

  /// Index of the currently active section
  @override
  int get currentSectionIndex;

  /// Index of the currently active question within the section
  @override
  int get currentQuestionIndex;

  /// Total number of questions across all sections
  @override
  int? get totalQuestions;

  /// Timestamp of last update
  @override
  DateTime? get lastUpdated;

  /// Create a copy of OverallProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OverallProgressImplCopyWith<_$OverallProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
