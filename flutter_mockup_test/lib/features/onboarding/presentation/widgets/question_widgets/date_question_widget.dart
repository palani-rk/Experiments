import 'package:flutter/material.dart';
import '../../../data/models/questionnaire_schema.dart';
import '../../../../../shared/theme/app_theme.dart';

class DateQuestionWidget extends StatelessWidget {
  final Question question;
  final DateTime? currentValue;
  final ValueChanged<DateTime> onChanged;

  const DateQuestionWidget({
    super.key,
    required this.question,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _selectDate(context),
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.l),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                border: Border.all(
                  color: currentValue != null
                    ? theme.colorScheme.primary.withOpacity(0.5)
                    : theme.colorScheme.outline.withOpacity(0.5),
                ),
                color: theme.colorScheme.surface,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: currentValue != null
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                    size: AppSizes.iconL,
                  ),
                  const SizedBox(width: AppSizes.m),
                  Expanded(
                    child: Text(
                      currentValue != null
                        ? _formatDate(currentValue!)
                        : 'Select date...',
                      style: AppTextStyles.answerText.copyWith(
                        color: currentValue != null
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                      ),
                    ),
                  ),
                  if (currentValue != null)
                    IconButton(
                      onPressed: () => onChanged(DateTime.now()),
                      icon: Icon(
                        Icons.clear,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: AppSizes.iconM,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final validation = question.validation ?? {};
    final firstDate = validation['firstDate'] != null
      ? DateTime.parse(validation['firstDate'] as String)
      : DateTime(1900);
    final lastDate = validation['lastDate'] != null
      ? DateTime.parse(validation['lastDate'] as String)
      : DateTime(2100);

    final date = await showDatePicker(
      context: context,
      initialDate: currentValue ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (date != null) {
      onChanged(date);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}