import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';

/// Individual chat message bubble component for conversational interfaces
/// 
/// This widget creates chat bubbles that can represent either:
/// - Bot messages (left-aligned with bot avatar and light background)
/// - User messages (right-aligned with user avatar and primary color background)
/// 
/// Features include:
/// - Dynamic alignment based on sender type
/// - Appropriate avatar icons (smart_toy for bot, person for user)
/// - Responsive width constraints (max 70% of screen width)
/// - Optional edit functionality with edit button
/// - Themed colors and styling with shadow effects
/// - Asymmetric border radius for chat bubble appearance
/// 
/// Used in onboarding chat flows to create natural conversation experiences.
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