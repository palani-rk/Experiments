import 'package:flutter/material.dart';
import '../../../data/models/question.dart';
import '../../../../../shared/theme/app_theme.dart';

/// Single select input widget (radio buttons) - Phase 1: Static implementation
/// TODO: Phase 2 - Add selection state and logic
class SingleSelectInput extends StatelessWidget {
  final Question question;
  final String? selectedValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmit;

  const SingleSelectInput({
    super.key,
    required this.question,
    this.selectedValue,
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
      ],
    );
  }

  Widget _buildOptionTile(BuildContext context, String option) {
    final isSelected = selectedValue == option;

    return GestureDetector(
      onTap: () {
        onChanged?.call(option);
        onSubmit?.call();
      },
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
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
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

  TextStyle _getInputTextStyle(BuildContext context) {
    return AppTextStyles.chatMessage.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
    );
  }
}