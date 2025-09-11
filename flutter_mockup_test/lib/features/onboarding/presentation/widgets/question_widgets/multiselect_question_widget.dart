import 'package:flutter/material.dart';
import '../../../data/models/questionnaire_schema.dart';
import '../../../../../shared/theme/app_theme.dart';

class MultiselectQuestionWidget extends StatelessWidget {
  final Question question;
  final List<String>? currentValue;
  final ValueChanged<List<String>> onChanged;

  const MultiselectQuestionWidget({
    super.key,
    required this.question,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final options = question.options ?? [];
    final selectedOptions = currentValue ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (question.hint != null) ...[
          Text(
            question.hint!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSizes.m),
        ],
        Text(
          'Select all that apply:',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSizes.m),
        Column(
          children: options.map((option) {
            final isSelected = selectedOptions.contains(option);
            
            return Container(
              margin: const EdgeInsets.only(bottom: AppSizes.s),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    final newSelection = List<String>.from(selectedOptions);
                    if (isSelected) {
                      newSelection.remove(option);
                    } else {
                      newSelection.add(option);
                    }
                    onChanged(newSelection);
                  },
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.m),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      border: Border.all(
                        color: isSelected 
                          ? theme.colorScheme.primary 
                          : theme.colorScheme.outline.withOpacity(0.5),
                        width: isSelected ? 2 : 1,
                      ),
                      color: isSelected 
                        ? theme.colorScheme.primaryContainer.withOpacity(0.1)
                        : theme.colorScheme.surface,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppSizes.radiusXs),
                            border: Border.all(
                              color: isSelected 
                                ? theme.colorScheme.primary 
                                : theme.colorScheme.outline,
                              width: 2,
                            ),
                            color: isSelected 
                              ? theme.colorScheme.primary 
                              : Colors.transparent,
                          ),
                          child: isSelected
                            ? Icon(
                                Icons.check,
                                size: 14,
                                color: theme.colorScheme.onPrimary,
                              )
                            : null,
                        ),
                        const SizedBox(width: AppSizes.m),
                        Expanded(
                          child: Text(
                            option,
                            style: AppTextStyles.answerText.copyWith(
                              color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                              fontWeight: isSelected 
                                ? FontWeight.w600 
                                : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (selectedOptions.isNotEmpty) ...[
          const SizedBox(height: AppSizes.m),
          Wrap(
            spacing: AppSizes.s,
            runSpacing: AppSizes.xs,
            children: selectedOptions.map((option) {
              return Chip(
                label: Text(
                  option,
                  style: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: theme.colorScheme.primaryContainer,
                deleteIcon: Icon(
                  Icons.close,
                  size: 16,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                onDeleted: () {
                  final newSelection = List<String>.from(selectedOptions);
                  newSelection.remove(option);
                  onChanged(newSelection);
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}