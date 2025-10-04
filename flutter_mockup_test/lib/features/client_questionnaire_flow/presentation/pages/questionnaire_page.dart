import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/branding_header.dart';
import '../widgets/progress_indicator.dart' as custom;
import '../widgets/current_question_area.dart';
import '../widgets/confirmation_dialog.dart';
import '../providers/questionnaire_providers.dart';
import '../../data/models/question.dart';
import '../../data/models/questionnaire_config.dart';
import '../../data/models/section_response.dart';
import '../../data/models/enums.dart';
import 'review_responses_page.dart';
import '../../../../shared/theme/app_theme.dart';

/// Main questionnaire screen with current question focus - Phase 3: Dynamic implementation
/// Uses Riverpod providers for state management and dynamic data loading
/// Navigate to ReviewResponsesPage after section completion
class QuestionnairePage extends ConsumerStatefulWidget {
  final String? targetQuestionId;

  const QuestionnairePage({
    super.key,
    this.targetQuestionId,
  });

  @override
  ConsumerState<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends ConsumerState<QuestionnairePage> {
  dynamic _currentInputValue;
  bool _isEditMode = false;
  String? _editTargetQuestionId;
  Question? _editTargetQuestion;
  QuestionnaireState? _originalState;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.targetQuestionId != null;
    _editTargetQuestionId = widget.targetQuestionId;

    // Initialize edit mode if needed
    if (_isEditMode && _editTargetQuestionId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeEditMode();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionnaireAsync = ref.watch(questionnaireNotifierProvider);
    final progressInfo = ref.watch(progressInfoProvider);
    final currentQuestion = ref.watch(currentQuestionProvider);
    final branding = ref.watch(brandingConfigProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _handleBackNavigation(context),
        ),
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
      body: questionnaireAsync.when(
          data: (state) => Column(
            children: [
              // Branding header with dynamic data
              BrandingHeader(
                showSubtitle: false,
                brandingConfig: branding,
              ),

              // Dynamic progress indicator
              custom.ProgressIndicator(
                currentSection: progressInfo.currentSection,
                totalSections: progressInfo.totalSections,
                sectionNames: state.config?.sections.map((s) => s.title).toList() ?? [],
                overallProgress: progressInfo.overallProgress,
              ),

              // Current question focus area
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Instructions for new users
                      if (state.sectionResponses.isEmpty)
                        _buildWelcomeInstructions(context),

                      // Current question input area (if not completed or in edit mode)
                      if ((currentQuestion != null && !state.isCompleted) || _isEditMode)
                        _buildCurrentQuestion(context, _getDisplayQuestion(state, currentQuestion)),

                      // Navigate to review if completed (but not in edit mode)
                      if (state.isCompleted && !_isEditMode)
                        _navigateToReviewPage(context),
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
                Text('Loading questionnaire...'),
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
                  'Failed to load questionnaire',
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
    );
  }

  Widget _buildWelcomeInstructions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppSizes.m),
          Text(
            'Let\'s Get Started!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.s),
          Text(
            'Answer each question below. After completing each section, you\'ll be able to review your responses.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentQuestion(BuildContext context, Question? currentQuestion) {
    if (currentQuestion == null) return const SizedBox.shrink();

    return CurrentQuestionArea(
      question: currentQuestion,
      currentValue: _currentInputValue,
      onValueChanged: (value) => _handleValueChanged(value),
      onSubmit: () => _isEditMode
          ? _handleEditSubmit(context, currentQuestion)
          : _handleSubmit(context, currentQuestion),
      isEditMode: _isEditMode,
    );
  }

  Widget _navigateToReviewPage(BuildContext context) {
    // Auto-navigate to review page when questionnaire is completed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ReviewResponsesPage(),
        ),
      );
    });

    // Show loading while navigation occurs
    return Container(
      padding: const EdgeInsets.all(AppSizes.xl),
      child: const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AppSizes.m),
          Text('Questionnaire complete! Redirecting to review...'),
        ],
      ),
    );
  }


  void _handleValueChanged(dynamic value) {
    // Store the current value for submission
    setState(() {
      _currentInputValue = value;
    });
    debugPrint('Value changed: $value');
  }

  void _handleSubmit(BuildContext context, Question currentQuestion) async {
    try {
      // Use the actual input value captured from user input
      dynamic value = _currentInputValue;

      // Fallback to demo values if no input captured
      if (value == null) {
        switch (currentQuestion.inputType) {
          case QuestionType.textInput:
            value = 'Sample text response';
            break;
          case QuestionType.numberInput:
            value = '25';
            break;
          case QuestionType.singleSelect:
            value = currentQuestion.options?.first ?? 'Option 1';
            break;
          case QuestionType.multiSelect:
            value = [currentQuestion.options?.first ?? 'Option 1'];
            break;
          case QuestionType.textArea:
            value = 'Sample longer text response';
            break;
        }
      }

      // Get state before answering question
      final previousState = ref.read(questionnaireNotifierProvider).value;
      if (previousState?.config == null) return;

      final currentSectionId = currentQuestion.sectionId;
      final currentSection = previousState!.config!.sections.firstWhere(
        (section) => section.id == currentSectionId,
      );

      // Count answered questions in current section before this answer
      final currentSectionResponse = previousState.sectionResponses[currentSectionId];
      final previouslyAnswered = currentSectionResponse?.responses.length ?? 0;

      await ref.read(questionnaireNotifierProvider.notifier)
          .answerQuestion(currentQuestion.id, value);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Response saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Check if this answer completed the section
        final newState = ref.read(questionnaireNotifierProvider).value;
        final newSectionResponse = newState?.sectionResponses[currentSectionId];
        final nowAnswered = newSectionResponse?.responses.length ?? 0;

        // Section is complete if we now have all questions answered
        final sectionComplete = nowAnswered >= currentSection.questions.length;
        final justCompleted = nowAnswered > previouslyAnswered && sectionComplete;

        if (justCompleted && !newState!.isCompleted) {
          // Section just completed but questionnaire not finished - navigate to review
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReviewResponsesPage(),
            ),
          );
        }

        // Clear input value after successful submission
        setState(() {
          _currentInputValue = null;
        });
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save response: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Initialize edit mode by setting up the target question and existing response
  void _initializeEditMode() async {
    if (_editTargetQuestionId == null) return;

    final state = ref.read(questionnaireNotifierProvider).value;
    if (state?.config == null) return;

    // Store original navigation state for restoration later
    _originalState = state;

    // Find the target question and existing response
    final targetQuestion = _findQuestionById(state!.config!, _editTargetQuestionId!);
    if (targetQuestion == null) return;

    final sectionResponse = state.sectionResponses[targetQuestion.sectionId];
    final existingResponse = sectionResponse?.getResponseByQuestionId(_editTargetQuestionId!);

    setState(() {
      _editTargetQuestion = targetQuestion;
      _currentInputValue = existingResponse?.value;
    });

    // DON'T modify provider state - keep edit mode isolated
  }

  /// Get the question to display (current question or edit target)
  Question? _getDisplayQuestion(QuestionnaireState state, Question? currentQuestion) {
    if (_isEditMode && _editTargetQuestion != null) {
      return _editTargetQuestion;
    }
    return currentQuestion;
  }

  /// Find a question by ID in the questionnaire config
  Question? _findQuestionById(QuestionnaireConfig config, String questionId) {
    for (final section in config.sections) {
      for (final question in section.questions) {
        if (question.id == questionId) {
          return question;
        }
      }
    }
    return null;
  }

  /// Handle edit submission - update existing response and return to review
  void _handleEditSubmit(BuildContext context, Question question) async {
    try {
      final value = _currentInputValue;
      if (value == null) return;

      // Update the existing response (this only modifies the response data, not navigation state)
      await ref.read(questionnaireNotifierProvider.notifier)
          .editResponse(question.id, value);

      // Restore original navigation state to preserve normal questionnaire flow
      if (_originalState != null) {
        await _restoreOriginalNavigationState();
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Response updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate back to review page - normal flow state restored
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ReviewResponsesPage(),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update response: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Restore the original navigation state after edit completion
  Future<void> _restoreOriginalNavigationState() async {
    if (_originalState == null) return;

    // Use the existing navigateToQuestion method to restore navigation state
    if (_originalState!.currentQuestionId != null) {
      await ref.read(questionnaireNotifierProvider.notifier)
          .navigateToQuestion(_originalState!.currentQuestionId!);
    }
  }

  /// Handle Save & Resume Later button press
  Future<void> _handleSaveAndExit(BuildContext context) async {
    final confirmed = await ConfirmationDialog.showSaveAndResumeConfirmation(context);

    if (confirmed && context.mounted) {
      // State is already saved automatically after each question
      // Just navigate back to home/welcome
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  /// Handle back button navigation with confirmation if in progress
  Future<void> _handleBackNavigation(BuildContext context) async {
    final state = ref.read(questionnaireNotifierProvider).value;

    // If user has answered questions, confirm before exiting
    if (state != null && state.sectionResponses.isNotEmpty && !state.isCompleted) {
      final confirmed = await ConfirmationDialog.show(
        context: context,
        title: 'Exit Questionnaire?',
        message: 'Your progress has been saved. You can resume later from where you left off.',
        confirmText: 'Exit',
        cancelText: 'Continue',
        isDestructive: false,
      );

      if (confirmed && context.mounted) {
        Navigator.of(context).pop();
      }
    } else {
      // No progress or already completed, just go back
      Navigator.of(context).pop();
    }
  }

}