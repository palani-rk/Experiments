import 'package:flutter/material.dart';
import '../../../data/models/questionnaire_schema.dart';
import 'text_question_widget.dart';
import 'number_question_widget.dart';
import 'radio_question_widget.dart';
import 'multiselect_question_widget.dart';
import 'slider_question_widget.dart';
import 'date_question_widget.dart';

class QuestionWidgetFactory {
  static Widget create({
    required Question question,
    required dynamic currentValue,
    required ValueChanged<dynamic> onChanged,
  }) {
    switch (question.inputType) {
      case QuestionType.text:
        return TextQuestionWidget(
          question: question,
          currentValue: currentValue as String?,
          onChanged: onChanged,
        );
      
      case QuestionType.number:
        return NumberQuestionWidget(
          question: question,
          currentValue: currentValue as int?,
          onChanged: onChanged,
        );
      
      case QuestionType.radio:
        return RadioQuestionWidget(
          question: question,
          currentValue: currentValue as String?,
          onChanged: onChanged,
        );
      
      case QuestionType.multiselect:
        return MultiselectQuestionWidget(
          question: question,
          currentValue: currentValue as List<String>?,
          onChanged: onChanged,
        );

      case QuestionType.slider:
        return SliderQuestionWidget(
          question: question,
          currentValue: currentValue as double?,
          onChanged: onChanged,
        );

      case QuestionType.date:
        return DateQuestionWidget(
          question: question,
          currentValue: currentValue as DateTime?,
          onChanged: onChanged,
        );
      
      default:
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Unsupported question type: ${question.inputType}',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        );
    }
  }
}