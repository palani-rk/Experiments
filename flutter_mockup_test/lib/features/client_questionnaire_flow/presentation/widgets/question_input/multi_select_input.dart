import 'package:flutter/material.dart';
import '../../../data/models/question.dart';
import '../../../../../shared/theme/app_theme.dart';

/// Multi select input widget (checkboxes) - Phase 1: Static implementation
/// TODO: Phase 2 - Add selection state and logic
class MultiSelectInput extends StatelessWidget {
  final Question question;
  final List<String>? selectedValues;
  final ValueChanged<List<String>>? onChanged;
  final VoidCallback? onSubmit;

  const MultiSelectInput({
    super.key,
    required this.question,
    this.selectedValues,
    this.onChanged,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    if (question.options == null || question.options!.isEmpty) {
      return Text(
        'No options available',
        style: _getInputTextStyle(context),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Constrain the options list to prevent overflow with many options
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5, // Max 50% of screen height
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: question.options!.map((option) =>
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.s),
                  child: _buildOptionTile(context, option),
                ),
              ).toList(),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.m),
        _buildSubmitButton(context),
      ],
    );
  }

  Widget _buildOptionTile(BuildContext context, String option) {
    final isSelected = selectedValues?.contains(option) ?? false;

    return GestureDetector(
      onTap: () => _toggleOption(option),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.m),
        decoration: BoxDecoration(
          color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
            : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(
            color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
              size: AppSizes.iconM,
            ),
            const SizedBox(width: AppSizes.m),
            Expanded(
              child: Text(
                option,
                style: _getInputTextStyle(context).copyWith(
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
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

  void _toggleOption(String option) {
    // Phase 1: Static implementation - no actual state change
    // TODO: Phase 2 - Implement actual selection logic
    final currentSelection = selectedValues ?? <String>[];
    final newSelection = currentSelection.contains(option)
      ? currentSelection.where((item) => item != option).toList()
      : [...currentSelection, option];

    onChanged?.call(newSelection);
  }

  TextStyle _getInputTextStyle(BuildContext context) {
    return AppTextStyles.chatMessage.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
    );
  }
}