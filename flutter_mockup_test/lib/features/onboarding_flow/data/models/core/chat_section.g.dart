// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IntroSectionImpl _$$IntroSectionImplFromJson(Map<String, dynamic> json) =>
    _$IntroSectionImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      welcomeMessages: (json['welcomeMessages'] as List<dynamic>)
          .map((e) => BotMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      sectionType:
          $enumDecodeNullable(_$SectionTypeEnumMap, json['sectionType']) ??
              SectionType.intro,
      status: $enumDecodeNullable(_$SectionStatusEnumMap, json['status']) ??
          SectionStatus.completed,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$IntroSectionImplToJson(_$IntroSectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'welcomeMessages': instance.welcomeMessages,
      'sectionType': _$SectionTypeEnumMap[instance.sectionType]!,
      'status': _$SectionStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'runtimeType': instance.$type,
    };

const _$SectionTypeEnumMap = {
  SectionType.intro: 'intro',
  SectionType.questionnaire: 'questionnaire',
  SectionType.media: 'media',
  SectionType.review: 'review',
  SectionType.completion: 'completion',
};

const _$SectionStatusEnumMap = {
  SectionStatus.pending: 'pending',
  SectionStatus.inProgress: 'inProgress',
  SectionStatus.completed: 'completed',
  SectionStatus.skipped: 'skipped',
};

_$QuestionnaireSectionImpl _$$QuestionnaireSectionImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionnaireSectionImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => SectionMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      sectionType:
          $enumDecodeNullable(_$SectionTypeEnumMap, json['sectionType']) ??
              SectionType.questionnaire,
      status: $enumDecodeNullable(_$SectionStatusEnumMap, json['status']) ??
          SectionStatus.pending,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$QuestionnaireSectionImplToJson(
        _$QuestionnaireSectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'questions': instance.questions,
      'messages': instance.messages,
      'sectionType': _$SectionTypeEnumMap[instance.sectionType]!,
      'status': _$SectionStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'runtimeType': instance.$type,
    };
