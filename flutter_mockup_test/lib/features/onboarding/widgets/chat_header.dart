import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';

/// Chat header component that displays assistant information and online status
/// 
/// This widget creates a header for chat interfaces showing:
/// - Assistant avatar with medical icon
/// - Title and subtitle text
/// - Online/offline status indicator
/// - Styled container with shadow and padding
/// 
/// Used primarily in onboarding chat flows to provide visual context
/// for conversational interfaces with health-focused branding.
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