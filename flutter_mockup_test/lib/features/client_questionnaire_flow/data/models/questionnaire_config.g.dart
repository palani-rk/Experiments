// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionnaireConfigImpl _$$QuestionnaireConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionnaireConfigImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map((e) => QuestionSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$QuestionnaireConfigImplToJson(
        _$QuestionnaireConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'sections': instance.sections,
    };
