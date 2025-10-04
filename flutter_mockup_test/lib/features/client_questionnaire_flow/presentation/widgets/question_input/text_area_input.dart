import 'package:flutter/material.dart';
import '../../../data/models/question.dart';
import '../../../../../shared/theme/app_theme.dart';

/// Multi-line text area input widget - Phase 1: Static implementation
/// TODO: Phase 2 - Add validation and state management
class TextAreaInput extends StatelessWidget {
  final Question question;
  final String? currentValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmit;

  const TextAreaInput({
    super.key,
    required this.question,
    this.currentValue,
    this.onChanged,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          key: ValueKey('text_area_${question.id}'),
          initialValue: currentValue,
          decoration: _getInputDecoration(context),
          style: _getInputTextStyle(context),
          maxLines: 4,
          minLines: 2,
          onChanged: onChanged,
        ),
        const SizedBox(height: AppSizes.m),
        _buildSubmitButton(context),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: onSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: AppSizes.m),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
      ),
      child: const Text('Continue'),
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