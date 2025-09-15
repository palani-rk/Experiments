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

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return _Question.fromJson(json);
}

/// @nodoc
mixin _$Question {
  String get id => throw _privateConstructorUsedError;
  String get sectionId => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  QuestionType get inputType => throw _privateConstructorUsedError;
  bool get required => throw _privateConstructorUsedError;
  String? get hint => throw _privateConstructorUsedError;
  String? get placeholder => throw _privateConstructorUsedError;
  List<String>? get options => throw _privateConstructorUsedError;
  Map<String, dynamic>? get validation => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

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
      String text,
      QuestionType inputType,
      bool required,
      String? hint,
      String? placeholder,
      List<String>? options,
      Map<String, dynamic>? validation,
      Map<String, dynamic>? metadata,
      int order});
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
    Object? text = null,
    Object? inputType = null,
    Object? required = null,
    Object? hint = freezed,
    Object? placeholder = freezed,
    Object? options = freezed,
    Object? validation = freezed,
    Object? metadata = freezed,
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
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      inputType: null == inputType
          ? _value.inputType
          : inputType // ignore: cast_nullable_to_non_nullable
              as QuestionType,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      hint: freezed == hint
          ? _value.hint
          : hint // ignore: cast_nullable_to_non_nullable
              as String?,
      placeholder: freezed == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as String?,
      options: freezed == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      validation: freezed == validation
          ? _value.validation
          : validation // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
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
      String sectionId,
      String text,
      QuestionType inputType,
      bool required,
      String? hint,
      String? placeholder,
      List<String>? options,
      Map<String, dynamic>? validation,
      Map<String, dynamic>? metadata,
      int order});
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
    Object? text = null,
    Object? inputType = null,
    Object? required = null,
    Object? hint = freezed,
    Object? placeholder = freezed,
    Object? options = freezed,
    Object? validation = freezed,
    Object? metadata = freezed,
    Object? order = null,
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
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      inputType: null == inputType
          ? _value.inputType
          : inputType // ignore: cast_nullable_to_non_nullable
              as QuestionType,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      hint: freezed == hint
          ? _value.hint
          : hint // ignore: cast_nullable_to_non_nullable
              as String?,
      placeholder: freezed == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as String?,
      options: freezed == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      validation: freezed == validation
          ? _value._validation
          : validation // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionImpl extends _Question with DiagnosticableTreeMixin {
  const _$QuestionImpl(
      {required this.id,
      required this.sectionId,
      required this.text,
      required this.inputType,
      this.required = false,
      this.hint,
      this.placeholder,
      final List<String>? options,
      final Map<String, dynamic>? validation,
      final Map<String, dynamic>? metadata,
      this.order = 0})
      : _options = options,
        _validation = validation,
        _metadata = metadata,
        super._();

  factory _$QuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionImplFromJson(json);

  @override
  final String id;
  @override
  final String sectionId;
  @override
  final String text;
  @override
  final QuestionType inputType;
  @override
  @JsonKey()
  final bool required;
  @override
  final String? hint;
  @override
  final String? placeholder;
  final List<String>? _options;
  @override
  List<String>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _validation;
  @override
  Map<String, dynamic>? get validation {
    final value = _validation;
    if (value == null) return null;
    if (_validation is EqualUnmodifiableMapView) return _validation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final int order;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Question(id: $id, sectionId: $sectionId, text: $text, inputType: $inputType, required: $required, hint: $hint, placeholder: $placeholder, options: $options, validation: $validation, metadata: $metadata, order: $order)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Question'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('sectionId', sectionId))
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('inputType', inputType))
      ..add(DiagnosticsProperty('required', required))
      ..add(DiagnosticsProperty('hint', hint))
      ..add(DiagnosticsProperty('placeholder', placeholder))
      ..add(DiagnosticsProperty('options', options))
      ..add(DiagnosticsProperty('validation', validation))
      ..add(DiagnosticsProperty('metadata', metadata))
      ..add(DiagnosticsProperty('order', order));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sectionId, sectionId) ||
                other.sectionId == sectionId) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.inputType, inputType) ||
                other.inputType == inputType) &&
            (identical(other.required, required) ||
                other.required == required) &&
            (identical(other.hint, hint) || other.hint == hint) &&
            (identical(other.placeholder, placeholder) ||
                other.placeholder == placeholder) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            const DeepCollectionEquality()
                .equals(other._validation, _validation) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sectionId,
      text,
      inputType,
      required,
      hint,
      placeholder,
      const DeepCollectionEquality().hash(_options),
      const DeepCollectionEquality().hash(_validation),
      const DeepCollectionEquality().hash(_metadata),
      order);

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

abstract class _Question extends Question {
  const factory _Question(
      {required final String id,
      required final String sectionId,
      required final String text,
      required final QuestionType inputType,
      final bool required,
      final String? hint,
      final String? placeholder,
      final List<String>? options,
      final Map<String, dynamic>? validation,
      final Map<String, dynamic>? metadata,
      final int order}) = _$QuestionImpl;
  const _Question._() : super._();

  factory _Question.fromJson(Map<String, dynamic> json) =
      _$QuestionImpl.fromJson;

  @override
  String get id;
  @override
  String get sectionId;
  @override
  String get text;
  @override
  QuestionType get inputType;
  @override
  bool get required;
  @override
  String? get hint;
  @override
  String? get placeholder;
  @override
  List<String>? get options;
  @override
  Map<String, dynamic>? get validation;
  @override
  Map<String, dynamic>? get metadata;
  @override
  int get order;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionImplCopyWith<_$QuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
