import 'package:flutter/material.dart';
import '../../../../shared/theme/app_theme.dart';

/// Progress indicator widget showing section completion - Phase 3: Dynamic implementation
/// Connected to dynamic progress state
class ProgressIndicator extends StatelessWidget {
  final int currentSection;
  final int totalSections;
  final List<String> sectionNames;
  final double? overallProgress;

  const ProgressIndicator({
    super.key,
    required this.currentSection,
    required this.totalSections,
    required this.sectionNames,
    this.overallProgress,
  });

  @override
  Widget build(BuildContext context) {
    final progress = overallProgress ?? (totalSections > 0 ? currentSection / totalSections : 0.0);

    return Container(
      padding: const EdgeInsets.all(AppSizes.l),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: AppShadows.card(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusS),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: AppSizes.progressBarHeight,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: AppSizes.s),

          // Progress text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentSection < sectionNames.length
                  ? sectionNames[currentSection]
                  : (sectionNames.isNotEmpty ? sectionNames.last : 'Complete'),
                style: AppTextStyles.progressLabel.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: AppTextStyles.progressPercent.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}