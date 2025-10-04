// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ValidationRules _$ValidationRulesFromJson(Map<String, dynamic> json) {
  return _ValidationRules.fromJson(json);
}

/// @nodoc
mixin _$ValidationRules {
  int? get minLength => throw _privateConstructorUsedError;
  int? get maxLength => throw _privateConstructorUsedError;
  num? get minValue => throw _privateConstructorUsedError;
  num? get maxValue => throw _privateConstructorUsedError;
  String? get pattern => throw _privateConstructorUsedError;
  bool? get required => throw _privateConstructorUsedError;

  /// Serializes this ValidationRules to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ValidationRules
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ValidationRulesCopyWith<ValidationRules> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValidationRulesCopyWith<$Res> {
  factory $ValidationRulesCopyWith(
          ValidationRules value, $Res Function(ValidationRules) then) =
      _$ValidationRulesCopyWithImpl<$Res, ValidationRules>;
  @useResult
  $Res call(
      {int? minLength,
      int? maxLength,
      num? minValue,
      num? maxValue,
      String? pattern,
      bool? required});
}

/// @nodoc
class _$ValidationRulesCopyWithImpl<$Res, $Val extends ValidationRules>
    implements $ValidationRulesCopyWith<$Res> {
  _$ValidationRulesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ValidationRules
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minLength = freezed,
    Object? maxLength = freezed,
    Object? minValue = freezed,
    Object? maxValue = freezed,
    Object? pattern = freezed,
    Object? required = freezed,
  }) {
    return _then(_value.copyWith(
      minLength: freezed == minLength
          ? _value.minLength
          : minLength // ignore: cast_nullable_to_non_nullable
              as int?,
      maxLength: freezed == maxLength
          ? _value.maxLength
          : maxLength // ignore: cast_nullable_to_non_nullable
              as int?,
      minValue: freezed == minValue
          ? _value.minValue
          : minValue // ignore: cast_nullable_to_non_nullable
              as num?,
      maxValue: freezed == maxValue
          ? _value.maxValue
          : maxValue // ignore: cast_nullable_to_non_nullable
              as num?,
      pattern: freezed == pattern
          ? _value.pattern
          : pattern // ignore: cast_nullable_to_non_nullable
              as String?,
      required: freezed == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ValidationRulesImplCopyWith<$Res>
    implements $ValidationRulesCopyWith<$Res> {
  factory _$$ValidationRulesImplCopyWith(_$ValidationRulesImpl value,
          $Res Function(_$ValidationRulesImpl) then) =
      __$$ValidationRulesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? minLength,
      int? maxLength,
      num? minValue,
      num? maxValue,
      String? pattern,
      bool? required});
}

/// @nodoc
class __$$ValidationRulesImplCopyWithImpl<$Res>
    extends _$ValidationRulesCopyWithImpl<$Res, _$ValidationRulesImpl>
    implements _$$ValidationRulesImplCopyWith<$Res> {
  __$$ValidationRulesImplCopyWithImpl(
      _$ValidationRulesImpl _value, $Res Function(_$ValidationRulesImpl) _then)
      : super(_value, _then);

  /// Create a copy of ValidationRules
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minLength = freezed,
    Object? maxLength = freezed,
    Object? minValue = freezed,
    Object? maxValue = freezed,
    Object? pattern = freezed,
    Object? required = freezed,
  }) {
    return _then(_$ValidationRulesImpl(
      minLength: freezed == minLength
          ? _value.minLength
          : minLength // ignore: cast_nullable_to_non_nullable
              as int?,
      maxLength: freezed == maxLength
          ? _value.maxLength
          : maxLength // ignore: cast_nullable_to_non_nullable
              as int?,
      minValue: freezed == minValue
          ? _value.minValue
          : minValue // ignore: cast_nullable_to_non_nullable
              as num?,
      maxValue: freezed == maxValue
          ? _value.maxValue
          : maxValue // ignore: cast_nullable_to_non_nullable
              as num?,
      pattern: freezed == pattern
          ? _value.pattern
          : pattern // ignore: cast_nullable_to_non_nullable
              as String?,
      required: freezed == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ValidationRulesImpl implements _ValidationRules {
  const _$ValidationRulesImpl(
      {this.minLength,
      this.maxLength,
      this.minValue,
      this.maxValue,
      this.pattern,
      this.required});

  factory _$ValidationRulesImpl.fromJson(Map<String, dynamic> json) =>
      _$$ValidationRulesImplFromJson(json);

  @override
  final int? minLength;
  @override
  final int? maxLength;
  @override
  final num? minValue;
  @override
  final num? maxValue;
  @override
  final String? pattern;
  @override
  final bool? required;

  @override
  String toString() {
    return 'ValidationRules(minLength: $minLength, maxLength: $maxLength, minValue: $minValue, maxValue: $maxValue, pattern: $pattern, required: $required)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationRulesImpl &&
            (identical(other.minLength, minLength) ||
                other.minLength == minLength) &&
            (identical(other.maxLength, maxLength) ||
                other.maxLength == maxLength) &&
            (identical(other.minValue, minValue) ||
                other.minValue == minValue) &&
            (identical(other.maxValue, maxValue) ||
                other.maxValue == maxValue) &&
            (identical(other.pattern, pattern) || other.pattern == pattern) &&
            (identical(other.required, required) ||
                other.required == required));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, minLength, maxLength, minValue, maxValue, pattern, required);

  /// Create a copy of ValidationRules
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationRulesImplCopyWith<_$ValidationRulesImpl> get copyWith =>
      __$$ValidationRulesImplCopyWithImpl<_$ValidationRulesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ValidationRulesImplToJson(
      this,
    );
  }
}

abstract class _ValidationRules implements ValidationRules {
  const factory _ValidationRules(
      {final int? minLength,
      final int? maxLength,
      final num? minValue,
      final num? maxValue,
      final String? pattern,
      final bool? required}) = _$ValidationRulesImpl;

  factory _ValidationRules.fromJson(Map<String, dynamic> json) =
      _$ValidationRulesImpl.fromJson;

  @override
  int? get minLength;
  @override
  int? get maxLength;
  @override
  num? get minValue;
  @override
  num? get maxValue;
  @override
  String? get pattern;
  @override
  bool? get required;

  /// Create a copy of ValidationRules
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationRulesImplCopyWith<_$ValidationRulesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return _Question.fromJson(json);
}

/// @nodoc
mixin _$Question {
  String get id => throw _privateConstructorUsedError;
  String get sectionId => throw _privateConstructorUsedError;
  String get questionText => throw _privateConstructorUsedError;
  QuestionType get inputType => throw _privateConstructorUsedError;
  bool get required => throw _privateConstructorUsedError;
  List<String>? get options => throw _privateConstructorUsedError;
  ValidationRules? get validation => throw _privateConstructorUsedError;
  String? get placeholder => throw _privateConstructorUsedError;

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
      String sectionId,
      String questionText,
      QuestionType inputType,
      bool required,
      List<String>? options,
      ValidationRules? validation,
      String? placeholder});

  $ValidationRulesCopyWith<$Res>? get validation;
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
    Object? sectionId = null,
    Object? questionText = null,
    Object? inputType = null,
    Object? required = null,
    Object? options = freezed,
    Object? validation = freezed,
    Object? placeholder = freezed,
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
      questionText: null == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String,
      inputType: null == inputType
          ? _value.inputType
          : inputType // ignore: cast_nullable_to_non_nullable
              as QuestionType,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      options: freezed == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      validation: freezed == validation
          ? _value.validation
          : validation // ignore: cast_nullable_to_non_nullable
              as ValidationRules?,
      placeholder: freezed == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ValidationRulesCopyWith<$Res>? get validation {
    if (_value.validation == null) {
      return null;
    }

    return $ValidationRulesCopyWith<$Res>(_value.validation!, (value) {
      return _then(_value.copyWith(validation: value) as $Val);
    });
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
      String sectionId,
      String questionText,
      QuestionType inputType,
      bool required,
      List<String>? options,
      ValidationRules? validation,
      String? placeholder});

  @override
  $ValidationRulesCopyWith<$Res>? get validation;
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
    Object? sectionId = null,
    Object? questionText = null,
    Object? inputType = null,
    Object? required = null,
    Object? options = freezed,
    Object? validation = freezed,
    Object? placeholder = freezed,
  }) {
    return _then(_$QuestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sectionId: null == sectionId
          ? _value.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String,
      questionText: null == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String,
      inputType: null == inputType
          ? _value.inputType
          : inputType // ignore: cast_nullable_to_non_nullable
              as QuestionType,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      options: freezed == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      validation: freezed == validation
          ? _value.validation
          : validation // ignore: cast_nullable_to_non_nullable
              as ValidationRules?,
      placeholder: freezed == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionImpl implements _Question {
  const _$QuestionImpl(
      {required this.id,
      required this.sectionId,
      required this.questionText,
      required this.inputType,
      this.required = true,
      final List<String>? options,
      this.validation,
      this.placeholder})
      : _options = options;

  factory _$QuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionImplFromJson(json);

  @override
  final String id;
  @override
  final String sectionId;
  @override
  final String questionText;
  @override
  final QuestionType inputType;
  @override
  @JsonKey()
  final bool required;
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
  final ValidationRules? validation;
  @override
  final String? placeholder;

  @override
  String toString() {
    return 'Question(id: $id, sectionId: $sectionId, questionText: $questionText, inputType: $inputType, required: $required, options: $options, validation: $validation, placeholder: $placeholder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sectionId, sectionId) ||
                other.sectionId == sectionId) &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            (identical(other.inputType, inputType) ||
                other.inputType == inputType) &&
            (identical(other.required, required) ||
                other.required == required) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.validation, validation) ||
                other.validation == validation) &&
            (identical(other.placeholder, placeholder) ||
                other.placeholder == placeholder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sectionId,
      questionText,
      inputType,
      required,
      const DeepCollectionEquality().hash(_options),
      validation,
      placeholder);

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
      required final String sectionId,
      required final String questionText,
      required final QuestionType inputType,
      final bool required,
      final List<String>? options,
      final ValidationRules? validation,
      final String? placeholder}) = _$QuestionImpl;

  factory _Question.fromJson(Map<String, dynamic> json) =
      _$QuestionImpl.fromJson;

  @override
  String get id;
  @override
  String get sectionId;
  @override
  String get questionText;
  @override
  QuestionType get inputType;
  @override
  bool get required;
  @override
  List<String>? get options;
  @override
  ValidationRules? get validation;
  @override
  String? get placeholder;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionImplCopyWith<_$QuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
