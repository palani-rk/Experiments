// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'questionnaire_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuestionnaireConfig _$QuestionnaireConfigFromJson(Map<String, dynamic> json) {
  return _QuestionnaireConfig.fromJson(json);
}

/// @nodoc
mixin _$QuestionnaireConfig {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<QuestionSection> get sections => throw _privateConstructorUsedError;

  /// Serializes this QuestionnaireConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionnaireConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionnaireConfigCopyWith<QuestionnaireConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionnaireConfigCopyWith<$Res> {
  factory $QuestionnaireConfigCopyWith(
          QuestionnaireConfig value, $Res Function(QuestionnaireConfig) then) =
      _$QuestionnaireConfigCopyWithImpl<$Res, QuestionnaireConfig>;
  @useResult
  $Res call({String id, String title, List<QuestionSection> sections});
}

/// @nodoc
class _$QuestionnaireConfigCopyWithImpl<$Res, $Val extends QuestionnaireConfig>
    implements $QuestionnaireConfigCopyWith<$Res> {
  _$QuestionnaireConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionnaireConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? sections = null,
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
      sections: null == sections
          ? _value.sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<QuestionSection>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionnaireConfigImplCopyWith<$Res>
    implements $QuestionnaireConfigCopyWith<$Res> {
  factory _$$QuestionnaireConfigImplCopyWith(_$QuestionnaireConfigImpl value,
          $Res Function(_$QuestionnaireConfigImpl) then) =
      __$$QuestionnaireConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, List<QuestionSection> sections});
}

/// @nodoc
class __$$QuestionnaireConfigImplCopyWithImpl<$Res>
    extends _$QuestionnaireConfigCopyWithImpl<$Res, _$QuestionnaireConfigImpl>
    implements _$$QuestionnaireConfigImplCopyWith<$Res> {
  __$$QuestionnaireConfigImplCopyWithImpl(_$QuestionnaireConfigImpl _value,
      $Res Function(_$QuestionnaireConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuestionnaireConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? sections = null,
  }) {
    return _then(_$QuestionnaireConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      sections: null == sections
          ? _value._sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<QuestionSection>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionnaireConfigImpl implements _QuestionnaireConfig {
  const _$QuestionnaireConfigImpl(
      {required this.id,
      required this.title,
      required final List<QuestionSection> sections})
      : _sections = sections;

  factory _$QuestionnaireConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionnaireConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  final List<QuestionSection> _sections;
  @override
  List<QuestionSection> get sections {
    if (_sections is EqualUnmodifiableListView) return _sections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sections);
  }

  @override
  String toString() {
    return 'QuestionnaireConfig(id: $id, title: $title, sections: $sections)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionnaireConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._sections, _sections));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, const DeepCollectionEquality().hash(_sections));

  /// Create a copy of QuestionnaireConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionnaireConfigImplCopyWith<_$QuestionnaireConfigImpl> get copyWith =>
      __$$QuestionnaireConfigImplCopyWithImpl<_$QuestionnaireConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionnaireConfigImplToJson(
      this,
    );
  }
}

abstract class _QuestionnaireConfig implements QuestionnaireConfig {
  const factory _QuestionnaireConfig(
          {required final String id,
          required final String title,
          required final List<QuestionSection> sections}) =
      _$QuestionnaireConfigImpl;

  factory _QuestionnaireConfig.fromJson(Map<String, dynamic> json) =
      _$QuestionnaireConfigImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  List<QuestionSection> get sections;

  /// Create a copy of QuestionnaireConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionnaireConfigImplCopyWith<_$QuestionnaireConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
