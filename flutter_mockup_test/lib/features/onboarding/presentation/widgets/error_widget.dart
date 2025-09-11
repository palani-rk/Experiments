import 'package:flutter/material.dart';
import '../../../../shared/theme/app_theme.dart';

class QuestionnaireErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const QuestionnaireErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
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
              // Error icon
              Icon(
                Icons.error_outline,
                size: 80,
                color: theme.colorScheme.error,
              ),
              
              const SizedBox(height: AppSizes.xxl),
              
              // Error title
              Text(
                'Oops! Something went wrong',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppSizes.l),
              
              // Error message
              Text(
                'We encountered an error while loading the questionnaire. Please check your connection and try again.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppSizes.m),
              
              // Error details (in debug mode)
              if (_shouldShowErrorDetails()) ...[
                Container(
                  padding: const EdgeInsets.all(AppSizes.m),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.radiusS),
                    color: theme.colorScheme.errorContainer.withOpacity(0.1),
                    border: Border.all(
                      color: theme.colorScheme.error.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    error.toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                      fontFamily: 'monospace',
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: AppSizes.m),
              ],
              
              const SizedBox(height: AppSizes.xxl),
              
              // Action buttons
              Column(
                children: [
                  if (onRetry != null)
                    ElevatedButton(
                      onPressed: onRetry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: AppSizes.l),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.refresh,
                            size: AppSizes.iconM,
                            color: theme.colorScheme.onPrimary,
                          ),
                          const SizedBox(width: AppSizes.s),
                          Text(
                            'Try Again',
                            style: AppTextStyles.buttonText.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: AppSizes.m),
                  
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.m),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      ),
                      side: BorderSide(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      'Go Back',
                      style: AppTextStyles.buttonText.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSizes.xxl),
              
              // Help text
              Text(
                'If the problem persists, please contact support.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  bool _shouldShowErrorDetails() {
    // Only show error details in debug mode
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
}