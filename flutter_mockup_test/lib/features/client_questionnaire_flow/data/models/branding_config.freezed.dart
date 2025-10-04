// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branding_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BrandingConfig _$BrandingConfigFromJson(Map<String, dynamic> json) {
  return _BrandingConfig.fromJson(json);
}

/// @nodoc
mixin _$BrandingConfig {
  String get logoUrl => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get subtitle => throw _privateConstructorUsedError;
  String? get nutritionistName => throw _privateConstructorUsedError;
  String? get clientName => throw _privateConstructorUsedError;
  String get primaryColor => throw _privateConstructorUsedError;
  String get secondaryColor => throw _privateConstructorUsedError;

  /// Serializes this BrandingConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BrandingConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BrandingConfigCopyWith<BrandingConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrandingConfigCopyWith<$Res> {
  factory $BrandingConfigCopyWith(
          BrandingConfig value, $Res Function(BrandingConfig) then) =
      _$BrandingConfigCopyWithImpl<$Res, BrandingConfig>;
  @useResult
  $Res call(
      {String logoUrl,
      String title,
      String subtitle,
      String? nutritionistName,
      String? clientName,
      String primaryColor,
      String secondaryColor});
}

/// @nodoc
class _$BrandingConfigCopyWithImpl<$Res, $Val extends BrandingConfig>
    implements $BrandingConfigCopyWith<$Res> {
  _$BrandingConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BrandingConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? logoUrl = null,
    Object? title = null,
    Object? subtitle = null,
    Object? nutritionistName = freezed,
    Object? clientName = freezed,
    Object? primaryColor = null,
    Object? secondaryColor = null,
  }) {
    return _then(_value.copyWith(
      logoUrl: null == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionistName: freezed == nutritionistName
          ? _value.nutritionistName
          : nutritionistName // ignore: cast_nullable_to_non_nullable
              as String?,
      clientName: freezed == clientName
          ? _value.clientName
          : clientName // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryColor: null == primaryColor
          ? _value.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryColor: null == secondaryColor
          ? _value.secondaryColor
          : secondaryColor // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BrandingConfigImplCopyWith<$Res>
    implements $BrandingConfigCopyWith<$Res> {
  factory _$$BrandingConfigImplCopyWith(_$BrandingConfigImpl value,
          $Res Function(_$BrandingConfigImpl) then) =
      __$$BrandingConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String logoUrl,
      String title,
      String subtitle,
      String? nutritionistName,
      String? clientName,
      String primaryColor,
      String secondaryColor});
}

/// @nodoc
class __$$BrandingConfigImplCopyWithImpl<$Res>
    extends _$BrandingConfigCopyWithImpl<$Res, _$BrandingConfigImpl>
    implements _$$BrandingConfigImplCopyWith<$Res> {
  __$$BrandingConfigImplCopyWithImpl(
      _$BrandingConfigImpl _value, $Res Function(_$BrandingConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of BrandingConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? logoUrl = null,
    Object? title = null,
    Object? subtitle = null,
    Object? nutritionistName = freezed,
    Object? clientName = freezed,
    Object? primaryColor = null,
    Object? secondaryColor = null,
  }) {
    return _then(_$BrandingConfigImpl(
      logoUrl: null == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionistName: freezed == nutritionistName
          ? _value.nutritionistName
          : nutritionistName // ignore: cast_nullable_to_non_nullable
              as String?,
      clientName: freezed == clientName
          ? _value.clientName
          : clientName // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryColor: null == primaryColor
          ? _value.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryColor: null == secondaryColor
          ? _value.secondaryColor
          : secondaryColor // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BrandingConfigImpl implements _BrandingConfig {
  const _$BrandingConfigImpl(
      {required this.logoUrl,
      required this.title,
      required this.subtitle,
      this.nutritionistName,
      this.clientName,
      this.primaryColor = '#6d5e0f',
      this.secondaryColor = '#43664e'});

  factory _$BrandingConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$BrandingConfigImplFromJson(json);

  @override
  final String logoUrl;
  @override
  final String title;
  @override
  final String subtitle;
  @override
  final String? nutritionistName;
  @override
  final String? clientName;
  @override
  @JsonKey()
  final String primaryColor;
  @override
  @JsonKey()
  final String secondaryColor;

  @override
  String toString() {
    return 'BrandingConfig(logoUrl: $logoUrl, title: $title, subtitle: $subtitle, nutritionistName: $nutritionistName, clientName: $clientName, primaryColor: $primaryColor, secondaryColor: $secondaryColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrandingConfigImpl &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.nutritionistName, nutritionistName) ||
                other.nutritionistName == nutritionistName) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.primaryColor, primaryColor) ||
                other.primaryColor == primaryColor) &&
            (identical(other.secondaryColor, secondaryColor) ||
                other.secondaryColor == secondaryColor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, logoUrl, title, subtitle,
      nutritionistName, clientName, primaryColor, secondaryColor);

  /// Create a copy of BrandingConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BrandingConfigImplCopyWith<_$BrandingConfigImpl> get copyWith =>
      __$$BrandingConfigImplCopyWithImpl<_$BrandingConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BrandingConfigImplToJson(
      this,
    );
  }
}

abstract class _BrandingConfig implements BrandingConfig {
  const factory _BrandingConfig(
      {required final String logoUrl,
      required final String title,
      required final String subtitle,
      final String? nutritionistName,
      final String? clientName,
      final String primaryColor,
      final String secondaryColor}) = _$BrandingConfigImpl;

  factory _BrandingConfig.fromJson(Map<String, dynamic> json) =
      _$BrandingConfigImpl.fromJson;

  @override
  String get logoUrl;
  @override
  String get title;
  @override
  String get subtitle;
  @override
  String? get nutritionistName;
  @override
  String? get clientName;
  @override
  String get primaryColor;
  @override
  String get secondaryColor;

  /// Create a copy of BrandingConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BrandingConfigImplCopyWith<_$BrandingConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
