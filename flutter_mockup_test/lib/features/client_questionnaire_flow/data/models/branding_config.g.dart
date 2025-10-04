// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branding_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BrandingConfigImpl _$$BrandingConfigImplFromJson(Map<String, dynamic> json) =>
    _$BrandingConfigImpl(
      logoUrl: json['logoUrl'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      nutritionistName: json['nutritionistName'] as String?,
      clientName: json['clientName'] as String?,
      primaryColor: json['primaryColor'] as String? ?? '#6d5e0f',
      secondaryColor: json['secondaryColor'] as String? ?? '#43664e',
    );

Map<String, dynamic> _$$BrandingConfigImplToJson(
        _$BrandingConfigImpl instance) =>
    <String, dynamic>{
      'logoUrl': instance.logoUrl,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'nutritionistName': instance.nutritionistName,
      'clientName': instance.clientName,
      'primaryColor': instance.primaryColor,
      'secondaryColor': instance.secondaryColor,
    };
