// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompletedResponseImpl _$$CompletedResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CompletedResponseImpl(
      questionId: json['questionId'] as String,
      questionText: json['questionText'] as String,
      answer: json['answer'],
      sectionId: json['sectionId'] as String,
      sectionTitle: json['sectionTitle'] as String,
      answeredAt: DateTime.parse(json['answeredAt'] as String),
      isEditable: json['isEditable'] as bool? ?? true,
      validationError: json['validationError'] as String?,
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$CompletedResponseImplToJson(
        _$CompletedResponseImpl instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'questionText': instance.questionText,
      'answer': instance.answer,
      'sectionId': instance.sectionId,
      'sectionTitle': instance.sectionTitle,
      'answeredAt': instance.answeredAt.toIso8601String(),
      'isEditable': instance.isEditable,
      'validationError': instance.validationError,
      'confidenceScore': instance.confidenceScore,
    };

_$ResponseGroupImpl _$$ResponseGroupImplFromJson(Map<String, dynamic> json) =>
    _$ResponseGroupImpl(
      sectionId: json['sectionId'] as String,
      sectionTitle: json['sectionTitle'] as String,
      responses: (json['responses'] as List<dynamic>)
          .map((e) => CompletedResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      isExpanded: json['isExpanded'] as bool? ?? false,
      totalQuestions: (json['totalQuestions'] as num?)?.toInt(),
      sectionDescription: json['sectionDescription'] as String?,
      orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ResponseGroupImplToJson(_$ResponseGroupImpl instance) =>
    <String, dynamic>{
      'sectionId': instance.sectionId,
      'sectionTitle': instance.sectionTitle,
      'responses': instance.responses,
      'isExpanded': instance.isExpanded,
      'totalQuestions': instance.totalQuestions,
      'sectionDescription': instance.sectionDescription,
      'orderIndex': instance.orderIndex,
    };

_$OverallProgressImpl _$$OverallProgressImplFromJson(
        Map<String, dynamic> json) =>
    _$OverallProgressImpl(
      groups: (json['groups'] as List<dynamic>)
          .map((e) => ResponseGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentSectionIndex: (json['currentSectionIndex'] as num?)?.toInt() ?? 0,
      currentQuestionIndex:
          (json['currentQuestionIndex'] as num?)?.toInt() ?? 0,
      totalQuestions: (json['totalQuestions'] as num?)?.toInt(),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$OverallProgressImplToJson(
        _$OverallProgressImpl instance) =>
    <String, dynamic>{
      'groups': instance.groups,
      'currentSectionIndex': instance.currentSectionIndex,
      'currentQuestionIndex': instance.currentQuestionIndex,
      'totalQuestions': instance.totalQuestions,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };
