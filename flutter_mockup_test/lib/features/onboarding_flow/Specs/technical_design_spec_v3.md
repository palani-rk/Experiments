# Technical Design Specification v3.0
## API-Ready Chat-Based Questionnaire Architecture

### Document Overview
**Version**: 3.0
**Date**: September 2025
**Purpose**: Granular persistence with API-ready architecture for questionnaire system
**Architecture**: Clean Architecture with Granular Services and Position Tracking

---

## 🏗️ Architecture Evolution

### **v2 → v3 Key Improvements**
1. **Granular Persistence**: Question/section-level operations instead of full state saves
2. **API-Ready Services**: Each operation maps directly to REST endpoints
3. **Position Tracking**: Comprehensive current state management for seamless resume
4. **Backend Transition**: Interface-based design for easy local→API migration
5. **Performance Optimization**: Minimal data transfer and efficient state updates

### **Core Architecture Principles**

#### **1. Unified Section Model** (Preserved from v2)
```
Everything is a Section → Sections contain Messages → Messages have Types
```

#### **2. Granular Operations** (New in v3)
```
Save Question Answer → Update Section Status → Track Position → Minimal Network/Storage
```

#### **3. Interface-Based Services** (Enhanced in v3)
```
PersistenceService (Interface)
    ↓ implementations
├── LocalPersistenceService (SharedPreferences)
└── ApiPersistenceService (HTTP REST API)
```

---

## 📁 File Structure Architecture (v3 Updates)

### **Updated Directory Layout**
```
lib/features/onboarding_flow/
├── data/
│   ├── models/
│   │   ├── core/
│   │   │   ├── chat_section.dart              # Abstract base classes
│   │   │   ├── section_message.dart           # Message interfaces
│   │   │   └── enums.dart                     # Shared enums
│   │   ├── sections/
│   │   │   ├── intro_section.dart             # Welcome/intro section
│   │   │   ├── questionnaire_section.dart     # Q&A section
│   │   │   └── media_section.dart             # Future: media content
│   │   ├── messages/
│   │   │   ├── bot_message.dart               # Bot messages
│   │   │   ├── question_answer.dart           # Q&A messages
│   │   │   └── media_message.dart             # Future: media messages
│   │   ├── support/
│   │   │   ├── question.dart                  # Question model
│   │   │   ├── validation_status.dart         # Validation results
│   │   │   ├── chat_state.dart                # Main state model
│   │   │   ├── questionnaire_position.dart    # 🆕 Position tracking
│   │   │   ├── questionnaire_session.dart     # 🆕 Session metadata
│   │   │   └── question_answer_data.dart      # 🆕 API transfer object
│   │   └── generated/                         # Freezed generated files
│   └── services/
│       ├── interfaces/
│       │   ├── questionnaire_service.dart     # 🔄 Main business logic service
│       │   ├── persistence_service.dart       # 🆕 Granular persistence interface
│       │   └── validation_service.dart        # Validation interface
│       ├── implementations/
│       │   ├── questionnaire_service_impl.dart    # 🆕 Business logic implementation
│       │   ├── local_persistence_service.dart     # 🆕 SharedPreferences impl
│       │   ├── api_persistence_service.dart       # 🆕 HTTP API impl
│       │   └── default_validation_service.dart    # Validation implementation
│       └── exceptions/
│           ├── questionnaire_exceptions.dart  # Service exceptions
│           └── persistence_exceptions.dart    # 🆕 Persistence exceptions
├── presentation/
│   ├── providers/
│   │   ├── questionnaire_state_provider.dart  # 🔄 Main state provider
│   │   ├── service_providers.dart             # Service dependency injection
│   │   ├── position_provider.dart             # 🆕 Position tracking provider
│   │   ├── progress_providers.dart            # Progress calculation providers
│   │   └── validation_providers.dart          # Validation providers
│   ├── pages/
│   │   ├── chat_questionnaire_view.dart       # Main orchestration page
│   │   └── chat_completion_view.dart          # Completion page
│   ├── widgets/
│   │   ├── core/
│   │   │   ├── chat_header_widget.dart        # Progress + info header
│   │   │   ├── chat_history_widget.dart       # Scrollable section list
│   │   │   ├── chat_progress_indicator.dart   # Overall progress
│   │   │   ├── chat_loading_widget.dart       # Loading states
│   │   │   └── chat_error_widget.dart         # Error states
│   │   ├── sections/
│   │   │   ├── base_section_widget.dart       # Abstract section widget
│   │   │   ├── intro_section_widget.dart      # Intro section
│   │   │   ├── questionnaire_section_widget.dart # Q&A section
│   │   │   └── section_widget_factory.dart    # Section factory
│   │   ├── messages/
│   │   │   ├── bot_message_widget.dart        # Bot message bubbles
│   │   │   ├── question_answer_widget.dart    # Q&A display
│   │   │   ├── media_message_widget.dart      # Future: media
│   │   │   └── message_widget_factory.dart    # Message factory
│   │   ├── input/
│   │   │   ├── current_question_input_widget.dart # Bottom input area
│   │   │   ├── question_input_factory.dart    # Input widget factory
│   │   │   └── question_inputs/               # Specific input widgets
│   │   │       ├── text_input_widget.dart
│   │   │       ├── number_input_widget.dart
│   │   │       ├── radio_input_widget.dart
│   │   │       ├── multiselect_input_widget.dart
│   │   │       ├── slider_input_widget.dart
│   │   │       └── date_input_widget.dart
│   │   └── common/
│   │       ├── section_header_widget.dart     # Section title + status
│   │       ├── progress_widgets.dart          # Progress components
│   │       └── validation_widgets.dart        # Validation UI
│   └── utils/
│       ├── navigation_helper.dart             # Navigation logic
│       ├── message_formatter.dart             # Display formatting
│       └── validation_helper.dart             # UI validation helpers
├── assets/
│   └── questionnaire_data.json               # Questionnaire structure
└── Specs/
    ├── technical_design_spec_v3.md            # This document
    ├── technical_design_spec_v2.md            # Previous version
    └── Implementation_Progress.md             # Progress tracking
```

---

## 📊 Enhanced Data Models (v3)

### **Position Tracking Models** (New in v3)

#### **QuestionnairePosition**
```dart
@freezed
class QuestionnairePosition with _$QuestionnairePosition {
  const factory QuestionnairePosition({
    required String currentSectionId,
    String? currentQuestionId,        // Next question to display
    String? lastAnsweredQuestionId,   // Last completed question
    required int currentQuestionIndex, // 0-based index in section
    required bool canNavigateBack,    // Navigation permissions
    required bool canSkipSection,
    required DateTime lastUpdated,
    @Default({}) Map<String, dynamic> metadata, // Extension data
  }) = _QuestionnairePosition;

  // Business Logic
  bool get isAtSectionStart => currentQuestionIndex == 0;
  bool get hasProgress => lastAnsweredQuestionId != null;

  factory QuestionnairePosition.fromJson(Map<String, dynamic> json) =>
      _$QuestionnairePositionFromJson(json);
}
```

#### **QuestionnaireSession**
```dart
@freezed
class QuestionnaireSession with _$QuestionnaireSession {
  const factory QuestionnaireSession({
    required String sessionId,
    required QuestionnairePosition position,
    required ChatStatus status,
    required DateTime createdAt,
    DateTime? completedAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _QuestionnaireSession;

  // Computed Properties
  Duration get duration => DateTime.now().difference(createdAt);
  bool get isActive => status == ChatStatus.inProgress;

  factory QuestionnaireSession.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireSessionFromJson(json);
}
```

#### **QuestionAnswerData** (API Transfer Object)
```dart
@freezed
class QuestionAnswerData with _$QuestionAnswerData {
  const factory QuestionAnswerData({
    required String sectionId,
    required String questionId,
    required dynamic answer,
    required String formattedAnswer,
    required DateTime timestamp,
    ValidationStatus? validation,
    @Default({}) Map<String, dynamic> metadata,
  }) = _QuestionAnswerData;

  factory QuestionAnswerData.fromJson(Map<String, dynamic> json) =>
      _$QuestionAnswerDataFromJson(json);
}
```

### **Enhanced Core Models** (Building on v2)

#### **ChatState** (Enhanced with Position)
```dart
@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    required String sessionId,
    required List<ChatSection> sections,
    required QuestionnairePosition position, // 🆕 Granular position tracking
    @Default(ChatStatus.notStarted) ChatStatus status,
    required DateTime createdAt,
    DateTime? completedAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _ChatState;

  // Computed Properties (Enhanced)
  ChatSection? get currentSection => sections.firstWhereOrNull(
    (s) => s.id == position.currentSectionId
  );

  Question? get currentQuestion => _getCurrentQuestion();
  double get overallProgress => _calculateProgress();
  bool get isComplete => status == ChatStatus.completed;
  bool get canProceed => _canProceedToNext();

  // Position-aware helpers
  QuestionnaireSection? get currentQuestionnaireSection =>
    currentSection is QuestionnaireSection
      ? currentSection as QuestionnaireSection
      : null;

  factory ChatState.fromJson(Map<String, dynamic> json) =>
      _$ChatStateFromJson(json);
}

enum ChatStatus { notStarted, inProgress, completed, abandoned, paused }
```

---

## 🔧 Granular Service Architecture (v3)

### **Core Service Interfaces**

#### **PersistenceService** (New Granular Interface)
```dart
abstract class PersistenceService {
  // ========================================================================
  // Session Management
  // ========================================================================

  /// Initialize or load existing questionnaire session
  /// Maps to: POST /api/questionnaire/init or GET /api/questionnaire/current
  Future<QuestionnaireSession?> loadSession();

  /// Save session metadata
  /// Maps to: PUT /api/questionnaire/session
  Future<void> saveSession(QuestionnaireSession session);

  /// Clear current session
  /// Maps to: DELETE /api/questionnaire/current
  Future<void> clearSession();

  // ========================================================================
  // Question-Level Operations (Granular)
  // ========================================================================

  /// Save a new question answer
  /// Maps to: POST /api/questionnaire/answers
  Future<void> saveQuestionAnswer(QuestionAnswerData data);

  /// Update an existing question answer
  /// Maps to: PUT /api/questionnaire/answers/{questionId}
  Future<void> updateQuestionAnswer(QuestionAnswerData data);

  /// Delete a question answer
  /// Maps to: DELETE /api/questionnaire/answers/{questionId}
  Future<void> deleteQuestionAnswer({
    required String sectionId,
    required String questionId,
  });

  /// Get specific question answer
  /// Maps to: GET /api/questionnaire/answers/{questionId}
  Future<QuestionAnswer?> getQuestionAnswer({
    required String sectionId,
    required String questionId,
  });

  // ========================================================================
  // Section-Level Operations (Granular)
  // ========================================================================

  /// Update section status and metadata
  /// Maps to: PUT /api/questionnaire/sections/{sectionId}
  Future<void> updateSectionStatus({
    required String sectionId,
    required SectionStatus status,
    DateTime? completedAt,
    Map<String, dynamic>? metadata,
  });

  /// Add a message to a section
  /// Maps to: POST /api/questionnaire/sections/{sectionId}/messages
  Future<void> addSectionMessage({
    required String sectionId,
    required SectionMessage message,
  });

  /// Update a section message
  /// Maps to: PUT /api/questionnaire/sections/{sectionId}/messages/{messageId}
  Future<void> updateSectionMessage({
    required String sectionId,
    required String messageId,
    required SectionMessage message,
  });

  /// Delete a section message
  /// Maps to: DELETE /api/questionnaire/sections/{sectionId}/messages/{messageId}
  Future<void> deleteSectionMessage({
    required String sectionId,
    required String messageId,
  });

  /// Get all answers for a section
  /// Maps to: GET /api/questionnaire/sections/{sectionId}/answers
  Future<List<QuestionAnswer>> getSectionAnswers(String sectionId);

  /// Get all messages for a section
  /// Maps to: GET /api/questionnaire/sections/{sectionId}/messages
  Future<List<SectionMessage>> getSectionMessages(String sectionId);

  // ========================================================================
  // Position Tracking (Granular)
  // ========================================================================

  /// Update current position
  /// Maps to: PUT /api/questionnaire/position
  Future<void> updatePosition(QuestionnairePosition position);

  /// Get current position
  /// Maps to: GET /api/questionnaire/position
  Future<QuestionnairePosition?> getCurrentPosition();

  // ========================================================================
  // Questionnaire Structure (Read-only)
  // ========================================================================

  /// Load questionnaire structure from assets/API
  /// Maps to: GET /api/questionnaire/structure
  Future<List<ChatSection>> loadQuestionnaireStructure();

  // ========================================================================
  // Batch Operations (for sync/recovery)
  // ========================================================================

  /// Sync all local changes to backend (offline support)
  /// Maps to: POST /api/questionnaire/sync
  Future<void> syncAllChanges();

  /// Export complete state for recovery
  /// Maps to: GET /api/questionnaire/export
  Future<ChatState> exportFullState();

  // ========================================================================
  // Cache Management
  // ========================================================================

  Future<bool> hasLocalData();
  Future<void> clearLocalCache();
  Future<bool> validateIntegrity();
}
```

#### **QuestionnaireService** (Enhanced Business Logic)
```dart
abstract class QuestionnaireService {
  // ========================================================================
  // Core Operations (Orchestration + Business Logic)
  // ========================================================================

  /// Initialize questionnaire session
  Future<ChatState> initialize();

  /// Submit answer with full business rule validation
  Future<void> submitAnswer({
    required String questionId,
    required dynamic answer,
  });

  /// Edit existing answer with validation
  Future<void> editAnswer({
    required String sectionId,
    required String questionId,
    required dynamic newAnswer,
  });

  /// Navigate to specific question
  Future<void> navigateToQuestion(String questionId);

  // ========================================================================
  // Section Management (Business Logic)
  // ========================================================================

  /// Complete current section
  Future<void> completeSection(String sectionId);

  /// Start next section
  Future<void> startNextSection();

  /// Check if can proceed to next section
  Future<bool> canProceedToNextSection(String sectionId);

  // ========================================================================
  // State Access (Computed Properties)
  // ========================================================================

  /// Get current complete state
  Future<ChatState> getCurrentState();

  /// Get current question
  Future<Question?> getCurrentQuestion();

  /// Get current position
  Future<QuestionnairePosition> getPosition();

  /// Get progress metrics
  Future<double> getOverallProgress();
  Future<double> getSectionProgress(String sectionId);

  // ========================================================================
  // Navigation & Business Rules
  // ========================================================================

  /// Check navigation permissions
  Future<bool> canNavigateBack();
  Future<void> navigateBack();

  /// Get visible questions based on conditions
  Future<List<Question>> getVisibleQuestions(String sectionId);

  /// Validate business rules
  Future<ValidationStatus> validateBusinessRules();

  // ========================================================================
  // Session Management
  // ========================================================================

  /// Reset questionnaire
  Future<void> reset();

  /// Pause session
  Future<void> pause();

  /// Resume session
  Future<void> resume();
}
```

### **Service Implementations**

#### **QuestionnaireServiceImpl** (Business Logic Implementation)
```dart
class QuestionnaireServiceImpl implements QuestionnaireService {
  final PersistenceService _persistence;
  final ValidationService _validation;

  QuestionnaireServiceImpl(this._persistence, this._validation);

  @override
  Future<ChatState> initialize() async {
    try {
      // Load existing session
      final session = await _persistence.loadSession();

      if (session != null) {
        // Resume existing session
        final position = await _persistence.getCurrentPosition();
        final sections = await _loadSectionsWithData();

        return ChatState(
          sessionId: session.sessionId,
          sections: sections,
          position: position ?? _createDefaultPosition(sections),
          status: session.status,
          createdAt: session.createdAt,
          completedAt: session.completedAt,
          metadata: session.metadata,
        );
      } else {
        // Create new session
        final questionnaireStructure = await _persistence.loadQuestionnaireStructure();
        final sessionId = _generateSessionId();
        final position = _createInitialPosition(questionnaireStructure);

        final session = QuestionnaireSession(
          sessionId: sessionId,
          position: position,
          status: ChatStatus.inProgress,
          createdAt: DateTime.now(),
        );

        await _persistence.saveSession(session);
        await _persistence.updatePosition(position);

        return ChatState(
          sessionId: sessionId,
          sections: questionnaireStructure,
          position: position,
          status: ChatStatus.inProgress,
          createdAt: DateTime.now(),
        );
      }
    } catch (e) {
      throw QuestionnaireInitializationException('Failed to initialize: $e');
    }
  }

  @override
  Future<void> submitAnswer({
    required String questionId,
    required dynamic answer,
  }) async {
    try {
      // Business Logic: Get current position and validate
      final position = await _persistence.getCurrentPosition();
      if (position == null) {
        throw InvalidStateException('No active session position');
      }

      // Business Logic: Validate answer
      final validation = await _validation.validateAnswer(
        questionId: questionId,
        answer: answer,
      );

      if (!validation.isValid) {
        throw ValidationException(
          'Answer validation failed: ${validation.primaryError}',
          questionId,
          answer,
        );
      }

      // Business Logic: Create answer data
      final answerData = QuestionAnswerData(
        sectionId: position.currentSectionId,
        questionId: questionId,
        answer: answer,
        formattedAnswer: _formatAnswer(answer),
        timestamp: DateTime.now(),
        validation: validation,
      );

      // Granular Operation: Save answer
      await _persistence.saveQuestionAnswer(answerData);

      // Business Logic: Create answer message
      final answerMessage = _createAnswerMessage(answerData, position);

      // Granular Operation: Add message to section
      await _persistence.addSectionMessage(
        sectionId: position.currentSectionId,
        message: answerMessage,
      );

      // Business Logic: Calculate next position
      final nextPosition = await _calculateNextPosition(position, questionId);

      // Granular Operation: Update position
      await _persistence.updatePosition(nextPosition);

      // Business Logic: Check section completion
      if (await _isSectionComplete(position.currentSectionId)) {
        await _handleSectionCompletion(position.currentSectionId);
      }

    } catch (e) {
      throw AnswerSubmissionException('Failed to submit answer: $e');
    }
  }

  @override
  Future<void> editAnswer({
    required String sectionId,
    required String questionId,
    required dynamic newAnswer,
  }) async {
    try {
      // Business Logic: Validate new answer
      final validation = await _validation.validateAnswer(
        questionId: questionId,
        answer: newAnswer,
      );

      if (!validation.isValid) {
        throw ValidationException(
          'New answer validation failed: ${validation.primaryError}',
          questionId,
          newAnswer,
        );
      }

      // Business Logic: Create updated answer data
      final answerData = QuestionAnswerData(
        sectionId: sectionId,
        questionId: questionId,
        answer: newAnswer,
        formattedAnswer: _formatAnswer(newAnswer),
        timestamp: DateTime.now(),
        validation: validation,
      );

      // Granular Operation: Update answer
      await _persistence.updateQuestionAnswer(answerData);

      // Business Logic: Find and update corresponding message
      final existingMessage = await _findAnswerMessage(sectionId, questionId);
      if (existingMessage != null) {
        final updatedMessage = _updateAnswerMessage(existingMessage, answerData);

        // Granular Operation: Update message
        await _persistence.updateSectionMessage(
          sectionId: sectionId,
          messageId: existingMessage.id,
          message: updatedMessage,
        );
      }

      // Business Logic: Recalculate conditional questions
      await _updateConditionalQuestions(sectionId);

      // Business Logic: Update position timestamp
      final position = await _persistence.getCurrentPosition();
      if (position != null) {
        await _persistence.updatePosition(
          position.copyWith(lastUpdated: DateTime.now())
        );
      }

    } catch (e) {
      throw AnswerEditException('Failed to edit answer: $e');
    }
  }

  @override
  Future<void> completeSection(String sectionId) async {
    try {
      // Business Logic: Validate section completion
      if (!await _isSectionComplete(sectionId)) {
        throw SectionIncompleteException(
          'Section cannot be completed: missing required answers',
          sectionId,
        );
      }

      // Granular Operation: Update section status
      await _persistence.updateSectionStatus(
        sectionId: sectionId,
        status: SectionStatus.completed,
        completedAt: DateTime.now(),
      );

      // Business Logic: Add completion message
      final wrapupMessage = _createWrapupMessage(sectionId);

      // Granular Operation: Add completion message
      await _persistence.addSectionMessage(
        sectionId: sectionId,
        message: wrapupMessage,
      );

      // Business Logic: Move to next section
      await _moveToNextSection(sectionId);

    } catch (e) {
      throw SectionCompletionException('Failed to complete section: $e');
    }
  }

  @override
  Future<ChatState> getCurrentState() async {
    try {
      final session = await _persistence.loadSession();
      final position = await _persistence.getCurrentPosition();
      final sections = await _loadSectionsWithData();

      if (session == null || position == null) {
        throw StateLoadException('No active session or position found');
      }

      return ChatState(
        sessionId: session.sessionId,
        sections: sections,
        position: position,
        status: session.status,
        createdAt: session.createdAt,
        completedAt: session.completedAt,
        metadata: session.metadata,
      );
    } catch (e) {
      throw StateLoadException('Failed to load current state: $e');
    }
  }

  @override
  Future<Question?> getCurrentQuestion() async {
    try {
      final position = await _persistence.getCurrentPosition();
      if (position?.currentQuestionId == null) return null;

      final sections = await _loadSectionsWithData();
      final currentSection = sections.firstWhereOrNull(
        (s) => s.id == position!.currentSectionId,
      ) as QuestionnaireSection?;

      return currentSection?.questions.firstWhereOrNull(
        (q) => q.id == position!.currentQuestionId,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<double> getOverallProgress() async {
    try {
      final sections = await _loadSectionsWithData();
      final questionnaireSections = sections.whereType<QuestionnaireSection>().toList();

      if (questionnaireSections.isEmpty) return 0.0;

      double totalProgress = 0.0;
      for (final section in questionnaireSections) {
        totalProgress += await getSectionProgress(section.id);
      }

      return totalProgress / questionnaireSections.length;
    } catch (e) {
      return 0.0;
    }
  }

  @override
  Future<double> getSectionProgress(String sectionId) async {
    try {
      final answers = await _persistence.getSectionAnswers(sectionId);
      final sections = await _loadSectionsWithData();

      final section = sections.firstWhereOrNull(
        (s) => s.id == sectionId,
      ) as QuestionnaireSection?;

      if (section == null) return 0.0;

      final totalQuestions = section.questions.length;
      if (totalQuestions == 0) return 1.0;

      final validAnswers = answers.where(
        (answer) => answer.validation?.isValid ?? false,
      ).length;

      return validAnswers / totalQuestions;
    } catch (e) {
      return 0.0;
    }
  }

  // Private Business Logic Methods
  Future<QuestionnairePosition> _calculateNextPosition(
    QuestionnairePosition currentPosition,
    String answeredQuestionId,
  ) async {
    // Business Logic: Find next question in section
    final sections = await _loadSectionsWithData();
    final currentSection = sections.firstWhereOrNull(
      (s) => s.id == currentPosition.currentSectionId,
    ) as QuestionnaireSection?;

    if (currentSection == null) return currentPosition;

    final questions = currentSection.questions;
    final currentIndex = questions.indexWhere(
      (q) => q.id == answeredQuestionId,
    );

    if (currentIndex == -1) return currentPosition;

    // Find next unanswered question
    final answeredQuestions = await _persistence.getSectionAnswers(currentSection.id);
    final answeredQuestionIds = answeredQuestions.map((a) => a.questionId).toSet();

    for (int i = currentIndex + 1; i < questions.length; i++) {
      final question = questions[i];
      if (!answeredQuestionIds.contains(question.id)) {
        // Check if question should be shown based on conditions
        if (await _shouldShowQuestion(question, answeredQuestions)) {
          return currentPosition.copyWith(
            currentQuestionId: question.id,
            lastAnsweredQuestionId: answeredQuestionId,
            currentQuestionIndex: i,
            canNavigateBack: true,
            lastUpdated: DateTime.now(),
          );
        }
      }
    }

    // No more questions in section
    return currentPosition.copyWith(
      currentQuestionId: null,
      lastAnsweredQuestionId: answeredQuestionId,
      currentQuestionIndex: questions.length,
      lastUpdated: DateTime.now(),
    );
  }

  Future<bool> _isSectionComplete(String sectionId) async {
    final sections = await _loadSectionsWithData();
    final section = sections.firstWhereOrNull(
      (s) => s.id == sectionId,
    ) as QuestionnaireSection?;

    if (section == null) return false;

    final requiredQuestions = section.questions.where((q) => q.required);
    final answeredQuestions = await _persistence.getSectionAnswers(sectionId);

    for (final requiredQuestion in requiredQuestions) {
      final hasValidAnswer = answeredQuestions.any(
        (answer) => answer.questionId == requiredQuestion.id &&
                   (answer.validation?.isValid ?? false),
      );
      if (!hasValidAnswer) return false;
    }

    return true;
  }

  Future<void> _handleSectionCompletion(String sectionId) async {
    await completeSection(sectionId);
  }

  Future<void> _moveToNextSection(String completedSectionId) async {
    final sections = await _loadSectionsWithData();
    final questionnaireSections = sections.whereType<QuestionnaireSection>().toList();

    final currentIndex = questionnaireSections.indexWhere(
      (s) => s.id == completedSectionId,
    );

    if (currentIndex != -1 && currentIndex + 1 < questionnaireSections.length) {
      final nextSection = questionnaireSections[currentIndex + 1];

      // Start next section
      await _startSection(nextSection.id);
    } else {
      // All sections complete - finish questionnaire
      await _completeQuestionnaire();
    }
  }

  Future<void> _startSection(String sectionId) async {
    final sections = await _loadSectionsWithData();
    final section = sections.firstWhereOrNull(
      (s) => s.id == sectionId,
    ) as QuestionnaireSection?;

    if (section == null) return;

    // Update section status
    await _persistence.updateSectionStatus(
      sectionId: sectionId,
      status: SectionStatus.inProgress,
    );

    // Add intro message
    final introMessage = BotMessage.intro(
      sectionId: sectionId,
      content: section.description,
    );

    await _persistence.addSectionMessage(
      sectionId: sectionId,
      message: introMessage,
    );

    // Update position to first question
    final firstQuestion = section.questions.firstOrNull;
    final newPosition = QuestionnairePosition(
      currentSectionId: sectionId,
      currentQuestionId: firstQuestion?.id,
      lastAnsweredQuestionId: null,
      currentQuestionIndex: 0,
      canNavigateBack: true,
      canSkipSection: false,
      lastUpdated: DateTime.now(),
    );

    await _persistence.updatePosition(newPosition);
  }

  Future<void> _completeQuestionnaire() async {
    final session = await _persistence.loadSession();
    if (session == null) return;

    final completedSession = session.copyWith(
      status: ChatStatus.completed,
      completedAt: DateTime.now(),
    );

    await _persistence.saveSession(completedSession);
  }

  // Helper methods for data formatting and utilities
  String _formatAnswer(dynamic answer) {
    if (answer is List) {
      return answer.join(', ');
    } else if (answer is DateTime) {
      return '${answer.day}/${answer.month}/${answer.year}';
    } else if (answer is bool) {
      return answer ? 'Yes' : 'No';
    }
    return answer.toString();
  }

  String _generateSessionId() {
    return 'session_${DateTime.now().millisecondsSinceEpoch}';
  }

  QuestionnairePosition _createInitialPosition(List<ChatSection> sections) {
    final firstQuestionnaireSection = sections.firstWhereOrNull(
      (s) => s.sectionType == SectionType.questionnaire,
    ) as QuestionnaireSection?;

    return QuestionnairePosition(
      currentSectionId: firstQuestionnaireSection?.id ?? '',
      currentQuestionId: firstQuestionnaireSection?.questions.firstOrNull?.id,
      lastAnsweredQuestionId: null,
      currentQuestionIndex: 0,
      canNavigateBack: false,
      canSkipSection: false,
      lastUpdated: DateTime.now(),
    );
  }

  // Additional helper methods...
  Future<List<ChatSection>> _loadSectionsWithData() async {
    // Implementation to load sections with their current messages
    // This assembles the complete section data from granular storage
    throw UnimplementedError('Implementation needed');
  }

  Future<bool> _shouldShowQuestion(Question question, List<QuestionAnswer> previousAnswers) async {
    // Business Logic: Question visibility based on conditions
    // Implementation of conditional question logic
    throw UnimplementedError('Implementation needed');
  }

  // Additional business logic methods...
}
```

#### **LocalPersistenceService** (SharedPreferences Implementation)
```dart
class LocalPersistenceService implements PersistenceService {
  // Storage keys
  static const String _sessionKey = 'questionnaire_session';
  static const String _positionKey = 'questionnaire_position';
  static const String _answerPrefix = 'answer_';
  static const String _sectionStatusPrefix = 'section_status_';
  static const String _sectionMessagePrefix = 'section_messages_';

  @override
  Future<QuestionnaireSession?> loadSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = prefs.getString(_sessionKey);

      if (sessionJson == null) return null;

      return QuestionnaireSession.fromJson(
        json.decode(sessionJson) as Map<String, dynamic>,
      );
    } catch (e) {
      throw PersistenceException('Failed to load session: $e');
    }
  }

  @override
  Future<void> saveSession(QuestionnaireSession session) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = json.encode(session.toJson());

      final success = await prefs.setString(_sessionKey, sessionJson);
      if (!success) {
        throw PersistenceException('Failed to save session');
      }
    } catch (e) {
      throw PersistenceException('Failed to save session: $e');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Remove all questionnaire-related keys
      final keys = prefs.getKeys().where(
        (key) => key.startsWith('questionnaire_') ||
                key.startsWith('answer_') ||
                key.startsWith('section_'),
      ).toList();

      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      throw PersistenceException('Failed to clear session: $e');
    }
  }

  @override
  Future<void> saveQuestionAnswer(QuestionAnswerData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_answerPrefix}${data.sectionId}_${data.questionId}';
      final json = jsonEncode(data.toJson());

      final success = await prefs.setString(key, json);
      if (!success) {
        throw PersistenceException('Failed to save question answer');
      }
    } catch (e) {
      throw PersistenceException('Failed to save question answer: $e');
    }
  }

  @override
  Future<void> updateQuestionAnswer(QuestionAnswerData data) async {
    // Same implementation as saveQuestionAnswer for local storage
    await saveQuestionAnswer(data);
  }

  @override
  Future<void> deleteQuestionAnswer({
    required String sectionId,
    required String questionId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_answerPrefix}${sectionId}_$questionId';
      await prefs.remove(key);
    } catch (e) {
      throw PersistenceException('Failed to delete question answer: $e');
    }
  }

  @override
  Future<QuestionAnswer?> getQuestionAnswer({
    required String sectionId,
    required String questionId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_answerPrefix}${sectionId}_$questionId';
      final answerJson = prefs.getString(key);

      if (answerJson == null) return null;

      final data = QuestionAnswerData.fromJson(
        json.decode(answerJson) as Map<String, dynamic>,
      );

      // Convert QuestionAnswerData to QuestionAnswer
      return _convertToQuestionAnswer(data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<QuestionAnswer>> getSectionAnswers(String sectionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      final sectionAnswerKeys = keys.where(
        (key) => key.startsWith('${_answerPrefix}${sectionId}_'),
      );

      final List<QuestionAnswer> answers = [];

      for (final key in sectionAnswerKeys) {
        final answerJson = prefs.getString(key);
        if (answerJson != null) {
          final data = QuestionAnswerData.fromJson(
            json.decode(answerJson) as Map<String, dynamic>,
          );
          answers.add(_convertToQuestionAnswer(data));
        }
      }

      return answers;
    } catch (e) {
      throw PersistenceException('Failed to get section answers: $e');
    }
  }

  @override
  Future<void> updateSectionStatus({
    required String sectionId,
    required SectionStatus status,
    DateTime? completedAt,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_sectionStatusPrefix}$sectionId';

      final statusData = {
        'status': status.name,
        'completedAt': completedAt?.toIso8601String(),
        'metadata': metadata ?? {},
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final success = await prefs.setString(key, json.encode(statusData));
      if (!success) {
        throw PersistenceException('Failed to update section status');
      }
    } catch (e) {
      throw PersistenceException('Failed to update section status: $e');
    }
  }

  @override
  Future<void> addSectionMessage({
    required String sectionId,
    required SectionMessage message,
  }) async {
    try {
      final messages = await getSectionMessages(sectionId);
      messages.add(message);
      await _saveSectionMessages(sectionId, messages);
    } catch (e) {
      throw PersistenceException('Failed to add section message: $e');
    }
  }

  @override
  Future<void> updateSectionMessage({
    required String sectionId,
    required String messageId,
    required SectionMessage message,
  }) async {
    try {
      final messages = await getSectionMessages(sectionId);
      final index = messages.indexWhere((m) => m.id == messageId);

      if (index != -1) {
        messages[index] = message;
        await _saveSectionMessages(sectionId, messages);
      }
    } catch (e) {
      throw PersistenceException('Failed to update section message: $e');
    }
  }

  @override
  Future<void> deleteSectionMessage({
    required String sectionId,
    required String messageId,
  }) async {
    try {
      final messages = await getSectionMessages(sectionId);
      messages.removeWhere((m) => m.id == messageId);
      await _saveSectionMessages(sectionId, messages);
    } catch (e) {
      throw PersistenceException('Failed to delete section message: $e');
    }
  }

  @override
  Future<List<SectionMessage>> getSectionMessages(String sectionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_sectionMessagePrefix}$sectionId';
      final messagesJson = prefs.getString(key);

      if (messagesJson == null) return [];

      final messagesList = json.decode(messagesJson) as List<dynamic>;
      return messagesList.map((msgJson) =>
        _convertToSectionMessage(msgJson as Map<String, dynamic>)
      ).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> updatePosition(QuestionnairePosition position) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final positionJson = json.encode(position.toJson());

      final success = await prefs.setString(_positionKey, positionJson);
      if (!success) {
        throw PersistenceException('Failed to update position');
      }
    } catch (e) {
      throw PersistenceException('Failed to update position: $e');
    }
  }

  @override
  Future<QuestionnairePosition?> getCurrentPosition() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final positionJson = prefs.getString(_positionKey);

      if (positionJson == null) return null;

      return QuestionnairePosition.fromJson(
        json.decode(positionJson) as Map<String, dynamic>,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ChatSection>> loadQuestionnaireStructure() async {
    try {
      // Load from assets
      final jsonString = await rootBundle.loadString(
        'assets/questionnaire_data.json',
      );
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;

      return _parseQuestionnaireStructure(jsonData);
    } catch (e) {
      throw PersistenceException('Failed to load questionnaire structure: $e');
    }
  }

  @override
  Future<void> syncAllChanges() async {
    // No-op for local storage
    // In API implementation, this would sync local changes to server
  }

  @override
  Future<ChatState> exportFullState() async {
    try {
      final session = await loadSession();
      final position = await getCurrentPosition();
      final sections = await loadQuestionnaireStructure();

      if (session == null || position == null) {
        throw PersistenceException('Incomplete state for export');
      }

      // Load all section data
      final sectionsWithData = await _loadSectionsWithData(sections);

      return ChatState(
        sessionId: session.sessionId,
        sections: sectionsWithData,
        position: position,
        status: session.status,
        createdAt: session.createdAt,
        completedAt: session.completedAt,
        metadata: session.metadata,
      );
    } catch (e) {
      throw PersistenceException('Failed to export full state: $e');
    }
  }

  @override
  Future<bool> hasLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_sessionKey);
  }

  @override
  Future<void> clearLocalCache() async {
    await clearSession();
  }

  @override
  Future<bool> validateIntegrity() async {
    try {
      final session = await loadSession();
      final position = await getCurrentPosition();

      if (session == null || position == null) return false;

      // Basic validation
      return session.sessionId.isNotEmpty &&
             position.currentSectionId.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Private helper methods
  Future<void> _saveSectionMessages(String sectionId, List<SectionMessage> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_sectionMessagePrefix}$sectionId';

    final messagesJson = json.encode(
      messages.map((msg) => _convertSectionMessageToJson(msg)).toList(),
    );

    await prefs.setString(key, messagesJson);
  }

  QuestionAnswer _convertToQuestionAnswer(QuestionAnswerData data) {
    return QuestionAnswer(
      id: 'qa_${data.questionId}_${data.timestamp.millisecondsSinceEpoch}',
      sectionId: data.sectionId,
      questionId: data.questionId,
      questionText: '', // Would need to lookup from structure
      inputType: QuestionType.text, // Would need to lookup from structure
      answer: data.answer,
      timestamp: data.timestamp,
      formattedAnswer: data.formattedAnswer,
      validation: data.validation,
    );
  }

  SectionMessage _convertToSectionMessage(Map<String, dynamic> json) {
    // Convert JSON back to appropriate SectionMessage subtype
    final messageType = MessageType.values.firstWhere(
      (type) => type.name == json['messageType'],
    );

    switch (messageType) {
      case MessageType.botIntro:
      case MessageType.botWrapup:
        return BotMessage.fromJson(json);
      case MessageType.userAnswer:
        return QuestionAnswer.fromJson(json);
      default:
        throw PersistenceException('Unknown message type: $messageType');
    }
  }

  Map<String, dynamic> _convertSectionMessageToJson(SectionMessage message) {
    if (message is BotMessage) {
      return message.toJson();
    } else if (message is QuestionAnswer) {
      return message.toJson();
    } else {
      throw PersistenceException('Unknown message type: ${message.runtimeType}');
    }
  }

  List<ChatSection> _parseQuestionnaireStructure(Map<String, dynamic> jsonData) {
    // Parse questionnaire structure from JSON
    // Implementation would convert JSON to ChatSection objects
    throw UnimplementedError('Implementation needed');
  }

  Future<List<ChatSection>> _loadSectionsWithData(List<ChatSection> baseStructure) async {
    // Load current messages and status for each section
    // Implementation would populate sections with their current state
    throw UnimplementedError('Implementation needed');
  }
}
```

#### **ApiPersistenceService** (HTTP API Implementation)
```dart
class ApiPersistenceService implements PersistenceService {
  final String baseUrl;
  final Dio _dio;

  ApiPersistenceService({
    required this.baseUrl,
    required Dio dio,
  }) : _dio = dio;

  @override
  Future<QuestionnaireSession?> loadSession() async {
    try {
      final response = await _dio.get('$baseUrl/api/questionnaire/current');

      if (response.statusCode == 200 && response.data != null) {
        return QuestionnaireSession.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null; // No current session
      }
      throw ApiException('Failed to load session: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to load session: $e');
    }
  }

  @override
  Future<void> saveSession(QuestionnaireSession session) async {
    try {
      final response = await _dio.put(
        '$baseUrl/api/questionnaire/session',
        data: session.toJson(),
      );

      if (response.statusCode != 200) {
        throw ApiException('Failed to save session: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ApiException('Failed to save session: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to save session: $e');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      final response = await _dio.delete('$baseUrl/api/questionnaire/current');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException('Failed to clear session: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ApiException('Failed to clear session: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to clear session: $e');
    }
  }

  @override
  Future<void> saveQuestionAnswer(QuestionAnswerData data) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/questionnaire/answers',
        data: data.toJson(),
      );

      if (response.statusCode != 201) {
        throw ApiException('Failed to save answer: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ApiException('Failed to save answer: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to save answer: $e');
    }
  }

  @override
  Future<void> updateQuestionAnswer(QuestionAnswerData data) async {
    try {
      final response = await _dio.put(
        '$baseUrl/api/questionnaire/answers/${data.questionId}',
        data: data.toJson(),
      );

      if (response.statusCode != 200) {
        throw ApiException('Failed to update answer: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ApiException('Failed to update answer: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to update answer: $e');
    }
  }

  @override
  Future<void> deleteQuestionAnswer({
    required String sectionId,
    required String questionId,
  }) async {
    try {
      final response = await _dio.delete(
        '$baseUrl/api/questionnaire/answers/$questionId',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException('Failed to delete answer: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ApiException('Failed to delete answer: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to delete answer: $e');
    }
  }

  @override
  Future<QuestionAnswer?> getQuestionAnswer({
    required String sectionId,
    required String questionId,
  }) async {
    try {
      final response = await _dio.get(
        '$baseUrl/api/questionnaire/answers/$questionId',
      );

      if (response.statusCode == 200 && response.data != null) {
        return QuestionAnswer.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw ApiException('Failed to get answer: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to get answer: $e');
    }
  }

  @override
  Future<List<QuestionAnswer>> getSectionAnswers(String sectionId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/api/questionnaire/sections/$sectionId/answers',
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> answersJson = response.data as List<dynamic>;
        return answersJson.map((json) =>
          QuestionAnswer.fromJson(json as Map<String, dynamic>)
        ).toList();
      }

      return [];
    } on DioException catch (e) {
      throw ApiException('Failed to get section answers: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to get section answers: $e');
    }
  }

  @override
  Future<void> updateSectionStatus({
    required String sectionId,
    required SectionStatus status,
    DateTime? completedAt,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _dio.put(
        '$baseUrl/api/questionnaire/sections/$sectionId',
        data: {
          'status': status.name,
          'completedAt': completedAt?.toIso8601String(),
          'metadata': metadata,
        },
      );

      if (response.statusCode != 200) {
        throw ApiException('Failed to update section status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ApiException('Failed to update section status: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to update section status: $e');
    }
  }

  @override
  Future<void> addSectionMessage({
    required String sectionId,
    required SectionMessage message,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/questionnaire/sections/$sectionId/messages',
        data: _convertSectionMessageToJson(message),
      );

      if (response.statusCode != 201) {
        throw ApiException('Failed to add message: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ApiException('Failed to add message: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to add message: $e');
    }
  }

  @override
  Future<void> updateSectionMessage({
    required String sectionId,
    required String messageId,
    required SectionMessage message,
  }) async {
    try {
      final response = await _dio.put(
        '$baseUrl/api/questionnaire/sections/$sectionId/messages/$messageId',
        data: _convertSectionMessageToJson(message),
      );

      if (response.statusCode != 200) {
        throw ApiException('Failed to update message: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ApiException('Failed to update message: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to update message: $e');
    }
  }

  @override
  Future<void> deleteSectionMessage({
    required String sectionId,
    required String messageId,
  }) async {
    try {
      final response = await _dio.delete(
        '$baseUrl/api/questionnaire/sections/$sectionId/messages/$messageId',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException('Failed to delete message: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ApiException('Failed to delete message: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to delete message: $e');
    }
  }

  @override
  Future<List<SectionMessage>> getSectionMessages(String sectionId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/api/questionnaire/sections/$sectionId/messages',
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> messagesJson = response.data as List<dynamic>;
        return messagesJson.map((json) =>
          _convertJsonToSectionMessage(json as Map<String, dynamic>)
        ).toList();
      }

      return [];
    } on DioException catch (e) {
      throw ApiException('Failed to get section messages: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to get section messages: $e');
    }
  }

  @override
  Future<void> updatePosition(QuestionnairePosition position) async {
    try {
      final response = await _dio.put(
        '$baseUrl/api/questionnaire/position',
        data: position.toJson(),
      );

      if (response.statusCode != 200) {
        throw ApiException('Failed to update position: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ApiException('Failed to update position: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to update position: $e');
    }
  }

  @override
  Future<QuestionnairePosition?> getCurrentPosition() async {
    try {
      final response = await _dio.get('$baseUrl/api/questionnaire/position');

      if (response.statusCode == 200 && response.data != null) {
        return QuestionnairePosition.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw ApiException('Failed to get position: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to get position: $e');
    }
  }

  @override
  Future<List<ChatSection>> loadQuestionnaireStructure() async {
    try {
      final response = await _dio.get('$baseUrl/api/questionnaire/structure');

      if (response.statusCode == 200 && response.data != null) {
        return _parseQuestionnaireStructure(
          response.data as Map<String, dynamic>,
        );
      }

      throw ApiException('Empty questionnaire structure response');
    } on DioException catch (e) {
      throw ApiException('Failed to load questionnaire structure: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to load questionnaire structure: $e');
    }
  }

  @override
  Future<void> syncAllChanges() async {
    try {
      final response = await _dio.post('$baseUrl/api/questionnaire/sync');

      if (response.statusCode != 200) {
        throw ApiException('Failed to sync changes: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ApiException('Failed to sync changes: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to sync changes: $e');
    }
  }

  @override
  Future<ChatState> exportFullState() async {
    try {
      final response = await _dio.get('$baseUrl/api/questionnaire/export');

      if (response.statusCode == 200 && response.data != null) {
        return ChatState.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw ApiException('Empty export response');
    } on DioException catch (e) {
      throw ApiException('Failed to export state: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to export state: $e');
    }
  }

  @override
  Future<bool> hasLocalData() async {
    // API implementation - check if session exists on server
    final session = await loadSession();
    return session != null;
  }

  @override
  Future<void> clearLocalCache() async {
    // No local cache in API implementation
    // Could implement client-side caching later
  }

  @override
  Future<bool> validateIntegrity() async {
    try {
      final response = await _dio.get('$baseUrl/api/questionnaire/validate');
      return response.statusCode == 200 &&
             response.data?['isValid'] == true;
    } catch (e) {
      return false;
    }
  }

  // Private helper methods
  Map<String, dynamic> _convertSectionMessageToJson(SectionMessage message) {
    if (message is BotMessage) {
      return message.toJson();
    } else if (message is QuestionAnswer) {
      return message.toJson();
    } else {
      throw ApiException('Unknown message type: ${message.runtimeType}');
    }
  }

  SectionMessage _convertJsonToSectionMessage(Map<String, dynamic> json) {
    final messageType = MessageType.values.firstWhere(
      (type) => type.name == json['messageType'],
    );

    switch (messageType) {
      case MessageType.botIntro:
      case MessageType.botWrapup:
        return BotMessage.fromJson(json);
      case MessageType.userAnswer:
        return QuestionAnswer.fromJson(json);
      default:
        throw ApiException('Unknown message type: $messageType');
    }
  }

  List<ChatSection> _parseQuestionnaireStructure(Map<String, dynamic> jsonData) {
    // Parse questionnaire structure from API response
    // Implementation would convert API JSON to ChatSection objects
    throw UnimplementedError('Implementation needed');
  }
}
```

---

## 🎛️ RiverPod State Management Architecture (v3)

### **Core Providers**

#### **Service Providers (Dependency Injection)**
```dart
// Service Configuration Provider
@riverpod
class ServiceConfig extends _$ServiceConfig {
  @override
  ServiceConfiguration build() {
    return const ServiceConfiguration(
      useApiPersistence: false, // Switch between local/API
      apiBaseUrl: 'https://api.example.com',
      enableOfflineSync: true,
      debugMode: true,
    );
  }

  void toggleApiMode(bool useApi) {
    state = state.copyWith(useApiPersistence: useApi);
  }
}

// Persistence Service Provider
@riverpod
PersistenceService persistenceService(PersistenceServiceRef ref) {
  final config = ref.watch(serviceConfigProvider);

  if (config.useApiPersistence) {
    return ApiPersistenceService(
      baseUrl: config.apiBaseUrl,
      dio: Dio(),
    );
  } else {
    return LocalPersistenceService();
  }
}

// Validation Service Provider
@riverpod
ValidationService validationService(ValidationServiceRef ref) {
  return DefaultValidationService();
}

// Main Questionnaire Service Provider
@riverpod
QuestionnaireService questionnaireService(QuestionnaireServiceRef ref) {
  final persistence = ref.watch(persistenceServiceProvider);
  final validation = ref.watch(validationServiceProvider);

  return QuestionnaireServiceImpl(persistence, validation);
}
```

#### **State Providers**

```dart
// Main Questionnaire State Provider
@riverpod
class QuestionnaireState extends _$QuestionnaireState {
  @override
  Future<ChatState> build() async {
    try {
      final service = ref.read(questionnaireServiceProvider);
      return await service.initialize();
    } catch (e) {
      throw QuestionnaireException('Failed to initialize questionnaire: $e');
    }
  }

  // Core Operations
  Future<void> submitAnswer({
    required String questionId,
    required dynamic answer,
  }) async {
    try {
      final service = ref.read(questionnaireServiceProvider);
      await service.submitAnswer(questionId: questionId, answer: answer);

      // Refresh state after submission
      await _refreshState();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> editAnswer({
    required String sectionId,
    required String questionId,
    required dynamic newAnswer,
  }) async {
    try {
      final service = ref.read(questionnaireServiceProvider);
      await service.editAnswer(
        sectionId: sectionId,
        questionId: questionId,
        newAnswer: newAnswer,
      );

      await _refreshState();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> navigateToQuestion(String questionId) async {
    try {
      final service = ref.read(questionnaireServiceProvider);
      await service.navigateToQuestion(questionId);

      await _refreshState();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> completeSection(String sectionId) async {
    try {
      final service = ref.read(questionnaireServiceProvider);
      await service.completeSection(sectionId);

      await _refreshState();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> reset() async {
    try {
      final service = ref.read(questionnaireServiceProvider);
      await service.reset();

      // Reinitialize after reset
      state = const AsyncValue.loading();
      final newState = await service.initialize();
      state = AsyncValue.data(newState);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  // Private helper
  Future<void> _refreshState() async {
    final service = ref.read(questionnaireServiceProvider);
    final newState = await service.getCurrentState();
    state = AsyncValue.data(newState);
  }
}

// Position Provider
@riverpod
Future<QuestionnairePosition?> currentPosition(CurrentPositionRef ref) async {
  final chatState = await ref.watch(questionnaireStateProvider.future);
  return chatState.position;
}

// Current Question Provider
@riverpod
Future<Question?> currentQuestion(CurrentQuestionRef ref) async {
  final service = ref.read(questionnaireServiceProvider);
  return await service.getCurrentQuestion();
}

// Progress Providers
@riverpod
Future<double> overallProgress(OverallProgressRef ref) async {
  final service = ref.read(questionnaireServiceProvider);
  return await service.getOverallProgress();
}

@riverpod
Future<double> sectionProgress(SectionProgressRef ref, String sectionId) async {
  final service = ref.read(questionnaireServiceProvider);
  return await service.getSectionProgress(sectionId);
}

// Navigation Providers
@riverpod
Future<bool> canNavigateBack(CanNavigateBackRef ref) async {
  final position = await ref.watch(currentPositionProvider.future);
  return position?.canNavigateBack ?? false;
}

@riverpod
Future<bool> canProceedToNext(CanProceedToNextRef ref, String sectionId) async {
  final service = ref.read(questionnaireServiceProvider);
  return await service.canProceedToNextSection(sectionId);
}

// Validation Providers
@riverpod
Future<List<ValidationError>> currentValidationErrors(
  CurrentValidationErrorsRef ref,
) async {
  final service = ref.read(questionnaireServiceProvider);
  final validationStatus = await service.validateBusinessRules();

  final errors = <ValidationError>[];
  if (!validationStatus.isValid) {
    errors.add(ValidationError(
      message: validationStatus.primaryError ?? 'Validation failed',
      questionId: null,
      sectionId: null,
    ));
  }

  if (validationStatus.warnings != null) {
    errors.addAll(
      validationStatus.warnings!.map(
        (warning) => ValidationError(
          message: warning,
          questionId: null,
          sectionId: null,
          isWarning: true,
        ),
      ),
    );
  }

  return errors;
}

// Section-specific Providers
@riverpod
Future<List<QuestionAnswer>> sectionAnswers(
  SectionAnswersRef ref,
  String sectionId,
) async {
  final chatState = await ref.watch(questionnaireStateProvider.future);
  final section = chatState.sections.firstWhereOrNull(
    (s) => s.id == sectionId,
  ) as QuestionnaireSection?;

  return section?.answeredQuestions ?? [];
}

@riverpod
Future<SectionStatus> sectionStatus(
  SectionStatusRef ref,
  String sectionId,
) async {
  final chatState = await ref.watch(questionnaireStateProvider.future);
  final section = chatState.sections.firstWhereOrNull(
    (s) => s.id == sectionId,
  );

  return section?.status ?? SectionStatus.pending;
}
```

#### **Computed Providers**

```dart
// UI State Providers
@riverpod
Future<bool> isQuestionnaireComplete(IsQuestionnaireCompleteRef ref) async {
  final chatState = await ref.watch(questionnaireStateProvider.future);
  return chatState.isComplete;
}

@riverpod
Future<String?> currentSectionId(CurrentSectionIdRef ref) async {
  final position = await ref.watch(currentPositionProvider.future);
  return position?.currentSectionId;
}

@riverpod
Future<String?> currentQuestionId(CurrentQuestionIdRef ref) async {
  final position = await ref.watch(currentPositionProvider.future);
  return position?.currentQuestionId;
}

// Section List Provider
@riverpod
Future<List<ChatSection>> allSections(AllSectionsRef ref) async {
  final chatState = await ref.watch(questionnaireStateProvider.future);
  return chatState.sections;
}

@riverpod
Future<List<QuestionnaireSection>> questionnaireSections(
  QuestionnaireSectionsRef ref,
) async {
  final sections = await ref.watch(allSectionsProvider.future);
  return sections.whereType<QuestionnaireSection>().toList();
}

// Question Navigation Provider
@riverpod
Future<QuestionNavigationState> questionNavigation(
  QuestionNavigationRef ref,
) async {
  final position = await ref.watch(currentPositionProvider.future);
  final currentQuestion = await ref.watch(currentQuestionProvider.future);
  final canGoBack = await ref.watch(canNavigateBackProvider.future);

  return QuestionNavigationState(
    currentQuestion: currentQuestion,
    position: position,
    canNavigateBack: canGoBack,
    hasNext: currentQuestion != null,
  );
}
```

#### **Supporting Data Classes**

```dart
@freezed
class ServiceConfiguration with _$ServiceConfiguration {
  const factory ServiceConfiguration({
    required bool useApiPersistence,
    required String apiBaseUrl,
    required bool enableOfflineSync,
    required bool debugMode,
  }) = _ServiceConfiguration;
}

@freezed
class ValidationError with _$ValidationError {
  const factory ValidationError({
    required String message,
    String? questionId,
    String? sectionId,
    @Default(false) bool isWarning,
  }) = _ValidationError;
}

@freezed
class QuestionNavigationState with _$QuestionNavigationState {
  const factory QuestionNavigationState({
    Question? currentQuestion,
    QuestionnairePosition? position,
    required bool canNavigateBack,
    required bool hasNext,
  }) = _QuestionNavigationState;
}
```

---

## 🎨 Widget Architecture (Enhanced from v2)

### **Main Orchestration Widget**

```dart
class ChatQuestionnaireView extends ConsumerWidget {
  const ChatQuestionnaireView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionnaireStateAsync = ref.watch(questionnaireStateProvider);

    return questionnaireStateAsync.when(
      loading: () => const ChatLoadingWidget(),
      error: (error, stack) => ChatErrorWidget(
        error: error,
        onRetry: () => ref.refresh(questionnaireStateProvider),
        onReset: () => ref.read(questionnaireStateProvider.notifier).reset(),
      ),
      data: (chatState) => _buildChatInterface(context, ref, chatState),
    );
  }

  Widget _buildChatInterface(BuildContext context, WidgetRef ref, ChatState chatState) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress
            ChatHeaderWidget(
              sessionId: chatState.sessionId,
              status: chatState.status,
            ),

            // Progress indicator
            Consumer(
              builder: (context, ref, child) {
                final progressAsync = ref.watch(overallProgressProvider);
                return progressAsync.when(
                  loading: () => const LinearProgressIndicator(value: null),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (progress) => ChatProgressIndicator(progress: progress),
                );
              },
            ),

            // Chat history (scrollable sections)
            Expanded(
              child: ChatHistoryWidget(
                sections: chatState.sections,
                currentSectionId: chatState.position.currentSectionId,
              ),
            ),

            // Current question input (bottom)
            _buildCurrentQuestionInput(context, ref, chatState),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentQuestionInput(BuildContext context, WidgetRef ref, ChatState chatState) {
    if (chatState.isComplete) {
      return const ChatCompletionWidget();
    }

    return Consumer(
      builder: (context, ref, child) {
        final currentQuestionAsync = ref.watch(currentQuestionProvider);
        final navigationAsync = ref.watch(questionNavigationProvider);

        return AsyncValue.guard(() async {
          final question = await currentQuestionAsync;
          final navigation = await navigationAsync;
          return (question, navigation);
        }).when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (data) {
            final (question, navigation) = data;
            return question != null
              ? CurrentQuestionInputWidget(
                  question: question,
                  navigation: navigation,
                  onSubmitAnswer: (answer) => ref
                    .read(questionnaireStateProvider.notifier)
                    .submitAnswer(questionId: question.id, answer: answer),
                  onNavigateBack: navigation.canNavigateBack
                    ? () => _handleNavigateBack(ref)
                    : null,
                )
              : const SizedBox.shrink();
          },
        );
      },
    );
  }

  void _handleNavigateBack(WidgetRef ref) {
    // Implementation for navigate back
    // Could involve updating position or navigating to previous question
  }
}
```

### **Enhanced Current Question Input Widget**

```dart
class CurrentQuestionInputWidget extends ConsumerStatefulWidget {
  final Question question;
  final QuestionNavigationState navigation;
  final Function(dynamic) onSubmitAnswer;
  final VoidCallback? onNavigateBack;

  const CurrentQuestionInputWidget({
    super.key,
    required this.question,
    required this.navigation,
    required this.onSubmitAnswer,
    this.onNavigateBack,
  });

  @override
  ConsumerState<CurrentQuestionInputWidget> createState() =>
      _CurrentQuestionInputWidgetState();
}

class _CurrentQuestionInputWidgetState
    extends ConsumerState<CurrentQuestionInputWidget> {

  dynamic _currentValue;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSizes.m),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.outline.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusL),
          topRight: Radius.circular(AppSizes.radiusL),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCurrentIndicator(context, theme),
          const SizedBox(height: AppSizes.m),
          _buildQuestionHeader(context, theme),
          const SizedBox(height: AppSizes.m),
          _buildQuestionInput(context, theme),
          const SizedBox(height: AppSizes.m),
          _buildActionButtons(context, theme),
        ],
      ),
    );
  }

  Widget _buildCurrentIndicator(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.keyboard_arrow_up,
          color: theme.colorScheme.primary,
          size: 16,
        ),
        Text(
          'CURRENT QUESTION',
          style: AppTextStyles.labelSmall.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionHeader(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.smart_toy,
            size: 16,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: AppSizes.s),
        Expanded(
          child: Text(
            widget.question.text,
            style: AppTextStyles.currentQuestionText.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        if (widget.question.required)
          Icon(
            Icons.star,
            size: 12,
            color: theme.colorScheme.error,
          ),
      ],
    );
  }

  Widget _buildQuestionInput(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.m),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Form(
        key: _formKey,
        child: QuestionInputWidgetFactory.create(
          question: widget.question,
          currentValue: _currentValue,
          onChanged: (value) => setState(() => _currentValue = value),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        // Back button
        if (widget.onNavigateBack != null)
          Expanded(
            flex: 1,
            child: OutlinedButton(
              onPressed: _isSubmitting ? null : widget.onNavigateBack,
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurfaceVariant,
                side: BorderSide(color: theme.colorScheme.outline),
                padding: const EdgeInsets.symmetric(vertical: AppSizes.m),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back, size: 16),
                  const SizedBox(width: AppSizes.xs),
                  Text('Back', style: AppTextStyles.buttonText),
                ],
              ),
            ),
          ),

        if (widget.onNavigateBack != null) const SizedBox(width: AppSizes.m),

        // Submit button
        Expanded(
          flex: 3,
          child: Consumer(
            builder: (context, ref, child) {
              final validationErrorsAsync = ref.watch(currentValidationErrorsProvider);

              return validationErrorsAsync.when(
                loading: () => _buildSubmitButton(theme, false),
                error: (_, __) => _buildSubmitButton(theme, false),
                data: (errors) {
                  final hasErrors = errors.any((e) => !e.isWarning);
                  return _buildSubmitButton(theme, !hasErrors);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(ThemeData theme, bool isValid) {
    final canSubmit = _canSubmit() && isValid && !_isSubmitting;

    return ElevatedButton(
      onPressed: canSubmit ? _handleSubmit : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
        disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
        padding: const EdgeInsets.symmetric(vertical: AppSizes.m),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
        elevation: 0,
      ),
      child: _isSubmitting
        ? SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.onPrimary,
              ),
            ),
          )
        : Text(
            'Submit',
            style: AppTextStyles.buttonText,
          ),
    );
  }

  bool _canSubmit() {
    if (widget.question.required && _currentValue == null) return false;
    return _formKey.currentState?.validate() ?? false;
  }

  void _handleSubmit() async {
    if (!_canSubmit() || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      await widget.onSubmitAnswer(_currentValue);
    } catch (e) {
      // Error handled by provider
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit answer: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
```

---

## 🔄 Control Flows (v3 Enhanced)

### **1. Initialize Flow**
```
[App Start]
    ↓
QuestionnaireService.initialize()
    ↓
PersistenceService.loadSession()
    ↓
if session exists:
    ├── PersistenceService.getCurrentPosition() [GRANULAR]
    ├── PersistenceService.loadSectionsWithData() [GRANULAR]
    └── return ChatState.fromPersistence()
else:
    ├── PersistenceService.loadQuestionnaireStructure() [GRANULAR]
    ├── create new QuestionnaireSession + Position
    ├── PersistenceService.saveSession() [GRANULAR]
    ├── PersistenceService.updatePosition() [GRANULAR]
    └── return ChatState.fromNew()
```

### **2. Submit Answer Flow (Enhanced)**
```
[User Submits Answer]
    ↓
QuestionnaireService.submitAnswer(questionId, answer)
    ↓
ValidationService.validateAnswer() [BUSINESS LOGIC]
    ↓ (if valid)
PersistenceService.saveQuestionAnswer() [GRANULAR]
    ↓
PersistenceService.addSectionMessage() [GRANULAR]
    ↓
calculate next position [BUSINESS LOGIC]
    ↓
PersistenceService.updatePosition() [GRANULAR]
    ↓
check section completion [BUSINESS LOGIC]
    ↓ (if complete)
PersistenceService.updateSectionStatus() [GRANULAR]
    ↓
PersistenceService.addSectionMessage(wrapup) [GRANULAR]
    ↓
find and start next section [BUSINESS LOGIC]
    ↓
[UI Updates via RiverPod]
```

### **3. Edit Answer Flow (New)**
```
[User Edits Answer]
    ↓
QuestionnaireService.editAnswer(sectionId, questionId, newAnswer)
    ↓
ValidationService.validateAnswer() [BUSINESS LOGIC]
    ↓ (if valid)
PersistenceService.updateQuestionAnswer() [GRANULAR]
    ↓
find corresponding message [BUSINESS LOGIC]
    ↓
PersistenceService.updateSectionMessage() [GRANULAR]
    ↓
recalculate conditional questions [BUSINESS LOGIC]
    ↓
PersistenceService.updatePosition(timestamp) [GRANULAR]
    ↓
[UI Updates via RiverPod]
```

### **4. Load State Flow (Enhanced)**
```
[Get Current State]
    ↓
QuestionnaireService.getCurrentState()
    ↓
PersistenceService.loadSession() [GRANULAR]
    ↓
PersistenceService.getCurrentPosition() [GRANULAR]
    ↓
for each section:
    ├── PersistenceService.getSectionAnswers() [GRANULAR]
    └── PersistenceService.getSectionMessages() [GRANULAR]
    ↓
assemble ChatState from granular data [BUSINESS LOGIC]
    ↓
return complete ChatState
    ↓
[RiverPod providers update UI]
```

### **5. Navigation Flow (New)**
```
[Navigate to Question]
    ↓
QuestionnaireService.navigateToQuestion(questionId)
    ↓
find question across sections [BUSINESS LOGIC]
    ↓
validate navigation permissions [BUSINESS LOGIC]
    ↓
calculate new position [BUSINESS LOGIC]
    ↓
PersistenceService.updatePosition() [GRANULAR]
    ↓
[UI scrolls to question]
```

---

## 🔗 API Endpoint Mapping

### **Local Storage → API Transition**
```dart
// Local Storage Key → API Endpoint
'questionnaire_session'           → GET    /api/questionnaire/current
'questionnaire_session'           → PUT    /api/questionnaire/session
'questionnaire_position'          → GET    /api/questionnaire/position
'questionnaire_position'          → PUT    /api/questionnaire/position
'answer_{sectionId}_{questionId}' → POST   /api/questionnaire/answers
'answer_{sectionId}_{questionId}' → PUT    /api/questionnaire/answers/{questionId}
'answer_{sectionId}_{questionId}' → DELETE /api/questionnaire/answers/{questionId}
'section_status_{sectionId}'      → PUT    /api/questionnaire/sections/{sectionId}
'section_messages_{sectionId}'    → POST   /api/questionnaire/sections/{sectionId}/messages
'section_messages_{sectionId}'    → GET    /api/questionnaire/sections/{sectionId}/messages
'questionnaire_structure'         → GET    /api/questionnaire/structure
```

### **REST API Design**
```yaml
# Session Management
GET    /api/questionnaire/current                    # Load current session
PUT    /api/questionnaire/session                    # Save session metadata
DELETE /api/questionnaire/current                    # Clear session
POST   /api/questionnaire/init                       # Initialize new session

# Question Operations
POST   /api/questionnaire/answers                    # Save new answer
PUT    /api/questionnaire/answers/{questionId}       # Update answer
DELETE /api/questionnaire/answers/{questionId}       # Delete answer
GET    /api/questionnaire/answers/{questionId}       # Get specific answer

# Section Operations
PUT    /api/questionnaire/sections/{sectionId}       # Update section status
POST   /api/questionnaire/sections/{sectionId}/messages  # Add message
PUT    /api/questionnaire/sections/{sectionId}/messages/{messageId}  # Update message
DELETE /api/questionnaire/sections/{sectionId}/messages/{messageId}  # Delete message
GET    /api/questionnaire/sections/{sectionId}/answers   # Get section answers
GET    /api/questionnaire/sections/{sectionId}/messages  # Get section messages

# Position Tracking
GET    /api/questionnaire/position                   # Get current position
PUT    /api/questionnaire/position                   # Update position

# Structure & Export
GET    /api/questionnaire/structure                  # Get questionnaire structure
GET    /api/questionnaire/export                     # Export complete state
POST   /api/questionnaire/sync                       # Sync offline changes
GET    /api/questionnaire/validate                   # Validate integrity
```

---

## 📈 Benefits of v3 Architecture

### **1. API-Ready Design**
- **Direct Mapping**: Each operation maps to specific REST endpoints
- **Minimal Payloads**: Only send/receive changed data
- **Scalable Backend**: Granular operations enable efficient server architecture
- **Offline Support**: Local implementation provides full offline capability

### **2. Performance Optimized**
- **Reduced Storage**: Save only what changes, not entire state
- **Faster Operations**: Granular updates vs full state serialization
- **Better UX**: Position tracking enables perfect resume experience
- **Network Efficiency**: Minimal data transfer for each operation

### **3. Developer Experience**
- **Interface Consistency**: Same API whether local or remote
- **Easy Testing**: Mock persistence interface for unit tests
- **Clear Separation**: Business logic in service, persistence in interface
- **Type Safety**: Comprehensive Dart type system usage

### **4. Maintainable Architecture**
- **Single Responsibility**: Each service has clear purpose
- **Extensible Design**: Easy to add new question types, section types
- **Future-Proof**: Clean migration path to more complex persistence
- **RiverPod Integration**: Reactive state management with error boundaries

### **5. Business Logic Organization**
- **Centralized Rules**: All questionnaire logic in service implementation
- **Validation Pipeline**: Consistent validation across all operations
- **Progress Calculation**: Automatic progress tracking and reporting
- **Navigation Logic**: Smart question sequencing and section transitions

---

## 🚀 Implementation Priority (v3)

### **Phase 1: Core Foundation**
1. Data models with position tracking (`QuestionnairePosition`, `QuestionnaireSession`)
2. Service interfaces (`PersistenceService`, `QuestionnaireService`)
3. Basic RiverPod providers setup

### **Phase 2: Local Implementation**
1. `LocalPersistenceService` with granular operations
2. `QuestionnaireServiceImpl` with business logic
3. Core widget structure (preserve v2 widgets)

### **Phase 3: Enhanced State Management**
1. Complete RiverPod provider architecture
2. Enhanced current question input widget
3. Position tracking and navigation

### **Phase 4: API Implementation**
1. `ApiPersistenceService` HTTP implementation
2. Service configuration and switching
3. Error handling and retry logic

### **Phase 5: Advanced Features**
1. Offline sync capabilities
2. Validation enhancement
3. Performance optimization
4. Comprehensive testing

---

**Document Version**: 3.0
**Last Updated**: September 2025
**Architecture**: Granular Persistence with API-Ready Design
**Review Cycle**: Monthly
**Next Review**: October 2025