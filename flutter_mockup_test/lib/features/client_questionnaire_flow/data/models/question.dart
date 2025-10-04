import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'question.freezed.dart';
part 'question.g.dart';

/// Validation rules for question responses
@freezed
class ValidationRules with _$ValidationRules {
  const factory ValidationRules({
    int? minLength,
    int? maxLength,
    num? minValue,
    num? maxValue,
    String? pattern,
    bool? required,
  }) = _ValidationRules;

  factory ValidationRules.fromJson(Map<String, dynamic> json) =>
      _$ValidationRulesFromJson(json);
}

/// Individual question model with validation rules
@freezed
class Question with _$Question {
  const factory Question({
    required String id,
    required String sectionId,
    required String questionText,
    required QuestionType inputType,
    @Default(true) bool required,
    List<String>? options,
    ValidationRules? validation,
    String? placeholder,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}

/// Extension methods for Question - Pure data access only
extension QuestionExtension on Question {
  /// Gets the appropriate placeholder text
  String get effectivePlaceholder {
    if (placeholder != null && placeholder!.isNotEmpty) {
      return placeholder!;
    }

    switch (inputType) {
      case QuestionType.textInput:
        return 'Enter your answer...';
      case QuestionType.numberInput:
        return 'Enter a number...';
      case QuestionType.singleSelect:
        return 'Select an option...';
      case QuestionType.multiSelect:
        return 'Select one or more options...';
      case QuestionType.textArea:
        return 'Enter your detailed response...';
    }
  }

  /// Checks if this question type supports options
  bool get supportsOptions {
    return inputType == QuestionType.singleSelect ||
           inputType == QuestionType.multiSelect;
  }
}