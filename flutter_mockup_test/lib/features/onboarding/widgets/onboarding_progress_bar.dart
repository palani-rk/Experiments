import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';

/// Progress indicator widget for tracking onboarding flow completion
/// 
/// This widget displays:
/// - Current section name being completed
/// - Progress percentage as text and visual progress bar
/// - Styled container with primary color theming
/// - Linear progress indicator with custom styling
/// 
/// Used throughout the onboarding process to give users clear
/// visual feedback on their completion progress and current position
/// in the multi-step onboarding flow.
class OnboardingProgressBar extends StatelessWidget {
  final String currentSection;
  final double progress;

  const OnboardingProgressBar({
    super.key,
    required this.currentSection,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.l,
        vertical: AppSizes.s,
      ),
      color: theme.colorScheme.primaryContainer,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentSection,
                style: AppTextStyles.progressLabel.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}% complete',
                style: AppTextStyles.progressPercent.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.s),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            minHeight: AppSizes.progressBarHeight,
          ),
        ],
      ),
    );
  }
}