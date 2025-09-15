import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../core/enums.dart';

part 'question.freezed.dart';
part 'question.g.dart';

/// Question model for the chat-based questionnaire
///
/// Represents a single question with its properties, validation rules,
/// and conditional display logic.
@freezed
class Question with _$Question {
  const Question._();

  const factory Question({
    required String id,
    required String sectionId,
    required String text,
    required QuestionType inputType,
    @Default(false) bool required,
    String? hint,
    String? placeholder,
    List<String>? options,
    Map<String, dynamic>? validation,
    Map<String, dynamic>? metadata,
    @Default(0) int order,
  }) = _Question;

  // Factory constructors for different question types
  factory Question.text({
    required String id,
    required String sectionId,
    required String text,
    bool required = false,
    String? hint,
    String? placeholder,
    int? maxLength,
    int? minLength,
    int order = 0,
  }) {
    return Question(
      id: id,
      sectionId: sectionId,
      text: text,
      inputType: QuestionType.text,
      required: required,
      hint: hint,
      placeholder: placeholder,
      validation: {
        if (maxLength != null) 'maxLength': maxLength,
        if (minLength != null) 'minLength': minLength,
      },
      order: order,
    );
  }

  factory Question.number({
    required String id,
    required String sectionId,
    required String text,
    bool required = false,
    String? hint,
    num? min,
    num? max,
    int? decimals,
    int order = 0,
  }) {
    return Question(
      id: id,
      sectionId: sectionId,
      text: text,
      inputType: QuestionType.number,
      required: required,
      hint: hint,
      validation: {
        if (min != null) 'min': min,
        if (max != null) 'max': max,
        if (decimals != null) 'decimals': decimals,
      },
      order: order,
    );
  }

  factory Question.email({
    required String id,
    required String sectionId,
    required String text,
    bool required = false,
    String? hint,
    int order = 0,
  }) {
    return Question(
      id: id,
      sectionId: sectionId,
      text: text,
      inputType: QuestionType.email,
      required: required,
      hint: hint,
      placeholder: 'example@email.com',
      order: order,
    );
  }

  factory Question.phone({
    required String id,
    required String sectionId,
    required String text,
    bool required = false,
    String? hint,
    String? countryCode,
    int order = 0,
  }) {
    return Question(
      id: id,
      sectionId: sectionId,
      text: text,
      inputType: QuestionType.phone,
      required: required,
      hint: hint,
      placeholder: '+1 (555) 123-4567',
      metadata: {
        if (countryCode != null) 'countryCode': countryCode,
      },
      order: order,
    );
  }

  factory Question.date({
    required String id,
    required String sectionId,
    required String text,
    bool required = false,
    String? hint,
    DateTime? minDate,
    DateTime? maxDate,
    int order = 0,
  }) {
    return Question(
      id: id,
      sectionId: sectionId,
      text: text,
      inputType: QuestionType.date,
      required: required,
      hint: hint,
      validation: {
        if (minDate != null) 'minDate': minDate.toIso8601String(),
        if (maxDate != null) 'maxDate': maxDate.toIso8601String(),
      },
      order: order,
    );
  }

  factory Question.radio({
    required String id,
    required String sectionId,
    required String text,
    required List<String> options,
    bool required = false,
    String? hint,
    int order = 0,
  }) {
    return Question(
      id: id,
      sectionId: sectionId,
      text: text,
      inputType: QuestionType.radio,
      required: required,
      hint: hint,
      options: options,
      order: order,
    );
  }

  factory Question.multiselect({
    required String id,
    required String sectionId,
    required String text,
    required List<String> options,
    bool required = false,
    String? hint,
    int? minSelections,
    int? maxSelections,
    int order = 0,
  }) {
    return Question(
      id: id,
      sectionId: sectionId,
      text: text,
      inputType: QuestionType.multiselect,
      required: required,
      hint: hint,
      options: options,
      validation: {
        if (minSelections != null) 'minSelections': minSelections,
        if (maxSelections != null) 'maxSelections': maxSelections,
      },
      order: order,
    );
  }

  factory Question.slider({
    required String id,
    required String sectionId,
    required String text,
    required double min,
    required double max,
    bool required = false,
    String? hint,
    double? step,
    String? minLabel,
    String? maxLabel,
    int order = 0,
  }) {
    return Question(
      id: id,
      sectionId: sectionId,
      text: text,
      inputType: QuestionType.slider,
      required: required,
      hint: hint,
      validation: {
        'min': min,
        'max': max,
        if (step != null) 'step': step,
      },
      metadata: {
        if (minLabel != null) 'minLabel': minLabel,
        if (maxLabel != null) 'maxLabel': maxLabel,
      },
      order: order,
    );
  }

  factory Question.scale({
    required String id,
    required String sectionId,
    required String text,
    required int min,
    required int max,
    bool required = false,
    String? hint,
    String? minLabel,
    String? maxLabel,
    int order = 0,
  }) {
    return Question(
      id: id,
      sectionId: sectionId,
      text: text,
      inputType: QuestionType.scale,
      required: required,
      hint: hint,
      validation: {
        'min': min,
        'max': max,
      },
      metadata: {
        if (minLabel != null) 'minLabel': minLabel,
        if (maxLabel != null) 'maxLabel': maxLabel,
      },
      order: order,
    );
  }

  factory Question.boolean({
    required String id,
    required String sectionId,
    required String text,
    bool required = false,
    String? hint,
    String? trueLabel,
    String? falseLabel,
    int order = 0,
  }) {
    return Question(
      id: id,
      sectionId: sectionId,
      text: text,
      inputType: QuestionType.boolean,
      required: required,
      hint: hint,
      metadata: {
        'trueLabel': trueLabel ?? 'Yes',
        'falseLabel': falseLabel ?? 'No',
      },
      order: order,
    );
  }

  // JSON serialization
  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  // Business logic properties
  bool get hasOptions => options != null && options!.isNotEmpty;
  bool get hasValidation => validation != null && validation!.isNotEmpty;
  bool get hasMetadata => metadata != null && metadata!.isNotEmpty;

  /// Get validation rule value
  T? getValidationRule<T>(String key) {
    try {
      return validation?[key] as T?;
    } catch (e) {
      return null;
    }
  }

  /// Get metadata value
  T? getMetadata<T>(String key) {
    try {
      return metadata?[key] as T?;
    } catch (e) {
      return null;
    }
  }

  /// Check if question should be shown based on conditions
  bool shouldShow(Map<String, dynamic> previousAnswers) {
    final showIf = getMetadata<Map<String, dynamic>>('showIf');
    if (showIf == null) return true;

    final dependentQuestionId = showIf['questionId'] as String?;
    final expectedValue = showIf['value'];
    final operator = showIf['operator'] as String? ?? 'equals';

    if (dependentQuestionId == null || expectedValue == null) return true;

    final dependentAnswer = previousAnswers[dependentQuestionId];
    if (dependentAnswer == null) return false;

    switch (operator) {
      case 'equals':
        return dependentAnswer == expectedValue;
      case 'not_equals':
        return dependentAnswer != expectedValue;
      case 'contains':
        if (dependentAnswer is List) {
          return dependentAnswer.contains(expectedValue);
        }
        return dependentAnswer.toString().contains(expectedValue.toString());
      case 'not_contains':
        if (dependentAnswer is List) {
          return !dependentAnswer.contains(expectedValue);
        }
        return !dependentAnswer.toString().contains(expectedValue.toString());
      case 'greater_than':
        if (dependentAnswer is num && expectedValue is num) {
          return dependentAnswer > expectedValue;
        }
        return false;
      case 'less_than':
        if (dependentAnswer is num && expectedValue is num) {
          return dependentAnswer < expectedValue;
        }
        return false;
      default:
        return true;
    }
  }

  /// Get effective placeholder text
  String get effectivePlaceholder =>
      placeholder ?? hint ?? inputType.inputHint;

  /// Get display text for this question
  String get displayText {
    const requiredIndicator = ' *';
    return this.required ? '$text$requiredIndicator' : text;
  }

  /// Validate an answer against this question's rules
  List<String> validateAnswer(dynamic answer) {
    final errors = <String>[];

    // Check if required
    if (this.required && (answer == null || _isEmpty(answer))) {
      errors.add('This field is required');
      return errors;
    }

    // Skip validation if answer is empty and not required
    if (answer == null || _isEmpty(answer)) return errors;

    // Type-specific validation
    switch (inputType) {
      case QuestionType.text:
        errors.addAll(_validateText(answer));
        break;
      case QuestionType.number:
      case QuestionType.slider:
      case QuestionType.scale:
        errors.addAll(_validateNumber(answer));
        break;
      case QuestionType.email:
        errors.addAll(_validateEmail(answer));
        break;
      case QuestionType.phone:
        errors.addAll(_validatePhone(answer));
        break;
      case QuestionType.date:
        errors.addAll(_validateDate(answer));
        break;
      case QuestionType.radio:
        errors.addAll(_validateRadio(answer));
        break;
      case QuestionType.multiselect:
        errors.addAll(_validateMultiselect(answer));
        break;
      case QuestionType.boolean:
        errors.addAll(_validateBoolean(answer));
        break;
    }

    return errors;
  }

  bool _isEmpty(dynamic value) {
    if (value == null) return true;
    if (value is String) return value.trim().isEmpty;
    if (value is List) return value.isEmpty;
    return false;
  }

  List<String> _validateText(dynamic answer) {
    final errors = <String>[];
    if (answer is! String) return ['Answer must be text'];

    final text = answer;
    final minLength = getValidationRule<int>('minLength');
    final maxLength = getValidationRule<int>('maxLength');

    if (minLength != null && text.length < minLength) {
      errors.add('Answer must be at least $minLength characters');
    }
    if (maxLength != null && text.length > maxLength) {
      errors.add('Answer must be no more than $maxLength characters');
    }

    return errors;
  }

  List<String> _validateNumber(dynamic answer) {
    final errors = <String>[];
    final num? number;

    if (answer is num) {
      number = answer;
    } else if (answer is String) {
      number = num.tryParse(answer);
      if (number == null) {
        return ['Answer must be a valid number'];
      }
    } else {
      return ['Answer must be a number'];
    }

    final min = getValidationRule<num>('min');
    final max = getValidationRule<num>('max');

    if (min != null && number < min) {
      errors.add('Answer must be at least $min');
    }
    if (max != null && number > max) {
      errors.add('Answer must be no more than $max');
    }

    return errors;
  }

  List<String> _validateEmail(dynamic answer) {
    if (answer is! String) return ['Email must be text'];

    final email = answer;
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

    if (!emailRegex.hasMatch(email)) {
      return ['Please enter a valid email address'];
    }

    return [];
  }

  List<String> _validatePhone(dynamic answer) {
    if (answer is! String) return ['Phone number must be text'];

    final phone = answer;
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');

    if (!phoneRegex.hasMatch(phone)) {
      return ['Please enter a valid phone number'];
    }

    return [];
  }

  List<String> _validateDate(dynamic answer) {
    DateTime? date;

    if (answer is DateTime) {
      date = answer;
    } else if (answer is String) {
      date = DateTime.tryParse(answer);
    } else {
      return ['Answer must be a valid date'];
    }

    if (date == null) return ['Please enter a valid date'];

    final errors = <String>[];
    final minDateStr = getValidationRule<String>('minDate');
    final maxDateStr = getValidationRule<String>('maxDate');

    if (minDateStr != null) {
      final minDate = DateTime.tryParse(minDateStr);
      if (minDate != null && date.isBefore(minDate)) {
        errors.add('Date must be after ${minDate.day}/${minDate.month}/${minDate.year}');
      }
    }

    if (maxDateStr != null) {
      final maxDate = DateTime.tryParse(maxDateStr);
      if (maxDate != null && date.isAfter(maxDate)) {
        errors.add('Date must be before ${maxDate.day}/${maxDate.month}/${maxDate.year}');
      }
    }

    return errors;
  }

  List<String> _validateRadio(dynamic answer) {
    if (answer is! String) return ['Please select an option'];

    if (hasOptions && !options!.contains(answer)) {
      return ['Selected option is not valid'];
    }

    return [];
  }

  List<String> _validateMultiselect(dynamic answer) {
    if (answer is! List) return ['Answer must be a list of selections'];

    final selections = answer;
    final errors = <String>[];

    final minSelections = getValidationRule<int>('minSelections');
    final maxSelections = getValidationRule<int>('maxSelections');

    if (minSelections != null && selections.length < minSelections) {
      errors.add('Please select at least $minSelections option(s)');
    }
    if (maxSelections != null && selections.length > maxSelections) {
      errors.add('Please select no more than $maxSelections option(s)');
    }

    if (hasOptions) {
      for (final selection in selections) {
        if (!options!.contains(selection)) {
          errors.add('$selection is not a valid option');
        }
      }
    }

    return errors;
  }

  List<String> _validateBoolean(dynamic answer) {
    if (answer is! bool) return ['Answer must be Yes or No'];
    return [];
  }
}