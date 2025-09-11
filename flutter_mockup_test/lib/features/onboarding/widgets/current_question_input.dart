import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';

/// Current question input section widget for active onboarding questions
/// 
/// This widget creates an interactive input area for the currently active
/// onboarding question, featuring:
/// 
/// - Question display with bot avatar and clear typography
/// - Input container with subtle background and border styling
/// - Flexible input fields area (can contain text fields, dropdowns, etc.)
/// - Primary action submit button with full-width styling
/// - "CURRENT" status indicator with upward arrow
/// - Elevated container style with rounded top corners
/// - Enable/disable state management for form validation
/// 
/// Designed to be the focal point of onboarding screens, positioned
/// at the bottom with distinctive styling to draw user attention
/// to the current step. The elevated design and status indicator
/// clearly communicate this is the active interaction area.
/// 
/// Used as a container for various input types depending on the
/// question requirements (text input, selections, etc.).
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