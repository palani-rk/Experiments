import '../../../data/models/core/chat_section.dart';
import '../../../data/models/core/enums.dart';
import '../../../data/models/core/section_message.dart';
import '../../../data/models/support/chat_state.dart';
import '../../../data/models/support/question.dart';
import '../../../data/models/support/validation_status.dart';

/// Enhanced Chat Questionnaire Service with embedded business logic
///
/// This service encapsulates all business rules and data access operations
/// for the chat-based questionnaire system, following the simplified 3-layer
/// architecture with service-embedded business logic.
abstract class ChatQuestionnaireService {
  // ========================================================================
  // Core Operations (Business Logic + Data Access)
  // ========================================================================

  /// Initializes a new questionnaire session or loads existing state
  /// Business Logic: Creates sections with intro messages, sets initial state
  Future<ChatState> initializeQuestionnaire();

  /// Submits an answer with full business rule validation
  /// Business Logic: Validates answer, saves state, checks completion, handles progression
  Future<void> submitAnswer({
    required String questionId,
    required dynamic answer,
  });

  /// Navigate directly to a specific question (for editing)
  /// Business Logic: Validates navigation permissions, updates current state
  Future<void> navigateToQuestion(String questionId);

  /// Edit an existing answer with business rule validation
  /// Business Logic: Validates edit permissions, updates answer, recalculates dependent questions
  Future<void> editAnswer({
    required String sectionId,
    required String messageId,
    required dynamic newAnswer,
  });

  // ========================================================================
  // Section Management
  // ========================================================================

  /// Load questionnaire structure from data source
  Future<List<ChatSection>> loadQuestionnaire();

  /// Save section with business rule enforcement
  Future<void> saveSection(ChatSection section);

  /// Get specific section with business logic applied
  Future<ChatSection?> getSection(String sectionId);

  /// Get all sections with current state
  Future<List<ChatSection>> getAllSections();

  // ========================================================================
  // Message Management
  // ========================================================================

  /// Add message to section with business validation
  Future<void> addMessage({
    required String sectionId,
    required SectionMessage message,
  });

  /// Update message with business rule enforcement
  Future<void> updateMessage({
    required String sectionId,
    required String messageId,
    required SectionMessage message,
  });

  /// Delete message with dependency validation
  Future<void> deleteMessage({
    required String sectionId,
    required String messageId,
  });

  // ========================================================================
  // Answer Management & Business Rules
  // ========================================================================

  /// Save answer with validation and business rule enforcement
  Future<void> saveAnswer({
    required String sectionId,
    required String questionId,
    required dynamic answer,
  });

  /// Get specific answer with formatting applied
  Future<QuestionAnswer?> getAnswer({
    required String sectionId,
    required String questionId,
  });

  /// Get all answers for a section
  Future<List<QuestionAnswer>> getSectionAnswers(String sectionId);

  /// Business Rule: Check if section can proceed to next
  Future<bool> canProceedToNextSection(String sectionId);

  /// Business Rule: Get questions that should be visible based on previous answers
  Future<List<Question>> getConditionalQuestions({
    required String sectionId,
    required List<QuestionAnswer> previousAnswers,
  });

  // ========================================================================
  // Progress Management & Calculation
  // ========================================================================

  /// Mark section as complete with business rule validation
  Future<void> markSectionComplete(String sectionId);

  /// Update section status with validation
  Future<void> updateSectionStatus({
    required String sectionId,
    required SectionStatus status,
  });

  /// Calculate overall progress across all sections
  Future<double> getOverallProgress();

  /// Calculate progress for specific section
  Future<double> getSectionProgress(String sectionId);

  // ========================================================================
  // Validation & Business Rules
  // ========================================================================

  /// Validate individual answer against business rules
  Future<ValidationStatus> validateAnswer({
    required String questionId,
    required dynamic answer,
  });

  /// Validate entire section against business rules
  Future<List<ValidationStatus>> validateSection(String sectionId);

  /// Business Rule: Determine if question should be shown based on dependencies
  Future<bool> shouldShowQuestion({
    required Question question,
    required List<QuestionAnswer> previousAnswers,
  });

  /// Cross-section business rule validation (e.g., age vs activity level)
  Future<ValidationStatus> validateBusinessRules(ChatState state);

  // ========================================================================
  // State Management
  // ========================================================================

  /// Get current complete chat state
  Future<ChatState> getCurrentState();

  /// Save current state with validation
  Future<void> saveCurrentState(ChatState state);

  /// Clear all state (reset questionnaire)
  Future<void> clearState();

  /// Get current question that should be displayed
  Future<Question?> getCurrentQuestion();

  /// Check if questionnaire is complete
  Future<bool> isQuestionnaireComplete();

  // ========================================================================
  // Session Management
  // ========================================================================

  /// Create new session with unique identifier
  Future<String> createSession();

  /// Load session by ID
  Future<ChatState?> loadSession(String sessionId);

  /// Save session with validation
  Future<void> saveSession({
    required String sessionId,
    required ChatState state,
  });

  /// Get all available sessions
  Future<List<String>> getSessions();

  /// Delete session and associated data
  Future<void> deleteSession(String sessionId);
}