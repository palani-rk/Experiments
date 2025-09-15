// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'validation_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ValidationStatus _$ValidationStatusFromJson(Map<String, dynamic> json) {
  return _ValidationStatus.fromJson(json);
}

/// @nodoc
mixin _$ValidationStatus {
  bool get isValid => throw _privateConstructorUsedError;
  List<String> get errors => throw _privateConstructorUsedError;
  List<String> get warnings => throw _privateConstructorUsedError;
  List<String> get info => throw _privateConstructorUsedError;
  String? get context => throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this ValidationStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ValidationStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ValidationStatusCopyWith<ValidationStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValidationStatusCopyWith<$Res> {
  factory $ValidationStatusCopyWith(
          ValidationStatus value, $Res Function(ValidationStatus) then) =
      _$ValidationStatusCopyWithImpl<$Res, ValidationStatus>;
  @useResult
  $Res call(
      {bool isValid,
      List<String> errors,
      List<String> warnings,
      List<String> info,
      String? context,
      DateTime? timestamp,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$ValidationStatusCopyWithImpl<$Res, $Val extends ValidationStatus>
    implements $ValidationStatusCopyWith<$Res> {
  _$ValidationStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ValidationStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
    Object? errors = null,
    Object? warnings = null,
    Object? info = null,
    Object? context = freezed,
    Object? timestamp = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      errors: null == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      warnings: null == warnings
          ? _value.warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      info: null == info
          ? _value.info
          : info // ignore: cast_nullable_to_non_nullable
              as List<String>,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ValidationStatusImplCopyWith<$Res>
    implements $ValidationStatusCopyWith<$Res> {
  factory _$$ValidationStatusImplCopyWith(_$ValidationStatusImpl value,
          $Res Function(_$ValidationStatusImpl) then) =
      __$$ValidationStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isValid,
      List<String> errors,
      List<String> warnings,
      List<String> info,
      String? context,
      DateTime? timestamp,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$ValidationStatusImplCopyWithImpl<$Res>
    extends _$ValidationStatusCopyWithImpl<$Res, _$ValidationStatusImpl>
    implements _$$ValidationStatusImplCopyWith<$Res> {
  __$$ValidationStatusImplCopyWithImpl(_$ValidationStatusImpl _value,
      $Res Function(_$ValidationStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of ValidationStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
    Object? errors = null,
    Object? warnings = null,
    Object? info = null,
    Object? context = freezed,
    Object? timestamp = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$ValidationStatusImpl(
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      errors: null == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      warnings: null == warnings
          ? _value._warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      info: null == info
          ? _value._info
          : info // ignore: cast_nullable_to_non_nullable
              as List<String>,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ValidationStatusImpl extends _ValidationStatus {
  const _$ValidationStatusImpl(
      {required this.isValid,
      final List<String> errors = const [],
      final List<String> warnings = const [],
      final List<String> info = const [],
      this.context,
      this.timestamp,
      final Map<String, dynamic>? metadata})
      : _errors = errors,
        _warnings = warnings,
        _info = info,
        _metadata = metadata,
        super._();

  factory _$ValidationStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$ValidationStatusImplFromJson(json);

  @override
  final bool isValid;
  final List<String> _errors;
  @override
  @JsonKey()
  List<String> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  final List<String> _warnings;
  @override
  @JsonKey()
  List<String> get warnings {
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warnings);
  }

  final List<String> _info;
  @override
  @JsonKey()
  List<String> get info {
    if (_info is EqualUnmodifiableListView) return _info;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_info);
  }

  @override
  final String? context;
  @override
  final DateTime? timestamp;
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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationStatusImpl &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings) &&
            const DeepCollectionEquality().equals(other._info, _info) &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isValid,
      const DeepCollectionEquality().hash(_errors),
      const DeepCollectionEquality().hash(_warnings),
      const DeepCollectionEquality().hash(_info),
      context,
      timestamp,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of ValidationStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationStatusImplCopyWith<_$ValidationStatusImpl> get copyWith =>
      __$$ValidationStatusImplCopyWithImpl<_$ValidationStatusImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ValidationStatusImplToJson(
      this,
    );
  }
}

abstract class _ValidationStatus extends ValidationStatus {
  const factory _ValidationStatus(
      {required final bool isValid,
      final List<String> errors,
      final List<String> warnings,
      final List<String> info,
      final String? context,
      final DateTime? timestamp,
      final Map<String, dynamic>? metadata}) = _$ValidationStatusImpl;
  const _ValidationStatus._() : super._();

  factory _ValidationStatus.fromJson(Map<String, dynamic> json) =
      _$ValidationStatusImpl.fromJson;

  @override
  bool get isValid;
  @override
  List<String> get errors;
  @override
  List<String> get warnings;
  @override
  List<String> get info;
  @override
  String? get context;
  @override
  DateTime? get timestamp;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of ValidationStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationStatusImplCopyWith<_$ValidationStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
