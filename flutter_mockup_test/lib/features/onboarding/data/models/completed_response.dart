import 'package:freezed_annotation/freezed_annotation.dart';

part 'completed_response.freezed.dart';
part 'completed_response.g.dart';

/// Represents a completed response to a questionnaire question
///
/// This model stores information about a user's answer to a specific question,
/// including metadata like when it was answered and which section it belongs to.
/// It supports various answer types and provides utility methods for display.
@freezed
class CompletedResponse with _$CompletedResponse {
  const factory CompletedResponse({
    /// Unique identifier for the question that was answered
    required String questionId,

    /// The actual text of the question
    required String questionText,

    /// The user's answer - can be String, number, List<String>, etc.
    required dynamic answer,

    /// ID of the section this question belongs to
    required String sectionId,

    /// Human-readable title of the section
    required String sectionTitle,

    /// Timestamp when the question was answered
    required DateTime answeredAt,

    /// Whether this response can be edited by the user
    @Default(true) bool isEditable,

    /// Optional validation error message if answer is invalid
    String? validationError,

    /// Optional confidence score for the answer (0.0 to 1.0)
    double? confidenceScore,
  }) = _CompletedResponse;

  const CompletedResponse._();

  factory CompletedResponse.fromJson(Map<String, dynamic> json) =>
      _$CompletedResponseFromJson(json);

  /// Returns a formatted display string for the answer
  ///
  /// Handles different answer types:
  /// - String: trims whitespace
  /// - List<String>: joins with commas
  /// - Numbers: formats appropriately
  /// - null/empty: returns appropriate message
  String get displayAnswer {
    if (answer == null) return 'No answer provided';

    if (answer is List<String>) {
      final list = answer as List<String>;
      if (list.isEmpty) return 'No selections made';
      return list.join(', ');
    }

    if (answer is List) {
      final list = answer as List;
      if (list.isEmpty) return 'No selections made';
      return list.map((e) => e.toString()).join(', ');
    }

    if (answer is String) {
      final str = answer as String;
      return str.trim().isEmpty ? 'No answer provided' : str.trim();
    }

    if (answer is num) {
      if (answer is double) {
        // Format decimals nicely
        return (answer as double) % 1 == 0
            ? (answer as double).toInt().toString()
            : (answer as double).toStringAsFixed(1);
      }
      return answer.toString();
    }

    return answer.toString();
  }

  /// Returns true if the answer is considered valid/non-empty
  bool get hasValidAnswer {
    if (answer == null) return false;

    if (answer is String) {
      return (answer as String).trim().isNotEmpty;
    }

    if (answer is List) {
      return (answer as List).isNotEmpty;
    }

    return true;
  }

  /// Returns a shortened version of the question text for compact display
  String getShortQuestionText({int maxLength = 30}) {
    if (questionText.length <= maxLength) {
      return questionText;
    }
    return '${questionText.substring(0, maxLength)}...';
  }

  /// Returns a shortened version of the answer for compact display
  String getShortDisplayAnswer({int maxLength = 20}) {
    final display = displayAnswer;
    if (display.length <= maxLength) {
      return display;
    }
    return '${display.substring(0, maxLength)}...';
  }

  /// Creates a copy with validation error
  CompletedResponse withValidationError(String error) {
    return copyWith(validationError: error);
  }

  /// Creates a copy clearing validation error
  CompletedResponse clearValidationError() {
    return copyWith(validationError: null);
  }
}

/// Represents a group of completed responses for a questionnaire section
///
/// This model groups responses by section and provides aggregate information
/// about completion status and expandable UI state.
@freezed
class ResponseGroup with _$ResponseGroup {
  const factory ResponseGroup({
    /// Unique identifier for the section
    required String sectionId,

    /// Human-readable title of the section
    required String sectionTitle,

    /// List of completed responses in this section
    required List<CompletedResponse> responses,

    /// Whether this group is expanded in the UI
    @Default(false) bool isExpanded,

    /// Total number of questions in this section (for progress calculation)
    int? totalQuestions,

    /// Optional section description
    String? sectionDescription,

    /// Order index for sorting sections
    @Default(0) int orderIndex,
  }) = _ResponseGroup;

  const ResponseGroup._();

  factory ResponseGroup.fromJson(Map<String, dynamic> json) =>
      _$ResponseGroupFromJson(json);

  /// Number of completed responses in this group
  int get completedCount => responses.length;

  /// Returns completion percentage if totalQuestions is known
  double get completionPercentage {
    if (totalQuestions == null || totalQuestions! == 0) {
      return responses.isEmpty ? 0.0 : 1.0;
    }
    return completedCount / totalQuestions!;
  }

  /// Returns true if all questions in the section are answered
  bool get isCompleted {
    if (totalQuestions == null) {
      return responses.isNotEmpty;
    }
    return completedCount >= totalQuestions!;
  }

  /// Returns true if no questions in the section are answered
  bool get isEmpty => responses.isEmpty;

  /// Returns true if some but not all questions are answered
  bool get isPartiallyCompleted {
    return !isEmpty && !isCompleted;
  }

  /// Returns a summary text for this group
  String get progressSummary {
    if (totalQuestions != null) {
      return '$completedCount/$totalQuestions completed';
    }
    return '$completedCount responses';
  }

  /// Returns the most recent response in this group
  CompletedResponse? get mostRecentResponse {
    if (responses.isEmpty) return null;

    return responses.reduce((a, b) =>
      a.answeredAt.isAfter(b.answeredAt) ? a : b);
  }

  /// Returns responses sorted by answer time (newest first)
  List<CompletedResponse> get responsesByTime {
    final sorted = List<CompletedResponse>.from(responses);
    sorted.sort((a, b) => b.answeredAt.compareTo(a.answeredAt));
    return sorted;
  }

  /// Creates a copy with toggled expansion state
  ResponseGroup toggleExpansion() {
    return copyWith(isExpanded: !isExpanded);
  }

  /// Creates a copy with a new response added
  ResponseGroup addResponse(CompletedResponse response) {
    final updatedResponses = List<CompletedResponse>.from(responses);

    // Remove existing response for the same question if it exists
    updatedResponses.removeWhere((r) => r.questionId == response.questionId);

    // Add the new response
    updatedResponses.add(response);

    return copyWith(responses: updatedResponses);
  }

  /// Creates a copy with a response removed
  ResponseGroup removeResponse(String questionId) {
    final updatedResponses = responses
        .where((r) => r.questionId != questionId)
        .toList();

    return copyWith(responses: updatedResponses);
  }

  /// Creates a copy with a response updated
  ResponseGroup updateResponse(CompletedResponse updatedResponse) {
    final updatedResponses = responses.map((r) {
      return r.questionId == updatedResponse.questionId
          ? updatedResponse
          : r;
    }).toList();

    return copyWith(responses: updatedResponses);
  }
}

/// Overall progress information across all response groups
///
/// This model provides aggregate statistics and navigation information
/// for the entire questionnaire response system.
@freezed
class OverallProgress with _$OverallProgress {
  const factory OverallProgress({
    /// List of all response groups
    required List<ResponseGroup> groups,

    /// Index of the currently active section
    @Default(0) int currentSectionIndex,

    /// Index of the currently active question within the section
    @Default(0) int currentQuestionIndex,

    /// Total number of questions across all sections
    int? totalQuestions,

    /// Timestamp of last update
    DateTime? lastUpdated,
  }) = _OverallProgress;

  const OverallProgress._();

  factory OverallProgress.fromJson(Map<String, dynamic> json) =>
      _$OverallProgressFromJson(json);

  /// Total number of completed responses across all groups
  int get totalCompleted {
    return groups.fold<int>(0, (sum, group) => sum + group.completedCount);
  }

  /// Overall completion percentage
  double get overallPercentage {
    if (totalQuestions == null || totalQuestions! == 0) {
      return groups.isEmpty ? 0.0 :
          (groups.any((g) => g.responses.isNotEmpty) ? 1.0 : 0.0);
    }
    return totalCompleted / totalQuestions!;
  }

  /// Number of sections with at least one response
  int get sectionsStarted {
    return groups.where((g) => g.responses.isNotEmpty).length;
  }

  /// Number of sections that are fully completed
  int get sectionsCompleted {
    return groups.where((g) => g.isCompleted).length;
  }

  /// Progress text for display (e.g., "2/4 sections")
  String get progressText {
    if (groups.isEmpty) return '0/0';
    return '${currentSectionIndex + 1}/${groups.length}';
  }

  /// Returns the currently active group
  ResponseGroup? get currentGroup {
    if (currentSectionIndex < 0 || currentSectionIndex >= groups.length) {
      return null;
    }
    return groups[currentSectionIndex];
  }

  /// Returns groups sorted by completion status (completed first, then by order)
  List<ResponseGroup> get groupsByCompletionStatus {
    final sorted = List<ResponseGroup>.from(groups);
    sorted.sort((a, b) {
      // Completed sections first
      if (a.isCompleted && !b.isCompleted) return -1;
      if (!a.isCompleted && b.isCompleted) return 1;

      // Then by order index
      return a.orderIndex.compareTo(b.orderIndex);
    });
    return sorted;
  }

  /// Returns true if any section has responses
  bool get hasAnyResponses {
    return groups.any((g) => g.responses.isNotEmpty);
  }

  /// Returns true if all sections are completed
  bool get isFullyCompleted {
    return groups.isNotEmpty && groups.every((g) => g.isCompleted);
  }
}