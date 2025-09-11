import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/questionnaire_schema.dart';
import '../providers/navigation_provider.dart';
import '../../../../shared/theme/app_theme.dart';

class WelcomePage extends ConsumerWidget {
  final WelcomeSection welcome;
  
  const WelcomePage({
    super.key,
    required this.welcome,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.health_and_safety,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: AppSizes.xxl * 1.5),
              Text(
                welcome.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.l),
              Text(
                welcome.message,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.xxl * 2),
              ElevatedButton(
                onPressed: () => ref.read(navigationStateProvider.notifier).startQuestionnaire(),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}