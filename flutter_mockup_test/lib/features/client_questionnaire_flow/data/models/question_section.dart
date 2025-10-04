import 'package:freezed_annotation/freezed_annotation.dart';
import 'question.dart';

part 'question_section.freezed.dart';
part 'question_section.g.dart';

/// Question section containing a group of related questions
@freezed
class QuestionSection with _$QuestionSection {
  const factory QuestionSection({
    required String id,
    required String title,
    String? description,
    required List<Question> questions,
    @Default('Great! Moving on to the next section.') String completionMessage,
  }) = _QuestionSection;

  factory QuestionSection.fromJson(Map<String, dynamic> json) =>
      _$QuestionSectionFromJson(json);
}

/// Extension methods for QuestionSection - Pure data access only
extension QuestionSectionExtension on QuestionSection {
  /// Gets the number of questions in this section
  int get questionCount => questions.length;

  /// Gets the number of required questions in this section
  int get requiredQuestionCount {
    return questions.where((q) => q.required).length;
  }

  /// Gets a question by its ID
  Question? getQuestionById(String questionId) {
    try {
      return questions.firstWhere((q) => q.id == questionId);
    } catch (e) {
      return null;
    }
  }

  /// Gets the index of a question by its ID
  int? getQuestionIndex(String questionId) {
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].id == questionId) {
        return i;
      }
    }
    return null;
  }
}