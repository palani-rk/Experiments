import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/questionnaire_provider.dart';
import '../providers/completed_responses_provider.dart';
import '../providers/response_provider.dart';
import '../providers/navigation_provider.dart' as nav;
import '../providers/branding_provider.dart';
import '../widgets/branding_header.dart';
import '../widgets/progress_indicator_widget.dart';
import '../widgets/completed_responses_widget.dart';
import '../widgets/question_widgets/question_widget_factory.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import 'welcome_page.dart';
import 'completion_page.dart';
import '../../data/models/questionnaire_schema.dart';
import '../../../../shared/theme/app_theme.dart';

/// Enhanced questionnaire page with chat-style layout
///
/// Features:
/// - Chat-style scrollable interface with completed responses as cards
/// - Overlay current question input at bottom
/// - Branding header and progress indicator
/// - Responsive design that adapts to different screen sizes
/// - Error handling and loading states
/// - Smooth navigation between questions and sections
class EnhancedQuestionnairePage extends ConsumerStatefulWidget {
  const EnhancedQuestionnairePage({super.key});

  @override
  ConsumerState<EnhancedQuestionnairePage> createState() =>
      _EnhancedQuestionnairePageState();
}

class _EnhancedQuestionnairePageState
    extends ConsumerState<EnhancedQuestionnairePage> {
  final ScrollController _scrollController = ScrollController();
  final bool _autoScrollEnabled = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Smoothly scrolls to the bottom of the chat area
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final schemaAsync = ref.watch(questionnaireSchemaProvider);
    final navigationState = ref.watch(nav.navigationStateProvider);
    final branding = ref.watch(brandingConfigProvider);

    // Listen for changes in response state to auto-scroll
    ref.listen(responseStateProvider, (previous, next) {
      if (_autoScrollEnabled && _scrollController.hasClients) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    });

    return schemaAsync.when(
      loading: () => const QuestionnaireLoadingWidget(),
      error: (error, stack) => QuestionnaireErrorWidget(
        error: error,
        onRetry: () => ref.refresh(questionnaireSchemaProvider),
      ),
      data: (schema) {
        if (navigationState.isCompleted) {
          return const CompletionPage();
        }

        if (navigationState.showWelcome) {
          return Column(
            children: [
              BrandingHeader(branding: branding),
              Expanded(
                child: WelcomePage(welcome: schema.welcome),
              ),
            ],
          );
        }

        return _buildChatStyleQuestionnaire(context, ref, schema, branding);
      },
    );
  }

  /// Builds the main chat-style questionnaire interface
  Widget _buildChatStyleQuestionnaire(
    BuildContext context,
    WidgetRef ref,
    QuestionnaireSchema schema,
    branding,
  ) {
    final theme = Theme.of(context);
    final currentQuestion = _getCurrentQuestion(ref, schema);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: Column(
          children: [
            // Branding Header
            BrandingHeader(branding: branding),

            // Progress Bar
            QuestionnaireProgressIndicator(
              progress: 0.5, // TODO: Calculate actual progress
            ),

            // Chat Area with Completed Responses
            Expanded(
              child: Stack(
                children: [
                  // Scrollable completed responses
                  CompletedResponsesWidget(
                    scrollController: _scrollController,
                    allowEditing: true,
                    onResponseEdit: () => _showEditDialog(context, ref),
                    addBottomPadding: true,
                  ),

                  // Current Question Overlay
                  if (currentQuestion != null)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _buildCurrentQuestionOverlay(
                        context,
                        ref,
                        currentQuestion,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Gets the current question being asked
  Question? _getCurrentQuestion(WidgetRef ref, QuestionnaireSchema schema) {
    try {
      final navigationState = ref.watch(nav.navigationStateProvider);

      if (navigationState.currentSectionIndex >= schema.sections.length) {
        return null;
      }

      final currentSection = schema.sections[navigationState.currentSectionIndex];

      if (navigationState.currentQuestionIndex >= currentSection.questions.length) {
        return null;
      }

      return currentSection.questions[navigationState.currentQuestionIndex];
    } catch (e) {
      // Return null if there's any error getting current question
      return null;
    }
  }

  /// Builds the current question overlay at the bottom
  Widget _buildCurrentQuestionOverlay(
    BuildContext context,
    WidgetRef ref,
    Question question,
  ) {
    final responseState = ref.watch(responseStateProvider);
    final currentAnswer = responseState.getAnswer(question.id);

    // Create appropriate input widget based on question type
    final inputWidget = QuestionWidgetFactory.create(
      question: question,
      currentValue: currentAnswer,
      onChanged: (value) {
        ref.read(responseStateProvider.notifier).setAnswer(question.id, value);
      },
    );

    return CurrentQuestionOverlay(
      questionText: question.text,
      inputWidget: inputWidget,
      onSubmit: () => _handleSubmitAnswer(ref, question),
      showCurrentIndicator: true,
    );
  }

  /// Handles submitting an answer and navigating to next question
  void _handleSubmitAnswer(WidgetRef ref, Question question) {
    try {
      final responseState = ref.watch(responseStateProvider);
      final navigationState = ref.watch(nav.navigationStateProvider);
      final schemaAsync = ref.watch(questionnaireSchemaProvider);

      // Validate the current answer
      if (!responseState.isQuestionAnswered(question.id)) {
        _showValidationError(context, 'Please provide an answer before continuing.');
        return;
      }

      schemaAsync.whenData((schema) {
        final navigationNotifier = ref.read(nav.navigationStateProvider.notifier);
        final currentSection = schema.sections[navigationState.currentSectionIndex];

        // Check if this is the last question in the current section
        if (navigationState.currentQuestionIndex >= currentSection.questions.length - 1) {
          // Move to next section
          if (navigationState.currentSectionIndex >= schema.sections.length - 1) {
            // This was the last section - complete questionnaire
            ref.read(responseStateProvider.notifier).completeQuestionnaire();
            navigationNotifier.completeQuestionnaire();
          } else {
            // Move to next section
            navigationNotifier.nextSection();
          }
        } else {
          // Move to next question in current section
          navigationNotifier.nextQuestion();
        }

        // Auto-scroll to show new content after a brief delay
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollToBottom();
        });
      });
    } catch (e) {
      _showValidationError(context, 'Error processing your answer. Please try again.');
    }
  }

  /// Shows validation error to user
  void _showValidationError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Shows edit dialog for responses (placeholder implementation)
  void _showEditDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Response'),
        content: const Text(
          'Response editing functionality will be implemented here. '
          'This would allow users to modify their previous answers.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement actual edit functionality
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}

/// Alternative simplified version for testing
class SimplifiedChatQuestionnairePage extends ConsumerWidget {
  const SimplifiedChatQuestionnairePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final responseGroups = ref.watch(responseGroupsProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: const Text('Nutrition Assessment'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 1,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Simple Progress Indicator
            Container(
              padding: const EdgeInsets.all(16.0),
              color: theme.colorScheme.primaryContainer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    '${responseGroups.where((g) => g.isCompleted).length}/${responseGroups.length} sections',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),

            // Chat Area
            Expanded(
              child: const CompletedResponsesWidget(
                allowEditing: true,
                addBottomPadding: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}