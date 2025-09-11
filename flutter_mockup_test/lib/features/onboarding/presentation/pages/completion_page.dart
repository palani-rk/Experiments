import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/response_provider.dart';
import '../../../../shared/theme/app_theme.dart';

class CompletionPage extends ConsumerWidget {
  const CompletionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final responseState = ref.watch(responseStateProvider);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Success icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primaryContainer,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 60,
                  color: theme.colorScheme.primary,
                ),
              ),
              
              const SizedBox(height: AppSizes.xxl * 2),
              
              // Completion title
              Text(
                'Questionnaire Complete!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppSizes.l),
              
              // Completion message
              Text(
                'Thank you for completing the questionnaire. Your responses have been saved and will help us provide you with personalized recommendations.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppSizes.xxl),
              
              // Completion stats
              Container(
                padding: const EdgeInsets.all(AppSizes.l),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Questions Answered:',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '${responseState.answers.length}',
                          style: AppTextStyles.answerText.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.s),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Completed:',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          responseState.completedTime != null
                            ? _formatDateTime(responseState.completedTime!)
                            : 'Just now',
                          style: AppTextStyles.answerText.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    if (responseState.completedTime != null) ...[
                      const SizedBox(height: AppSizes.s),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Time Taken:',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            _formatDuration(
                              responseState.completedTime!.difference(responseState.startTime),
                            ),
                            style: AppTextStyles.answerText.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: AppSizes.xxl * 2),
              
              // Action buttons
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to main app or next step
                      Navigator.of(context).pop();
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
                      'Continue to App',
                      style: AppTextStyles.buttonText.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.m),
                  
                  OutlinedButton(
                    onPressed: () {
                      // Show review dialog or navigate to review
                      _showReviewDialog(context, ref);
                    },
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
                      'Review My Answers',
                      style: AppTextStyles.buttonText.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (date == today) {
      return 'Today ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
  
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
  
  void _showReviewDialog(BuildContext context, WidgetRef ref) {
    final responseState = ref.read(responseStateProvider);
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Your Answers',
          style: AppTextStyles.headerTitle.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: responseState.answers.length,
            separatorBuilder: (context, index) => const SizedBox(height: AppSizes.m),
            itemBuilder: (context, index) {
              final entry = responseState.answers.entries.elementAt(index);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q${index + 1}:',
                    style: AppTextStyles.statusLabel.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    entry.value.toString(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}