// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProgressDetailsImpl _$$ProgressDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$ProgressDetailsImpl(
      totalSections: (json['totalSections'] as num).toInt(),
      completedSections: (json['completedSections'] as num).toInt(),
      totalMessages: (json['totalMessages'] as num).toInt(),
      completedMessages: (json['completedMessages'] as num).toInt(),
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      answeredQuestions: (json['answeredQuestions'] as num).toInt(),
      overallProgress: (json['overallProgress'] as num).toDouble(),
      currentSectionProgress:
          (json['currentSectionProgress'] as num).toDouble(),
      currentSectionId: json['currentSectionId'] as String,
      currentMessageId: json['currentMessageId'] as String,
      isComplete: json['isComplete'] as bool? ?? false,
    );

Map<String, dynamic> _$$ProgressDetailsImplToJson(
        _$ProgressDetailsImpl instance) =>
    <String, dynamic>{
      'totalSections': instance.totalSections,
      'completedSections': instance.completedSections,
      'totalMessages': instance.totalMessages,
      'completedMessages': instance.completedMessages,
      'totalQuestions': instance.totalQuestions,
      'answeredQuestions': instance.answeredQuestions,
      'overallProgress': instance.overallProgress,
      'currentSectionProgress': instance.currentSectionProgress,
      'currentSectionId': instance.currentSectionId,
      'currentMessageId': instance.currentMessageId,
      'isComplete': instance.isComplete,
    };
