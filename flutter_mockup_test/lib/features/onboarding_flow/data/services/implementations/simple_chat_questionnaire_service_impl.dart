import '../interfaces/simple_chat_questionnaire_service.dart';
import '../interfaces/simple_persistence_service.dart';
import '../../../data/models/core/chat_section.dart';
import '../../../data/models/core/section_message.dart';
import '../../../data/models/core/enums.dart';
import '../../../data/models/support/chat_state.dart';
import '../../../data/models/support/progress_details.dart';

/// Simple implementation of ChatQuestionnaireService using KISS principles
///
/// This service integrates the simplified persistence layer with minimal
/// business logic for essential questionnaire operations.
class SimpleChatQuestionnaireServiceImpl implements SimpleChatQuestionnaireService {
  final SimplePersistenceService _persistenceService;
  ChatState? _currentState;

  SimpleChatQuestionnaireServiceImpl(this._persistenceService);

  @override
  Future<ChatState> loadQuestionnaire() async {
    // Load questionnaire structure (typically from assets or API)
    final sections = await _loadQuestionnaireStructure();

    // Set initial positions to first section, first message
    final firstSection = sections.isNotEmpty ? sections.first : null;
    final firstMessage = firstSection?.allMessages.isNotEmpty == true
        ? firstSection!.allMessages.first
        : null;

    final state = ChatState(
      sessionId: _generateSessionId(),
      sections: sections,
      currentSectionId: firstSection?.id,
      currentQuestionId: firstMessage?.id,
      createdAt: DateTime.now(),
      lastActivityAt: DateTime.now(),
    );

    _currentState = state;
    await _persistenceService.saveSession(state);
    return state;
  }

  @override
  Future<ChatState?> loadChatState() async {
    final state = await _persistenceService.loadSession();
    _currentState = state;
    return state;
  }

  @override
  Future<ChatSection?> getSection([String? sectionId]) async {
    final state = await getCurrentState();
    final targetId = sectionId ?? state.currentSectionId;

    return state.sections
        .where((section) => section.id == targetId)
        .firstOrNull;
  }

  @override
  Future<SectionMessage?> getMessage(String messageId) async {
    final state = await getCurrentState();

    for (final section in state.sections) {
      for (final message in section.allMessages) {
        if (message.id == messageId) {
          return message;
        }
      }
    }

    return null;
  }

  @override
  Future<void> updateMessage({
    required String messageId,
    required dynamic answer,
  }) async {
    final state = await getCurrentState();

    final updatedSections = state.sections.map((section) {
      final updatedMessages = section.allMessages.map((message) {
        return message.when(
          bot: (id, sectionId, content, messageType, timestamp, isEditable, order, context, metadata) => message,
          questionAnswer: (id, sectionId, questionId, questionText, inputType, currentAnswer, timestamp, messageType, isEditable, isComplete, order, formattedAnswer, validation, questionMetadata) {
            if (id == messageId) {
              return message.copyWith(
                answer: answer,
                isComplete: true,
                timestamp: DateTime.now(),
              );
            }
            return message;
          },
        );
      }).toList();

      return section.when(
        intro: (id, title, welcomeMessages, sectionType, status, order, createdAt, completedAt) =>
            section.copyWith(
              welcomeMessages: updatedMessages.whereType<BotMessage>().toList(),
            ),
        questionnaire: (id, title, description, questions, messages, sectionType, status, order, createdAt, completedAt) =>
            section.copyWith(
              messages: updatedMessages,
            ),
      );
    }).toList();

    final updatedState = state.copyWith(
      sections: updatedSections,
      lastActivityAt: DateTime.now(),
    );

    _currentState = updatedState;
    await _persistenceService.saveSession(updatedState);
  }

  @override
  Future<void> editMessage({
    required String messageId,
    required dynamic newAnswer,
  }) async {
    final state = await getCurrentState();

    final updatedSections = state.sections.map((section) {
      final updatedMessages = section.allMessages.map((message) {
        return message.when(
          bot: (id, sectionId, content, messageType, timestamp, isEditable, order, context, metadata) => message,
          questionAnswer: (id, sectionId, questionId, questionText, inputType, currentAnswer, timestamp, messageType, isEditable, isComplete, order, formattedAnswer, validation, questionMetadata) {
            if (id == messageId) {
              return message.copyWith(
                answer: newAnswer,
                timestamp: DateTime.now(),
              );
            }
            return message;
          },
        );
      }).toList();

      return section.when(
        intro: (id, title, welcomeMessages, sectionType, status, order, createdAt, completedAt) =>
            section.copyWith(
              welcomeMessages: updatedMessages.whereType<BotMessage>().toList(),
            ),
        questionnaire: (id, title, description, questions, messages, sectionType, status, order, createdAt, completedAt) =>
            section.copyWith(
              messages: updatedMessages,
            ),
      );
    }).toList();

    final updatedState = state.copyWith(
      sections: updatedSections,
      lastActivityAt: DateTime.now(),
    );

    _currentState = updatedState;
    await _persistenceService.saveSession(updatedState);
  }

  @override
  Future<void> moveToNext() async {
    final state = await getCurrentState();

    // Find next message in order
    final nextMessageId = _findNextMessageId(state);
    final nextSectionId = _findSectionForMessage(state.sections, nextMessageId);

    if (nextMessageId.isNotEmpty && nextSectionId != null) {
      await setCurrentPosition(
        sectionId: nextSectionId,
        messageId: nextMessageId,
      );
    }
  }

  @override
  Future<void> setCurrentPosition({
    required String sectionId,
    required String messageId,
  }) async {
    final state = await getCurrentState();

    final updatedState = state.copyWith(
      currentSectionId: sectionId,
      currentQuestionId: messageId,
      lastActivityAt: DateTime.now(),
    );

    _currentState = updatedState;
    await _persistenceService.saveSession(updatedState);
  }

  @override
  Future<void> saveCurrentState() async {
    if (_currentState != null) {
      await _persistenceService.saveSession(_currentState!);
    }
  }

  @override
  Future<ChatState> getCurrentState() async {
    if (_currentState != null) {
      return _currentState!;
    }

    final state = await _persistenceService.loadSession();
    if (state == null) {
      throw Exception('No active session found. Call loadQuestionnaire() first.');
    }

    _currentState = state;
    return state;
  }

  @override
  Future<ProgressDetails> getProgress() async {
    final state = await getCurrentState();

    return ProgressCalculator.calculateFromState(
      sections: state.sections,
      currentSectionId: state.currentSectionId ?? '',
      currentQuestionId: state.currentQuestionId ?? '',
      getSectionMessages: (section) => section.allMessages,
      isSectionComplete: (section) => section.when(
        intro: (id, title, welcomeMessages, sectionType, status, order, createdAt, completedAt) => true,
        questionnaire: (id, title, description, questions, messages, sectionType, status, order, createdAt, completedAt) => status == SectionStatus.completed,
      ),
      isMessageComplete: (message) => message.when(
        bot: (id, sectionId, content, messageType, timestamp, isEditable, order, context, metadata) => true,
        questionAnswer: (id, sectionId, questionId, questionText, inputType, answer, timestamp, messageType, isEditable, isComplete, order, formattedAnswer, validation, questionMetadata) => isComplete,
      ),
      isQuestionMessage: (message) => message.when(
        bot: (id, sectionId, content, messageType, timestamp, isEditable, order, context, metadata) => false,
        questionAnswer: (id, sectionId, questionId, questionText, inputType, answer, timestamp, messageType, isEditable, isComplete, order, formattedAnswer, validation, questionMetadata) => true,
      ),
    );
  }

  @override
  Future<bool> isComplete() async {
    final state = await getCurrentState();

    return state.sections.every((section) => section.when(
      intro: (id, title, welcomeMessages, sectionType, status, order, createdAt, completedAt) => true,
      questionnaire: (id, title, description, questions, messages, sectionType, status, order, createdAt, completedAt) => status == SectionStatus.completed,
    ));
  }

  // ========================================================================
  // Private Helper Methods
  // ========================================================================

  String _generateSessionId() {
    return 'session_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Load questionnaire structure - typically from assets or API
  Future<List<ChatSection>> _loadQuestionnaireStructure() async {
    // This would typically load from assets/API
    // For now, return basic structure
    return [
      ChatSection.intro(
        id: 'intro',
        title: 'Welcome',
        welcomeMessages: [
          SectionMessage.bot(
            id: 'welcome_1',
            sectionId: 'intro',
            content: 'Welcome to the nutrition questionnaire!',
            messageType: MessageType.botIntro,
            timestamp: DateTime.now(),
            order: 1,
          ) as BotMessage,
        ],
        order: 1,
        createdAt: DateTime.now(),
      ),
      ChatSection.questionnaire(
        id: 'basic_info',
        title: 'Basic Information',
        description: 'Let\'s start with some basic information',
        questions: [], // Questions would be loaded here
        messages: [
          SectionMessage.bot(
            id: 'basic_intro',
            sectionId: 'basic_info',
            content: 'Let\'s start with some basic information about you.',
            messageType: MessageType.botQuestion,
            timestamp: DateTime.now(),
            order: 1,
          ),
          SectionMessage.questionAnswer(
            id: 'q_name',
            sectionId: 'basic_info',
            questionId: 'name',
            questionText: 'What\'s your name?',
            inputType: QuestionType.text,
            answer: null,
            timestamp: DateTime.now(),
            order: 2,
          ),
        ],
        order: 2,
        createdAt: DateTime.now(),
      ),
    ];
  }

  String _findNextMessageId(ChatState state) {
    // Get all messages from all sections, sorted by section order then message order
    final allMessages = <MapEntry<SectionMessage, int>>[];

    for (final section in state.sections) {
      final sectionOrder = section.when(
        intro: (_, __, ___, ____, _____, order, ______, _______) => order,
        questionnaire: (_, __, ___, ____, _____, ______, _______, order, ________, _________) => order,
      );

      for (final message in section.allMessages) {
        final messageOrder = message.when(
          bot: (id, sectionId, content, messageType, timestamp, isEditable, order, context, metadata) => order,
          questionAnswer: (id, sectionId, questionId, questionText, inputType, answer, timestamp, messageType, isEditable, isComplete, order, formattedAnswer, validation, questionMetadata) => order,
        );

        allMessages.add(MapEntry(message, sectionOrder * 1000 + messageOrder));
      }
    }

    // Sort by combined order
    allMessages.sort((a, b) => a.value.compareTo(b.value));

    // Find current message index
    final currentIndex = allMessages.indexWhere(
      (entry) => entry.key.id == state.currentQuestionId,
    );

    // Return next message ID or empty if at end
    if (currentIndex >= 0 && currentIndex < allMessages.length - 1) {
      return allMessages[currentIndex + 1].key.id;
    }

    return state.currentQuestionId; // Stay at current if no next
  }

  String? _findSectionForMessage(List<ChatSection> sections, String messageId) {
    for (final section in sections) {
      final hasMessage = section.allMessages.any((m) => m.id == messageId);
      if (hasMessage) return section.id;
    }
    return null;
  }
}