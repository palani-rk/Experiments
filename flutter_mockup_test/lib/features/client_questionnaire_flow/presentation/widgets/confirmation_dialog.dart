import 'package:flutter/material.dart';
import '../../../../shared/theme/app_theme.dart';

/// Reusable confirmation dialog for destructive or important actions
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final bool isDestructive;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: AppTextStyles.sectionTitle.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      content: Text(
        message,
        style: AppTextStyles.questionText.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            cancelText,
            style: AppTextStyles.buttonText.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDestructive
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
            foregroundColor: isDestructive
                ? Theme.of(context).colorScheme.onError
                : Theme.of(context).colorScheme.onPrimary,
          ),
          child: Text(
            confirmText,
            style: AppTextStyles.buttonText,
          ),
        ),
      ],
    );
  }

  /// Show confirmation dialog and return true if confirmed
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        onConfirm: () {},
      ),
    );
    return result ?? false;
  }

  /// Show "Start Fresh" confirmation with destructive warning
  static Future<bool> showStartFreshConfirmation(BuildContext context) {
    return show(
      context: context,
      title: 'Start Fresh?',
      message: 'This will clear your saved progress and start the questionnaire from the beginning. This action cannot be undone.',
      confirmText: 'Start Fresh',
      cancelText: 'Cancel',
      isDestructive: true,
    );
  }

  /// Show "Save & Resume Later" confirmation
  static Future<bool> showSaveAndResumeConfirmation(BuildContext context) {
    return show(
      context: context,
      title: 'Save Progress?',
      message: 'Your progress will be saved. You can resume this questionnaire anytime from where you left off.',
      confirmText: 'Save & Exit',
      cancelText: 'Continue',
      isDestructive: false,
    );
  }
}
