// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_section.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatSection _$ChatSectionFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'intro':
      return IntroSection.fromJson(json);
    case 'questionnaire':
      return QuestionnaireSection.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'ChatSection',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$ChatSection {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  SectionType get sectionType => throw _privateConstructorUsedError;
  SectionStatus get status => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String title,
            List<BotMessage> welcomeMessages,
            SectionType sectionType,
            SectionStatus status,
            int order,
            DateTime createdAt,
            DateTime? completedAt)
        intro,
    required TResult Function(
            String id,
            String title,
            String description,
            List<Question> questions,
            List<SectionMessage> messages,
            SectionType sectionType,
            SectionStatus status,
            int order,
            DateTime createdAt,
            DateTime? completedAt)
        questionnaire,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String title,
            List<BotMessage> welcomeMessages,
            SectionType sectionType,
            SectionStatus status,
            int order,
            DateTime createdAt,
            DateTime? completedAt)?
        intro,
    TResult? Function(
            String id,
            String title,
            String description,
            List<Question> questions,
            List<SectionMessage> messages,
            SectionType sectionType,
            SectionStatus status,
            int order,
            DateTime createdAt,
            DateTime? completedAt)?
        questionnaire,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String title,
            List<BotMessage> welcomeMessages,
            SectionType sectionType,
            SectionStatus status,
            int order,
            DateTime createdAt,
            DateTime? completedAt)?
        intro,
    TResult Function(
            String id,
            String title,
            String description,
            List<Question> questions,
            List<SectionMessage> messages,
            SectionType sectionType,
            SectionStatus status,
            int order,
            DateTime createdAt,
            DateTime? completedAt)?
        questionnaire,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(IntroSection value) intro,
    required TResult Function(QuestionnaireSection value) questionnaire,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(IntroSection value)? intro,
    TResult? Function(QuestionnaireSection value)? questionnaire,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IntroSection value)? intro,
    TResult Function(QuestionnaireSection value)? questionnaire,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ChatSection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatSectionCopyWith<ChatSection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatSectionCopyWith<$Res> {
  factory $ChatSectionCopyWith(
          ChatSection value, $Res Function(ChatSection) then) =
      _$ChatSectionCopyWithImpl<$Res, ChatSection>;
  @useResult
  $Res call(
      {String id,
      String title,
      SectionType sectionType,
      SectionStatus status,
      int order,
      DateTime createdAt,
      DateTime? completedAt});
}

/// @nodoc
class _$ChatSectionCopyWithImpl<$Res, $Val extends ChatSection>
    implements $ChatSectionCopyWith<$Res> {
  _$ChatSectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? sectionType = null,
    Object? status = null,
    Object? order = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      sectionType: null == sectionType
          ? _value.sectionType
          : sectionType // ignore: cast_nullable_to_non_nullable
              as SectionType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SectionStatus,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IntroSectionImplCopyWith<$Res>
    implements $ChatSectionCopyWith<$Res> {
  factory _$$IntroSectionImplCopyWith(
          _$IntroSectionImpl value, $Res Function(_$IntroSectionImpl) then) =
      __$$IntroSectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      List<BotMessage> welcomeMessages,
      SectionType sectionType,
      SectionStatus status,
      int order,
      DateTime createdAt,
      DateTime? completedAt});
}

/// @nodoc
class __$$IntroSectionImplCopyWithImpl<$Res>
    extends _$ChatSectionCopyWithImpl<$Res, _$IntroSectionImpl>
    implements _$$IntroSectionImplCopyWith<$Res> {
  __$$IntroSectionImplCopyWithImpl(
      _$IntroSectionImpl _value, $Res Function(_$IntroSectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? welcomeMessages = null,
    Object? sectionType = null,
    Object? status = null,
    Object? order = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(_$IntroSectionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      welcomeMessages: null == welcomeMessages
          ? _value._welcomeMessages
          : welcomeMessages // ignore: cast_nullable_to_non_nullable
              as List<BotMessage>,
      sectionType: null == sectionType
          ? _value.sectionType
          : sectionType // ignore: cast_nullable_to_non_nullable
              as SectionType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SectionStatus,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IntroSectionImpl implements IntroSection {
  const _$IntroSectionImpl(
      {required this.id,
      required this.title,
      required final List<BotMessage> welcomeMessages,
      this.sectionType = SectionType.intro,
      this.status = SectionStatus.completed,
      this.order = 0,
      required this.createdAt,
      this.completedAt,
      final String? $type})
      : _welcomeMessages = welcomeMessages,
        $type = $type ?? 'intro';

  factory _$IntroSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$IntroSectionImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  final List<BotMessage> _welcomeMessages;
  @override
  List<BotMessage> get welcomeMessages {
    if (_welcomeMessages is EqualUnmodifiableListView) return _welcomeMessages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_welcomeMessages);
  }

  @override
  @JsonKey()
  final SectionType sectionType;
  @override
  @JsonKey()
  final SectionStatus status;
  @override
  @JsonKey()
  final int order;
  @override
  final DateTime createdAt;
  @override
  final DateTime? completedAt;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ChatSection.intro(id: $id, title: $title, welcomeMessages: $welcomeMessages, sectionType: $sectionType, status: $status, order: $order, createdAt: $createdAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IntroSectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality()
                .equals(other._welcomeMessages, _welcomeMessages) &&
            (identical(other.sectionType, sectionType) ||
                other.sectionType == sectionType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      const DeepCollectionEquality().hash(_welcomeMessages),
      sectionType,
      status,
      order,
      createdAt,
      completedAt);

  /// Create a copy of ChatSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IntroSectionImplCopyWith<_$IntroSectionImpl> get copyWith =>
      __$$IntroSectionImplCopyWithImpl<_$IntroSectionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String title,
            List<BotMessage> welcomeMessages,
            SectionType sectionType,
            SectionStatus status,
            int order,
            DateTime createdAt,
            DateTime? completedAt)
        intro,
    required TResult Function(
            String id,
            String title,
            String description,
            List<Question> questions,
            List<SectionMessage> messages,
            SectionType sectionType,
            SectionStatus status,
            int order,
            DateTime createdAt,
            DateTime? completedAt)
        questionnaire,
  }) {
    return intro(id, title, welcomeMessages, sectionType, status, order,
        createdAt, completedAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String title,
            List<BotMessage> welcomeMessages,
            SectionType sectionType,
            SectionStatus status,
            int order,
            DateTime createdAt,
            DateTime? completedAt)?
        intro,
    TResult? Function(
            String id,
            String title,
            String description,
            List<Question> questions,
            List<SectionMessage> messages,
            SectionType sectionType,
            SectionStatus status,
            int order,
            DateTime createdAt,
            DateTime? completedAt)?
        questionnaire,
  }) {
    return intro?.call(id, title, welcomeMessages, sectionType, status, order,
        createdAt, completedAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String title,
            List<BotMessage> welcomeMessages,
            SectionType sectionType,
            SectionStatus status,
            int order,
            DateTime createdAt,
            DateTime? completedAt)?
        intro,
    TResult Function(
            String id,
            String title,
            String description,
            List<Question> questions,
            List<SectionMessage> messages,
            SectionType sectionType,
            SectionStatus status,
            int order,
            DateTime createdAt,
            DateTime? completedAt)?
        questionnaire,
    required TResult orElse(),
  }) {
    if (intro != null) {
      return intro(id, title, welcomeMessages, sectionType, status, order,
          createdAt, completedAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(IntroSection value) intro,
    required TResult Function(QuestionnaireSection value) questionnaire,
  }) {
    return intro(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(IntroSection value)? intro,
    TResult? Function(QuestionnaireSection value)? questionnaire,
  }) {
    return intro?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IntroSection value)? intro,
    TResult Function(QuestionnaireSection value)? questionnaire,
    required TResult orElse(),
  }) {
    if (intro != null) {
      return intro(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$IntroSectionImplToJson(
      this,
    );
  }
}

abstract class IntroSection implements ChatSection {
  const factory IntroSection(
      {required final String id,
      required final String title,
      required final List<BotMessage> welcomeMessages,
      final SectionType sectionType,
      final SectionStatus status,
      final int order,
      required final DateTime createdAt,
      final DateTime? completedAt}) = _$IntroSectionImpl;

  factory IntroSection.fromJson(Map<String, dynamic> json) =
      _$IntroSectionImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  List<BotMessage> get welcomeMessages;
  @override
  SectionType get sectionType;
  @override
  SectionStatus get status;
  @override
  int get order;
  @override
  DateTime get createdAt;
  @override
  DateTime? get completedAt;

  /// Create a copy of ChatSection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IntroSectionImplCopyWith<_$IntroSectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$QuestionnaireSectionImplCopyWith<$Res>
    implements $ChatSectionCopyWith<$Res> {
  factory _$$QuestionnaireSectionImplCopyWith(_$QuestionnaireSectionImpl value,
          $Res Function(_$QuestionnaireSectionImpl) then) =
      __$$QuestionnaireSectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      List<Question> questions,
      List<SectionMessage> messages,
      SectionType sectionType,
      SectionStatus status,
      int order,
      DateTime createdAt,
      DateTime? completedAt});
}

/// @nodoc
class __$$QuestionnaireSectionImplCopyWithImpl<$Res>
    extends _$ChatSectionCopyWithImpl<$Res, _$QuestionnaireSectionImpl>
    implements _$$QuestionnaireSectionImplCopyWith<$Res> {
  __$$QuestionnaireSectionImplCopyWithImpl(_$QuestionnaireSectionImpl _value,
      $Res Function(_$QuestionnaireSectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? questions = null,
    Object? messages = null,
    Object? sectionType = null,
    Object? status = null,
    Object? order = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(_$QuestionnaireSectionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<Question>,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<SectionMessage>,
      sectionType: null == sectionType
          ? _value.sectionType
          : sectionType // ignore: cast_nullable_to_non_nullable
              as SectionType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SectionStatus,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionnaireSectionImpl implements QuestionnaireSection {
  const _$QuestionnaireSectionImpl(
      {required this.id,
      required this.title,
      required this.description,
      required final List<Question> questions,
      final List<SectionMessage> messages = const [],
      this.sectionType = SectionType.questionnaire,
      this.status = SectionStatus.pending,
      this.order = 0,
      required this.createdAt,
      this.completedAt,
      final String? $type})
      : _questions = questions,
        _messages = messages,
        $type = $type ?? 'questionnaire';

  factory _$QuestionnaireSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionnaireSectionImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  final List<Question> _questions;
  @override
  List<Question> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  final List<SectionMessage> _messages;
  @override
  @JsonKey()
  List<SectionMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  @JsonKey()
  final SectionType sectionType;
  @override
  @JsonKey()
  final SectionStatus status;
  @override
  @JsonKey()
  final int order;
  @override
  final DateTime createdAt;
  @override
  final DateTime? completedAt;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ChatSection.questionnaire(id: $id, title: $title, description: $description, questions: $questions, messages: $messages, sectionType: $sectionType, status: $status, order: $order, createdAt: $createdAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionnaireSectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.sectionType, sectionType) ||
                other.sectionType == sectionType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      const DeepCollectionEquality().hash(_questions),
      const DeepCollectionEquality().hash(_messages),
      sectionType,
      status,
      order,
      createdAt,
      completedAt);

  /// Create a copy of ChatSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionnaireSectionImplCopyWith<_$QuestionnaireSectionImpl>
      get copyWith =>
          __$$QuestionnaireSectionImplCopyWithImpl<_$QuestionnaireSectionImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String title,
            List<BotMessage> welcomeMessages,
            SectionType sectionType,
            SectionStatus status,
            int order,
            DateTime createdAt,
            DateTime? completedAt)
        intro,
    required TResult Function(
            String id,
            String title,
            String description,
            List<Question> questions,
            List<SectionMessage> messages,
            SectionType sectionType,
            SectionStatus status,
            int order,
            DateTime createdAt,
            DateTime? completedAt)
        questionnaire,
  }) {
    return questionnaire(id, title, description, questions, messages,
        sectionType, status, order, createdAt, completedAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String title,
            List<BotMessage> welcomeMessages,
            SectionType sectionType,
            SectionStatus status,
            int order,
            DateTime createdAt,
            DateTime? completedAt)?
        intro,
    TResult? Function(
            String id,
            String title,
            String description,
            List<Question> questions,
            List<SectionMessage> messages,
            SectionType sectionType,
            SectionStatus status,
            int order,
            DateTime createdAt,
            DateTime? completedAt)?
        questionnaire,
  }) {
    return questionnaire?.call(id, title, description, questions, messages,
        sectionType, status, order, createdAt, completedAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String title,
            List<BotMessage> welcomeMessages,
            SectionType sectionType,
            SectionStatus status,
            int order,
            DateTime createdAt,
            DateTime? completedAt)?
        intro,
    TResult Function(
            String id,
            String title,
            String description,
            List<Question> questions,
            List<SectionMessage> messages,
            SectionType sectionType,
            SectionStatus status,
            int order,
            DateTime createdAt,
            DateTime? completedAt)?
        questionnaire,
    required TResult orElse(),
  }) {
    if (questionnaire != null) {
      return questionnaire(id, title, description, questions, messages,
          sectionType, status, order, createdAt, completedAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(IntroSection value) intro,
    required TResult Function(QuestionnaireSection value) questionnaire,
  }) {
    return questionnaire(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(IntroSection value)? intro,
    TResult? Function(QuestionnaireSection value)? questionnaire,
  }) {
    return questionnaire?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IntroSection value)? intro,
    TResult Function(QuestionnaireSection value)? questionnaire,
    required TResult orElse(),
  }) {
    if (questionnaire != null) {
      return questionnaire(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionnaireSectionImplToJson(
      this,
    );
  }
}

abstract class QuestionnaireSection implements ChatSection {
  const factory QuestionnaireSection(
      {required final String id,
      required final String title,
      required final String description,
      required final List<Question> questions,
      final List<SectionMessage> messages,
      final SectionType sectionType,
      final SectionStatus status,
      final int order,
      required final DateTime createdAt,
      final DateTime? completedAt}) = _$QuestionnaireSectionImpl;

  factory QuestionnaireSection.fromJson(Map<String, dynamic> json) =
      _$QuestionnaireSectionImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  String get description;
  List<Question> get questions;
  List<SectionMessage> get messages;
  @override
  SectionType get sectionType;
  @override
  SectionStatus get status;
  @override
  int get order;
  @override
  DateTime get createdAt;
  @override
  DateTime? get completedAt;

  /// Create a copy of ChatSection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionnaireSectionImplCopyWith<_$QuestionnaireSectionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
