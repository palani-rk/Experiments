// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionnaireSchemaImpl _$$QuestionnaireSchemaImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionnaireSchemaImpl(
      welcome: WelcomeSection.fromJson(json['welcome'] as Map<String, dynamic>),
      sections: (json['sections'] as List<dynamic>)
          .map((e) => QuestionSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$QuestionnaireSchemaImplToJson(
        _$QuestionnaireSchemaImpl instance) =>
    <String, dynamic>{
      'welcome': instance.welcome,
      'sections': instance.sections,
    };

_$WelcomeSectionImpl _$$WelcomeSectionImplFromJson(Map<String, dynamic> json) =>
    _$WelcomeSectionImpl(
      title: json['title'] as String,
      message: json['message'] as String,
      buttonText: json['buttonText'] as String,
    );

Map<String, dynamic> _$$WelcomeSectionImplToJson(
        _$WelcomeSectionImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'message': instance.message,
      'buttonText': instance.buttonText,
    };

_$QuestionSectionImpl _$$QuestionSectionImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionSectionImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$QuestionSectionImplToJson(
        _$QuestionSectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'questions': instance.questions,
    };

_$QuestionImpl _$$QuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuestionImpl(
      id: json['id'] as String,
      text: json['text'] as String,
      inputType: $enumDecode(_$QuestionTypeEnumMap, json['inputType']),
      options:
          (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
      required: json['required'] as bool? ?? false,
      hint: json['hint'] as String?,
      validation: json['validation'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$QuestionImplToJson(_$QuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'inputType': _$QuestionTypeEnumMap[instance.inputType]!,
      'options': instance.options,
      'required': instance.required,
      'hint': instance.hint,
      'validation': instance.validation,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.text: 'text',
  QuestionType.number: 'number',
  QuestionType.radio: 'radio',
  QuestionType.multiselect: 'multiselect',
  QuestionType.slider: 'slider',
  QuestionType.date: 'date',
};
