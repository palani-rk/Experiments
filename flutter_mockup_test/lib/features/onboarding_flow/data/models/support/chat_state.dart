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