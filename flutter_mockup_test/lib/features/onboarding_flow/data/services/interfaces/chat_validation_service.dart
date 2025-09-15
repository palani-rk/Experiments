import '../../../data/models/core/chat_section.dart';
import '../../../data/models/core/enums.dart';
import '../../../data/models/core/section_message.dart';
import '../../../data/models/support/chat_state.dart';
import '../../../data/models/support/question.dart';
import '../../../data/models/support/validation_status.dart';

/// Chat Validation Service Interface
///
/// Provides comprehensive validation for answers, sections, and business rules
/// in the chat-based questionnaire system.
abstract class ChatValidationService {
  // ========================================================================
  // Answer Validation by Type
  // ========================================================================

  /// Validate text answer with optional rules
  /// Rules can include: minLength, maxLength, pattern, required
  ValidationStatus validateTextAnswer({
    required String value,
    Map<String, dynamic>? rules,
  });

  /// Validate number answer with range and type validation
  /// Rules can include: min, max, integer, decimal, required
  ValidationStatus validateNumberAnswer({
    required num value,
    Map<String, dynamic>? rules,
  });

  /// Validate email format and optional domain restrictions
  ValidationStatus validateEmailAnswer({
    required String value,
    List<String>? allowedDomains,
  });

  /// Validate phone number format for different regions
  ValidationStatus validatePhoneAnswer({
    required String value,
    String? region, // Default: US
  });

  /// Validate date with range constraints
  /// Rules can include: minDate, maxDate, format, required
  ValidationStatus validateDateAnswer({
    required DateTime value,
    Map<String, dynamic>? rules,
  });

  /// Validate selection answer (radio/multiselect)
  /// For radio: ensures single valid option
  /// For multiselect: validates all selected options and constraints
  ValidationStatus validateSelectionAnswer({
    required dynamic value,
    required List<String> options,
    required bool isMultiselect,
    Map<String, dynamic>? rules, // minSelections, maxSelections
  });

  /// Validate slider/scale answer
  /// Rules include: min, max, step, required
  ValidationStatus validateSliderAnswer({
    required num value,
    Map<String, dynamic>? rules,
  });

  /// Validate boolean answer (yes/no questions)
  ValidationStatus validateBooleanAnswer({
    required bool value,
    Map<String, dynamic>? rules,
  });

  // ========================================================================
  // Section & Questionnaire Validation
  // ========================================================================

  /// Validate entire questionnaire section
  /// Checks all answered questions and identifies missing required questions
  Future<List<ValidationStatus>> validateSection(QuestionnaireSection section);

  /// Validate complete questionnaire across all sections
  /// Performs cross-section validation and business rule checks
  Future<ValidationStatus> validateQuestionnaire(List<ChatSection> sections);

  /// Validate section completion requirements
  Future<ValidationStatus> validateSectionCompletion(String sectionId);

  // ========================================================================
  // Business Rules Validation
  // ========================================================================

  /// Validate cross-section business rules
  /// Examples:
  /// - Age vs activity level compatibility
  /// - Dietary restrictions vs goal alignment
  /// - Health conditions vs exercise recommendations
  Future<ValidationStatus> validateBusinessRules(ChatState state);

  /// Check question dependencies and conditional display rules
  /// Determines if a question should be shown based on previous answers
  ValidationStatus checkDependencies({
    required Question question,
    required List<QuestionAnswer> answers,
  });

  /// Validate answer consistency within and across sections
  /// Checks for contradictory answers or impossible combinations
  Future<ValidationStatus> validateAnswerConsistency({
    required String questionId,
    required dynamic answer,
    required ChatState currentState,
  });

  // ========================================================================
  // Real-time Validation
  // ========================================================================

  /// Validate answer as user types (real-time validation)
  ValidationStatus validateAnswerRealtime({
    required String questionId,
    required dynamic partialAnswer,
    required QuestionType questionType,
    Map<String, dynamic>? rules,
  });

  /// Get validation hints for better user experience
  /// Returns suggestions or guidance for proper answer format
  List<String> getValidationHints({
    required QuestionType questionType,
    Map<String, dynamic>? rules,
  });

  /// Check if answer format is correct (without business rule validation)
  bool isAnswerFormatValid({
    required dynamic answer,
    required QuestionType questionType,
  });

  // ========================================================================
  // Custom Validation Rules
  // ========================================================================

  /// Register custom validation rule
  void registerCustomValidator({
    required String ruleName,
    required ValidationStatus Function(dynamic value, Map<String, dynamic>? params) validator,
  });

  /// Apply custom validation rule
  ValidationStatus applyCustomValidation({
    required String ruleName,
    required dynamic value,
    Map<String, dynamic>? params,
  });

  /// Get available custom validation rules
  List<String> getAvailableCustomRules();

  // ========================================================================
  // Validation Utilities
  // ========================================================================

  /// Combine multiple validation results into a single result
  ValidationStatus combineValidationResults(List<ValidationStatus> results);

  /// Check if validation status indicates blocking error
  bool isBlockingError(ValidationStatus status);

  /// Get user-friendly error message for validation failure
  String getUserFriendlyErrorMessage(ValidationStatus status);

  /// Generate validation summary for a section
  Future<Map<String, dynamic>> getValidationSummary(String sectionId);

  /// Validate answer against question rules and business logic
  Future<ValidationStatus> validateAnswer({
    required String questionId,
    required dynamic answer,
  });
}