import 'package:flutter/material.dart';
import '../../../data/models/question.dart';
import '../../../data/models/enums.dart';
import 'text_question_input.dart';
import 'number_question_input.dart';
import 'single_select_input.dart';
import 'multi_select_input.dart';
import 'text_area_input.dart';

/// Dynamic input widget factory based on question type - Phase 1: Static implementation
/// TODO: Phase 2 - Add validation and state management
class QuestionInput extends StatelessWidget {
  final Question question;
  final dynamic currentValue;
  final ValueChanged<dynamic>? onChanged;
  final VoidCallback? onSubmit;

  const QuestionInput({
    super.key,
    required this.question,
    this.currentValue,
    this.onChanged,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    switch (question.inputType) {
      case QuestionType.textInput:
        return TextQuestionInput(
          question: question,
          currentValue: currentValue?.toString(),
          onChanged: (value) => onChanged?.call(value),
          onSubmit: onSubmit,
        );

      case QuestionType.numberInput:
        return NumberQuestionInput(
          question: question,
          currentValue: currentValue?.toString(),
          onChanged: (value) => onChanged?.call(value),
          onSubmit: onSubmit,
        );

      case QuestionType.singleSelect:
        return SingleSelectInput(
          question: question,
          selectedValue: currentValue?.toString(),
          onChanged: (value) => onChanged?.call(value),
          onSubmit: onSubmit,
        );

      case QuestionType.multiSelect:
        return MultiSelectInput(
          question: question,
          selectedValues: currentValue is List
            ? (currentValue as List).map((e) => e.toString()).toList()
            : null,
          onChanged: (values) => onChanged?.call(values),
          onSubmit: onSubmit,
        );

      case QuestionType.textArea:
        return TextAreaInput(
          question: question,
          currentValue: currentValue?.toString(),
          onChanged: (value) => onChanged?.call(value),
          onSubmit: onSubmit,
        );
    }
  }
}