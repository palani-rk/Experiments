// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionnaireResponseImpl _$$QuestionnaireResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionnaireResponseImpl(
      questionnaireId: json['questionnaireId'] as String,
      answers: json['answers'] as Map<String, dynamic>,
      startTime: DateTime.parse(json['startTime'] as String),
      completedTime: json['completedTime'] == null
          ? null
          : DateTime.parse(json['completedTime'] as String),
      status:
          $enumDecodeNullable(_$QuestionnaireStatusEnumMap, json['status']) ??
              QuestionnaireStatus.inProgress,
    );

Map<String, dynamic> _$$QuestionnaireResponseImplToJson(
        _$QuestionnaireResponseImpl instance) =>
    <String, dynamic>{
      'questionnaireId': instance.questionnaireId,
      'answers': instance.answers,
      'startTime': instance.startTime.toIso8601String(),
      'completedTime': instance.completedTime?.toIso8601String(),
      'status': _$QuestionnaireStatusEnumMap[instance.status]!,
    };

const _$QuestionnaireStatusEnumMap = {
  QuestionnaireStatus.notStarted: 'notStarted',
  QuestionnaireStatus.inProgress: 'inProgress',
  QuestionnaireStatus.completed: 'completed',
  QuestionnaireStatus.abandoned: 'abandoned',
};
