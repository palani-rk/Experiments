import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/branding_header.dart';
import '../widgets/progress_indicator.dart' as custom;
import '../widgets/section_container.dart';
import '../widgets/confirmation_dialog.dart';
import '../providers/questionnaire_providers.dart';
import 'questionnaire_page.dart';
import '../../../../shared/theme/app_theme.dart';

/// Review responses page showing completed sections - navigated to after each section completion
/// Shows all completed sections and handles Continue/Submit based on completion status
class ReviewResponsesPage extends ConsumerWidget {
  final String? editTargetQuestionId;

  const ReviewResponsesPage({
    super.key,
    this.editTargetQuestionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionnaireAsync = ref.watch(questionnaireNotifierProvider);
    final progressInfo = ref.watch(progressInfoProvider);
    final branding = ref.watch(brandingConfigProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Review Your Responses',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          // Save & Resume Later button
          IconButton(
            icon: const Icon(Icons.save_outlined),
            tooltip: 'Save & Resume Later',
            onPressed: () => _handleSaveAndExit(context),
          ),
          const SizedBox(width: AppSizes.s),
        ],
      ),
      body: SafeArea(
        child: questionnaireAsync.when(
          data: (state) => Column(
            children: [
              // Same branding header as questionnaire page
              BrandingHeader(
                showSubtitle: false,
                brandingConfig: branding,
              ),

              // Same progress indicator as questionnaire page
              custom.ProgressIndicator(
                currentSection: progressInfo.currentSection,
                totalSections: progressInfo.totalSections,
                sectionNames: state.config?.sections.map((s) => s.title).toList() ?? [],
                overallProgress: progressInfo.overallProgress,
              ),

              // Scrollable content area with completed sections
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Completed sections display
                      _buildCompletedSections(context, ref, state),

                      // Action area - Continue or Submit based on completion
                      _buildActionArea(context, ref, state),

                      const SizedBox(height: AppSizes.l),
                    ],
                  ),
                ),
              ),
            ],
          ),
          loading: () => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading your responses...'),
              ],
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load responses',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(questionnaireNotifierProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedSections(BuildContext context, WidgetRef ref, QuestionnaireState state) {
    if (state.config == null) return const SizedBox.shrink();

    final completedSections = <Widget>[];

    // Build completed sections from state (moved from QuestionnairePage)
    for (final section in state.config!.sections) {
      final sectionResponse = state.sectionResponses[section.id];
      if (sectionResponse != null && sectionResponse.responses.isNotEmpty) {
        completedSections.add(
          SectionContainer(
            sectionTitle: section.title,
            questions: section.questions,
            sectionResponse: sectionResponse,
            onEdit: (questionId) => _handleEditResponse(context, ref, questionId),
          ),
        );
        completedSections.add(const SizedBox(height: AppSizes.l));
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.s, horizontal: AppSizes.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (completedSections.isNotEmpty) ...[
            Text(
              'Your Responses',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.m),
            ...completedSections,
          ] else ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.xl),
                child: Column(
                  children: [
                    Icon(
                      Icons.quiz_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppSizes.m),
                    Text(
                      'No responses yet',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.s),
                    Text(
                      'Start answering questions to see your responses here',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionArea(BuildContext context, WidgetRef ref, QuestionnaireState state) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.l),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          if (state.isCompleted) ...[
            // All sections complete - show submission area
            _buildSubmissionArea(context, ref, state),
          ] else ...[
            // More sections pending - show continue button
            _buildContinueArea(context, ref, state),
          ],
        ],
      ),
    );
  }

  Widget _buildContinueArea(BuildContext context, WidgetRef ref, QuestionnaireState state) {
    final progressInfo = ref.watch(progressInfoProvider);

    return Column(
      children: [
        Icon(
          Icons.arrow_forward_ios,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: AppSizes.s),
        Text(
          'Section ${progressInfo.currentSection} of ${progressInfo.totalSections} Complete',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.s),
        Text(
          'Ready to continue with the next section?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.l),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _navigateBackToQuestionnaire(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: AppSizes.l),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
              ),
            ),
            child: const Text(
              'Continue to Next Section',
              style: AppTextStyles.buttonText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmissionArea(BuildContext context, WidgetRef ref, QuestionnaireState state) {
    return Column(
      children: [
        if (!state.isSubmitted) ...[
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppSizes.s),
          Text(
            'Questionnaire Complete!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.s),
          Text(
            'Thank you for completing all sections. Review your responses above and submit when ready.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSizes.l),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () => _handleSubmitQuestionnaire(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: AppSizes.l),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
              ),
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Submit Questionnaire',
                      style: AppTextStyles.buttonText,
                    ),
            ),
          ),
        ] else ...[
          // Already submitted - show success state
          Container(
            padding: const EdgeInsets.all(AppSizes.l),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 48,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: AppSizes.s),
                Text(
                  'Successfully Submitted!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.s),
                Text(
                  'Your responses have been submitted successfully. Thank you for completing the questionnaire.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _handleEditResponse(BuildContext context, WidgetRef ref, String questionId) {
    // Navigate back to questionnaire page with target question ID for editing
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionnairePage(targetQuestionId: questionId),
      ),
    );
  }

  void _navigateBackToQuestionnaire(BuildContext context) {
    // Navigate back to questionnaire page to continue with next section
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const QuestionnairePage(),
      ),
    );
  }

  void _handleSubmitQuestionnaire(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(questionnaireNotifierProvider.notifier).submitQuestionnaire();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Questionnaire submitted successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit questionnaire: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Handle Save & Resume Later button press
  Future<void> _handleSaveAndExit(BuildContext context) async {
    final confirmed = await ConfirmationDialog.showSaveAndResumeConfirmation(context);

    if (confirmed && context.mounted) {
      // State is already saved automatically
      // Navigate back to welcome/home
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}