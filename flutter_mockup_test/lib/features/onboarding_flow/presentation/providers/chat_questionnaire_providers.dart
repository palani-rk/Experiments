import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/interfaces/simple_chat_questionnaire_service.dart';
import '../../data/services/interfaces/simple_persistence_service.dart';
import '../../data/services/implementations/simple_chat_questionnaire_service_impl.dart';
import '../../data/services/implementations/simple_local_persistence_service.dart';
import '../../data/models/support/chat_state.dart';
import '../../data/models/support/progress_details.dart';
import '../../data/models/support/question.dart';
import '../../data/models/core/chat_section.dart';
import '../../data/models/core/section_message.dart';

// ============================================================================
// Core Service Providers
// ============================================================================

/// Provider for the persistence service
/// This can be easily swapped for different implementations (local, API, etc.)
final persistenceServiceProvider = Provider<SimplePersistenceService>((ref) {
  return SimpleLocalPersistenceService();
});

/// Provider for the chat questionnaire service
/// Depends on persistence service for data operations
final chatQuestionnaireServiceProvider = Provider<SimpleChatQuestionnaireService>((ref) {
  final persistenceService = ref.read(persistenceServiceProvider);
  return SimpleChatQuestionnaireServiceImpl(persistenceService);
});

// ============================================================================
// Chat State Management
// ============================================================================

/// Main state notifier for the chat questionnaire
/// Manages the current ChatState and provides methods for state updates
class ChatStateNotifier extends StateNotifier<AsyncValue<ChatState?>> {
  final SimpleChatQuestionnaireService _service;

  ChatStateNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadInitialState();
  }

  /// Load existing state or start fresh questionnaire
  Future<void> _loadInitialState() async {
    try {
      // First try to load existing state
      final existingState = await _service.loadChatState();
      if (existingState != null) {
        state = AsyncValue.data(existingState);
        return;
      }

      // If no existing state, load fresh questionnaire
      final newState = await _service.loadQuestionnaire();
      state = AsyncValue.data(newState);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Start a fresh questionnaire
  Future<void> startNewQuestionnaire() async {
    state = const AsyncValue.loading();
    try {
      final newState = await _service.loadQuestionnaire();
      state = AsyncValue.data(newState);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Resume from existing state
  Future<void> resumeQuestionnaire() async {
    state = const AsyncValue.loading();
    try {
      final existingState = await _service.loadChatState();
      state = AsyncValue.data(existingState);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update message answer
  Future<void> updateMessageAnswer({
    required String messageId,
    required dynamic answer,
  }) async {
    try {
      await _service.updateMessage(messageId: messageId, answer: answer);
      final updatedState = await _service.getCurrentState();
      state = AsyncValue.data(updatedState);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Edit existing message answer
  Future<void> editMessageAnswer({
    required String messageId,
    required dynamic newAnswer,
  }) async {
    try {
      await _service.editMessage(messageId: messageId, newAnswer: newAnswer);
      final updatedState = await _service.getCurrentState();
      state = AsyncValue.data(updatedState);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Move to next question/section
  Future<void> moveToNext() async {
    try {
      await _service.moveToNext();
      final updatedState = await _service.getCurrentState();
      state = AsyncValue.data(updatedState);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Navigate to specific position
  Future<void> navigateToPosition({
    required String sectionId,
    required String messageId,
  }) async {
    try {
      await _service.setCurrentPosition(
        sectionId: sectionId,
        messageId: messageId,
      );
      final updatedState = await _service.getCurrentState();
      state = AsyncValue.data(updatedState);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Save current state to persistence
  Future<void> saveState() async {
    try {
      await _service.saveCurrentState();
    } catch (error, stackTrace) {
      // Log error but don't update state since this is just a save operation
      print('Error saving state: $error');
    }
  }

  /// Refresh state from service
  Future<void> refreshState() async {
    try {
      final currentState = await _service.getCurrentState();
      state = AsyncValue.data(currentState);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for the chat state notifier
final chatStateProvider = StateNotifierProvider<ChatStateNotifier, AsyncValue<ChatState?>>((ref) {
  final service = ref.read(chatQuestionnaireServiceProvider);
  return ChatStateNotifier(service);
});

// ============================================================================
// Derived State Providers
// ============================================================================

/// Provider for the current chat state (unwrapped from AsyncValue)
final currentChatStateProvider = Provider<ChatState?>((ref) {
  final asyncState = ref.watch(chatStateProvider);
  return asyncState.whenOrNull(data: (state) => state);
});

/// Provider for the current section
final currentSectionProvider = Provider<ChatSection?>((ref) {
  final chatState = ref.watch(currentChatStateProvider);
  return chatState?.currentSection;
});

/// Provider for the current question
final currentQuestionProvider = Provider<Question?>((ref) {
  final chatState = ref.watch(currentChatStateProvider);
  return chatState?.currentQuestion;
});

/// Provider for all sections
final sectionsProvider = Provider<List<ChatSection>>((ref) {
  final chatState = ref.watch(currentChatStateProvider);
  return chatState?.sections ?? [];
});

/// Provider for questionnaire completion status
final isQuestionnaireCompleteProvider = Provider<bool>((ref) {
  final chatState = ref.watch(currentChatStateProvider);
  return chatState?.isComplete ?? false;
});

/// Provider for loading state
final isLoadingProvider = Provider<bool>((ref) {
  final asyncState = ref.watch(chatStateProvider);
  return asyncState.isLoading;
});

/// Provider for error state
final errorProvider = Provider<Object?>((ref) {
  final asyncState = ref.watch(chatStateProvider);
  return asyncState.hasError ? asyncState.error : null;
});

// ============================================================================
// Progress Tracking Providers
// ============================================================================

/// Provider for progress details
final progressDetailsProvider = FutureProvider<ProgressDetails?>((ref) async {
  final service = ref.read(chatQuestionnaireServiceProvider);
  final chatState = ref.watch(currentChatStateProvider);

  if (chatState == null) return null;

  try {
    return await service.getProgress();
  } catch (e) {
    return null;
  }
});

/// Provider for overall progress percentage (0.0 to 1.0)
final progressPercentageProvider = Provider<double>((ref) {
  final chatState = ref.watch(currentChatStateProvider);
  return chatState?.overallProgress ?? 0.0;
});

// ============================================================================
// Navigation Action Providers
// ============================================================================

/// Provider for navigation actions
/// This provides methods that widgets can call to perform navigation
final navigationActionsProvider = Provider<NavigationActions>((ref) {
  return NavigationActions(ref);
});

class NavigationActions {
  final Ref _ref;

  NavigationActions(this._ref);

  /// Start a new questionnaire
  Future<void> startNew() async {
    await _ref.read(chatStateProvider.notifier).startNewQuestionnaire();
  }

  /// Resume existing questionnaire
  Future<void> resume() async {
    await _ref.read(chatStateProvider.notifier).resumeQuestionnaire();
  }

  /// Answer current question and move to next
  Future<void> answerAndMoveNext({
    required String messageId,
    required dynamic answer,
  }) async {
    final notifier = _ref.read(chatStateProvider.notifier);
    await notifier.updateMessageAnswer(messageId: messageId, answer: answer);
    await notifier.moveToNext();
  }

  /// Edit a previous answer
  Future<void> editAnswer({
    required String messageId,
    required dynamic newAnswer,
  }) async {
    await _ref.read(chatStateProvider.notifier).editMessageAnswer(
      messageId: messageId,
      newAnswer: newAnswer,
    );
  }

  /// Navigate to specific section and message
  Future<void> navigateTo({
    required String sectionId,
    required String messageId,
  }) async {
    await _ref.read(chatStateProvider.notifier).navigateToPosition(
      sectionId: sectionId,
      messageId: messageId,
    );
  }

  /// Save current progress
  Future<void> saveProgress() async {
    await _ref.read(chatStateProvider.notifier).saveState();
  }

  /// Refresh state
  Future<void> refresh() async {
    await _ref.read(chatStateProvider.notifier).refreshState();
  }
}

// ============================================================================
// Convenience Providers for Common UI Patterns
// ============================================================================

/// Provider for current message ID
final currentMessageIdProvider = Provider<String?>((ref) {
  final chatState = ref.watch(currentChatStateProvider);
  return chatState?.currentQuestionId;
});

/// Provider for current section ID
final currentSectionIdProvider = Provider<String?>((ref) {
  final chatState = ref.watch(currentChatStateProvider);
  return chatState?.currentSectionId;
});

/// Provider that checks if there are more questions/sections ahead
final hasNextProvider = Provider<bool>((ref) {
  final chatState = ref.watch(currentChatStateProvider);
  if (chatState == null) return false;

  final currentSection = chatState.currentSection;
  if (currentSection == null) return false;

  // Check if there are more sections after current
  final currentSectionIndex = chatState.sections.indexOf(currentSection);
  return currentSectionIndex < chatState.sections.length - 1;
});

/// Provider that checks if we can go back
final canGoBackProvider = Provider<bool>((ref) {
  final chatState = ref.watch(currentChatStateProvider);
  if (chatState == null) return false;

  final currentSection = chatState.currentSection;
  if (currentSection == null) return false;

  // Check if we're not at the first section
  final currentSectionIndex = chatState.sections.indexOf(currentSection);
  return currentSectionIndex > 0;
});

/// Provider for section-specific data
final sectionProvider = Provider.family<ChatSection?, String>((ref, sectionId) {
  final chatState = ref.watch(currentChatStateProvider);
  return chatState?.getSection(sectionId);
});

/// Provider for message-specific data
final messageProvider = FutureProvider.family<SectionMessage?, String>((ref, messageId) async {
  final service = ref.read(chatQuestionnaireServiceProvider);
  try {
    return await service.getMessage(messageId);
  } catch (e) {
    return null;
  }
});