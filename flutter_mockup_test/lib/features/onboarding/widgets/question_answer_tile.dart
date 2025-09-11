import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';

/// Question-answer pair display component for completed onboarding sections
/// 
/// This widget displays a question and answer pair in a compact format:
/// - Question with bot avatar and secondary text styling
/// - Answer with user avatar and primary text styling  
/// - Optional edit button for modifying answers
/// - Compact vertical layout with proper spacing
/// 
/// Used in onboarding review screens to show previously completed
/// question-answer pairs, allowing users to see their responses
/// and optionally edit them before final submission.
/// 
/// The styling differentiates between bot questions and user answers
/// using different avatars and text colors for clear visual hierarchy.
class QuestionAnswerTile extends StatelessWidget {
  final String question;
  final String answer;
  final VoidCallback? onEdit;

  const QuestionAnswerTile({
    super.key,
    required this.question,
    required this.answer,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: AppSizes.avatarXs,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.smart_toy,
                  size: AppSizes.iconXs,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSizes.s),
              Expanded(
                child: Text(
                  question,
                  style: AppTextStyles.questionText.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.xs + 2),
          Row(
            children: [
              CircleAvatar(
                radius: AppSizes.avatarXs,
                backgroundColor: theme.colorScheme.secondaryContainer,
                child: Icon(
                  Icons.person,
                  size: AppSizes.iconXs,
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(width: AppSizes.s),
              Expanded(
                child: Text(
                  answer,
                  style: AppTextStyles.answerText.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (onEdit != null)
                InkWell(
                  onTap: onEdit,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s,
                      vertical: AppSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit,
                          size: AppSizes.iconS,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'Edit',
                          style: AppTextStyles.editButtonText.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}