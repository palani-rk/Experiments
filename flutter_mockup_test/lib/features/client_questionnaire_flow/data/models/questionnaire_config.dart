import 'package:freezed_annotation/freezed_annotation.dart';
import 'question_section.dart';

part 'questionnaire_config.freezed.dart';
part 'questionnaire_config.g.dart';

/// Complete questionnaire configuration
@freezed
class QuestionnaireConfig with _$QuestionnaireConfig {
  const factory QuestionnaireConfig({
    required String id,
    required String title,
    required List<QuestionSection> sections,
  }) = _QuestionnaireConfig;

  factory QuestionnaireConfig.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireConfigFromJson(json);
}

/// Extension methods for QuestionnaireConfig - Pure data access only
extension QuestionnaireConfigExtension on QuestionnaireConfig {
  /// Gets the number of sections
  int get sectionCount => sections.length;

  /// Gets the total number of questions across all sections
  int get totalQuestionCount {
    return sections.fold(0, (total, section) => total + section.questionCount);
  }

  /// Gets the total number of required questions across all sections
  int get totalRequiredQuestionCount {
    return sections.fold(0, (total, section) => total + section.requiredQuestionCount);
  }

  /// Gets a section by its ID
  QuestionSection? getSectionById(String sectionId) {
    try {
      return sections.firstWhere((s) => s.id == sectionId);
    } catch (e) {
      return null;
    }
  }

  /// Gets the index of a section by its ID
  int? getSectionIndex(String sectionId) {
    for (int i = 0; i < sections.length; i++) {
      if (sections[i].id == sectionId) {
        return i;
      }
    }
    return null;
  }
}