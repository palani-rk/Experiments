import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/branding_header.dart';
import '../widgets/confirmation_dialog.dart';
import '../providers/resume_providers.dart';
import '../providers/questionnaire_providers.dart';
import 'questionnaire_page.dart';
import 'review_responses_page.dart';
import '../../../../shared/theme/app_theme.dart';
import 'package:intl/intl.dart';

/// Welcome screen with resume detection and section preview
class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumeStateAsync = ref.watch(resumeStateProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: resumeStateAsync.when(
          data: (resumeState) => _buildContent(context, ref, resumeState),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _buildContent(context, ref, const ResumeState(hasExistingData: false)),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, ResumeState resumeState) {
    return Column(
      children: [
        // Branding header
        const BrandingHeader(),

        // Main content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSizes.xxl),

                // Welcome message
                Text(
                  resumeState.hasExistingData
                      ? 'Welcome back!'
                      : 'Let\'s create your personalized nutrition plan!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSizes.l),

                // Resume card or time estimate
                if (resumeState.hasExistingData)
                  _buildResumeCard(context, ref, resumeState)
                else
                  _buildTimeEstimate(context),

                const SizedBox(height: AppSizes.xxl),

                // Section preview (only show if starting fresh)
                if (!resumeState.hasExistingData)
                  _buildSectionPreview(context),

                const Spacer(),

                // Action buttons
                if (resumeState.hasExistingData)
                  _buildResumeActions(context, ref, resumeState)
                else
                  _buildStartButton(context, ref),

                const SizedBox(height: AppSizes.l),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeEstimate(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.l),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            color: Theme.of(context).colorScheme.primary,
            size: AppSizes.iconL,
          ),
          const SizedBox(width: AppSizes.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Takes about 5-10 minutes',
                  style: AppTextStyles.progressLabel.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  'You can save and resume anytime',
                  style: AppTextStyles.progressPercent.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionPreview(BuildContext context) {
    // Phase 1: Hardcoded section preview
    // TODO: Phase 2 - Load sections from QuestionnaireConfig
    final sections = [
      {'title': 'Personal Information', 'icon': Icons.person_outline},
      {'title': 'Health Goals', 'icon': Icons.flag_outlined},
      {'title': 'Health Background', 'icon': Icons.medical_information_outlined},
      {'title': 'Lifestyle', 'icon': Icons.home_outlined},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'We\'ll cover these areas:',
          style: AppTextStyles.sectionTitle.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSizes.m),
        ...sections.map((section) => _buildSectionItem(
          context,
          section['title'] as String,
          section['icon'] as IconData,
        )),
      ],
    );
  }

  Widget _buildSectionItem(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.s),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSizes.iconM,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: AppSizes.m),
          Text(
            title,
            style: AppTextStyles.questionText.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumeCard(BuildContext context, WidgetRef ref, ResumeState resumeState) {
    final percentageText = '${(resumeState.progressPercentage * 100).toStringAsFixed(0)}%';

    return Container(
      padding: const EdgeInsets.all(AppSizes.l),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: Theme.of(context).colorScheme.primary,
                size: AppSizes.iconL,
              ),
              const SizedBox(width: AppSizes.m),
              Expanded(
                child: Text(
                  'Continue where you left off',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.m),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusS),
            child: LinearProgressIndicator(
              value: resumeState.progressPercentage,
              minHeight: 8,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.s),

          // Progress text
          Text(
            '$percentageText complete - ${resumeState.progressMessage}',
            style: AppTextStyles.progressLabel.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),

          if (resumeState.currentSectionTitle != null) ...[
            const SizedBox(height: AppSizes.xs),
            Text(
              resumeState.sectionMessage,
              style: AppTextStyles.progressPercent.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],

          if (resumeState.lastSavedAt != null) ...[
            const SizedBox(height: AppSizes.xs),
            Text(
              'Last saved: ${_formatDateTime(resumeState.lastSavedAt!)}',
              style: AppTextStyles.progressPercent.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResumeActions(BuildContext context, WidgetRef ref, ResumeState resumeState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Resume button (primary)
        ElevatedButton(
          onPressed: () => _handleResume(context, ref, resumeState),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: AppSizes.l),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
          ),
          child: Text(
            resumeState.isCompleted == true ? 'Review Responses' : 'Continue',
            style: AppTextStyles.buttonText,
          ),
        ),

        const SizedBox(height: AppSizes.m),

        // Start fresh button (secondary)
        OutlinedButton(
          onPressed: () => _handleStartFresh(context, ref),
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
            side: BorderSide(color: Theme.of(context).colorScheme.error),
            padding: const EdgeInsets.symmetric(vertical: AppSizes.l),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
          ),
          child: const Text(
            'Start Fresh',
            style: AppTextStyles.buttonText,
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => _navigateToQuestionnaire(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: AppSizes.l),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
      ),
      child: const Text(
        'Yes, let\'s do this!',
        style: AppTextStyles.buttonText,
      ),
    );
  }

  void _handleResume(BuildContext context, WidgetRef ref, ResumeState resumeState) {
    if (resumeState.isCompleted == true) {
      // Navigate to review page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ReviewResponsesPage(),
        ),
      );
    } else {
      // Navigate to questionnaire page (will resume from saved question)
      _navigateToQuestionnaire(context);
    }
  }

  Future<void> _handleStartFresh(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.showStartFreshConfirmation(context);

    if (confirmed && context.mounted) {
      // Reset questionnaire state
      await ref.read(questionnaireNotifierProvider.notifier).resetQuestionnaire();

      // Invalidate resume state to refresh UI
      ref.invalidate(resumeStateProvider);
    }
  }

  void _navigateToQuestionnaire(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuestionnairePage(),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, y').format(dateTime);
    }
  }
}