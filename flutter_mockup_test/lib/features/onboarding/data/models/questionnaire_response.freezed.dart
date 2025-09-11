// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'questionnaire_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuestionnaireResponse _$QuestionnaireResponseFromJson(
    Map<String, dynamic> json) {
  return _QuestionnaireResponse.fromJson(json);
}

/// @nodoc
mixin _$QuestionnaireResponse {
  String get questionnaireId => throw _privateConstructorUsedError;
  Map<String, dynamic> get answers => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get completedTime => throw _privateConstructorUsedError;
  QuestionnaireStatus get status => throw _privateConstructorUsedError;

  /// Serializes this QuestionnaireResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionnaireResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionnaireResponseCopyWith<QuestionnaireResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionnaireResponseCopyWith<$Res> {
  factory $QuestionnaireResponseCopyWith(QuestionnaireResponse value,
          $Res Function(QuestionnaireResponse) then) =
      _$QuestionnaireResponseCopyWithImpl<$Res, QuestionnaireResponse>;
  @useResult
  $Res call(
      {String questionnaireId,
      Map<String, dynamic> answers,
      DateTime startTime,
      DateTime? completedTime,
      QuestionnaireStatus status});
}

/// @nodoc
class _$QuestionnaireResponseCopyWithImpl<$Res,
        $Val extends QuestionnaireResponse>
    implements $QuestionnaireResponseCopyWith<$Res> {
  _$QuestionnaireResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionnaireResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionnaireId = null,
    Object? answers = null,
    Object? startTime = null,
    Object? completedTime = freezed,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      questionnaireId: null == questionnaireId
          ? _value.questionnaireId
          : questionnaireId // ignore: cast_nullable_to_non_nullable
              as String,
      answers: null == answers
          ? _value.answers
          : answers // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedTime: freezed == completedTime
          ? _value.completedTime
          : completedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuestionnaireStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionnaireResponseImplCopyWith<$Res>
    implements $QuestionnaireResponseCopyWith<$Res> {
  factory _$$QuestionnaireResponseImplCopyWith(
          _$QuestionnaireResponseImpl value,
          $Res Function(_$QuestionnaireResponseImpl) then) =
      __$$QuestionnaireResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String questionnaireId,
      Map<String, dynamic> answers,
      DateTime startTime,
      DateTime? completedTime,
      QuestionnaireStatus status});
}

/// @nodoc
class __$$QuestionnaireResponseImplCopyWithImpl<$Res>
    extends _$QuestionnaireResponseCopyWithImpl<$Res,
        _$QuestionnaireResponseImpl>
    implements _$$QuestionnaireResponseImplCopyWith<$Res> {
  __$$QuestionnaireResponseImplCopyWithImpl(_$QuestionnaireResponseImpl _value,
      $Res Function(_$QuestionnaireResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuestionnaireResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionnaireId = null,
    Object? answers = null,
    Object? startTime = null,
    Object? completedTime = freezed,
    Object? status = null,
  }) {
    return _then(_$QuestionnaireResponseImpl(
      questionnaireId: null == questionnaireId
          ? _value.questionnaireId
          : questionnaireId // ignore: cast_nullable_to_non_nullable
              as String,
      answers: null == answers
          ? _value._answers
          : answers // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedTime: freezed == completedTime
          ? _value.completedTime
          : completedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuestionnaireStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionnaireResponseImpl extends _QuestionnaireResponse {
  const _$QuestionnaireResponseImpl(
      {required this.questionnaireId,
      required final Map<String, dynamic> answers,
      required this.startTime,
      this.completedTime,
      this.status = QuestionnaireStatus.inProgress})
      : _answers = answers,
        super._();

  factory _$QuestionnaireResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionnaireResponseImplFromJson(json);

  @override
  final String questionnaireId;
  final Map<String, dynamic> _answers;
  @override
  Map<String, dynamic> get answers {
    if (_answers is EqualUnmodifiableMapView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_answers);
  }

  @override
  final DateTime startTime;
  @override
  final DateTime? completedTime;
  @override
  @JsonKey()
  final QuestionnaireStatus status;

  @override
  String toString() {
    return 'QuestionnaireResponse(questionnaireId: $questionnaireId, answers: $answers, startTime: $startTime, completedTime: $completedTime, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionnaireResponseImpl &&
            (identical(other.questionnaireId, questionnaireId) ||
                other.questionnaireId == questionnaireId) &&
            const DeepCollectionEquality().equals(other._answers, _answers) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.completedTime, completedTime) ||
                other.completedTime == completedTime) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      questionnaireId,
      const DeepCollectionEquality().hash(_answers),
      startTime,
      completedTime,
      status);

  /// Create a copy of QuestionnaireResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionnaireResponseImplCopyWith<_$QuestionnaireResponseImpl>
      get copyWith => __$$QuestionnaireResponseImplCopyWithImpl<
          _$QuestionnaireResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionnaireResponseImplToJson(
      this,
    );
  }
}

abstract class _QuestionnaireResponse extends QuestionnaireResponse {
  const factory _QuestionnaireResponse(
      {required final String questionnaireId,
      required final Map<String, dynamic> answers,
      required final DateTime startTime,
      final DateTime? completedTime,
      final QuestionnaireStatus status}) = _$QuestionnaireResponseImpl;
  const _QuestionnaireResponse._() : super._();

  factory _QuestionnaireResponse.fromJson(Map<String, dynamic> json) =
      _$QuestionnaireResponseImpl.fromJson;

  @override
  String get questionnaireId;
  @override
  Map<String, dynamic> get answers;
  @override
  DateTime get startTime;
  @override
  DateTime? get completedTime;
  @override
  QuestionnaireStatus get status;

  /// Create a copy of QuestionnaireResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionnaireResponseImplCopyWith<_$QuestionnaireResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NavigationState {
  int get currentSectionIndex => throw _privateConstructorUsedError;
  int get currentQuestionIndex => throw _privateConstructorUsedError;
  bool get showWelcome => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;

  /// Create a copy of NavigationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavigationStateCopyWith<NavigationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavigationStateCopyWith<$Res> {
  factory $NavigationStateCopyWith(
          NavigationState value, $Res Function(NavigationState) then) =
      _$NavigationStateCopyWithImpl<$Res, NavigationState>;
  @useResult
  $Res call(
      {int currentSectionIndex,
      int currentQuestionIndex,
      bool showWelcome,
      bool isCompleted});
}

/// @nodoc
class _$NavigationStateCopyWithImpl<$Res, $Val extends NavigationState>
    implements $NavigationStateCopyWith<$Res> {
  _$NavigationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NavigationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentSectionIndex = null,
    Object? currentQuestionIndex = null,
    Object? showWelcome = null,
    Object? isCompleted = null,
  }) {
    return _then(_value.copyWith(
      currentSectionIndex: null == currentSectionIndex
          ? _value.currentSectionIndex
          : currentSectionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      currentQuestionIndex: null == currentQuestionIndex
          ? _value.currentQuestionIndex
          : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      showWelcome: null == showWelcome
          ? _value.showWelcome
          : showWelcome // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavigationStateImplCopyWith<$Res>
    implements $NavigationStateCopyWith<$Res> {
  factory _$$NavigationStateImplCopyWith(_$NavigationStateImpl value,
          $Res Function(_$NavigationStateImpl) then) =
      __$$NavigationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentSectionIndex,
      int currentQuestionIndex,
      bool showWelcome,
      bool isCompleted});
}

/// @nodoc
class __$$NavigationStateImplCopyWithImpl<$Res>
    extends _$NavigationStateCopyWithImpl<$Res, _$NavigationStateImpl>
    implements _$$NavigationStateImplCopyWith<$Res> {
  __$$NavigationStateImplCopyWithImpl(
      _$NavigationStateImpl _value, $Res Function(_$NavigationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NavigationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentSectionIndex = null,
    Object? currentQuestionIndex = null,
    Object? showWelcome = null,
    Object? isCompleted = null,
  }) {
    return _then(_$NavigationStateImpl(
      currentSectionIndex: null == currentSectionIndex
          ? _value.currentSectionIndex
          : currentSectionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      currentQuestionIndex: null == currentQuestionIndex
          ? _value.currentQuestionIndex
          : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      showWelcome: null == showWelcome
          ? _value.showWelcome
          : showWelcome // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$NavigationStateImpl implements _NavigationState {
  const _$NavigationStateImpl(
      {this.currentSectionIndex = 0,
      this.currentQuestionIndex = 0,
      this.showWelcome = true,
      this.isCompleted = false});

  @override
  @JsonKey()
  final int currentSectionIndex;
  @override
  @JsonKey()
  final int currentQuestionIndex;
  @override
  @JsonKey()
  final bool showWelcome;
  @override
  @JsonKey()
  final bool isCompleted;

  @override
  String toString() {
    return 'NavigationState(currentSectionIndex: $currentSectionIndex, currentQuestionIndex: $currentQuestionIndex, showWelcome: $showWelcome, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavigationStateImpl &&
            (identical(other.currentSectionIndex, currentSectionIndex) ||
                other.currentSectionIndex == currentSectionIndex) &&
            (identical(other.currentQuestionIndex, currentQuestionIndex) ||
                other.currentQuestionIndex == currentQuestionIndex) &&
            (identical(other.showWelcome, showWelcome) ||
                other.showWelcome == showWelcome) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentSectionIndex,
      currentQuestionIndex, showWelcome, isCompleted);

  /// Create a copy of NavigationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavigationStateImplCopyWith<_$NavigationStateImpl> get copyWith =>
      __$$NavigationStateImplCopyWithImpl<_$NavigationStateImpl>(
          this, _$identity);
}

abstract class _NavigationState implements NavigationState {
  const factory _NavigationState(
      {final int currentSectionIndex,
      final int currentQuestionIndex,
      final bool showWelcome,
      final bool isCompleted}) = _$NavigationStateImpl;

  @override
  int get currentSectionIndex;
  @override
  int get currentQuestionIndex;
  @override
  bool get showWelcome;
  @override
  bool get isCompleted;

  /// Create a copy of NavigationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavigationStateImplCopyWith<_$NavigationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
