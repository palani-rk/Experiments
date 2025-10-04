// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResponseImpl _$$ResponseImplFromJson(Map<String, dynamic> json) =>
    _$ResponseImpl(
      questionId: json['questionId'] as String,
      value: json['value'],
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$ResponseImplToJson(_$ResponseImpl instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'value': instance.value,
      'timestamp': instance.timestamp.toIso8601String(),
    };
