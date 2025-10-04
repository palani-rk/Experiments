import '../../models/section_response.dart';

/// Forward declaration for QuestionnaireState
/// This allows the service interface to reference the state without circular imports
abstract class QuestionnaireState {
  Map<String, SectionResponse> get sectionResponses;
  String? get currentQuestionId;
  int get currentSectionIndex;
  bool get isCompleted;
  bool get isSubmitted;
}

/// Service interface for persisting questionnaire responses
/// Handles local storage for state persistence and submission
abstract class ResponsePersistenceService {
  /// Save the current questionnaire state for recovery
  /// Used to persist progress across app restarts
  Future<void> saveState(QuestionnaireState state);

  /// Load previously saved questionnaire state
  /// Returns null if no saved state exists
  Future<QuestionnaireState?> loadSavedState();

  /// Clear any saved state (after successful submission)
  Future<void> clearSavedState();

  /// Submit completed responses (final submission)
  /// In testing mode: saves to local file
  /// In production mode: submits to backend API
  Future<void> submitResponses(Map<String, SectionResponse> responses);

  /// Get all previously submitted responses (for testing/demo)
  /// Used to show submission history in testing mode
  Future<List<Map<String, SectionResponse>>> getSubmissionHistory();

  /// Export responses to different formats for testing
  /// Supports JSON export for debugging and validation
  Future<String> exportResponsesToJson(Map<String, SectionResponse> responses);
}