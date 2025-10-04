import 'package:flutter/material.dart';
import '../../data/models/question.dart';
import 'question_input/question_input.dart';
import '../../../../shared/theme/app_theme.dart';

/// Active question input area container with continue button
/// Enhanced to include explicit continue button for better UX
class CurrentQuestionArea extends StatefulWidget {
  final Question question;
  final dynamic currentValue;
  final ValueChanged<dynamic>? onValueChanged;
  final VoidCallback? onSubmit;
  final bool isEditMode;

  const CurrentQuestionArea({
    super.key,
    required this.question,
    this.currentValue,
    this.onValueChanged,
    this.onSubmit,
    this.isEditMode = false,
  });

  @override
  State<CurrentQuestionArea> createState() => _CurrentQuestionAreaState();
}

class _CurrentQuestionAreaState extends State<CurrentQuestionArea> {
  dynamic _inputValue;

  @override
  void initState() {
    super.initState();
    _inputValue = widget.currentValue;
  }

  @override
  void didUpdateWidget(CurrentQuestionArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentValue != oldWidget.currentValue) {
      _inputValue = widget.currentValue;
    }
  }

  void _handleInputChanged(dynamic value) {
    setState(() {
      _inputValue = value;
    });
    widget.onValueChanged?.call(value);
  }

  void _handleContinue() {
    if (_inputValue != null) {
      widget.onSubmit?.call();
    }
  }

  bool get _hasValidInput {
    return _inputValue != null &&
           _inputValue.toString().trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.l),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: AppShadows.elevated(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Edit mode indicator and question display
          if (widget.isEditMode) ...[
            Container(
              padding: const EdgeInsets.all(AppSizes.s),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppSizes.radiusS),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    size: AppSizes.iconS,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: AppSizes.s),
                  Text(
                    'Edit Mode',
                    style: AppTextStyles.statusLabel.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.m),
          ],

          // Current question display
          Text(
            widget.question.questionText,
            style: AppTextStyles.currentQuestionText.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: AppSizes.m),

          // Dynamic input based on question type
          QuestionInput(
            question: widget.question,
            currentValue: _inputValue,
            onChanged: _handleInputChanged,
            onSubmit: null, // Remove auto-submit from input
          ),

          const SizedBox(height: AppSizes.l),

          // Continue/Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _hasValidInput ? _handleContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isEditMode
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.primary,
                foregroundColor: widget.isEditMode
                    ? Theme.of(context).colorScheme.onSecondary
                    : Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: AppSizes.m),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isEditMode) ...[
                    const Icon(
                      Icons.save,
                      size: AppSizes.iconS,
                    ),
                    const SizedBox(width: AppSizes.s),
                  ],
                  Text(
                    widget.isEditMode ? 'Save Changes' : 'Continue',
                    style: AppTextStyles.buttonText,
                  ),
                ],
              ),
            ),
          ),

          // Add some bottom padding to ensure content doesn't get cut off
          const SizedBox(height: AppSizes.m),
        ],
      ),
    );
  }
}