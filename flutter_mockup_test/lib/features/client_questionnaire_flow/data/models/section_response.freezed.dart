// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'section_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SectionResponse _$SectionResponseFromJson(Map<String, dynamic> json) {
  return _SectionResponse.fromJson(json);
}

/// @nodoc
mixin _$SectionResponse {
  String get sectionId => throw _privateConstructorUsedError;
  List<Response> get responses => throw _privateConstructorUsedError;
  SectionStatus get status => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime get savedAt => throw _privateConstructorUsedError;

  /// Serializes this SectionResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SectionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SectionResponseCopyWith<SectionResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SectionResponseCopyWith<$Res> {
  factory $SectionResponseCopyWith(
          SectionResponse value, $Res Function(SectionResponse) then) =
      _$SectionResponseCopyWithImpl<$Res, SectionResponse>;
  @useResult
  $Res call(
      {String sectionId,
      List<Response> responses,
      SectionStatus status,
      DateTime? completedAt,
      DateTime savedAt});
}

/// @nodoc
class _$SectionResponseCopyWithImpl<$Res, $Val extends SectionResponse>
    implements $SectionResponseCopyWith<$Res> {
  _$SectionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SectionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sectionId = null,
    Object? responses = null,
    Object? status = null,
    Object? completedAt = freezed,
    Object? savedAt = null,
  }) {
    return _then(_value.copyWith(
      sectionId: null == sectionId
          ? _value.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String,
      responses: null == responses
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as List<Response>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SectionStatus,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      savedAt: null == savedAt
          ? _value.savedAt
          : savedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SectionResponseImplCopyWith<$Res>
    implements $SectionResponseCopyWith<$Res> {
  factory _$$SectionResponseImplCopyWith(_$SectionResponseImpl value,
          $Res Function(_$SectionResponseImpl) then) =
      __$$SectionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sectionId,
      List<Response> responses,
      SectionStatus status,
      DateTime? completedAt,
      DateTime savedAt});
}

/// @nodoc
class __$$SectionResponseImplCopyWithImpl<$Res>
    extends _$SectionResponseCopyWithImpl<$Res, _$SectionResponseImpl>
    implements _$$SectionResponseImplCopyWith<$Res> {
  __$$SectionResponseImplCopyWithImpl(
      _$SectionResponseImpl _value, $Res Function(_$SectionResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SectionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sectionId = null,
    Object? responses = null,
    Object? status = null,
    Object? completedAt = freezed,
    Object? savedAt = null,
  }) {
    return _then(_$SectionResponseImpl(
      sectionId: null == sectionId
          ? _value.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String,
      responses: null == responses
          ? _value._responses
          : responses // ignore: cast_nullable_to_non_nullable
              as List<Response>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SectionStatus,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      savedAt: null == savedAt
          ? _value.savedAt
          : savedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SectionResponseImpl implements _SectionResponse {
  const _$SectionResponseImpl(
      {required this.sectionId,
      required final List<Response> responses,
      required this.status,
      this.completedAt,
      required this.savedAt})
      : _responses = responses;

  factory _$SectionResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SectionResponseImplFromJson(json);

  @override
  final String sectionId;
  final List<Response> _responses;
  @override
  List<Response> get responses {
    if (_responses is EqualUnmodifiableListView) return _responses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_responses);
  }

  @override
  final SectionStatus status;
  @override
  final DateTime? completedAt;
  @override
  final DateTime savedAt;

  @override
  String toString() {
    return 'SectionResponse(sectionId: $sectionId, responses: $responses, status: $status, completedAt: $completedAt, savedAt: $savedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SectionResponseImpl &&
            (identical(other.sectionId, sectionId) ||
                other.sectionId == sectionId) &&
            const DeepCollectionEquality()
                .equals(other._responses, _responses) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.savedAt, savedAt) || other.savedAt == savedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sectionId,
      const DeepCollectionEquality().hash(_responses),
      status,
      completedAt,
      savedAt);

  /// Create a copy of SectionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SectionResponseImplCopyWith<_$SectionResponseImpl> get copyWith =>
      __$$SectionResponseImplCopyWithImpl<_$SectionResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SectionResponseImplToJson(
      this,
    );
  }
}

abstract class _SectionResponse implements SectionResponse {
  const factory _SectionResponse(
      {required final String sectionId,
      required final List<Response> responses,
      required final SectionStatus status,
      final DateTime? completedAt,
      required final DateTime savedAt}) = _$SectionResponseImpl;

  factory _SectionResponse.fromJson(Map<String, dynamic> json) =
      _$SectionResponseImpl.fromJson;

  @override
  String get sectionId;
  @override
  List<Response> get responses;
  @override
  SectionStatus get status;
  @override
  DateTime? get completedAt;
  @override
  DateTime get savedAt;

  /// Create a copy of SectionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SectionResponseImplCopyWith<_$SectionResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
