import 'package:flutter/material.dart';
import 'theme.dart';

/// Chat header component showing assistant info and status
class ChatHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isOnline;

  const ChatHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.isOnline = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.l,
        vertical: AppSizes.m,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: AppShadows.card(context),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSizes.avatarM,
            backgroundColor: theme.colorScheme.primary,
            child: Icon(
              Icons.local_hospital,
              color: theme.colorScheme.onPrimary,
              size: AppSizes.iconL,
            ),
          ),
          const SizedBox(width: AppSizes.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.headerTitle.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.headerSubtitle.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: AppSizes.s,
            height: AppSizes.s,
            decoration: BoxDecoration(
              color: isOnline
                  ? theme.colorScheme.tertiary
                  : theme.colorScheme.outline,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

/// Progress indicator for onboarding flow
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

/// Individual chat bubble component
class ChatBubble extends StatelessWidget {
  final String text;
  final bool isBot;
  final bool isEditable;
  final VoidCallback? onEdit;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isBot,
    this.isEditable = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.l),
      child: Row(
        mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot) ...[
            CircleAvatar(
              radius: AppSizes.avatarS,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.smart_toy,
                size: AppSizes.iconM,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: AppSizes.s),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * AppSizes.chatBubbleMaxWidthRatio,
              ),
              decoration: BoxDecoration(
                color: isBot
                    ? theme.colorScheme.surface
                    : theme.colorScheme.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isBot ? AppSizes.radiusXs : AppSizes.radiusXl),
                  topRight: Radius.circular(isBot ? AppSizes.radiusXl : AppSizes.radiusXs),
                  bottomLeft: const Radius.circular(AppSizes.radiusXl),
                  bottomRight: const Radius.circular(AppSizes.radiusXl),
                ),
                boxShadow: AppShadows.chatBubble(context),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.l,
                vertical: AppSizes.m,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: AppTextStyles.chatMessage.copyWith(
                      color: isBot
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onPrimary,
                    ),
                  ),
                  if (isEditable) ...[
                    const SizedBox(height: AppSizes.s),
                    InkWell(
                      onTap: onEdit,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit,
                            size: AppSizes.iconS,
                            color: isBot
                                ? theme.colorScheme.onSurfaceVariant
                                : theme.colorScheme.onPrimary.withOpacity(0.7),
                          ),
                          const SizedBox(width: AppSizes.xs),
                          Text(
                            'Edit',
                            style: AppTextStyles.editLabel.copyWith(
                              color: isBot
                                  ? theme.colorScheme.onSurfaceVariant
                                  : theme.colorScheme.onPrimary.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (!isBot) ...[
            const SizedBox(width: AppSizes.s),
            CircleAvatar(
              radius: AppSizes.avatarS,
              backgroundColor: theme.colorScheme.secondaryContainer,
              child: Icon(
                Icons.person,
                size: AppSizes.iconM,
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Question-answer pair component
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

/// Section group card for displaying completed sections
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

/// Current question input section
class CurrentQuestionInput extends StatelessWidget {
  final String question;
  final List<Widget> inputFields;
  final VoidCallback? onSubmit;
  final bool isEnabled;

  const CurrentQuestionInput({
    super.key,
    required this.question,
    required this.inputFields,
    this.onSubmit,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppSizes.l),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: AppShadows.elevated(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusXxl),
          topRight: Radius.circular(AppSizes.radiusXxl),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: AppSizes.avatarS,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.smart_toy,
                  size: AppSizes.iconM,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSizes.m),
              Expanded(
                child: Text(
                  question,
                  style: AppTextStyles.currentQuestionText.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.l),
          Container(
            padding: const EdgeInsets.all(AppSizes.l),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.5),
                width: AppSizes.inputBorderWidth,
              ),
            ),
            child: Column(
              children: [
                ...inputFields,
                const SizedBox(height: AppSizes.l),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isEnabled ? onSubmit : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: AppSizes.l),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radiusM),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Submit',
                          style: AppTextStyles.buttonText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.s),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.keyboard_arrow_up,
                      color: theme.colorScheme.primary,
                      size: AppSizes.iconM,
                    ),
                    Text(
                      'CURRENT',
                      style: AppTextStyles.statusLabel.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}