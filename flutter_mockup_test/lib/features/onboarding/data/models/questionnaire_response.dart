import 'package:freezed_annotation/freezed_annotation.dart';

part 'questionnaire_response.freezed.dart';
part 'questionnaire_response.g.dart';

@freezed
class QuestionnaireResponse with _$QuestionnaireResponse {
  const factory QuestionnaireResponse({
    required String questionnaireId,
    required Map<String, dynamic> answers,
    required DateTime startTime,
    DateTime? completedTime,
    @Default(QuestionnaireStatus.inProgress) QuestionnaireStatus status,
  }) = _QuestionnaireResponse;

  const QuestionnaireResponse._();

  factory QuestionnaireResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireResponseFromJson(json);

  dynamic getAnswer(String questionId) {
    return answers[questionId];
  }

  bool isQuestionAnswered(String questionId) {
    final answer = answers[questionId];
    if (answer == null) return false;
    if (answer is String) return answer.trim().isNotEmpty;
    if (answer is List) return answer.isNotEmpty;
    return true;
  }
}

@freezed
class NavigationState with _$NavigationState {
  const factory NavigationState({
    @Default(0) int currentSectionIndex,
    @Default(0) int currentQuestionIndex,
    @Default(true) bool showWelcome,
    @Default(false) bool isCompleted,
  }) = _NavigationState;
}

enum QuestionnaireStatus {
  notStarted,
  inProgress,
  completed,
  abandoned,
}