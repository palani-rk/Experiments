import 'package:freezed_annotation/freezed_annotation.dart';

part 'progress_details.freezed.dart';
part 'progress_details.g.dart';

/// Progress details for questionnaire completion tracking
///
/// This helper class provides detailed progress information for the
/// questionnaire session, including section and message completion rates.
@freezed
class ProgressDetails with _$ProgressDetails {
  const factory ProgressDetails({
    required int totalSections,
    required int completedSections,
    required int totalMessages,
    required int completedMessages,
    required int totalQuestions,
    required int answeredQuestions,
    required double overallProgress,
    required double currentSectionProgress,
    required String currentSectionId,
    required String currentMessageId,
    @Default(false) bool isComplete,
  }) = _ProgressDetails;

  factory ProgressDetails.fromJson(Map<String, dynamic> json) =>
      _$ProgressDetailsFromJson(json);
}

/// Extension for ProgressDetails calculations and helpers
extension ProgressDetailsExtension on ProgressDetails {
  /// Get human-readable progress summary
  String get progressSummary {
    if (isComplete) {
      return 'Questionnaire Complete!';
    }
    return 'Section ${completedSections + 1} of $totalSections - ${(overallProgress * 100).toStringAsFixed(0)}% Complete';
  }

  /// Get current section progress as percentage
  String get currentSectionProgressText {
    return '${(currentSectionProgress * 100).toStringAsFixed(0)}%';
  }

  /// Get questions answered in current section
  String get questionsProgressText {
    return '$answeredQuestions of $totalQuestions answered';
  }

  /// Check if current section is complete
  bool get isCurrentSectionComplete => currentSectionProgress >= 1.0;

  /// Get estimated time remaining (assuming 30 seconds per question)
  Duration get estimatedTimeRemaining {
    final remainingQuestions = totalQuestions - answeredQuestions;
    return Duration(seconds: remainingQuestions * 30);
  }

  /// Get formatted time remaining
  String get formattedTimeRemaining {
    final duration = estimatedTimeRemaining;
    if (duration.inMinutes < 1) {
      return '< 1 min';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes} min';
    } else {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return '${hours}h ${minutes}m';
    }
  }
}

/// Utility class for calculating progress details
class ProgressCalculator {
  /// Calculate progress details from ChatState
  static ProgressDetails calculateFromState({
    required List<dynamic> sections,
    required String currentSectionId,
    required String currentMessageId,
    required Function(dynamic) getSectionMessages,
    required Function(dynamic) isSectionComplete,
    required Function(dynamic) isMessageComplete,
    required Function(dynamic) isQuestionMessage,
  }) {
    final totalSections = sections.length;
    var completedSections = 0;
    var totalMessages = 0;
    var completedMessages = 0;
    var totalQuestions = 0;
    var answeredQuestions = 0;

    // Find current section index
    final currentSectionIndex = sections.indexWhere(
      (section) => section.id == currentSectionId,
    );

    for (var i = 0; i < sections.length; i++) {
      final section = sections[i];
      final messages = getSectionMessages(section);
      totalMessages += messages.length;

      if (isSectionComplete(section)) {
        completedSections++;
      }

      for (final message in messages) {
        if (isQuestionMessage(message)) {
          totalQuestions++;
          if (isMessageComplete(message)) {
            answeredQuestions++;
          }
        }

        if (isMessageComplete(message)) {
          completedMessages++;
        }
      }
    }

    // Calculate current section progress
    double currentSectionProgress = 0.0;
    if (currentSectionIndex >= 0) {
      final currentSection = sections[currentSectionIndex];
      final currentMessages = getSectionMessages(currentSection);
      final currentCompletedMessages = currentMessages
          .where((msg) => isMessageComplete(msg))
          .length;

      if (currentMessages.isNotEmpty) {
        currentSectionProgress = currentCompletedMessages / currentMessages.length;
      }
    }

    // Calculate overall progress
    final overallProgress = totalMessages > 0 ? completedMessages / totalMessages : 0.0;
    final isComplete = completedSections == totalSections && overallProgress >= 1.0;

    return ProgressDetails(
      totalSections: totalSections,
      completedSections: completedSections,
      totalMessages: totalMessages,
      completedMessages: completedMessages,
      totalQuestions: totalQuestions,
      answeredQuestions: answeredQuestions,
      overallProgress: overallProgress,
      currentSectionProgress: currentSectionProgress,
      currentSectionId: currentSectionId,
      currentMessageId: currentMessageId,
      isComplete: isComplete,
    );
  }
}