import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/questionnaire_config.dart';
import '../../data/models/question.dart';
import '../../data/models/question_section.dart';
import '../../data/models/response.dart';
import '../../data/models/section_response.dart';
import '../../data/models/branding_config.dart';
import '../../data/models/enums.dart';
import '../../data/services/interfaces/questionnaire_config_service.dart';
import '../../data/services/interfaces/response_persistence_service.dart' as service;
import '../../data/services/implementations/questionnaire_config_service_impl.dart';
import '../../data/services/implementations/response_persistence_service_impl.dart';

part 'questionnaire_providers.freezed.dart';
part 'questionnaire_providers.g.dart';

/// Questionnaire state for managing the complete questionnaire flow
@freezed
class QuestionnaireState with _$QuestionnaireState {
  const factory QuestionnaireState({
    QuestionnaireConfig? config,
    @Default({}) Map<String, SectionResponse> sectionResponses,
    String? currentQuestionId,
    @Default(0) int currentSectionIndex,
    @Default(false) bool isCompleted,
    @Default(false) bool isSubmitted,
    @Default(false) bool isLoading,
    String? error,
  }) = _QuestionnaireState;
}

/// Service providers
@riverpod
QuestionnaireConfigService questionnaireConfigService(Ref ref) {
  return QuestionnaireConfigServiceImpl();
}

@riverpod
service.ResponsePersistenceService responsePersistenceService(Ref ref) {
  return ResponsePersistenceServiceImpl();
}

/// Main questionnaire state notifier
@riverpod
class QuestionnaireNotifier extends _$QuestionnaireNotifier {
  @override
  Future<QuestionnaireState> build() async {
    // Load saved state if exists
    final savedState = await _loadSavedState();
    if (savedState != null) {
      return savedState;
    }

    // Load questionnaire config
    try {
      final config = await ref.read(questionnaireConfigServiceProvider).loadQuestionnaireConfig();
      return QuestionnaireState(
        config: config,
        currentQuestionId: _getFirstQuestion(config)?.id,
      );
    } catch (error) {
      return QuestionnaireState(
        error: 'Failed to load questionnaire: $error',
      );
    }
  }

  /// Answer a question and advance to next
  Future<void> answerQuestion(String questionId, dynamic answer) async {
    final currentState = state.value;
    if (currentState == null || currentState.config == null) return;

    try {
      state = AsyncValue.data(currentState.copyWith(isLoading: true));

      // Find the question and section
      final question = _findQuestion(currentState.config!, questionId);
      if (question == null) return;

      // Create or update response
      final response = Response(
        questionId: questionId,
        value: answer,
        timestamp: DateTime.now(),
      );

      // Update section response
      final updatedSectionResponses = Map<String, SectionResponse>.from(currentState.sectionResponses);
      final sectionResponse = updatedSectionResponses[question.sectionId] ??
        SectionResponse(
          sectionId: question.sectionId,
          responses: [],
          status: SectionStatus.inProgress,
          savedAt: DateTime.now(),
        );

      // Update or add response
      final updatedResponses = List<Response>.from(sectionResponse.responses);
      final existingIndex = updatedResponses.indexWhere((r) => r.questionId == questionId);
      if (existingIndex >= 0) {
        updatedResponses[existingIndex] = response;
      } else {
        updatedResponses.add(response);
      }

      // Update section response
      updatedSectionResponses[question.sectionId] = sectionResponse.copyWith(
        responses: updatedResponses,
        savedAt: DateTime.now(),
      );

      // Calculate next question
      final nextQuestion = _calculateNextQuestion(currentState.config!, questionId, updatedSectionResponses);
      final isCompleted = nextQuestion == null;

      // Check if section is completed
      final currentSection = currentState.config!.getSectionById(question.sectionId);
      if (currentSection != null && _isSectionCompleted(currentSection, updatedSectionResponses[question.sectionId]!)) {
        updatedSectionResponses[question.sectionId] = updatedSectionResponses[question.sectionId]!.copyWith(
          status: SectionStatus.completed,
          completedAt: DateTime.now(),
        );
      }

      final updatedState = currentState.copyWith(
        sectionResponses: updatedSectionResponses,
        currentQuestionId: nextQuestion?.id,
        currentSectionIndex: nextQuestion?.sectionId != null
          ? (currentState.config!.getSectionIndex(nextQuestion!.sectionId) ?? currentState.currentSectionIndex)
          : currentState.currentSectionIndex,
        isCompleted: isCompleted,
        isLoading: false,
      );

      state = AsyncValue.data(updatedState);

      // Persist state
      await _saveState(updatedState);

    } catch (error) {
      state = AsyncValue.data(currentState.copyWith(
        isLoading: false,
        error: 'Failed to save answer: $error',
      ));
    }
  }

  /// Edit an existing response
  Future<void> editResponse(String questionId, dynamic newAnswer) async {
    final currentState = state.value;
    if (currentState == null || currentState.config == null) return;

    try {
      state = AsyncValue.data(currentState.copyWith(isLoading: true));

      // Find the question and section
      final question = _findQuestion(currentState.config!, questionId);
      if (question == null) return;

      // Update the specific response
      final updatedSectionResponses = Map<String, SectionResponse>.from(currentState.sectionResponses);
      final sectionResponse = updatedSectionResponses[question.sectionId];
      if (sectionResponse == null) return;

      final updatedResponses = sectionResponse.responses.map((response) {
        if (response.questionId == questionId) {
          return response.copyWith(
            value: newAnswer,
            timestamp: DateTime.now(),
          );
        }
        return response;
      }).toList();

      updatedSectionResponses[question.sectionId] = sectionResponse.copyWith(
        responses: updatedResponses,
        savedAt: DateTime.now(),
      );

      final updatedState = currentState.copyWith(
        sectionResponses: updatedSectionResponses,
        isLoading: false,
      );

      state = AsyncValue.data(updatedState);

      // Persist state
      await _saveState(updatedState);

    } catch (error) {
      state = AsyncValue.data(currentState.copyWith(
        isLoading: false,
        error: 'Failed to edit response: $error',
      ));
    }
  }

  /// Submit the completed questionnaire
  Future<void> submitQuestionnaire() async {
    final currentState = state.value;
    if (currentState == null || !currentState.isCompleted) return;

    try {
      state = AsyncValue.data(currentState.copyWith(isLoading: true));

      // Submit to persistence service (in real app, this would submit to backend)
      await ref.read(responsePersistenceServiceProvider).submitResponses(currentState.sectionResponses);

      // Clear saved state after successful submission
      await _clearSavedState();

      state = AsyncValue.data(currentState.copyWith(
        isSubmitted: true,
        isLoading: false,
      ));

    } catch (error) {
      state = AsyncValue.data(currentState.copyWith(
        isLoading: false,
        error: 'Failed to submit questionnaire: $error',
      ));
    }
  }

  /// Navigate to a specific section (for progress indicator navigation)
  Future<void> navigateToSection(int sectionIndex) async {
    final currentState = state.value;
    if (currentState == null || currentState.config == null) return;

    if (sectionIndex < 0 || sectionIndex >= currentState.config!.sections.length) return;

    final section = currentState.config!.sections[sectionIndex];
    final firstQuestionInSection = section.questions.isNotEmpty ? section.questions.first : null;

    if (firstQuestionInSection != null) {
      state = AsyncValue.data(currentState.copyWith(
        currentSectionIndex: sectionIndex,
        currentQuestionId: firstQuestionInSection.id,
      ));

      await _saveState(state.value!);
    }
  }

  /// Navigate to a specific question (for edit mode)
  Future<void> navigateToQuestion(String questionId) async {
    final currentState = state.value;
    if (currentState == null || currentState.config == null) return;

    // Find the question and its section
    final question = _findQuestion(currentState.config!, questionId);
    if (question == null) return;

    final sectionIndex = currentState.config!.getSectionIndex(question.sectionId);
    if (sectionIndex == null) return;

    state = AsyncValue.data(currentState.copyWith(
      currentQuestionId: questionId,
      currentSectionIndex: sectionIndex,
    ));

    await _saveState(state.value!);
  }

  /// Reset questionnaire to start over
  Future<void> resetQuestionnaire() async {
    await _clearSavedState();
    ref.invalidateSelf();
  }

  // Private helper methods
  Question? _findQuestion(QuestionnaireConfig config, String questionId) {
    for (final section in config.sections) {
      for (final question in section.questions) {
        if (question.id == questionId) {
          return question;
        }
      }
    }
    return null;
  }

  Question? _getFirstQuestion(QuestionnaireConfig config) {
    if (config.sections.isNotEmpty && config.sections.first.questions.isNotEmpty) {
      return config.sections.first.questions.first;
    }
    return null;
  }

  Question? _calculateNextQuestion(QuestionnaireConfig config, String currentQuestionId, Map<String, SectionResponse> responses) {
    // Find current question
    Question? currentQuestion;
    int currentSectionIndex = -1;
    int currentQuestionIndex = -1;

    for (int sectionIndex = 0; sectionIndex < config.sections.length; sectionIndex++) {
      final section = config.sections[sectionIndex];
      for (int questionIndex = 0; questionIndex < section.questions.length; questionIndex++) {
        if (section.questions[questionIndex].id == currentQuestionId) {
          currentQuestion = section.questions[questionIndex];
          currentSectionIndex = sectionIndex;
          currentQuestionIndex = questionIndex;
          break;
        }
      }
      if (currentQuestion != null) break;
    }

    if (currentQuestion == null) return null;

    // Look for next question in current section
    final currentSection = config.sections[currentSectionIndex];
    if (currentQuestionIndex + 1 < currentSection.questions.length) {
      final nextQuestion = currentSection.questions[currentQuestionIndex + 1];
      if (_shouldShowQuestion(nextQuestion, responses)) {
        return nextQuestion;
      }
    }

    // Look for first question in next section
    if (currentSectionIndex + 1 < config.sections.length) {
      final nextSection = config.sections[currentSectionIndex + 1];
      if (nextSection.questions.isNotEmpty) {
        final firstQuestionInNextSection = nextSection.questions.first;
        if (_shouldShowQuestion(firstQuestionInNextSection, responses)) {
          return firstQuestionInNextSection;
        }
      }
    }

    return null; // No more questions
  }

  bool _shouldShowQuestion(Question question, Map<String, SectionResponse> responses) {
    // For now, show all questions since conditional logic is not implemented yet
    return true;
  }

  bool _isSectionCompleted(QuestionSection section, SectionResponse sectionResponse) {
    final requiredQuestions = section.questions.where((q) => q.required).toList();
    final answeredQuestionIds = sectionResponse.responses.map((r) => r.questionId).toSet();

    return requiredQuestions.every((q) => answeredQuestionIds.contains(q.id));
  }

  Future<QuestionnaireState?> _loadSavedState() async {
    try {
      final savedState = await ref.read(responsePersistenceServiceProvider).loadSavedState();
      if (savedState == null) return null;

      // Load config to attach to resumed state
      QuestionnaireConfig? config;
      try {
        config = await ref.read(questionnaireConfigServiceProvider).loadQuestionnaireConfig();
      } catch (e) {
        // If config fails to load, we can't resume properly
        return null;
      }

      // Convert from service state to provider state with config attached
      return QuestionnaireState(
        config: config,
        sectionResponses: savedState.sectionResponses,
        currentQuestionId: savedState.currentQuestionId,
        currentSectionIndex: savedState.currentSectionIndex,
        isCompleted: savedState.isCompleted,
        isSubmitted: savedState.isSubmitted,
      );
    } catch (error) {
      return null;
    }
  }

  Future<void> _saveState(QuestionnaireState state) async {
    try {
      // Convert our QuestionnaireState to the service interface format
      final serviceState = _QuestionnaireStateAdapter(state);
      await ref.read(responsePersistenceServiceProvider).saveState(serviceState);
    } catch (error) {
      // Log error but don't throw - saving is not critical for core functionality
    }
  }

  Future<void> _clearSavedState() async {
    try {
      await ref.read(responsePersistenceServiceProvider).clearSavedState();
    } catch (error) {
      // Log error but don't throw
    }
  }
}

/// Derived providers for UI consumption
@riverpod
Question? currentQuestion(Ref ref) {
  final questionnaireState = ref.watch(questionnaireNotifierProvider).value;
  if (questionnaireState?.currentQuestionId == null || questionnaireState?.config == null) {
    return null;
  }

  final config = questionnaireState!.config!;
  final questionId = questionnaireState.currentQuestionId!;

  for (final section in config.sections) {
    for (final question in section.questions) {
      if (question.id == questionId) {
        return question;
      }
    }
  }
  return null;
}

@riverpod
Map<String, SectionResponse> allResponses(Ref ref) {
  return ref.watch(questionnaireNotifierProvider).value?.sectionResponses ?? {};
}

@riverpod
SectionResponse? currentSectionResponse(Ref ref) {
  final state = ref.watch(questionnaireNotifierProvider).value;
  final currentQuestion = ref.watch(currentQuestionProvider);

  if (state == null || currentQuestion == null) return null;

  return state.sectionResponses[currentQuestion.sectionId];
}

@riverpod
ProgressInfo progressInfo(Ref ref) {
  final state = ref.watch(questionnaireNotifierProvider).value;
  if (state?.config == null) {
    return const ProgressInfo(
      currentSection: 0,
      totalSections: 4,
      overallProgress: 0.0,
      sectionProgress: 0.0,
    );
  }

  final config = state!.config!;
  final totalQuestions = config.totalQuestionCount;
  final answeredQuestions = state.sectionResponses.values
      .expand((sr) => sr.responses)
      .length;

  final overallProgress = totalQuestions > 0 ? answeredQuestions / totalQuestions : 0.0;

  // Calculate current section progress
  double sectionProgress = 0.0;
  if (state.currentSectionIndex < config.sections.length) {
    final currentSection = config.sections[state.currentSectionIndex];
    final currentSectionResponse = state.sectionResponses[currentSection.id];
    if (currentSectionResponse != null) {
      final sectionQuestionCount = currentSection.questionCount;
      final sectionAnsweredCount = currentSectionResponse.responses.length;
      sectionProgress = sectionQuestionCount > 0 ? sectionAnsweredCount / sectionQuestionCount : 0.0;
    }
  }

  return ProgressInfo(
    currentSection: state.currentSectionIndex,
    totalSections: config.sectionCount,
    overallProgress: overallProgress,
    sectionProgress: sectionProgress,
  );
}

@riverpod
BrandingConfig brandingConfig(Ref ref) {
  // In a real app, this would be loaded from config or backend
  return const BrandingConfig(
    title: 'NutriWell Clinic',
    subtitle: 'Your Nutrition Partner',
    logoUrl: '',
    nutritionistName: 'Dr. Sarah Johnson',
    primaryColor: '#2196F3',
    secondaryColor: '#4CAF50',
  );
}

/// Progress info model for UI
@freezed
class ProgressInfo with _$ProgressInfo {
  const factory ProgressInfo({
    required int currentSection,
    required int totalSections,
    required double overallProgress,
    required double sectionProgress,
  }) = _ProgressInfo;
}

/// Adapter to convert our QuestionnaireState to the service interface format
class _QuestionnaireStateAdapter implements service.QuestionnaireState {
  final QuestionnaireState _state;

  _QuestionnaireStateAdapter(this._state);

  @override
  Map<String, SectionResponse> get sectionResponses => _state.sectionResponses;

  @override
  String? get currentQuestionId => _state.currentQuestionId;

  @override
  int get currentSectionIndex => _state.currentSectionIndex;

  @override
  bool get isCompleted => _state.isCompleted;

  @override
  bool get isSubmitted => _state.isSubmitted;
}