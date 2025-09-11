import 'package:freezed_annotation/freezed_annotation.dart';

part 'questionnaire_schema.freezed.dart';
part 'questionnaire_schema.g.dart';

@freezed
class QuestionnaireSchema with _$QuestionnaireSchema {
  const factory QuestionnaireSchema({
    required WelcomeSection welcome,
    required List<QuestionSection> sections,
  }) = _QuestionnaireSchema;

  factory QuestionnaireSchema.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireSchemaFromJson(json);
}

@freezed
class WelcomeSection with _$WelcomeSection {
  const factory WelcomeSection({
    required String title,
    required String message,
    required String buttonText,
  }) = _WelcomeSection;

  factory WelcomeSection.fromJson(Map<String, dynamic> json) =>
      _$WelcomeSectionFromJson(json);
}

@freezed
class QuestionSection with _$QuestionSection {
  const factory QuestionSection({
    required String id,
    required String title,
    required List<Question> questions,
  }) = _QuestionSection;

  factory QuestionSection.fromJson(Map<String, dynamic> json) =>
      _$QuestionSectionFromJson(json);
}

@freezed
class Question with _$Question {
  const factory Question({
    required String id,
    required String text,
    required QuestionType inputType,
    List<String>? options,
    @Default(false) bool required,
    String? hint,
    Map<String, dynamic>? validation,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}

enum QuestionType {
  @JsonValue('text')
  text,
  @JsonValue('number')
  number,
  @JsonValue('radio')
  radio,
  @JsonValue('multiselect')
  multiselect,
  @JsonValue('slider')
  slider,
  @JsonValue('date')
  date,
}