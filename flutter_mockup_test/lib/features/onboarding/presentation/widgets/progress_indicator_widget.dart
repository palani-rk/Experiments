import 'package:flutter/material.dart';
import '../../../../shared/theme/app_theme.dart';

class QuestionnaireProgressIndicator extends StatelessWidget {
  final double progress;
  
  const QuestionnaireProgressIndicator({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.l),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: AppTextStyles.progressLabel.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: AppTextStyles.progressPercent.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.xs),
        Container(
          height: AppSizes.progressBarHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusXs),
          ),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusXs),
          ),
        ),
      ],
    );
  }
}