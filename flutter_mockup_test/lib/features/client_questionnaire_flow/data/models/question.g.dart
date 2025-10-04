// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ValidationRulesImpl _$$ValidationRulesImplFromJson(
        Map<String, dynamic> json) =>
    _$ValidationRulesImpl(
      minLength: (json['minLength'] as num?)?.toInt(),
      maxLength: (json['maxLength'] as num?)?.toInt(),
      minValue: json['minValue'] as num?,
      maxValue: json['maxValue'] as num?,
      pattern: json['pattern'] as String?,
      required: json['required'] as bool?,
    );

Map<String, dynamic> _$$ValidationRulesImplToJson(
        _$ValidationRulesImpl instance) =>
    <String, dynamic>{
      'minLength': instance.minLength,
      'maxLength': instance.maxLength,
      'minValue': instance.minValue,
      'maxValue': instance.maxValue,
      'pattern': instance.pattern,
      'required': instance.required,
    };

_$QuestionImpl _$$QuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuestionImpl(
      id: json['id'] as String,
      sectionId: json['sectionId'] as String,
      questionText: json['questionText'] as String,
      inputType: $enumDecode(_$QuestionTypeEnumMap, json['inputType']),
      required: json['required'] as bool? ?? true,
      options:
          (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
      validation: json['validation'] == null
          ? null
          : ValidationRules.fromJson(
              json['validation'] as Map<String, dynamic>),
      placeholder: json['placeholder'] as String?,
    );

Map<String, dynamic> _$$QuestionImplToJson(_$QuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sectionId': instance.sectionId,
      'questionText': instance.questionText,
      'inputType': _$QuestionTypeEnumMap[instance.inputType]!,
      'required': instance.required,
      'options': instance.options,
      'validation': instance.validation,
      'placeholder': instance.placeholder,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.textInput: 'text_input',
  QuestionType.numberInput: 'number_input',
  QuestionType.singleSelect: 'single_select',
  QuestionType.multiSelect: 'multi_select',
  QuestionType.textArea: 'text_area',
};
