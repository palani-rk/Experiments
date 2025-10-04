import 'package:freezed_annotation/freezed_annotation.dart';
import 'section_response.dart';
import 'enums.dart';

part 'questionnaire_responses_submission.freezed.dart';
part 'questionnaire_responses_submission.g.dart';

/// Complete questionnaire responses submission
@freezed
class QuestionnaireResponsesSubmission with _$QuestionnaireResponsesSubmission {
  const factory QuestionnaireResponsesSubmission({
    required String questionnaireId,
    required String userId,
    required List<SectionResponse> sectionResponses,
    DateTime? submittedAt,
    @Default(false) bool isComplete,
  }) = _QuestionnaireResponsesSubmission;

  factory QuestionnaireResponsesSubmission.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireResponsesSubmissionFromJson(json);
}

/// Extension methods for QuestionnaireResponsesSubmission - Pure data access only
extension QuestionnaireResponsesSubmissionExtension on QuestionnaireResponsesSubmission {
  /// Gets the number of section responses
  int get sectionResponseCount => sectionResponses.length;

  /// Gets the total number of individual responses
  int get totalResponseCount {
    return sectionResponses.fold(0, (total, section) => total + section.responseCount);
  }

  /// Gets a section response by section ID
  SectionResponse? getSectionResponseById(String sectionId) {
    try {
      return sectionResponses.firstWhere((sr) => sr.sectionId == sectionId);
    } catch (e) {
      return null;
    }
  }

  /// Checks if a section has been completed
  bool isSectionCompleted(String sectionId) {
    final sectionResponse = getSectionResponseById(sectionId);
    return sectionResponse?.status == SectionStatus.completed;
  }
}