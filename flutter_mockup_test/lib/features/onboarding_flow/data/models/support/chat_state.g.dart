// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatStateImpl _$$ChatStateImplFromJson(Map<String, dynamic> json) =>
    _$ChatStateImpl(
      sessionId: json['sessionId'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map((e) => ChatSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentSectionId: json['currentSectionId'] as String?,
      currentQuestionId: json['currentQuestionId'] as String?,
      status: $enumDecodeNullable(_$ChatStatusEnumMap, json['status']) ??
          ChatStatus.notStarted,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      lastActivityAt: json['lastActivityAt'] == null
          ? null
          : DateTime.parse(json['lastActivityAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$ChatStateImplToJson(_$ChatStateImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'sections': instance.sections,
      'currentSectionId': instance.currentSectionId,
      'currentQuestionId': instance.currentQuestionId,
      'status': _$ChatStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'lastActivityAt': instance.lastActivityAt?.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$ChatStatusEnumMap = {
  ChatStatus.notStarted: 'notStarted',
  ChatStatus.inProgress: 'inProgress',
  ChatStatus.completed: 'completed',
  ChatStatus.abandoned: 'abandoned',
};
