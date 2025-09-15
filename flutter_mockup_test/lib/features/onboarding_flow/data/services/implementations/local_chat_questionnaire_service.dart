import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

import '../../../data/models/core/chat_section.dart';
import '../../../data/models/core/enums.dart';
import '../../../data/models/core/section_message.dart';
import '../../../data/models/support/chat_state.dart';
import '../../../data/models/support/question.dart';
import '../../../data/models/support/validation_status.dart';
import '../exceptions/chat_exceptions.dart';
import '../interfaces/chat_persistence_service.dart';
import '../interfaces/chat_questionnaire_service.dart';
import '../interfaces/chat_validation_service.dart';

/// Local implementation of ChatQuestionnaireService with embedded business logic
///
/// This service handles all questionnaire operations using local JSON data and
/// SharedPreferences for persistence. All business rules are embedded within
/// the service methods for optimal performance and maintainability.
class LocalChatQuestionnaireService implements ChatQuestionnaireService {
  final ChatPersistenceService _persistenceService;
  final ChatValidationService _validationService;
  static const String _assetPath = 'assets/questionnaires/nutrition_onboarding.json';

  LocalChatQuestionnaireService(
    this._persistenceService,
    this._validationService,
  );

  // ========================================================================
  // Core Operations (Business Logic + Data Access)
  // ========================================================================

  @override
  Future<ChatState> initializeQuestionnaire() async {
    return handleServiceOperation(
      () async {
        // Business Logic: Load existing state or create new
        final existingState = await _persistenceService.loadChatState();
        if (existingState != null) {
          // Validate loaded state integrity
          if (await _validateStateIntegrity(existingState)) {
            return existingState;
          } else {
            // State is corrupted, create new one
            await _persistenceService.clearChatState();
          }
        }

        // Business Logic: Initialize new questionnaire
        final sections = await loadQuestionnaire();
        final introSection = sections.firstWhere(
          (section) => section.sectionType == SectionType.intro,
          orElse: () => throw QuestionnaireLoadException(
            'No intro section found in questionnaire data',
          ),
        );

        // Business Logic: Create chat state with proper initialization
        final chatState = ChatState(
          sessionId: _generateSessionId(),
          sections: sections,
          currentSectionId: _findFirstQuestionnaireSection(sections)?.id,
          status: ChatStatus.inProgress,
          createdAt: DateTime.now(),
          metadata: {
            'version': '2.0',
            'initialized_at': DateTime.now().toIso8601String(),
            'total_sections': sections.length,
          },
        );

        // Business Logic: Auto-save initial state
        await _persistenceService.saveChatState(chatState);
        return chatState;
      },
      operationName: 'initializeQuestionnaire',
    );
  }

  @override
  Future<void> submitAnswer({
    required String questionId,
    required dynamic answer,
  }) async {
    return handleServiceOperation(
      () async {
        // Business Logic: Get current state and validate context
        final currentState = await getCurrentState();
        final currentSection = currentState.currentSection;

        if (currentSection is! QuestionnaireSection) {
          throw InvalidStateException(
            'Cannot submit answer when not in questionnaire section',
            currentSection?.sectionType.toString() ?? 'null',
            'QuestionnaireSection',
          );
        }

        // Business Logic: Find and validate question
        final question = currentSection.questions.firstWhere(
          (q) => q.id == questionId,
          orElse: () => throw ValidationException(
            'Question not found in current section',
            questionId,
            answer,
          ),
        );

        // Business Logic: Validate answer
        final validation = await _validationService.validateAnswer(
          questionId: questionId,
          answer: answer,
        );

        if (!validation.isValid) {
          throw ValidationException(
            'Answer validation failed: ${validation.primaryError}',
            questionId,
            answer,
            validationErrors: validation.warnings,
          );
        }

        // Business Logic: Create answer message
        final qaMessage = SectionMessage.questionAnswer(
          id: _generateId(),
          sectionId: currentSection.id,
          questionId: questionId,
          questionText: question.text,
          inputType: question.inputType,
          answer: answer,
          timestamp: DateTime.now(),
          formattedAnswer: _formatAnswer(answer, question.inputType),
          validation: validation,
        );

        // Business Logic: Add message to section
        await addMessage(
          sectionId: currentSection.id,
          message: qaMessage,
        );

        // Business Logic: Check conditional questions and update visibility
        await _updateConditionalQuestions(currentSection.id);

        // Business Logic: Check section completion
        if (await _isSectionComplete(currentSection.id)) {
          await _handleSectionCompletion(currentSection.id);
        }

        // Business Logic: Auto-save state
        final updatedState = await getCurrentState();
        await _persistenceService.saveChatState(updatedState);
      },
      operationName: 'submitAnswer',
      context: {'questionId': questionId, 'answer': answer},
    );
  }

  @override
  Future<void> navigateToQuestion(String questionId) async {
    return handleServiceOperation(
      () async {
        // Business Logic: Find question across all sections
        final sections = await getAllSections();
        ChatSection? targetSection;
        Question? targetQuestion;

        for (final section in sections) {
          if (section is QuestionnaireSection) {
            try {
              targetQuestion = section.questions.firstWhere((q) => q.id == questionId);
              targetSection = section;
              break;
            } catch (_) {
              continue;
            }
          }
        }

        if (targetSection == null || targetQuestion == null) {
          throw InvalidNavigationException(
            'Question not found for navigation',
            'current',
            questionId,
            'Question ID does not exist in any section',
          );
        }

        // Business Logic: Validate navigation permissions
        if (!await _canNavigateToQuestion(targetQuestion, targetSection as QuestionnaireSection)) {
          throw InvalidNavigationException(
            'Navigation to question not allowed',
            'current',
            questionId,
            'Question dependencies not met or section not accessible',
          );
        }

        // Business Logic: Update current state
        final currentState = await getCurrentState();
        final updatedState = currentState.copyWith(
          currentSectionId: targetSection.id,
          currentQuestionId: questionId,
        );

        await _persistenceService.saveChatState(updatedState);
      },
      operationName: 'navigateToQuestion',
      context: {'questionId': questionId},
    );
  }

  @override
  Future<void> editAnswer({
    required String sectionId,
    required String messageId,
    required dynamic newAnswer,
  }) async {
    return handleServiceOperation(
      () async {
        // Business Logic: Get section and validate edit permissions
        final section = await getSection(sectionId);
        if (section is! QuestionnaireSection) {
          throw SectionException(
            'Cannot edit answer in non-questionnaire section',
            sectionId,
          );
        }

        // Business Logic: Find message and validate editability
        final message = section.messages.firstWhere(
          (m) => m.id == messageId && m is QuestionAnswer,
          orElse: () => throw MessageException(
            'Message not found or not editable',
            sectionId,
            messageId: messageId,
          ),
        ) as QuestionAnswer;

        if (!message.isEditable) {
          throw MessageException(
            'Message is not editable',
            sectionId,
            messageId: messageId,
          );
        }

        // Business Logic: Validate new answer
        final validation = await _validationService.validateAnswer(
          questionId: message.questionId,
          answer: newAnswer,
        );

        if (!validation.isValid) {
          throw ValidationException(
            'New answer validation failed: ${validation.primaryError}',
            message.questionId,
            newAnswer,
            validationErrors: validation.warnings,
          );
        }

        // Business Logic: Create updated message
        final question = section.questions.firstWhere((q) => q.id == message.questionId);
        final updatedMessage = message.copyWith(
          answer: newAnswer,
          timestamp: DateTime.now(),
          formattedAnswer: _formatAnswer(newAnswer, question.inputType),
          validation: validation,
        );

        // Business Logic: Update message
        await updateMessage(
          sectionId: sectionId,
          messageId: messageId,
          message: updatedMessage,
        );

        // Business Logic: Recalculate conditional questions due to edit
        await _updateConditionalQuestions(sectionId);

        // Business Logic: Revalidate section completion
        await _revalidateSectionCompletion(sectionId);
      },
      operationName: 'editAnswer',
      context: {
        'sectionId': sectionId,
        'messageId': messageId,
        'newAnswer': newAnswer,
      },
    );
  }

  // ========================================================================
  // Section Management
  // ========================================================================

  @override
  Future<List<ChatSection>> loadQuestionnaire() async {
    return handleServiceOperation(
      () async {
        try {
          // Load questionnaire from assets
          final jsonString = await rootBundle.loadString(_assetPath);
          final jsonData = json.decode(jsonString) as Map<String, dynamic>;

          return _parseQuestionnaireData(jsonData);
        } catch (e) {
          throw QuestionnaireLoadException(
            'Failed to load questionnaire from $_assetPath: $e',
            cause: e,
          );
        }
      },
      operationName: 'loadQuestionnaire',
    );
  }

  @override
  Future<void> saveSection(ChatSection section) async {
    return handleServiceOperation(
      () async {
        final currentState = await getCurrentState();
        final updatedSections = currentState.sections.map((s) {
          return s.id == section.id ? section : s;
        }).toList();

        final updatedState = currentState.copyWith(sections: updatedSections);
        await _persistenceService.saveChatState(updatedState);
      },
      operationName: 'saveSection',
      context: {'sectionId': section.id},
    );
  }

  @override
  Future<ChatSection?> getSection(String sectionId) async {
    return handleServiceOperation(
      () async {
        final sections = await getAllSections();
        try {
          return sections.firstWhere((s) => s.id == sectionId);
        } catch (_) {
          return null;
        }
      },
      operationName: 'getSection',
      context: {'sectionId': sectionId},
    );
  }

  @override
  Future<List<ChatSection>> getAllSections() async {
    return handleServiceOperation(
      () async {
        final currentState = await getCurrentState();
        return currentState.sections;
      },
      operationName: 'getAllSections',
    );
  }

  // ========================================================================
  // Message Management
  // ========================================================================

  @override
  Future<void> addMessage({
    required String sectionId,
    required SectionMessage message,
  }) async {
    return handleServiceOperation(
      () async {
        final section = await getSection(sectionId);
        if (section is! QuestionnaireSection) {
          throw MessageException(
            'Cannot add message to non-questionnaire section',
            sectionId,
          );
        }

        final updatedSection = section.copyWith(
          messages: [...section.messages, message],
        );

        await saveSection(updatedSection);
      },
      operationName: 'addMessage',
      context: {'sectionId': sectionId, 'messageType': message.runtimeType},
    );
  }

  @override
  Future<void> updateMessage({
    required String sectionId,
    required String messageId,
    required SectionMessage message,
  }) async {
    return handleServiceOperation(
      () async {
        final section = await getSection(sectionId);
        if (section is! QuestionnaireSection) {
          throw MessageException(
            'Cannot update message in non-questionnaire section',
            sectionId,
          );
        }

        final updatedMessages = section.messages.map((m) {
          return m.id == messageId ? message : m;
        }).toList();

        final updatedSection = section.copyWith(messages: updatedMessages);
        await saveSection(updatedSection);
      },
      operationName: 'updateMessage',
      context: {'sectionId': sectionId, 'messageId': messageId},
    );
  }

  @override
  Future<void> deleteMessage({
    required String sectionId,
    required String messageId,
  }) async {
    return handleServiceOperation(
      () async {
        final section = await getSection(sectionId);
        if (section is! QuestionnaireSection) {
          throw MessageException(
            'Cannot delete message from non-questionnaire section',
            sectionId,
          );
        }

        // Business Logic: Validate deletion permissions
        final messageToDelete = section.messages.firstWhere(
          (m) => m.id == messageId,
          orElse: () => throw MessageException(
            'Message not found for deletion',
            sectionId,
            messageId: messageId,
          ),
        );

        // Business Logic: Check if deletion affects dependencies
        if (messageToDelete is QuestionAnswer) {
          await _validateMessageDeletion(messageToDelete, section);
        }

        final updatedMessages = section.messages
            .where((m) => m.id != messageId)
            .toList();

        final updatedSection = section.copyWith(messages: updatedMessages);
        await saveSection(updatedSection);

        // Business Logic: Recalculate conditional questions after deletion
        await _updateConditionalQuestions(sectionId);
      },
      operationName: 'deleteMessage',
      context: {'sectionId': sectionId, 'messageId': messageId},
    );
  }

  // ========================================================================
  // Answer Management & Business Rules
  // ========================================================================

  @override
  Future<void> saveAnswer({
    required String sectionId,
    required String questionId,
    required dynamic answer,
  }) async {
    // Implemented via submitAnswer for consistency
    await submitAnswer(questionId: questionId, answer: answer);
  }

  @override
  Future<QuestionAnswer?> getAnswer({
    required String sectionId,
    required String questionId,
  }) async {
    return handleServiceOperation(
      () async {
        final section = await getSection(sectionId);
        if (section is! QuestionnaireSection) {
          return null;
        }

        try {
          return section.messages
              .whereType<QuestionAnswer>()
              .firstWhere((qa) => qa.questionId == questionId);
        } catch (_) {
          return null;
        }
      },
      operationName: 'getAnswer',
      context: {'sectionId': sectionId, 'questionId': questionId},
    );
  }

  @override
  Future<List<QuestionAnswer>> getSectionAnswers(String sectionId) async {
    return handleServiceOperation(
      () async {
        final section = await getSection(sectionId);
        if (section is! QuestionnaireSection) {
          return [];
        }

        return section.messages.whereType<QuestionAnswer>().toList();
      },
      operationName: 'getSectionAnswers',
      context: {'sectionId': sectionId},
    );
  }

  @override
  Future<bool> canProceedToNextSection(String sectionId) async {
    return handleServiceOperation(
      () async {
        final section = await getSection(sectionId);
        if (section is! QuestionnaireSection) {
          return false;
        }

        // Business Logic: Check all required questions answered
        final requiredQuestions = section.questions.where((q) => q.required).toList();
        final answeredQuestions = await getSectionAnswers(sectionId);

        for (final requiredQuestion in requiredQuestions) {
          final hasAnswer = answeredQuestions.any(
            (answer) => answer.questionId == requiredQuestion.id && answer.validation?.isValid == true,
          );
          if (!hasAnswer) {
            return false;
          }
        }

        // Business Logic: Validate business rules for section
        final sectionValidation = await _validationService.validateSection(section);
        return sectionValidation.every((validation) => validation.isValid);
      },
      operationName: 'canProceedToNextSection',
      context: {'sectionId': sectionId},
    );
  }

  @override
  Future<List<Question>> getConditionalQuestions({
    required String sectionId,
    required List<QuestionAnswer> previousAnswers,
  }) async {
    return handleServiceOperation(
      () async {
        final section = await getSection(sectionId);
        if (section is! QuestionnaireSection) {
          return [];
        }

        final List<Question> visibleQuestions = [];

        for (final question in section.questions) {
          if (await shouldShowQuestion(
            question: question,
            previousAnswers: previousAnswers,
          )) {
            visibleQuestions.add(question);
          }
        }

        return visibleQuestions;
      },
      operationName: 'getConditionalQuestions',
      context: {'sectionId': sectionId, 'previousAnswersCount': previousAnswers.length},
    );
  }

  // ========================================================================
  // Progress Management & Calculation
  // ========================================================================

  @override
  Future<void> markSectionComplete(String sectionId) async {
    return handleServiceOperation(
      () async {
        final section = await getSection(sectionId);
        if (section == null) {
          throw SectionException('Section not found', sectionId);
        }

        final updatedSection = section.copyWith(
          status: SectionStatus.completed,
          completedAt: DateTime.now(),
        );

        await saveSection(updatedSection);
      },
      operationName: 'markSectionComplete',
      context: {'sectionId': sectionId},
    );
  }

  @override
  Future<void> updateSectionStatus({
    required String sectionId,
    required SectionStatus status,
  }) async {
    return handleServiceOperation(
      () async {
        final section = await getSection(sectionId);
        if (section == null) {
          throw SectionException('Section not found', sectionId);
        }

        final updatedSection = section.copyWith(
          status: status,
          completedAt: status == SectionStatus.completed ? DateTime.now() : null,
        );

        await saveSection(updatedSection);
      },
      operationName: 'updateSectionStatus',
      context: {'sectionId': sectionId, 'status': status},
    );
  }

  @override
  Future<double> getOverallProgress() async {
    return handleServiceOperation(
      () async {
        final sections = await getAllSections();
        final questionnaireSections = sections.whereType<QuestionnaireSection>().toList();

        if (questionnaireSections.isEmpty) {
          return 0.0;
        }

        double totalProgress = 0.0;
        for (final section in questionnaireSections) {
          totalProgress += await getSectionProgress(section.id);
        }

        return totalProgress / questionnaireSections.length;
      },
      operationName: 'getOverallProgress',
    );
  }

  @override
  Future<double> getSectionProgress(String sectionId) async {
    return handleServiceOperation(
      () async {
        final section = await getSection(sectionId);
        if (section is! QuestionnaireSection) {
          return 0.0;
        }

        final totalQuestions = section.questions.length;
        if (totalQuestions == 0) {
          return 1.0;
        }

        final answeredQuestions = await getSectionAnswers(sectionId);
        final validAnswers = answeredQuestions
            .where((answer) => answer.validation?.isValid ?? false)
            .length;

        return validAnswers / totalQuestions;
      },
      operationName: 'getSectionProgress',
      context: {'sectionId': sectionId},
    );
  }

  // ========================================================================
  // Validation & Business Rules
  // ========================================================================

  @override
  Future<ValidationStatus> validateAnswer({
    required String questionId,
    required dynamic answer,
  }) async {
    return _validationService.validateAnswer(
      questionId: questionId,
      answer: answer,
    );
  }

  @override
  Future<List<ValidationStatus>> validateSection(String sectionId) async {
    return handleServiceOperation(
      () async {
        final section = await getSection(sectionId);
        if (section is! QuestionnaireSection) {
          return [
            ValidationStatus.error('Section is not a questionnaire section')
          ];
        }

        return _validationService.validateSection(section);
      },
      operationName: 'validateSection',
      context: {'sectionId': sectionId},
    );
  }

  @override
  Future<bool> shouldShowQuestion({
    required Question question,
    required List<QuestionAnswer> previousAnswers,
  }) async {
    return handleServiceOperation(
      () async {
        // Business Logic: Check if question has conditional display rules
        final showIf = question.metadata?['showIf'] as Map<String, dynamic>?;
        if (showIf == null) {
          return true; // Always show if no conditions
        }

        // Business Logic: Check dependencies
        final dependentQuestionId = showIf['questionId'] as String?;
        final expectedValue = showIf['value'];
        final operator = showIf['operator'] as String? ?? 'equals';

        if (dependentQuestionId == null) {
          return true;
        }

        // Find dependent answer
        final dependentAnswer = previousAnswers.firstWhere(
          (answer) => answer.questionId == dependentQuestionId,
          orElse: () => throw ValidationException(
            'Dependent question answer not found',
            dependentQuestionId,
            null,
          ),
        );

        // Business Logic: Apply conditional operator
        switch (operator) {
          case 'equals':
            return dependentAnswer.answer == expectedValue;
          case 'not_equals':
            return dependentAnswer.answer != expectedValue;
          case 'greater_than':
            if (dependentAnswer.answer is num && expectedValue is num) {
              return (dependentAnswer.answer as num) > (expectedValue as num);
            }
            return false;
          case 'less_than':
            if (dependentAnswer.answer is num && expectedValue is num) {
              return (dependentAnswer.answer as num) < (expectedValue as num);
            }
            return false;
          case 'contains':
            if (dependentAnswer.answer is List) {
              return (dependentAnswer.answer as List).contains(expectedValue);
            }
            return false;
          default:
            return true;
        }
      },
      operationName: 'shouldShowQuestion',
      context: {
        'questionId': question.id,
        'previousAnswersCount': previousAnswers.length,
      },
    );
  }

  @override
  Future<ValidationStatus> validateBusinessRules(ChatState state) async {
    return _validationService.validateBusinessRules(state);
  }

  // ========================================================================
  // State Management
  // ========================================================================

  @override
  Future<ChatState> getCurrentState() async {
    return handleServiceOperation(
      () async {
        final state = await _persistenceService.loadChatState();
        if (state == null) {
          throw StateLoadException('No current state available');
        }
        return state;
      },
      operationName: 'getCurrentState',
    );
  }

  @override
  Future<void> saveCurrentState(ChatState state) async {
    return handleServiceOperation(
      () async {
        await _persistenceService.saveChatState(state);
      },
      operationName: 'saveCurrentState',
    );
  }

  @override
  Future<void> clearState() async {
    return handleServiceOperation(
      () async {
        await _persistenceService.clearChatState();
      },
      operationName: 'clearState',
    );
  }

  @override
  Future<Question?> getCurrentQuestion() async {
    return handleServiceOperation(
      () async {
        final currentState = await getCurrentState();
        final currentSection = currentState.currentSection;

        if (currentSection is! QuestionnaireSection) {
          return null;
        }

        // Business Logic: Find next unanswered question
        final answeredQuestions = await getSectionAnswers(currentSection.id);
        final answeredQuestionIds = answeredQuestions.map((qa) => qa.questionId).toSet();

        for (final question in currentSection.questions) {
          if (!answeredQuestionIds.contains(question.id)) {
            // Check if question should be shown based on dependencies
            if (await shouldShowQuestion(
              question: question,
              previousAnswers: answeredQuestions,
            )) {
              return question;
            }
          }
        }

        return null; // All questions answered
      },
      operationName: 'getCurrentQuestion',
    );
  }

  @override
  Future<bool> isQuestionnaireComplete() async {
    return handleServiceOperation(
      () async {
        final currentState = await getCurrentState();
        if (currentState.status == ChatStatus.completed) {
          return true;
        }

        // Business Logic: Check if all sections are complete
        final sections = currentState.sections.whereType<QuestionnaireSection>();
        for (final section in sections) {
          if (!(await canProceedToNextSection(section.id))) {
            return false;
          }
        }

        return true;
      },
      operationName: 'isQuestionnaireComplete',
    );
  }

  // ========================================================================
  // Session Management
  // ========================================================================

  @override
  Future<String> createSession() async {
    return handleServiceOperation(
      () async {
        final sessionId = _generateSessionId();
        final currentState = await getCurrentState();

        await _persistenceService.saveSession(
          sessionId: sessionId,
          state: currentState,
        );

        return sessionId;
      },
      operationName: 'createSession',
    );
  }

  @override
  Future<ChatState?> loadSession(String sessionId) async {
    return _persistenceService.loadSession(sessionId);
  }

  @override
  Future<void> saveSession({
    required String sessionId,
    required ChatState state,
  }) async {
    return _persistenceService.saveSession(sessionId: sessionId, state: state);
  }

  @override
  Future<List<String>> getSessions() async {
    return _persistenceService.getSessions();
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    return _persistenceService.deleteSession(sessionId);
  }

  // ========================================================================
  // Private Business Logic Methods
  // ========================================================================

  /// Generate unique session ID
  String _generateSessionId() {
    return 'session_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }

  /// Generate unique message/entity ID
  String _generateId() {
    return 'id_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }

  /// Validate state integrity for loaded states
  Future<bool> _validateStateIntegrity(ChatState state) async {
    try {
      // Check basic structure
      if (state.sections.isEmpty) return false;
      if (state.sessionId.isEmpty) return false;

      // Validate section IDs are unique
      final sectionIds = state.sections.map((s) => s.id).toSet();
      if (sectionIds.length != state.sections.length) return false;

      return true;
    } catch (_) {
      return false;
    }
  }

  /// Find first questionnaire section for initialization
  ChatSection? _findFirstQuestionnaireSection(List<ChatSection> sections) {
    try {
      return sections.firstWhere(
        (section) => section.sectionType == SectionType.questionnaire,
      );
    } catch (_) {
      return null;
    }
  }

  /// Parse questionnaire data from JSON
  List<ChatSection> _parseQuestionnaireData(Map<String, dynamic> jsonData) {
    try {
      final List<ChatSection> sections = [];

      // Validate required top-level structure
      if (!jsonData.containsKey('metadata') || !jsonData.containsKey('intro') || !jsonData.containsKey('sections')) {
        throw QuestionnaireLoadException(
          'Invalid questionnaire format: missing required fields (metadata, intro, sections)',
        );
      }

      // Parse intro section
      final introData = jsonData['intro'] as Map<String, dynamic>;

      // Convert welcome messages from bot messages to proper format
      final welcomeMessagesData = introData['welcomeMessages'] as List<dynamic>;
      final welcomeMessages = welcomeMessagesData.map((msgData) {
        final msgMap = msgData as Map<String, dynamic>;
        return BotMessage(
          id: msgMap['id'] as String,
          sectionId: msgMap['sectionId'] as String,
          content: msgMap['content'] as String,
          messageType: MessageType.values.firstWhere(
            (type) => type.name == msgMap['messageType'],
            orElse: () => MessageType.botIntro,
          ),
          timestamp: DateTime.parse(msgMap['timestamp'] as String),
          isEditable: msgMap['isEditable'] as bool? ?? false,
          context: msgMap['context'] as String?,
          metadata: msgMap['metadata'] as Map<String, dynamic>?,
        );
      }).toList();

      // Create intro section with parsed welcome messages
      final introSection = IntroSection(
        id: introData['id'] as String,
        title: introData['title'] as String,
        welcomeMessages: welcomeMessages,
        sectionType: SectionType.intro,
        status: SectionStatus.values.firstWhere(
          (status) => status.name == introData['status'],
          orElse: () => SectionStatus.completed,
        ),
        createdAt: DateTime.parse(introData['createdAt'] as String),
        completedAt: introData['completedAt'] != null
          ? DateTime.parse(introData['completedAt'] as String)
          : null,
      );
      sections.add(introSection);

      // Parse questionnaire sections
      final sectionsData = jsonData['sections'] as List<dynamic>;
      for (final sectionData in sectionsData) {
        final sectionMap = sectionData as Map<String, dynamic>;

        // Parse questions
        final questionsData = sectionMap['questions'] as List<dynamic>;
        final questions = questionsData.map((questionData) {
          final questionMap = questionData as Map<String, dynamic>;
          return Question(
            id: questionMap['id'] as String,
            sectionId: questionMap['sectionId'] as String,
            text: questionMap['text'] as String,
            inputType: QuestionType.values.firstWhere(
              (type) => type.name == questionMap['inputType'],
            ),
            required: questionMap['required'] as bool? ?? false,
            hint: questionMap['hint'] as String?,
            placeholder: questionMap['placeholder'] as String?,
            options: (questionMap['options'] as List<dynamic>?)?.cast<String>(),
            validation: questionMap['validation'] as Map<String, dynamic>?,
            metadata: questionMap['metadata'] as Map<String, dynamic>?,
            order: questionMap['order'] as int? ?? 0,
          );
        }).toList();

        // Parse existing messages (if any)
        final messagesData = sectionMap['messages'] as List<dynamic>? ?? [];
        final messages = messagesData.map((messageData) {
          final messageMap = messageData as Map<String, dynamic>;

          // Determine message type and create appropriate message
          if (messageMap.containsKey('questionId')) {
            // This is a QuestionAnswer message
            return QuestionAnswer(
              id: messageMap['id'] as String,
              sectionId: messageMap['sectionId'] as String,
              questionId: messageMap['questionId'] as String,
              questionText: messageMap['questionText'] as String,
              inputType: QuestionType.values.firstWhere(
                (type) => type.name == messageMap['inputType'],
              ),
              answer: messageMap['answer'],
              timestamp: DateTime.parse(messageMap['timestamp'] as String),
              messageType: MessageType.userAnswer,
              isEditable: messageMap['isEditable'] as bool? ?? true,
              formattedAnswer: messageMap['formattedAnswer'] as String?,
              validation: messageMap['validation'] != null
                ? ValidationStatus.fromJson(messageMap['validation'] as Map<String, dynamic>)
                : null,
              questionMetadata: messageMap['questionMetadata'] as Map<String, dynamic>?,
            );
          } else {
            // This is a BotMessage
            return BotMessage(
              id: messageMap['id'] as String,
              sectionId: messageMap['sectionId'] as String,
              content: messageMap['content'] as String,
              messageType: MessageType.values.firstWhere(
                (type) => type.name == messageMap['messageType'],
                orElse: () => MessageType.botIntro,
              ),
              timestamp: DateTime.parse(messageMap['timestamp'] as String),
              isEditable: messageMap['isEditable'] as bool? ?? false,
              context: messageMap['context'] as String?,
              metadata: messageMap['metadata'] as Map<String, dynamic>?,
            );
          }
        }).toList();

        // Create questionnaire section
        final questionnaireSection = QuestionnaireSection(
          id: sectionMap['id'] as String,
          title: sectionMap['title'] as String,
          description: sectionMap['description'] as String,
          questions: questions,
          messages: messages,
          sectionType: SectionType.questionnaire,
          status: SectionStatus.values.firstWhere(
            (status) => status.name == sectionMap['status'],
            orElse: () => SectionStatus.pending,
          ),
          createdAt: DateTime.parse(sectionMap['createdAt'] as String),
          completedAt: sectionMap['completedAt'] != null
            ? DateTime.parse(sectionMap['completedAt'] as String)
            : null,
        );
        sections.add(questionnaireSection);
      }

      return sections;
    } catch (e) {
      throw QuestionnaireLoadException(
        'Failed to parse questionnaire data: $e',
        cause: e,
      );
    }
  }

  /// Format answer for display
  String _formatAnswer(dynamic answer, QuestionType inputType) {
    switch (inputType) {
      case QuestionType.date:
        if (answer is DateTime) {
          return '${answer.day}/${answer.month}/${answer.year}';
        }
        return answer.toString();

      case QuestionType.multiselect:
        if (answer is List) {
          return answer.join(', ');
        }
        return answer.toString();

      case QuestionType.boolean:
        return answer == true ? 'Yes' : 'No';

      default:
        return answer.toString();
    }
  }

  /// Check if section is complete based on business rules
  Future<bool> _isSectionComplete(String sectionId) async {
    final section = await getSection(sectionId);
    if (section is! QuestionnaireSection) {
      return false;
    }

    // Business Logic: All required questions must be answered
    final requiredQuestions = section.questions.where((q) => q.required);
    final answeredQuestions = await getSectionAnswers(sectionId);

    for (final requiredQuestion in requiredQuestions) {
      final hasValidAnswer = answeredQuestions.any(
        (answer) => answer.questionId == requiredQuestion.id &&
                   (answer.validation?.isValid ?? false),
      );
      if (!hasValidAnswer) {
        return false;
      }
    }

    return true;
  }

  /// Handle section completion with business logic
  Future<void> _handleSectionCompletion(String sectionId) async {
    // Add completion message
    final section = await getSection(sectionId) as QuestionnaireSection?;
    if (section == null) return;

    final wrapupMessage = BotMessage(
      id: _generateId(),
      sectionId: sectionId,
      content: "Perfect! ${section.title} is complete. Let's move on to the next section.",
      messageType: MessageType.botWrapup,
      timestamp: DateTime.now(),
    );

    await addMessage(sectionId: sectionId, message: wrapupMessage);
    await markSectionComplete(sectionId);

    // Business Logic: Move to next section
    final nextSection = await _findNextSection(sectionId);
    if (nextSection != null) {
      await _startNextSection(nextSection.id);
    } else {
      // All sections complete
      await _completeQuestionnaire();
    }
  }

  /// Find next section in sequence
  Future<ChatSection?> _findNextSection(String currentSectionId) async {
    final sections = await getAllSections();
    final questionnaireSections = sections.whereType<QuestionnaireSection>().toList();

    final currentIndex = questionnaireSections.indexWhere((s) => s.id == currentSectionId);
    if (currentIndex != -1 && currentIndex + 1 < questionnaireSections.length) {
      return questionnaireSections[currentIndex + 1];
    }

    return null;
  }

  /// Start next section with intro message
  Future<void> _startNextSection(String sectionId) async {
    final section = await getSection(sectionId) as QuestionnaireSection?;
    if (section == null) return;

    // Add intro message for new section
    final introMessage = BotMessage(
      id: _generateId(),
      sectionId: sectionId,
      content: section.description,
      messageType: MessageType.botIntro,
      timestamp: DateTime.now(),
    );

    await addMessage(sectionId: sectionId, message: introMessage);
    await updateSectionStatus(sectionId: sectionId, status: SectionStatus.inProgress);

    // Update current section in state
    final currentState = await getCurrentState();
    final updatedState = currentState.copyWith(currentSectionId: sectionId);
    await saveCurrentState(updatedState);
  }

  /// Complete entire questionnaire
  Future<void> _completeQuestionnaire() async {
    final currentState = await getCurrentState();
    final completedState = currentState.copyWith(
      status: ChatStatus.completed,
      completedAt: DateTime.now(),
      currentSectionId: null,
      currentQuestionId: null,
    );

    await saveCurrentState(completedState);
  }

  /// Update conditional questions based on new answers
  Future<void> _updateConditionalQuestions(String sectionId) async {
    // Business Logic: Recalculate which questions should be visible
    final section = await getSection(sectionId) as QuestionnaireSection?;
    if (section == null) return;

    final answeredQuestions = await getSectionAnswers(sectionId);
    final visibleQuestions = await getConditionalQuestions(
      sectionId: sectionId,
      previousAnswers: answeredQuestions,
    );

    // Update section with visible questions (if needed for UI optimization)
    // This could involve updating metadata about visible questions
  }

  /// Validate if navigation to question is allowed
  Future<bool> _canNavigateToQuestion(Question question, QuestionnaireSection section) async {
    // Business Logic: Check if all dependencies are met
    final answeredQuestions = await getSectionAnswers(section.id);
    return await shouldShowQuestion(
      question: question,
      previousAnswers: answeredQuestions,
    );
  }

  /// Validate message deletion for dependency impact
  Future<void> _validateMessageDeletion(QuestionAnswer message, QuestionnaireSection section) async {
    // Business Logic: Check if any other questions depend on this answer
    for (final question in section.questions) {
      final showIf = question.metadata?['showIf'] as Map<String, dynamic>?;
      if (showIf?['questionId'] == message.questionId) {
        throw BusinessRuleException(
          'Cannot delete answer that other questions depend on',
          'dependency_violation',
          ruleData: {
            'dependentQuestionId': question.id,
            'dependsOnQuestionId': message.questionId,
          },
        );
      }
    }
  }

  /// Revalidate section completion after edits
  Future<void> _revalidateSectionCompletion(String sectionId) async {
    final isComplete = await _isSectionComplete(sectionId);
    final section = await getSection(sectionId);

    if (section?.status == SectionStatus.completed && !isComplete) {
      // Section was marked complete but no longer is due to edit
      await updateSectionStatus(sectionId: sectionId, status: SectionStatus.inProgress);
    } else if (section?.status != SectionStatus.completed && isComplete) {
      // Section is now complete due to edit
      await _handleSectionCompletion(sectionId);
    }
  }
}