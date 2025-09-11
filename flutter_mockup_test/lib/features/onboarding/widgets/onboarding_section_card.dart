import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';

/// Section group card widget for displaying completed onboarding sections
/// 
/// This widget creates a card-style container for organizing related
/// onboarding content into logical sections:
/// 
/// - Card-style container with border, shadow, and rounded corners
/// - Header area with section icon, title, and completion status
/// - Primary container background for header visual emphasis
/// - Check circle icon when section is marked as completed
/// - Flexible content area for child widgets (questions, answers, etc.)
/// - Consistent padding and spacing throughout
/// 
/// Used in onboarding review screens to group related question-answer
/// pairs or other content by topic (e.g., "Personal Information", 
/// "Health Goals", "Dietary Preferences"). Provides clear visual
/// organization and completion status for user progress tracking.
class OnboardingSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isCompleted;
  final List<Widget> children;

  const OnboardingSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.5),
          width: AppSizes.inputBorderWidth,
        ),
        boxShadow: AppShadows.card(context),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.l),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSizes.radiusL - 2),
                topRight: Radius.circular(AppSizes.radiusL - 2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: AppSizes.iconL,
                ),
                const SizedBox(width: AppSizes.s),
                Text(
                  title,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const Spacer(),
                if (isCompleted)
                  Icon(
                    Icons.check_circle,
                    color: theme.colorScheme.tertiary,
                    size: AppSizes.iconL,
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.l),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}