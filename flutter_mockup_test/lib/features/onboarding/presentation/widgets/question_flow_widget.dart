import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/questionnaire_schema.dart';
import '../providers/navigation_provider.dart';
import '../providers/response_provider.dart';
import 'question_widgets/question_widget_factory.dart';
import 'progress_indicator_widget.dart';
import 'navigation_buttons_widget.dart';
import '../../../../shared/theme/app_theme.dart';

class QuestionFlowWidget extends ConsumerWidget {
  final QuestionnaireSchema schema;

  const QuestionFlowWidget({
    super.key,
    required this.schema,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final navigationState = ref.watch(navigationStateProvider);
    final responseState = ref.watch(responseStateProvider);
    
    final currentSection = schema.sections[navigationState.currentSectionIndex];
    final currentQuestion = currentSection.questions[navigationState.currentQuestionIndex];
    
    final questionsPerSection = schema.sections.map((s) => s.questions.length).toList();
    final progress = ref.read(navigationStateProvider.notifier).getProgress(questionsPerSection);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          currentSection.title,
          style: AppTextStyles.headerTitle.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.m),
            child: QuestionnaireProgressIndicator(progress: progress),
          ),
        ),
        leading: navigationState.currentSectionIndex > 0 || navigationState.currentQuestionIndex > 0
          ? IconButton(
              onPressed: () => ref.read(navigationStateProvider.notifier)
                  .goToPreviousQuestion(questionsPerSection),
              icon: Icon(
                Icons.arrow_back,
                color: theme.colorScheme.onSurface,
              ),
            )
          : null,
      ),
      body: Column(
        children: [
          // Question content area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Question text
                  Container(
                    padding: const EdgeInsets.all(AppSizes.l),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      color: theme.colorScheme.primaryContainer.withOpacity(0.1),
                      border: Border.all(
                        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentQuestion.text,
                          style: AppTextStyles.currentQuestionText.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        if (currentQuestion.required) ...[
                          const SizedBox(height: AppSizes.s),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 12,
                                color: theme.colorScheme.error,
                              ),
                              const SizedBox(width: AppSizes.xs),
                              Text(
                                'Required',
                                style: AppTextStyles.statusLabel.copyWith(
                                  color: theme.colorScheme.error,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.xxl),
                  
                  // Question input widget
                  QuestionWidgetFactory.create(
                    question: currentQuestion,
                    currentValue: responseState.getAnswer(currentQuestion.id),
                    onChanged: (value) {
                      ref.read(responseStateProvider.notifier).setAnswer(
                        currentQuestion.id,
                        value,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Navigation buttons
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.outline.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: NavigationButtonsWidget(
                currentQuestion: currentQuestion,
                questionsPerSection: questionsPerSection,
              ),
            ),
          ),
        ],
      ),
    );
  }
}