import 'package:json_annotation/json_annotation.dart';

/// Question input types for different UI components
@JsonEnum()
enum QuestionType {
  @JsonValue('text_input')
  textInput,
  @JsonValue('number_input')
  numberInput,
  @JsonValue('single_select')
  singleSelect,
  @JsonValue('multi_select')
  multiSelect,
  @JsonValue('text_area')
  textArea,
}

/// Section completion status
@JsonEnum()
enum SectionStatus {
  @JsonValue('not_started')
  notStarted,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
}

/// Extension methods for QuestionType
extension QuestionTypeExtension on QuestionType {
  String get displayName {
    switch (this) {
      case QuestionType.textInput:
        return 'Text Input';
      case QuestionType.numberInput:
        return 'Number Input';
      case QuestionType.singleSelect:
        return 'Single Select';
      case QuestionType.multiSelect:
        return 'Multi Select';
      case QuestionType.textArea:
        return 'Text Area';
    }
  }
}

/// Extension methods for SectionStatus
extension SectionStatusExtension on SectionStatus {
  String get displayName {
    switch (this) {
      case SectionStatus.notStarted:
        return 'Not Started';
      case SectionStatus.inProgress:
        return 'In Progress';
      case SectionStatus.completed:
        return 'Completed';
    }
  }

  bool get isCompleted => this == SectionStatus.completed;
  bool get isStarted => this != SectionStatus.notStarted;
}