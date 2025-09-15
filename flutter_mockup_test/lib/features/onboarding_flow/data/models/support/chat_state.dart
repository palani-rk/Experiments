import 'package:freezed_annotation/freezed_annotation.dart';
import '../core/chat_section.dart';
import '../core/section_message.dart';
import '../core/enums.dart';
import 'question.dart';

part 'chat_state.freezed.dart';
part 'chat_state.g.dart';

/// Main state model for the chat-based questionnaire system
///
/// Contains all sections, tracks progress, and provides business logic
/// for section navigation and completion detection.
@freezed
class ChatState with _$ChatState {
  const ChatState._();

  const factory ChatState({
    required String sessionId,
    required List<ChatSection> sections,
    String? currentSectionId,
    String? currentQuestionId,
    @Default(ChatStatus.notStarted) ChatStatus status,
    required DateTime createdAt,
    DateTime? completedAt,
    DateTime? lastActivityAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _ChatState;

  // Factory constructors
  factory ChatState.initial({
    required List<ChatSection> sections,
    Map<String, dynamic>? metadata,
  }) {
    final sessionId = _generateSessionId();
    return ChatState(
      sessionId: sessionId,
      sections: sections,
      currentSectionId: _findFirstActiveSection(sections)?.id,
      status: ChatStatus.notStarted,
      createdAt: DateTime.now(),
      lastActivityAt: DateTime.now(),
      metadata: metadata ?? {},
    );
  }

  factory ChatState.started({
    required List<ChatSection> sections,
    Map<String, dynamic>? metadata,
  }) {
    final initialState = ChatState.initial(
      sections: sections,
      metadata: metadata,
    );
    return initialState.copyWith(
      status: ChatStatus.inProgress,
      lastActivityAt: DateTime.now(),
    );
  }

  // JSON serialization
  factory ChatState.fromJson(Map<String, dynamic> json) =>
      _$ChatStateFromJson(json);


  // Business logic properties
  ChatSection? get currentSection =>
      currentSectionId != null
          ? sections.firstWhere(
              (s) => s.id == currentSectionId,
              orElse: () => sections.first,
            )
          : null;

  Question? get currentQuestion {
    final section = currentSection;
    if (section is QuestionnaireSection) {
      if (currentQuestionId != null) {
        try {
          return section.questions.firstWhere((q) => q.id == currentQuestionId);
        } catch (e) {
          return null;
        }
      }
      // Return first unanswered question
      final answeredQuestionIds = section.allMessages
          .whereType<QuestionAnswer>()
          .map((qa) => qa.questionId)
          .toSet();

      return section.questions
          .where((q) => !answeredQuestionIds.contains(q.id))
          .firstOrNull;
    }
    return null;
  }

  /// Overall completion progress (0.0 to 1.0)
  double get overallProgress {
    if (sections.isEmpty) return 1.0;

    final totalProgress = sections
        .map((s) => s.completionProgress)
        .reduce((a, b) => a + b);

    return totalProgress / sections.length;
  }

  /// Whether all sections are complete
  bool get isComplete => sections.every((s) => s.isComplete);

  /// Whether the questionnaire has been started
  bool get isStarted => status != ChatStatus.notStarted;

  /// Whether the questionnaire is currently active
  bool get isActive => status == ChatStatus.inProgress;

  /// Whether the questionnaire is finished
  bool get isFinished => status == ChatStatus.completed || status == ChatStatus.abandoned;

  /// Get all questionnaire sections
  List<QuestionnaireSection> get questionnaireSections =>
      sections.whereType<QuestionnaireSection>().toList();

  /// Get completed sections
  List<ChatSection> get completedSections =>
      sections.where((s) => s.isComplete).toList();

  /// Get pending sections
  List<ChatSection> get pendingSections =>
      sections.where((s) => !s.isComplete).toList();

  /// Get total number of questions across all questionnaire sections
  int get totalQuestions => questionnaireSections
      .map((s) => s.totalQuestions)
      .fold(0, (a, b) => a + b);

  /// Get total number of answered questions
  int get totalAnsweredQuestions => questionnaireSections
      .map((s) => s.answeredCount)
      .fold(0, (a, b) => a + b);

  /// Get session duration
  Duration get sessionDuration => DateTime.now().difference(createdAt);

  /// Get time since last activity
  Duration get timeSinceLastActivity =>
      lastActivityAt != null
          ? DateTime.now().difference(lastActivityAt!)
          : Duration.zero;

  /// Check if session is recent (within last 30 minutes)
  bool get isRecentSession => timeSinceLastActivity.inMinutes < 30;

  // State management methods
  ChatState startSession() {
    return copyWith(
      status: ChatStatus.inProgress,
      lastActivityAt: DateTime.now(),
    );
  }

  ChatState completeSession() {
    return copyWith(
      status: ChatStatus.completed,
      completedAt: DateTime.now(),
      lastActivityAt: DateTime.now(),
    );
  }

  ChatState abandonSession() {
    return copyWith(
      status: ChatStatus.abandoned,
      lastActivityAt: DateTime.now(),
    );
  }

  ChatState updateActivity() {
    return copyWith(lastActivityAt: DateTime.now());
  }

  /// Move to next section
  ChatState moveToNextSection() {
    final currentIndex = currentSection != null
        ? sections.indexWhere((s) => s.id == currentSection!.id)
        : -1;

    if (currentIndex >= 0 && currentIndex < sections.length - 1) {
      final nextSection = sections[currentIndex + 1];
      return copyWith(
        currentSectionId: nextSection.id,
        lastActivityAt: DateTime.now(),
      );
    }

    // No next section - complete the questionnaire
    return completeSession();
  }

  /// Move to previous section
  ChatState moveToPreviousSection() {
    final currentIndex = currentSection != null
        ? sections.indexWhere((s) => s.id == currentSection!.id)
        : -1;

    if (currentIndex > 0) {
      final previousSection = sections[currentIndex - 1];
      return copyWith(
        currentSectionId: previousSection.id,
        lastActivityAt: DateTime.now(),
      );
    }

    return this; // Already at first section
  }

  /// Move to specific section
  ChatState moveToSection(String sectionId) {
    final sectionExists = sections.any((s) => s.id == sectionId);
    if (sectionExists) {
      return copyWith(
        currentSectionId: sectionId,
        lastActivityAt: DateTime.now(),
      );
    }
    return this;
  }

  /// Set current question
  ChatState setCurrentQuestion(String? questionId) {
    return copyWith(
      currentQuestionId: questionId,
      lastActivityAt: DateTime.now(),
    );
  }

  /// Update a section in the state
  ChatState updateSection(ChatSection updatedSection) {
    final updatedSections = sections
        .map((s) => s.id == updatedSection.id ? updatedSection : s)
        .toList();

    // Check if questionnaire should be completed
    final shouldComplete = updatedSections.every((s) => s.isComplete);
    final newStatus = shouldComplete ? ChatStatus.completed : status;
    final newCompletedAt = shouldComplete ? DateTime.now() : completedAt;

    return copyWith(
      sections: updatedSections,
      status: newStatus,
      completedAt: newCompletedAt,
      lastActivityAt: DateTime.now(),
    );
  }

  /// Replace all sections
  ChatState replaceSections(List<ChatSection> newSections) {
    return copyWith(
      sections: newSections,
      currentSectionId: _findFirstActiveSection(newSections)?.id,
      lastActivityAt: DateTime.now(),
    );
  }

  /// Get section by ID
  ChatSection? getSection(String sectionId) {
    try {
      return sections.firstWhere((s) => s.id == sectionId);
    } catch (e) {
      return null;
    }
  }

  /// Get next section after current
  ChatSection? getNextSection() {
    if (currentSection == null) return null;

    final currentIndex = sections.indexWhere((s) => s.id == currentSection!.id);
    if (currentIndex >= 0 && currentIndex < sections.length - 1) {
      return sections[currentIndex + 1];
    }

    return null;
  }

  /// Get previous section before current
  ChatSection? getPreviousSection() {
    if (currentSection == null) return null;

    final currentIndex = sections.indexWhere((s) => s.id == currentSection!.id);
    if (currentIndex > 0) {
      return sections[currentIndex - 1];
    }

    return null;
  }

  /// Check if can proceed to next section
  bool get canProceedToNext => currentSection?.canProceed ?? false;

  /// Get metadata value
  T? getMetadata<T>(String key) {
    try {
      return metadata[key] as T?;
    } catch (e) {
      return null;
    }
  }

  /// Set metadata value
  ChatState setMetadata(String key, dynamic value) {
    return copyWith(
      metadata: {...metadata, key: value},
      lastActivityAt: DateTime.now(),
    );
  }

  /// Get progress statistics
  Map<String, dynamic> get progressStats => {
    'totalSections': sections.length,
    'completedSections': completedSections.length,
    'totalQuestions': totalQuestions,
    'answeredQuestions': totalAnsweredQuestions,
    'overallProgress': overallProgress,
    'sessionDuration': sessionDuration.inMinutes,
    'lastActivity': timeSinceLastActivity.inMinutes,
  };

  // Helper methods
  static String _generateSessionId() {
    final now = DateTime.now();
    return 'session_${now.millisecondsSinceEpoch}_${now.microsecond % 1000}';
  }

  static ChatSection? _findFirstActiveSection(List<ChatSection> sections) {
    // Find first incomplete section, or first section if all complete
    try {
      return sections.firstWhere((s) => !s.isComplete);
    } catch (e) {
      return sections.isNotEmpty ? sections.first : null;
    }
  }

  @override
  String toString() {
    return 'ChatState('
        'sessionId: $sessionId, '
        'status: $status, '
        'sections: ${sections.length}, '
        'progress: ${(overallProgress * 100).toStringAsFixed(1)}%'
        ')';
  }
}