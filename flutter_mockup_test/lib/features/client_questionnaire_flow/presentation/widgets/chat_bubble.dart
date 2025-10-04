import 'package:flutter/material.dart';
import '../../../../shared/theme/app_theme.dart';

/// Chat bubble types
enum ChatBubbleType { bot, user }

/// Reusable chat bubble widget - Phase 1: Static implementation
/// TODO: Phase 2 - Add edit functionality and dynamic content
class ChatBubble extends StatelessWidget {
  final String content;
  final ChatBubbleType type;
  final bool isEditable;
  final VoidCallback? onEdit;

  const ChatBubble({
    super.key,
    required this.content,
    required this.type,
    this.isEditable = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isBot = type == ChatBubbleType.bot;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.l,
        vertical: AppSizes.s,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot) ...[
            _buildAvatar(context, isBot),
            const SizedBox(width: AppSizes.m),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                _buildBubble(context, isBot),
                if (isEditable && !isBot) ...[
                  const SizedBox(height: AppSizes.xs),
                  _buildEditButton(context),
                ],
              ],
            ),
          ),
          if (!isBot) ...[
            const SizedBox(width: AppSizes.m),
            _buildAvatar(context, isBot),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, bool isBot) {
    return Container(
      width: AppSizes.avatarM,
      height: AppSizes.avatarM,
      decoration: BoxDecoration(
        color: isBot
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.secondary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isBot ? Icons.support_agent : Icons.person,
        size: AppSizes.iconS,
        color: isBot
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }

  Widget _buildBubble(BuildContext context, bool isBot) {
    final maxWidth = MediaQuery.of(context).size.width * AppSizes.chatBubbleMaxWidthRatio;

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.m,
        vertical: AppSizes.s,
      ),
      decoration: BoxDecoration(
        color: isBot
          ? Theme.of(context).colorScheme.surfaceContainerHigh
          : Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        boxShadow: AppShadows.chatBubble(context),
      ),
      child: Text(
        content,
        style: AppTextStyles.chatMessage.copyWith(
          color: isBot
            ? Theme.of(context).colorScheme.onSurface
            : Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s,
          vertical: AppSizes.xs,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusS),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Text(
          'Edit',
          style: AppTextStyles.editButtonText.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}