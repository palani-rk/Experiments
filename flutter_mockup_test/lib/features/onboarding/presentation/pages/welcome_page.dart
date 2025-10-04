import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/questionnaire_schema.dart';
import '../providers/navigation_provider.dart';
import '../providers/branding_provider.dart';
import '../widgets/branding_header.dart';
import '../../../../shared/theme/app_theme.dart';

/// Enhanced welcome page with branding integration
///
/// Features:
/// - Branded header with clinic logo and nutritionist information
/// - Personalized welcome messages from branding configuration
/// - Health icon display with theme-aware styling
/// - Responsive layout with proper spacing
/// - Accessibility support with semantic labels
///
/// Security considerations:
/// - All text content is sanitized through BrandingConfig
/// - Image URLs are validated before loading
/// - Error handling for failed image loads
class WelcomePage extends ConsumerWidget {
  final WelcomeSection welcome;

  const WelcomePage({
    super.key,
    required this.welcome,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final branding = ref.watch(activeBrandingProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          // Branding Header
          BrandingHeader(
            branding: branding,
            showNutritionist: true,
          ),

          // Main Welcome Content
          Expanded(
            child: SafeArea(
              top: false, // Header handles its own safe area
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.xxl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Health Icon
                    Container(
                      padding: const EdgeInsets.all(AppSizes.l),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.health_and_safety,
                        size: 80,
                        color: theme.colorScheme.primary,
                        semanticLabel: 'Health and wellness icon',
                      ),
                    ),

                    const SizedBox(height: AppSizes.xxl * 1.5),

                    // Welcome Title (from schema)
                    Text(
                      welcome.title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      semanticsLabel: 'Welcome title',
                    ),

                    const SizedBox(height: AppSizes.l),

                    // Personalized Welcome Message (from branding)
                    Text(
                      branding.safeWelcomeMessage,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      semanticsLabel: 'Personalized welcome message',
                    ),

                    const SizedBox(height: AppSizes.m),

                    // Welcome Subtitle (from branding)
                    if (branding.safeWelcomeSubtitle.isNotEmpty)
                      Text(
                        branding.safeWelcomeSubtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                        semanticsLabel: 'Welcome subtitle',
                      ),

                    const SizedBox(height: AppSizes.l),

                    // Quick Assessment Info (from schema)
                    Text(
                      welcome.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                      semanticsLabel: 'Assessment information',
                    ),

                    const SizedBox(height: AppSizes.xxl * 2),

                    // Get Started Button
                    ElevatedButton(
                      onPressed: () {
                        try {
                          ref.read(navigationStateProvider.notifier).startQuestionnaire();
                        } catch (e) {
                          // Handle navigation errors gracefully
                          debugPrint('WelcomePage: Navigation error: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Unable to start questionnaire. Please try again.'),
                              backgroundColor: theme.colorScheme.error,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: AppSizes.l),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        welcome.buttonText,
                        style: AppTextStyles.buttonText.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                        semanticsLabel: 'Start questionnaire button',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}