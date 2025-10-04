// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_responses_submission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionnaireResponsesSubmissionImpl
    _$$QuestionnaireResponsesSubmissionImplFromJson(
            Map<String, dynamic> json) =>
        _$QuestionnaireResponsesSubmissionImpl(
          questionnaireId: json['questionnaireId'] as String,
          userId: json['userId'] as String,
          sectionResponses: (json['sectionResponses'] as List<dynamic>)
              .map((e) => SectionResponse.fromJson(e as Map<String, dynamic>))
              .toList(),
          submittedAt: json['submittedAt'] == null
              ? null
              : DateTime.parse(json['submittedAt'] as String),
          isComplete: json['isComplete'] as bool? ?? false,
        );

Map<String, dynamic> _$$QuestionnaireResponsesSubmissionImplToJson(
        _$QuestionnaireResponsesSubmissionImpl instance) =>
    <String, dynamic>{
      'questionnaireId': instance.questionnaireId,
      'userId': instance.userId,
      'sectionResponses': instance.sectionResponses,
      'submittedAt': instance.submittedAt?.toIso8601String(),
      'isComplete': instance.isComplete,
    };
