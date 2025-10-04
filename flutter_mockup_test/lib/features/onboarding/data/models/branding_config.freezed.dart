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
  /// The name of the healthcare clinic or practice
  String get clinicName => throw _privateConstructorUsedError;

  /// The name of the assigned nutritionist or dietitian
  String get nutritionistName => throw _privateConstructorUsedError;

  /// Optional URL to the clinic's logo image
  /// Should be validated for security before use
  String? get clinicLogoUrl => throw _privateConstructorUsedError;

  /// Optional URL to the nutritionist's profile photo
  /// Should be validated for security before use
  String? get nutritionistAvatarUrl => throw _privateConstructorUsedError;

  /// Personalized welcome message displayed on the welcome screen
  String get welcomeMessage => throw _privateConstructorUsedError;

  /// Supporting text that provides additional context or encouragement
  String get welcomeSubtitle => throw _privateConstructorUsedError;

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
      {String clinicName,
      String nutritionistName,
      String? clinicLogoUrl,
      String? nutritionistAvatarUrl,
      String welcomeMessage,
      String welcomeSubtitle});
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
    Object? clinicName = null,
    Object? nutritionistName = null,
    Object? clinicLogoUrl = freezed,
    Object? nutritionistAvatarUrl = freezed,
    Object? welcomeMessage = null,
    Object? welcomeSubtitle = null,
  }) {
    return _then(_value.copyWith(
      clinicName: null == clinicName
          ? _value.clinicName
          : clinicName // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionistName: null == nutritionistName
          ? _value.nutritionistName
          : nutritionistName // ignore: cast_nullable_to_non_nullable
              as String,
      clinicLogoUrl: freezed == clinicLogoUrl
          ? _value.clinicLogoUrl
          : clinicLogoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionistAvatarUrl: freezed == nutritionistAvatarUrl
          ? _value.nutritionistAvatarUrl
          : nutritionistAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      welcomeMessage: null == welcomeMessage
          ? _value.welcomeMessage
          : welcomeMessage // ignore: cast_nullable_to_non_nullable
              as String,
      welcomeSubtitle: null == welcomeSubtitle
          ? _value.welcomeSubtitle
          : welcomeSubtitle // ignore: cast_nullable_to_non_nullable
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
      {String clinicName,
      String nutritionistName,
      String? clinicLogoUrl,
      String? nutritionistAvatarUrl,
      String welcomeMessage,
      String welcomeSubtitle});
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
    Object? clinicName = null,
    Object? nutritionistName = null,
    Object? clinicLogoUrl = freezed,
    Object? nutritionistAvatarUrl = freezed,
    Object? welcomeMessage = null,
    Object? welcomeSubtitle = null,
  }) {
    return _then(_$BrandingConfigImpl(
      clinicName: null == clinicName
          ? _value.clinicName
          : clinicName // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionistName: null == nutritionistName
          ? _value.nutritionistName
          : nutritionistName // ignore: cast_nullable_to_non_nullable
              as String,
      clinicLogoUrl: freezed == clinicLogoUrl
          ? _value.clinicLogoUrl
          : clinicLogoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionistAvatarUrl: freezed == nutritionistAvatarUrl
          ? _value.nutritionistAvatarUrl
          : nutritionistAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      welcomeMessage: null == welcomeMessage
          ? _value.welcomeMessage
          : welcomeMessage // ignore: cast_nullable_to_non_nullable
              as String,
      welcomeSubtitle: null == welcomeSubtitle
          ? _value.welcomeSubtitle
          : welcomeSubtitle // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BrandingConfigImpl extends _BrandingConfig {
  const _$BrandingConfigImpl(
      {this.clinicName = 'NutriApp',
      this.nutritionistName = 'Dr. Smith',
      this.clinicLogoUrl,
      this.nutritionistAvatarUrl,
      this.welcomeMessage = 'Welcome to your personalized nutrition journey!',
      this.welcomeSubtitle =
          'We\'re excited to help you achieve your health goals.'})
      : super._();

  factory _$BrandingConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$BrandingConfigImplFromJson(json);

  /// The name of the healthcare clinic or practice
  @override
  @JsonKey()
  final String clinicName;

  /// The name of the assigned nutritionist or dietitian
  @override
  @JsonKey()
  final String nutritionistName;

  /// Optional URL to the clinic's logo image
  /// Should be validated for security before use
  @override
  final String? clinicLogoUrl;

  /// Optional URL to the nutritionist's profile photo
  /// Should be validated for security before use
  @override
  final String? nutritionistAvatarUrl;

  /// Personalized welcome message displayed on the welcome screen
  @override
  @JsonKey()
  final String welcomeMessage;

  /// Supporting text that provides additional context or encouragement
  @override
  @JsonKey()
  final String welcomeSubtitle;

  @override
  String toString() {
    return 'BrandingConfig(clinicName: $clinicName, nutritionistName: $nutritionistName, clinicLogoUrl: $clinicLogoUrl, nutritionistAvatarUrl: $nutritionistAvatarUrl, welcomeMessage: $welcomeMessage, welcomeSubtitle: $welcomeSubtitle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrandingConfigImpl &&
            (identical(other.clinicName, clinicName) ||
                other.clinicName == clinicName) &&
            (identical(other.nutritionistName, nutritionistName) ||
                other.nutritionistName == nutritionistName) &&
            (identical(other.clinicLogoUrl, clinicLogoUrl) ||
                other.clinicLogoUrl == clinicLogoUrl) &&
            (identical(other.nutritionistAvatarUrl, nutritionistAvatarUrl) ||
                other.nutritionistAvatarUrl == nutritionistAvatarUrl) &&
            (identical(other.welcomeMessage, welcomeMessage) ||
                other.welcomeMessage == welcomeMessage) &&
            (identical(other.welcomeSubtitle, welcomeSubtitle) ||
                other.welcomeSubtitle == welcomeSubtitle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, clinicName, nutritionistName,
      clinicLogoUrl, nutritionistAvatarUrl, welcomeMessage, welcomeSubtitle);

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

abstract class _BrandingConfig extends BrandingConfig {
  const factory _BrandingConfig(
      {final String clinicName,
      final String nutritionistName,
      final String? clinicLogoUrl,
      final String? nutritionistAvatarUrl,
      final String welcomeMessage,
      final String welcomeSubtitle}) = _$BrandingConfigImpl;
  const _BrandingConfig._() : super._();

  factory _BrandingConfig.fromJson(Map<String, dynamic> json) =
      _$BrandingConfigImpl.fromJson;

  /// The name of the healthcare clinic or practice
  @override
  String get clinicName;

  /// The name of the assigned nutritionist or dietitian
  @override
  String get nutritionistName;

  /// Optional URL to the clinic's logo image
  /// Should be validated for security before use
  @override
  String? get clinicLogoUrl;

  /// Optional URL to the nutritionist's profile photo
  /// Should be validated for security before use
  @override
  String? get nutritionistAvatarUrl;

  /// Personalized welcome message displayed on the welcome screen
  @override
  String get welcomeMessage;

  /// Supporting text that provides additional context or encouragement
  @override
  String get welcomeSubtitle;

  /// Create a copy of BrandingConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BrandingConfigImplCopyWith<_$BrandingConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
