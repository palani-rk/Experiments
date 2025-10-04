// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'section_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SectionMessage _$SectionMessageFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'bot':
      return BotMessage.fromJson(json);
    case 'questionAnswer':
      return QuestionAnswer.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'SectionMessage',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$SectionMessage {
  String get id => throw _privateConstructorUsedError;
  String get sectionId => throw _privateConstructorUsedError;
  MessageType get messageType => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  bool get isEditable => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String sectionId,
            String content,
            MessageType messageType,
            DateTime timestamp,
            bool isEditable,
            int order,
            String? context,
            Map<String, dynamic>? metadata)
        bot,
    required TResult Function(
            String id,
            String sectionId,
            String questionId,
            String questionText,
            QuestionType inputType,
            dynamic answer,
            DateTime timestamp,
            MessageType messageType,
            bool isEditable,
            bool isComplete,
            int order,
            String? formattedAnswer,
            ValidationStatus? validation,
            Map<String, dynamic>? questionMetadata)
        questionAnswer,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String sectionId,
            String content,
            MessageType messageType,
            DateTime timestamp,
            bool isEditable,
            int order,
            String? context,
            Map<String, dynamic>? metadata)?
        bot,
    TResult? Function(
            String id,
            String sectionId,
            String questionId,
            String questionText,
            QuestionType inputType,
            dynamic answer,
            DateTime timestamp,
            MessageType messageType,
            bool isEditable,
            bool isComplete,
            int order,
            String? formattedAnswer,
            ValidationStatus? validation,
            Map<String, dynamic>? questionMetadata)?
        questionAnswer,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String sectionId,
            String content,
            MessageType messageType,
            DateTime timestamp,
            bool isEditable,
            int order,
            String? context,
            Map<String, dynamic>? metadata)?
        bot,
    TResult Function(
            String id,
            String sectionId,
            String questionId,
            String questionText,
            QuestionType inputType,
            dynamic answer,
            DateTime timestamp,
            MessageType messageType,
            bool isEditable,
            bool isComplete,
            int order,
            String? formattedAnswer,
            ValidationStatus? validation,
            Map<String, dynamic>? questionMetadata)?
        questionAnswer,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BotMessage value) bot,
    required TResult Function(QuestionAnswer value) questionAnswer,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BotMessage value)? bot,
    TResult? Function(QuestionAnswer value)? questionAnswer,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BotMessage value)? bot,
    TResult Function(QuestionAnswer value)? questionAnswer,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this SectionMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SectionMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SectionMessageCopyWith<SectionMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SectionMessageCopyWith<$Res> {
  factory $SectionMessageCopyWith(
          SectionMessage value, $Res Function(SectionMessage) then) =
      _$SectionMessageCopyWithImpl<$Res, SectionMessage>;
  @useResult
  $Res call(
      {String id,
      String sectionId,
      MessageType messageType,
      DateTime timestamp,
      bool isEditable,
      int order});
}

/// @nodoc
class _$SectionMessageCopyWithImpl<$Res, $Val extends SectionMessage>
    implements $SectionMessageCopyWith<$Res> {
  _$SectionMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SectionMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sectionId = null,
    Object? messageType = null,
    Object? timestamp = null,
    Object? isEditable = null,
    Object? order = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sectionId: null == sectionId
          ? _value.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as MessageType,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isEditable: null == isEditable
          ? _value.isEditable
          : isEditable // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BotMessageImplCopyWith<$Res>
    implements $SectionMessageCopyWith<$Res> {
  factory _$$BotMessageImplCopyWith(
          _$BotMessageImpl value, $Res Function(_$BotMessageImpl) then) =
      __$$BotMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String sectionId,
      String content,
      MessageType messageType,
      DateTime timestamp,
      bool isEditable,
      int order,
      String? context,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$BotMessageImplCopyWithImpl<$Res>
    extends _$SectionMessageCopyWithImpl<$Res, _$BotMessageImpl>
    implements _$$BotMessageImplCopyWith<$Res> {
  __$$BotMessageImplCopyWithImpl(
      _$BotMessageImpl _value, $Res Function(_$BotMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of SectionMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sectionId = null,
    Object? content = null,
    Object? messageType = null,
    Object? timestamp = null,
    Object? isEditable = null,
    Object? order = null,
    Object? context = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$BotMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sectionId: null == sectionId
          ? _value.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as MessageType,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isEditable: null == isEditable
          ? _value.isEditable
          : isEditable // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BotMessageImpl implements BotMessage {
  const _$BotMessageImpl(
      {required this.id,
      required this.sectionId,
      required this.content,
      required this.messageType,
      required this.timestamp,
      this.isEditable = false,
      this.order = 0,
      this.context,
      final Map<String, dynamic>? metadata,
      final String? $type})
      : _metadata = metadata,
        $type = $type ?? 'bot';

  factory _$BotMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$BotMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String sectionId;
  @override
  final String content;
  @override
  final MessageType messageType;
  @override
  final DateTime timestamp;
  @override
  @JsonKey()
  final bool isEditable;
  @override
  @JsonKey()
  final int order;
  @override
  final String? context;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SectionMessage.bot(id: $id, sectionId: $sectionId, content: $content, messageType: $messageType, timestamp: $timestamp, isEditable: $isEditable, order: $order, context: $context, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BotMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sectionId, sectionId) ||
                other.sectionId == sectionId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isEditable, isEditable) ||
                other.isEditable == isEditable) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.context, context) || other.context == context) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sectionId,
      content,
      messageType,
      timestamp,
      isEditable,
      order,
      context,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of SectionMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BotMessageImplCopyWith<_$BotMessageImpl> get copyWith =>
      __$$BotMessageImplCopyWithImpl<_$BotMessageImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String sectionId,
            String content,
            MessageType messageType,
            DateTime timestamp,
            bool isEditable,
            int order,
            String? context,
            Map<String, dynamic>? metadata)
        bot,
    required TResult Function(
            String id,
            String sectionId,
            String questionId,
            String questionText,
            QuestionType inputType,
            dynamic answer,
            DateTime timestamp,
            MessageType messageType,
            bool isEditable,
            bool isComplete,
            int order,
            String? formattedAnswer,
            ValidationStatus? validation,
            Map<String, dynamic>? questionMetadata)
        questionAnswer,
  }) {
    return bot(id, sectionId, content, messageType, timestamp, isEditable,
        order, context, metadata);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String sectionId,
            String content,
            MessageType messageType,
            DateTime timestamp,
            bool isEditable,
            int order,
            String? context,
            Map<String, dynamic>? metadata)?
        bot,
    TResult? Function(
            String id,
            String sectionId,
            String questionId,
            String questionText,
            QuestionType inputType,
            dynamic answer,
            DateTime timestamp,
            MessageType messageType,
            bool isEditable,
            bool isComplete,
            int order,
            String? formattedAnswer,
            ValidationStatus? validation,
            Map<String, dynamic>? questionMetadata)?
        questionAnswer,
  }) {
    return bot?.call(id, sectionId, content, messageType, timestamp, isEditable,
        order, context, metadata);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String sectionId,
            String content,
            MessageType messageType,
            DateTime timestamp,
            bool isEditable,
            int order,
            String? context,
            Map<String, dynamic>? metadata)?
        bot,
    TResult Function(
            String id,
            String sectionId,
            String questionId,
            String questionText,
            QuestionType inputType,
            dynamic answer,
            DateTime timestamp,
            MessageType messageType,
            bool isEditable,
            bool isComplete,
            int order,
            String? formattedAnswer,
            ValidationStatus? validation,
            Map<String, dynamic>? questionMetadata)?
        questionAnswer,
    required TResult orElse(),
  }) {
    if (bot != null) {
      return bot(id, sectionId, content, messageType, timestamp, isEditable,
          order, context, metadata);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BotMessage value) bot,
    required TResult Function(QuestionAnswer value) questionAnswer,
  }) {
    return bot(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BotMessage value)? bot,
    TResult? Function(QuestionAnswer value)? questionAnswer,
  }) {
    return bot?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BotMessage value)? bot,
    TResult Function(QuestionAnswer value)? questionAnswer,
    required TResult orElse(),
  }) {
    if (bot != null) {
      return bot(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BotMessageImplToJson(
      this,
    );
  }
}

abstract class BotMessage implements SectionMessage {
  const factory BotMessage(
      {required final String id,
      required final String sectionId,
      required final String content,
      required final MessageType messageType,
      required final DateTime timestamp,
      final bool isEditable,
      final int order,
      final String? context,
      final Map<String, dynamic>? metadata}) = _$BotMessageImpl;

  factory BotMessage.fromJson(Map<String, dynamic> json) =
      _$BotMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get sectionId;
  String get content;
  @override
  MessageType get messageType;
  @override
  DateTime get timestamp;
  @override
  bool get isEditable;
  @override
  int get order;
  String? get context;
  Map<String, dynamic>? get metadata;

  /// Create a copy of SectionMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BotMessageImplCopyWith<_$BotMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$QuestionAnswerImplCopyWith<$Res>
    implements $SectionMessageCopyWith<$Res> {
  factory _$$QuestionAnswerImplCopyWith(_$QuestionAnswerImpl value,
          $Res Function(_$QuestionAnswerImpl) then) =
      __$$QuestionAnswerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String sectionId,
      String questionId,
      String questionText,
      QuestionType inputType,
      dynamic answer,
      DateTime timestamp,
      MessageType messageType,
      bool isEditable,
      bool isComplete,
      int order,
      String? formattedAnswer,
      ValidationStatus? validation,
      Map<String, dynamic>? questionMetadata});

  $ValidationStatusCopyWith<$Res>? get validation;
}

/// @nodoc
class __$$QuestionAnswerImplCopyWithImpl<$Res>
    extends _$SectionMessageCopyWithImpl<$Res, _$QuestionAnswerImpl>
    implements _$$QuestionAnswerImplCopyWith<$Res> {
  __$$QuestionAnswerImplCopyWithImpl(
      _$QuestionAnswerImpl _value, $Res Function(_$QuestionAnswerImpl) _then)
      : super(_value, _then);

  /// Create a copy of SectionMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sectionId = null,
    Object? questionId = null,
    Object? questionText = null,
    Object? inputType = null,
    Object? answer = freezed,
    Object? timestamp = null,
    Object? messageType = null,
    Object? isEditable = null,
    Object? isComplete = null,
    Object? order = null,
    Object? formattedAnswer = freezed,
    Object? validation = freezed,
    Object? questionMetadata = freezed,
  }) {
    return _then(_$QuestionAnswerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sectionId: null == sectionId
          ? _value.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String,
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      questionText: null == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String,
      inputType: null == inputType
          ? _value.inputType
          : inputType // ignore: cast_nullable_to_non_nullable
              as QuestionType,
      answer: freezed == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as dynamic,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as MessageType,
      isEditable: null == isEditable
          ? _value.isEditable
          : isEditable // ignore: cast_nullable_to_non_nullable
              as bool,
      isComplete: null == isComplete
          ? _value.isComplete
          : isComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      formattedAnswer: freezed == formattedAnswer
          ? _value.formattedAnswer
          : formattedAnswer // ignore: cast_nullable_to_non_nullable
              as String?,
      validation: freezed == validation
          ? _value.validation
          : validation // ignore: cast_nullable_to_non_nullable
              as ValidationStatus?,
      questionMetadata: freezed == questionMetadata
          ? _value._questionMetadata
          : questionMetadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }

  /// Create a copy of SectionMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ValidationStatusCopyWith<$Res>? get validation {
    if (_value.validation == null) {
      return null;
    }

    return $ValidationStatusCopyWith<$Res>(_value.validation!, (value) {
      return _then(_value.copyWith(validation: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionAnswerImpl implements QuestionAnswer {
  const _$QuestionAnswerImpl(
      {required this.id,
      required this.sectionId,
      required this.questionId,
      required this.questionText,
      required this.inputType,
      required this.answer,
      required this.timestamp,
      this.messageType = MessageType.userAnswer,
      this.isEditable = true,
      this.isComplete = false,
      this.order = 0,
      this.formattedAnswer,
      this.validation,
      final Map<String, dynamic>? questionMetadata,
      final String? $type})
      : _questionMetadata = questionMetadata,
        $type = $type ?? 'questionAnswer';

  factory _$QuestionAnswerImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionAnswerImplFromJson(json);

  @override
  final String id;
  @override
  final String sectionId;
  @override
  final String questionId;
  @override
  final String questionText;
  @override
  final QuestionType inputType;
  @override
  final dynamic answer;
  @override
  final DateTime timestamp;
  @override
  @JsonKey()
  final MessageType messageType;
  @override
  @JsonKey()
  final bool isEditable;
  @override
  @JsonKey()
  final bool isComplete;
  @override
  @JsonKey()
  final int order;
  @override
  final String? formattedAnswer;
  @override
  final ValidationStatus? validation;
  final Map<String, dynamic>? _questionMetadata;
  @override
  Map<String, dynamic>? get questionMetadata {
    final value = _questionMetadata;
    if (value == null) return null;
    if (_questionMetadata is EqualUnmodifiableMapView) return _questionMetadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SectionMessage.questionAnswer(id: $id, sectionId: $sectionId, questionId: $questionId, questionText: $questionText, inputType: $inputType, answer: $answer, timestamp: $timestamp, messageType: $messageType, isEditable: $isEditable, isComplete: $isComplete, order: $order, formattedAnswer: $formattedAnswer, validation: $validation, questionMetadata: $questionMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionAnswerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sectionId, sectionId) ||
                other.sectionId == sectionId) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            (identical(other.inputType, inputType) ||
                other.inputType == inputType) &&
            const DeepCollectionEquality().equals(other.answer, answer) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.isEditable, isEditable) ||
                other.isEditable == isEditable) &&
            (identical(other.isComplete, isComplete) ||
                other.isComplete == isComplete) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.formattedAnswer, formattedAnswer) ||
                other.formattedAnswer == formattedAnswer) &&
            (identical(other.validation, validation) ||
                other.validation == validation) &&
            const DeepCollectionEquality()
                .equals(other._questionMetadata, _questionMetadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sectionId,
      questionId,
      questionText,
      inputType,
      const DeepCollectionEquality().hash(answer),
      timestamp,
      messageType,
      isEditable,
      isComplete,
      order,
      formattedAnswer,
      validation,
      const DeepCollectionEquality().hash(_questionMetadata));

  /// Create a copy of SectionMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionAnswerImplCopyWith<_$QuestionAnswerImpl> get copyWith =>
      __$$QuestionAnswerImplCopyWithImpl<_$QuestionAnswerImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String sectionId,
            String content,
            MessageType messageType,
            DateTime timestamp,
            bool isEditable,
            int order,
            String? context,
            Map<String, dynamic>? metadata)
        bot,
    required TResult Function(
            String id,
            String sectionId,
            String questionId,
            String questionText,
            QuestionType inputType,
            dynamic answer,
            DateTime timestamp,
            MessageType messageType,
            bool isEditable,
            bool isComplete,
            int order,
            String? formattedAnswer,
            ValidationStatus? validation,
            Map<String, dynamic>? questionMetadata)
        questionAnswer,
  }) {
    return questionAnswer(
        id,
        sectionId,
        questionId,
        questionText,
        inputType,
        answer,
        timestamp,
        messageType,
        isEditable,
        isComplete,
        order,
        formattedAnswer,
        validation,
        questionMetadata);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String sectionId,
            String content,
            MessageType messageType,
            DateTime timestamp,
            bool isEditable,
            int order,
            String? context,
            Map<String, dynamic>? metadata)?
        bot,
    TResult? Function(
            String id,
            String sectionId,
            String questionId,
            String questionText,
            QuestionType inputType,
            dynamic answer,
            DateTime timestamp,
            MessageType messageType,
            bool isEditable,
            bool isComplete,
            int order,
            String? formattedAnswer,
            ValidationStatus? validation,
            Map<String, dynamic>? questionMetadata)?
        questionAnswer,
  }) {
    return questionAnswer?.call(
        id,
        sectionId,
        questionId,
        questionText,
        inputType,
        answer,
        timestamp,
        messageType,
        isEditable,
        isComplete,
        order,
        formattedAnswer,
        validation,
        questionMetadata);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String sectionId,
            String content,
            MessageType messageType,
            DateTime timestamp,
            bool isEditable,
            int order,
            String? context,
            Map<String, dynamic>? metadata)?
        bot,
    TResult Function(
            String id,
            String sectionId,
            String questionId,
            String questionText,
            QuestionType inputType,
            dynamic answer,
            DateTime timestamp,
            MessageType messageType,
            bool isEditable,
            bool isComplete,
            int order,
            String? formattedAnswer,
            ValidationStatus? validation,
            Map<String, dynamic>? questionMetadata)?
        questionAnswer,
    required TResult orElse(),
  }) {
    if (questionAnswer != null) {
      return questionAnswer(
          id,
          sectionId,
          questionId,
          questionText,
          inputType,
          answer,
          timestamp,
          messageType,
          isEditable,
          isComplete,
          order,
          formattedAnswer,
          validation,
          questionMetadata);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BotMessage value) bot,
    required TResult Function(QuestionAnswer value) questionAnswer,
  }) {
    return questionAnswer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BotMessage value)? bot,
    TResult? Function(QuestionAnswer value)? questionAnswer,
  }) {
    return questionAnswer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BotMessage value)? bot,
    TResult Function(QuestionAnswer value)? questionAnswer,
    required TResult orElse(),
  }) {
    if (questionAnswer != null) {
      return questionAnswer(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionAnswerImplToJson(
      this,
    );
  }
}

abstract class QuestionAnswer implements SectionMessage {
  const factory QuestionAnswer(
      {required final String id,
      required final String sectionId,
      required final String questionId,
      required final String questionText,
      required final QuestionType inputType,
      required final dynamic answer,
      required final DateTime timestamp,
      final MessageType messageType,
      final bool isEditable,
      final bool isComplete,
      final int order,
      final String? formattedAnswer,
      final ValidationStatus? validation,
      final Map<String, dynamic>? questionMetadata}) = _$QuestionAnswerImpl;

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) =
      _$QuestionAnswerImpl.fromJson;

  @override
  String get id;
  @override
  String get sectionId;
  String get questionId;
  String get questionText;
  QuestionType get inputType;
  dynamic get answer;
  @override
  DateTime get timestamp;
  @override
  MessageType get messageType;
  @override
  bool get isEditable;
  bool get isComplete;
  @override
  int get order;
  String? get formattedAnswer;
  ValidationStatus? get validation;
  Map<String, dynamic>? get questionMetadata;

  /// Create a copy of SectionMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionAnswerImplCopyWith<_$QuestionAnswerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
