import 'package:flutter/material.dart';
import '../../../data/models/questionnaire_schema.dart';
import '../../../../../shared/theme/app_theme.dart';

class SliderQuestionWidget extends StatelessWidget {
  final Question question;
  final double? currentValue;
  final ValueChanged<double> onChanged;

  const SliderQuestionWidget({
    super.key,
    required this.question,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final validation = question.validation ?? {};
    final min = (validation['min'] as num?)?.toDouble() ?? 0.0;
    final max = (validation['max'] as num?)?.toDouble() ?? 100.0;
    final divisions = (validation['divisions'] as num?)?.toInt() ?? 10;
    final value = currentValue ?? min;
    
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
        Container(
          padding: const EdgeInsets.all(AppSizes.l),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.5),
            ),
            color: theme.colorScheme.surface,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Value:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.m,
                      vertical: AppSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.radiusS),
                      color: theme.colorScheme.primaryContainer,
                    ),
                    child: Text(
                      value.toInt().toString(),
                      style: AppTextStyles.answerText.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.m),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: theme.colorScheme.primary,
                  inactiveTrackColor: theme.colorScheme.surfaceVariant,
                  thumbColor: theme.colorScheme.primary,
                  overlayColor: theme.colorScheme.primary.withOpacity(0.2),
                  valueIndicatorColor: theme.colorScheme.primary,
                  valueIndicatorTextStyle: TextStyle(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: divisions,
                  onChanged: onChanged,
                  label: value.toInt().toString(),
                ),
              ),
              const SizedBox(height: AppSizes.s),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    min.toInt().toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    max.toInt().toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}