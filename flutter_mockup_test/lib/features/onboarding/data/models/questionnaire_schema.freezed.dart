// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'questionnaire_schema.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuestionnaireSchema _$QuestionnaireSchemaFromJson(Map<String, dynamic> json) {
  return _QuestionnaireSchema.fromJson(json);
}

/// @nodoc
mixin _$QuestionnaireSchema {
  WelcomeSection get welcome => throw _privateConstructorUsedError;
  List<QuestionSection> get sections => throw _privateConstructorUsedError;

  /// Serializes this QuestionnaireSchema to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionnaireSchema
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionnaireSchemaCopyWith<QuestionnaireSchema> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionnaireSchemaCopyWith<$Res> {
  factory $QuestionnaireSchemaCopyWith(
          QuestionnaireSchema value, $Res Function(QuestionnaireSchema) then) =
      _$QuestionnaireSchemaCopyWithImpl<$Res, QuestionnaireSchema>;
  @useResult
  $Res call({WelcomeSection welcome, List<QuestionSection> sections});

  $WelcomeSectionCopyWith<$Res> get welcome;
}

/// @nodoc
class _$QuestionnaireSchemaCopyWithImpl<$Res, $Val extends QuestionnaireSchema>
    implements $QuestionnaireSchemaCopyWith<$Res> {
  _$QuestionnaireSchemaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionnaireSchema
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? welcome = null,
    Object? sections = null,
  }) {
    return _then(_value.copyWith(
      welcome: null == welcome
          ? _value.welcome
          : welcome // ignore: cast_nullable_to_non_nullable
              as WelcomeSection,
      sections: null == sections
          ? _value.sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<QuestionSection>,
    ) as $Val);
  }

  /// Create a copy of QuestionnaireSchema
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WelcomeSectionCopyWith<$Res> get welcome {
    return $WelcomeSectionCopyWith<$Res>(_value.welcome, (value) {
      return _then(_value.copyWith(welcome: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuestionnaireSchemaImplCopyWith<$Res>
    implements $QuestionnaireSchemaCopyWith<$Res> {
  factory _$$QuestionnaireSchemaImplCopyWith(_$QuestionnaireSchemaImpl value,
          $Res Function(_$QuestionnaireSchemaImpl) then) =
      __$$QuestionnaireSchemaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WelcomeSection welcome, List<QuestionSection> sections});

  @override
  $WelcomeSectionCopyWith<$Res> get welcome;
}

/// @nodoc
class __$$QuestionnaireSchemaImplCopyWithImpl<$Res>
    extends _$QuestionnaireSchemaCopyWithImpl<$Res, _$QuestionnaireSchemaImpl>
    implements _$$QuestionnaireSchemaImplCopyWith<$Res> {
  __$$QuestionnaireSchemaImplCopyWithImpl(_$QuestionnaireSchemaImpl _value,
      $Res Function(_$QuestionnaireSchemaImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuestionnaireSchema
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? welcome = null,
    Object? sections = null,
  }) {
    return _then(_$QuestionnaireSchemaImpl(
      welcome: null == welcome
          ? _value.welcome
          : welcome // ignore: cast_nullable_to_non_nullable
              as WelcomeSection,
      sections: null == sections
          ? _value._sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<QuestionSection>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionnaireSchemaImpl implements _QuestionnaireSchema {
  const _$QuestionnaireSchemaImpl(
      {required this.welcome, required final List<QuestionSection> sections})
      : _sections = sections;

  factory _$QuestionnaireSchemaImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionnaireSchemaImplFromJson(json);

  @override
  final WelcomeSection welcome;
  final List<QuestionSection> _sections;
  @override
  List<QuestionSection> get sections {
    if (_sections is EqualUnmodifiableListView) return _sections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sections);
  }

  @override
  String toString() {
    return 'QuestionnaireSchema(welcome: $welcome, sections: $sections)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionnaireSchemaImpl &&
            (identical(other.welcome, welcome) || other.welcome == welcome) &&
            const DeepCollectionEquality().equals(other._sections, _sections));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, welcome, const DeepCollectionEquality().hash(_sections));

  /// Create a copy of QuestionnaireSchema
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionnaireSchemaImplCopyWith<_$QuestionnaireSchemaImpl> get copyWith =>
      __$$QuestionnaireSchemaImplCopyWithImpl<_$QuestionnaireSchemaImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionnaireSchemaImplToJson(
      this,
    );
  }
}

abstract class _QuestionnaireSchema implements QuestionnaireSchema {
  const factory _QuestionnaireSchema(
          {required final WelcomeSection welcome,
          required final List<QuestionSection> sections}) =
      _$QuestionnaireSchemaImpl;

  factory _QuestionnaireSchema.fromJson(Map<String, dynamic> json) =
      _$QuestionnaireSchemaImpl.fromJson;

  @override
  WelcomeSection get welcome;
  @override
  List<QuestionSection> get sections;

  /// Create a copy of QuestionnaireSchema
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionnaireSchemaImplCopyWith<_$QuestionnaireSchemaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WelcomeSection _$WelcomeSectionFromJson(Map<String, dynamic> json) {
  return _WelcomeSection.fromJson(json);
}

/// @nodoc
mixin _$WelcomeSection {
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get buttonText => throw _privateConstructorUsedError;

  /// Serializes this WelcomeSection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WelcomeSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WelcomeSectionCopyWith<WelcomeSection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WelcomeSectionCopyWith<$Res> {
  factory $WelcomeSectionCopyWith(
          WelcomeSection value, $Res Function(WelcomeSection) then) =
      _$WelcomeSectionCopyWithImpl<$Res, WelcomeSection>;
  @useResult
  $Res call({String title, String message, String buttonText});
}

/// @nodoc
class _$WelcomeSectionCopyWithImpl<$Res, $Val extends WelcomeSection>
    implements $WelcomeSectionCopyWith<$Res> {
  _$WelcomeSectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WelcomeSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? message = null,
    Object? buttonText = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      buttonText: null == buttonText
          ? _value.buttonText
          : buttonText // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WelcomeSectionImplCopyWith<$Res>
    implements $WelcomeSectionCopyWith<$Res> {
  factory _$$WelcomeSectionImplCopyWith(_$WelcomeSectionImpl value,
          $Res Function(_$WelcomeSectionImpl) then) =
      __$$WelcomeSectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String message, String buttonText});
}

/// @nodoc
class __$$WelcomeSectionImplCopyWithImpl<$Res>
    extends _$WelcomeSectionCopyWithImpl<$Res, _$WelcomeSectionImpl>
    implements _$$WelcomeSectionImplCopyWith<$Res> {
  __$$WelcomeSectionImplCopyWithImpl(
      _$WelcomeSectionImpl _value, $Res Function(_$WelcomeSectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of WelcomeSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? message = null,
    Object? buttonText = null,
  }) {
    return _then(_$WelcomeSectionImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      buttonText: null == buttonText
          ? _value.buttonText
          : buttonText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WelcomeSectionImpl implements _WelcomeSection {
  const _$WelcomeSectionImpl(
      {required this.title, required this.message, required this.buttonText});

  factory _$WelcomeSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WelcomeSectionImplFromJson(json);

  @override
  final String title;
  @override
  final String message;
  @override
  final String buttonText;

  @override
  String toString() {
    return 'WelcomeSection(title: $title, message: $message, buttonText: $buttonText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WelcomeSectionImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.buttonText, buttonText) ||
                other.buttonText == buttonText));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, message, buttonText);

  /// Create a copy of WelcomeSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WelcomeSectionImplCopyWith<_$WelcomeSectionImpl> get copyWith =>
      __$$WelcomeSectionImplCopyWithImpl<_$WelcomeSectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WelcomeSectionImplToJson(
      this,
    );
  }
}

abstract class _WelcomeSection implements WelcomeSection {
  const factory _WelcomeSection(
      {required final String title,
      required final String message,
      required final String buttonText}) = _$WelcomeSectionImpl;

  factory _WelcomeSection.fromJson(Map<String, dynamic> json) =
      _$WelcomeSectionImpl.fromJson;

  @override
  String get title;
  @override
  String get message;
  @override
  String get buttonText;

  /// Create a copy of WelcomeSection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WelcomeSectionImplCopyWith<_$WelcomeSectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuestionSection _$QuestionSectionFromJson(Map<String, dynamic> json) {
  return _QuestionSection.fromJson(json);
}

/// @nodoc
mixin _$QuestionSection {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<Question> get questions => throw _privateConstructorUsedError;

  /// Serializes this QuestionSection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionSectionCopyWith<QuestionSection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionSectionCopyWith<$Res> {
  factory $QuestionSectionCopyWith(
          QuestionSection value, $Res Function(QuestionSection) then) =
      _$QuestionSectionCopyWithImpl<$Res, QuestionSection>;
  @useResult
  $Res call({String id, String title, List<Question> questions});
}

/// @nodoc
class _$QuestionSectionCopyWithImpl<$Res, $Val extends QuestionSection>
    implements $QuestionSectionCopyWith<$Res> {
  _$QuestionSectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? questions = null,
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
      questions: null == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<Question>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionSectionImplCopyWith<$Res>
    implements $QuestionSectionCopyWith<$Res> {
  factory _$$QuestionSectionImplCopyWith(_$QuestionSectionImpl value,
          $Res Function(_$QuestionSectionImpl) then) =
      __$$QuestionSectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, List<Question> questions});
}

/// @nodoc
class __$$QuestionSectionImplCopyWithImpl<$Res>
    extends _$QuestionSectionCopyWithImpl<$Res, _$QuestionSectionImpl>
    implements _$$QuestionSectionImplCopyWith<$Res> {
  __$$QuestionSectionImplCopyWithImpl(
      _$QuestionSectionImpl _value, $Res Function(_$QuestionSectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuestionSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? questions = null,
  }) {
    return _then(_$QuestionSectionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<Question>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionSectionImpl implements _QuestionSection {
  const _$QuestionSectionImpl(
      {required this.id,
      required this.title,
      required final List<Question> questions})
      : _questions = questions;

  factory _$QuestionSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionSectionImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  final List<Question> _questions;
  @override
  List<Question> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  String toString() {
    return 'QuestionSection(id: $id, title: $title, questions: $questions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionSectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, const DeepCollectionEquality().hash(_questions));

  /// Create a copy of QuestionSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionSectionImplCopyWith<_$QuestionSectionImpl> get copyWith =>
      __$$QuestionSectionImplCopyWithImpl<_$QuestionSectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionSectionImplToJson(
      this,
    );
  }
}

abstract class _QuestionSection implements QuestionSection {
  const factory _QuestionSection(
      {required final String id,
      required final String title,
      required final List<Question> questions}) = _$QuestionSectionImpl;

  factory _QuestionSection.fromJson(Map<String, dynamic> json) =
      _$QuestionSectionImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  List<Question> get questions;

  /// Create a copy of QuestionSection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionSectionImplCopyWith<_$QuestionSectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return _Question.fromJson(json);
}

/// @nodoc
mixin _$Question {
  String get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  QuestionType get inputType => throw _privateConstructorUsedError;
  List<String>? get options => throw _privateConstructorUsedError;
  bool get required => throw _privateConstructorUsedError;
  String? get hint => throw _privateConstructorUsedError;
  Map<String, dynamic>? get validation => throw _privateConstructorUsedError;

  /// Serializes this Question to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionCopyWith<Question> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionCopyWith<$Res> {
  factory $QuestionCopyWith(Question value, $Res Function(Question) then) =
      _$QuestionCopyWithImpl<$Res, Question>;
  @useResult
  $Res call(
      {String id,
      String text,
      QuestionType inputType,
      List<String>? options,
      bool required,
      String? hint,
      Map<String, dynamic>? validation});
}

/// @nodoc
class _$QuestionCopyWithImpl<$Res, $Val extends Question>
    implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? inputType = null,
    Object? options = freezed,
    Object? required = null,
    Object? hint = freezed,
    Object? validation = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      inputType: null == inputType
          ? _value.inputType
          : inputType // ignore: cast_nullable_to_non_nullable
              as QuestionType,
      options: freezed == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      hint: freezed == hint
          ? _value.hint
          : hint // ignore: cast_nullable_to_non_nullable
              as String?,
      validation: freezed == validation
          ? _value.validation
          : validation // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionImplCopyWith<$Res>
    implements $QuestionCopyWith<$Res> {
  factory _$$QuestionImplCopyWith(
          _$QuestionImpl value, $Res Function(_$QuestionImpl) then) =
      __$$QuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String text,
      QuestionType inputType,
      List<String>? options,
      bool required,
      String? hint,
      Map<String, dynamic>? validation});
}

/// @nodoc
class __$$QuestionImplCopyWithImpl<$Res>
    extends _$QuestionCopyWithImpl<$Res, _$QuestionImpl>
    implements _$$QuestionImplCopyWith<$Res> {
  __$$QuestionImplCopyWithImpl(
      _$QuestionImpl _value, $Res Function(_$QuestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? inputType = null,
    Object? options = freezed,
    Object? required = null,
    Object? hint = freezed,
    Object? validation = freezed,
  }) {
    return _then(_$QuestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      inputType: null == inputType
          ? _value.inputType
          : inputType // ignore: cast_nullable_to_non_nullable
              as QuestionType,
      options: freezed == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      hint: freezed == hint
          ? _value.hint
          : hint // ignore: cast_nullable_to_non_nullable
              as String?,
      validation: freezed == validation
          ? _value._validation
          : validation // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionImpl implements _Question {
  const _$QuestionImpl(
      {required this.id,
      required this.text,
      required this.inputType,
      final List<String>? options,
      this.required = false,
      this.hint,
      final Map<String, dynamic>? validation})
      : _options = options,
        _validation = validation;

  factory _$QuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionImplFromJson(json);

  @override
  final String id;
  @override
  final String text;
  @override
  final QuestionType inputType;
  final List<String>? _options;
  @override
  List<String>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool required;
  @override
  final String? hint;
  final Map<String, dynamic>? _validation;
  @override
  Map<String, dynamic>? get validation {
    final value = _validation;
    if (value == null) return null;
    if (_validation is EqualUnmodifiableMapView) return _validation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Question(id: $id, text: $text, inputType: $inputType, options: $options, required: $required, hint: $hint, validation: $validation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.inputType, inputType) ||
                other.inputType == inputType) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.required, required) ||
                other.required == required) &&
            (identical(other.hint, hint) || other.hint == hint) &&
            const DeepCollectionEquality()
                .equals(other._validation, _validation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      text,
      inputType,
      const DeepCollectionEquality().hash(_options),
      required,
      hint,
      const DeepCollectionEquality().hash(_validation));

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionImplCopyWith<_$QuestionImpl> get copyWith =>
      __$$QuestionImplCopyWithImpl<_$QuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionImplToJson(
      this,
    );
  }
}

abstract class _Question implements Question {
  const factory _Question(
      {required final String id,
      required final String text,
      required final QuestionType inputType,
      final List<String>? options,
      final bool required,
      final String? hint,
      final Map<String, dynamic>? validation}) = _$QuestionImpl;

  factory _Question.fromJson(Map<String, dynamic> json) =
      _$QuestionImpl.fromJson;

  @override
  String get id;
  @override
  String get text;
  @override
  QuestionType get inputType;
  @override
  List<String>? get options;
  @override
  bool get required;
  @override
  String? get hint;
  @override
  Map<String, dynamic>? get validation;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionImplCopyWith<_$QuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
