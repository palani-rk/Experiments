// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ValidationStatusImpl _$$ValidationStatusImplFromJson(
        Map<String, dynamic> json) =>
    _$ValidationStatusImpl(
      isValid: json['isValid'] as bool,
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      info:
          (json['info'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      context: json['context'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ValidationStatusImplToJson(
        _$ValidationStatusImpl instance) =>
    <String, dynamic>{
      'isValid': instance.isValid,
      'errors': instance.errors,
      'warnings': instance.warnings,
      'info': instance.info,
      'context': instance.context,
      'timestamp': instance.timestamp?.toIso8601String(),
      'metadata': instance.metadata,
    };
