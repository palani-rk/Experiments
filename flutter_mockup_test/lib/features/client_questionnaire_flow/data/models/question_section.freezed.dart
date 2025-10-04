// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_section.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuestionSection _$QuestionSectionFromJson(Map<String, dynamic> json) {
  return _QuestionSection.fromJson(json);
}

/// @nodoc
mixin _$QuestionSection {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<Question> get questions => throw _privateConstructorUsedError;
  String get completionMessage => throw _privateConstructorUsedError;

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
  $Res call(
      {String id,
      String title,
      String? description,
      List<Question> questions,
      String completionMessage});
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
    Object? description = freezed,
    Object? questions = null,
    Object? completionMessage = null,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      questions: null == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<Question>,
      completionMessage: null == completionMessage
          ? _value.completionMessage
          : completionMessage // ignore: cast_nullable_to_non_nullable
              as String,
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
  $Res call(
      {String id,
      String title,
      String? description,
      List<Question> questions,
      String completionMessage});
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
    Object? description = freezed,
    Object? questions = null,
    Object? completionMessage = null,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<Question>,
      completionMessage: null == completionMessage
          ? _value.completionMessage
          : completionMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionSectionImpl implements _QuestionSection {
  const _$QuestionSectionImpl(
      {required this.id,
      required this.title,
      this.description,
      required final List<Question> questions,
      this.completionMessage = 'Great! Moving on to the next section.'})
      : _questions = questions;

  factory _$QuestionSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionSectionImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  final List<Question> _questions;
  @override
  List<Question> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  @JsonKey()
  final String completionMessage;

  @override
  String toString() {
    return 'QuestionSection(id: $id, title: $title, description: $description, questions: $questions, completionMessage: $completionMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionSectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions) &&
            (identical(other.completionMessage, completionMessage) ||
                other.completionMessage == completionMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description,
      const DeepCollectionEquality().hash(_questions), completionMessage);

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
      final String? description,
      required final List<Question> questions,
      final String completionMessage}) = _$QuestionSectionImpl;

  factory _QuestionSection.fromJson(Map<String, dynamic> json) =
      _$QuestionSectionImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  List<Question> get questions;
  @override
  String get completionMessage;

  /// Create a copy of QuestionSection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionSectionImplCopyWith<_$QuestionSectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
