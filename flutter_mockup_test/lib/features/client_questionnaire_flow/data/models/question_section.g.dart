// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionSectionImpl _$$QuestionSectionImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionSectionImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
      completionMessage: json['completionMessage'] as String? ??
          'Great! Moving on to the next section.',
    );

Map<String, dynamic> _$$QuestionSectionImplToJson(
        _$QuestionSectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'questions': instance.questions,
      'completionMessage': instance.completionMessage,
    };
