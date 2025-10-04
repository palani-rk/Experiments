import '../../../data/models/core/chat_section.dart';
import '../../../data/models/core/section_message.dart';
import '../../../data/models/support/chat_state.dart';
import '../../../data/models/support/progress_details.dart';

/// Simple Chat Questionnaire Service - KISS Implementation
///
/// This service provides only the essential methods needed for the
/// questionnaire system, following strict KISS principles.
abstract class SimpleChatQuestionnaireService {

  /// 1. Load a fresh questionnaire and set initial positions
  /// Creates new ChatState with all sections and sets current positions
  Future<ChatState> loadQuestionnaire();

  /// 2. Load existing chat state from storage
  /// Returns null if no existing state found
  Future<ChatState?> loadChatState();

  /// 3. Get section by ID, or get current section if no ID provided
  /// Uses currentSectionId from state if sectionId is null
  Future<ChatSection?> getSection([String? sectionId]);

  /// 4. Get message by ID from any section
  /// Generic method that works for both BotMessage and QuestionAnswer
  Future<SectionMessage?> getMessage(String messageId);

  /// 5. Update message answer and mark as complete
  /// Used when user provides/updates an answer
  Future<void> updateMessage({
    required String messageId,
    required dynamic answer,
  });

  /// 6. Edit existing message answer
  /// Used when user wants to modify a previous answer
  Future<void> editMessage({
    required String messageId,
    required dynamic newAnswer,
  });

  // Additional Navigation & State Methods

  /// Move to next question/section and update current position
  Future<void> moveToNext();

  /// Set current position manually (for navigation)
  Future<void> setCurrentPosition({
    required String sectionId,
    required String messageId,
  });

  /// Save current state to persistence
  Future<void> saveCurrentState();

  /// Get current complete state
  Future<ChatState> getCurrentState();

  /// Get progress details for UI display
  Future<ProgressDetails> getProgress();

  /// Check if questionnaire is complete
  Future<bool> isComplete();
}