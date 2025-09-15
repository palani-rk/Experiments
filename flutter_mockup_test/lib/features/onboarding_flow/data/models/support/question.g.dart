// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionImpl _$$QuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuestionImpl(
      id: json['id'] as String,
      sectionId: json['sectionId'] as String,
      text: json['text'] as String,
      inputType: $enumDecode(_$QuestionTypeEnumMap, json['inputType']),
      required: json['required'] as bool? ?? false,
      hint: json['hint'] as String?,
      placeholder: json['placeholder'] as String?,
      options:
          (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
      validation: json['validation'] as Map<String, dynamic>?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$QuestionImplToJson(_$QuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sectionId': instance.sectionId,
      'text': instance.text,
      'inputType': _$QuestionTypeEnumMap[instance.inputType]!,
      'required': instance.required,
      'hint': instance.hint,
      'placeholder': instance.placeholder,
      'options': instance.options,
      'validation': instance.validation,
      'metadata': instance.metadata,
      'order': instance.order,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.text: 'text',
  QuestionType.number: 'number',
  QuestionType.email: 'email',
  QuestionType.phone: 'phone',
  QuestionType.date: 'date',
  QuestionType.radio: 'radio',
  QuestionType.multiselect: 'multiselect',
  QuestionType.slider: 'slider',
  QuestionType.scale: 'scale',
  QuestionType.boolean: 'boolean',
};
