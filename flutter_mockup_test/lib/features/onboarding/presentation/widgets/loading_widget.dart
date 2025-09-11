import 'package:flutter/material.dart';
import '../../../../shared/theme/app_theme.dart';

class QuestionnaireLoadingWidget extends StatelessWidget {
  const QuestionnaireLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Loading animation
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
                strokeWidth: 4,
              ),
            ),
            
            const SizedBox(height: AppSizes.xxl),
            
            // Loading text
            Text(
              'Loading Questionnaire...',
              style: AppTextStyles.headerTitle.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            
            const SizedBox(height: AppSizes.m),
            
            Text(
              'Please wait while we prepare your questions',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}