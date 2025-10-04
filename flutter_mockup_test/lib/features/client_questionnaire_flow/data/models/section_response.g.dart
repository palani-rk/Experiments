// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SectionResponseImpl _$$SectionResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SectionResponseImpl(
      sectionId: json['sectionId'] as String,
      responses: (json['responses'] as List<dynamic>)
          .map((e) => Response.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: $enumDecode(_$SectionStatusEnumMap, json['status']),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      savedAt: DateTime.parse(json['savedAt'] as String),
    );

Map<String, dynamic> _$$SectionResponseImplToJson(
        _$SectionResponseImpl instance) =>
    <String, dynamic>{
      'sectionId': instance.sectionId,
      'responses': instance.responses,
      'status': _$SectionStatusEnumMap[instance.status]!,
      'completedAt': instance.completedAt?.toIso8601String(),
      'savedAt': instance.savedAt.toIso8601String(),
    };

const _$SectionStatusEnumMap = {
  SectionStatus.notStarted: 'not_started',
  SectionStatus.inProgress: 'in_progress',
  SectionStatus.completed: 'completed',
};
