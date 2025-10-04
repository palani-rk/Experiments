import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/questionnaire_config.dart';
import '../../data/services/implementations/response_persistence_service_impl.dart';
import 'questionnaire_providers.dart';

part 'resume_providers.freezed.dart';
part 'resume_providers.g.dart';

/// Resume state containing information about saved questionnaire progress
@freezed
class ResumeState with _$ResumeState {
  const factory ResumeState({
    required bool hasExistingData,
    int? savedSectionIndex,
    String? savedQuestionId,
    DateTime? lastSavedAt,
    @Default(0) int answeredQuestionsCount,
    @Default(0) int totalQuestionsCount,
    @Default(0.0) double progressPercentage,
    String? currentSectionTitle,
    bool? isCompleted,
  }) = _ResumeState;

  const ResumeState._();

  /// Get a human-readable progress message
  String get progressMessage {
    if (isCompleted == true) {
      return 'Questionnaire completed - Ready to review';
    }
    if (answeredQuestionsCount == 0) {
      return 'No progress yet';
    }
    return '$answeredQuestionsCount of $totalQuestionsCount questions answered';
  }

  /// Get section progress message
  String get sectionMessage {
    if (currentSectionTitle != null) {
      return 'On: $currentSectionTitle';
    }
    return '';
  }
}

/// Provider to check for existing saved state and calculate resume information
@riverpod
Future<ResumeState> resumeState(Ref ref) async {
  try {
    // Load saved state from persistence service
    final persistenceService = ref.read(responsePersistenceServiceProvider);
    final savedState = await persistenceService.loadSavedState();

    if (savedState == null) {
      return const ResumeState(hasExistingData: false);
    }

    // Load questionnaire config to get total question count and section info
    final configService = ref.read(questionnaireConfigServiceProvider);
    QuestionnaireConfig? config;

    try {
      config = await configService.loadQuestionnaireConfig();
    } catch (e) {
      // If config fails to load, return basic resume state without config details
      return ResumeState(
        hasExistingData: true,
        savedSectionIndex: savedState.currentSectionIndex,
        savedQuestionId: savedState.currentQuestionId,
        answeredQuestionsCount: savedState.sectionResponses.values
            .expand((sr) => sr.responses)
            .length,
        isCompleted: savedState.isCompleted,
      );
    }

    // Calculate total questions
    final totalQuestions = config.totalQuestionCount;

    // Calculate answered questions
    final answeredQuestions = savedState.sectionResponses.values
        .expand((sr) => sr.responses)
        .length;

    // Calculate progress percentage
    final progress = totalQuestions > 0 ? answeredQuestions / totalQuestions : 0.0;

    // Get current section title
    String? currentSectionTitle;
    if (savedState.currentSectionIndex < config.sections.length) {
      currentSectionTitle = config.sections[savedState.currentSectionIndex].title;
    }

    // Get last saved timestamp from metadata (if available)
    DateTime? lastSaved;
    if (savedState is SimpleQuestionnaireState) {
      // Try to get from first section response's savedAt
      final firstResponse = savedState.sectionResponses.values.firstOrNull;
      lastSaved = firstResponse?.savedAt;
    }

    return ResumeState(
      hasExistingData: true,
      savedSectionIndex: savedState.currentSectionIndex,
      savedQuestionId: savedState.currentQuestionId,
      lastSavedAt: lastSaved,
      answeredQuestionsCount: answeredQuestions,
      totalQuestionsCount: totalQuestions,
      progressPercentage: progress,
      currentSectionTitle: currentSectionTitle,
      isCompleted: savedState.isCompleted,
    );
  } catch (e) {
    // On any error, treat as no saved data
    return const ResumeState(hasExistingData: false);
  }
}
