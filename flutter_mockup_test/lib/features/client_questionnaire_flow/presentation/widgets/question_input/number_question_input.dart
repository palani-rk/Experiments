import 'package:flutter/material.dart';
import '../../../data/models/question.dart';
import '../../../../../shared/theme/app_theme.dart';

/// Number input widget with unit selector - Phase 1: Static implementation
/// TODO: Phase 2 - Add validation and state management
class NumberQuestionInput extends StatelessWidget {
  final Question question;
  final String? currentValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmit;

  const NumberQuestionInput({
    super.key,
    required this.question,
    this.currentValue,
    this.onChanged,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey('number_input_${question.id}'),
      initialValue: currentValue,
      decoration: _getInputDecoration(context),
      style: _getInputTextStyle(context),
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      onFieldSubmitted: (_) => onSubmit?.call(),
    );
  }

  InputDecoration _getInputDecoration(BuildContext context) {
    return InputDecoration(
      hintText: question.effectivePlaceholder,
      hintStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: AppSizes.inputBorderWidth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: AppSizes.inputBorderWidth,
        ),
      ),
    );
  }

  TextStyle _getInputTextStyle(BuildContext context) {
    return AppTextStyles.chatMessage.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
    );
  }
}