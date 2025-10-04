import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'section_message.dart';
import '../support/question.dart';

part 'chat_section.freezed.dart';
part 'chat_section.g.dart';

/// Sealed class for all chat section types
///
/// This sealed class represents all possible section types in the
/// chat-based questionnaire system using union types.
@freezed
sealed class ChatSection with _$ChatSection {
  /// Introduction section with welcome messages
  const factory ChatSection.intro({
    required String id,
    required String title,
    required List<BotMessage> welcomeMessages,
    @Default(SectionType.intro) SectionType sectionType,
    @Default(SectionStatus.completed) SectionStatus status,
    @Default(0) int order,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = IntroSection;

  /// Questionnaire section with questions and answers
  const factory ChatSection.questionnaire({
    required String id,
    required String title,
    required String description,
    required List<Question> questions,
    @Default([]) List<SectionMessage> messages,
    @Default(SectionType.questionnaire) SectionType sectionType,
    @Default(SectionStatus.pending) SectionStatus status,
    @Default(0) int order,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = QuestionnaireSection;

  factory ChatSection.fromJson(Map<String, dynamic> json) =>
      _$ChatSectionFromJson(json);
}

/// Extension for ChatSection business logic
extension ChatSectionExtension on ChatSection {
  /// Whether this section has been completed
  bool get isComplete => switch (this) {
    IntroSection() => true, // Intro sections are always complete
    QuestionnaireSection(:final questions, :final messages) =>
      questions.every((q) => _hasAnswer(q.id, messages)),
  };

  /// Whether we can proceed from this section to the next
  bool get canProceed => switch (this) {
    IntroSection() => true,
    QuestionnaireSection(:final questions, :final messages) =>
      questions
          .where((q) => q.required == true)
          .every((q) => _hasAnswer(q.id, messages)),
  };

  /// Completion progress as a percentage (0.0 to 1.0)
  double get completionProgress => switch (this) {
    IntroSection() => 1.0,
    QuestionnaireSection(:final questions, :final messages) =>
      questions.isEmpty ? 1.0 : _getAnsweredQuestions(messages).length / questions.length,
  };

  /// Get all messages in this section
  List<SectionMessage> get allMessages => switch (this) {
    IntroSection(:final welcomeMessages) => welcomeMessages.cast<SectionMessage>(),
    QuestionnaireSection(:final messages) => messages,
  };

  /// Total number of questions (for QuestionnaireSection)
  int get totalQuestions => switch (this) {
    QuestionnaireSection(:final questions) => questions.length,
    _ => 0,
  };

  /// Number of answered questions (for QuestionnaireSection)
  int get answeredCount => switch (this) {
    QuestionnaireSection(:final messages) => _getAnsweredQuestions(messages).length,
    _ => 0,
  };

  /// Get answered questions (for QuestionnaireSection)
  List<QuestionAnswer> get answeredQuestions => switch (this) {
    QuestionnaireSection(:final messages) => _getAnsweredQuestions(messages),
    _ => [],
  };

  /// Helper to check if a question has an answer
  bool _hasAnswer(String questionId, List<SectionMessage> messages) {
    return messages.any((msg) =>
        msg is QuestionAnswer && msg.questionId == questionId);
  }

  /// Helper to get answered questions
  List<QuestionAnswer> _getAnsweredQuestions(List<SectionMessage> messages) {
    return messages.whereType<QuestionAnswer>().toList();
  }
}