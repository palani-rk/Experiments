// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branding_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BrandingConfigImpl _$$BrandingConfigImplFromJson(Map<String, dynamic> json) =>
    _$BrandingConfigImpl(
      clinicName: json['clinicName'] as String? ?? 'NutriApp',
      nutritionistName: json['nutritionistName'] as String? ?? 'Dr. Smith',
      clinicLogoUrl: json['clinicLogoUrl'] as String?,
      nutritionistAvatarUrl: json['nutritionistAvatarUrl'] as String?,
      welcomeMessage: json['welcomeMessage'] as String? ??
          'Welcome to your personalized nutrition journey!',
      welcomeSubtitle: json['welcomeSubtitle'] as String? ??
          'We\'re excited to help you achieve your health goals.',
    );

Map<String, dynamic> _$$BrandingConfigImplToJson(
        _$BrandingConfigImpl instance) =>
    <String, dynamic>{
      'clinicName': instance.clinicName,
      'nutritionistName': instance.nutritionistName,
      'clinicLogoUrl': instance.clinicLogoUrl,
      'nutritionistAvatarUrl': instance.nutritionistAvatarUrl,
      'welcomeMessage': instance.welcomeMessage,
      'welcomeSubtitle': instance.welcomeSubtitle,
    };
