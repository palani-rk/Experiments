// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BotMessageImpl _$$BotMessageImplFromJson(Map<String, dynamic> json) =>
    _$BotMessageImpl(
      id: json['id'] as String,
      sectionId: json['sectionId'] as String,
      content: json['content'] as String,
      messageType: $enumDecode(_$MessageTypeEnumMap, json['messageType']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isEditable: json['isEditable'] as bool? ?? false,
      order: (json['order'] as num?)?.toInt() ?? 0,
      context: json['context'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$BotMessageImplToJson(_$BotMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sectionId': instance.sectionId,
      'content': instance.content,
      'messageType': _$MessageTypeEnumMap[instance.messageType]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'isEditable': instance.isEditable,
      'order': instance.order,
      'context': instance.context,
      'metadata': instance.metadata,
      'runtimeType': instance.$type,
    };

const _$MessageTypeEnumMap = {
  MessageType.botIntro: 'botIntro',
  MessageType.botQuestion: 'botQuestion',
  MessageType.userAnswer: 'userAnswer',
  MessageType.botWrapup: 'botWrapup',
  MessageType.mediaContent: 'mediaContent',
  MessageType.systemNotification: 'systemNotification',
};

_$QuestionAnswerImpl _$$QuestionAnswerImplFromJson(Map<String, dynamic> json) =>
    _$QuestionAnswerImpl(
      id: json['id'] as String,
      sectionId: json['sectionId'] as String,
      questionId: json['questionId'] as String,
      questionText: json['questionText'] as String,
      inputType: $enumDecode(_$QuestionTypeEnumMap, json['inputType']),
      answer: json['answer'],
      timestamp: DateTime.parse(json['timestamp'] as String),
      messageType:
          $enumDecodeNullable(_$MessageTypeEnumMap, json['messageType']) ??
              MessageType.userAnswer,
      isEditable: json['isEditable'] as bool? ?? true,
      isComplete: json['isComplete'] as bool? ?? false,
      order: (json['order'] as num?)?.toInt() ?? 0,
      formattedAnswer: json['formattedAnswer'] as String?,
      validation: json['validation'] == null
          ? null
          : ValidationStatus.fromJson(
              json['validation'] as Map<String, dynamic>),
      questionMetadata: json['questionMetadata'] as Map<String, dynamic>?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$QuestionAnswerImplToJson(
        _$QuestionAnswerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sectionId': instance.sectionId,
      'questionId': instance.questionId,
      'questionText': instance.questionText,
      'inputType': _$QuestionTypeEnumMap[instance.inputType]!,
      'answer': instance.answer,
      'timestamp': instance.timestamp.toIso8601String(),
      'messageType': _$MessageTypeEnumMap[instance.messageType]!,
      'isEditable': instance.isEditable,
      'isComplete': instance.isComplete,
      'order': instance.order,
      'formattedAnswer': instance.formattedAnswer,
      'validation': instance.validation,
      'questionMetadata': instance.questionMetadata,
      'runtimeType': instance.$type,
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
