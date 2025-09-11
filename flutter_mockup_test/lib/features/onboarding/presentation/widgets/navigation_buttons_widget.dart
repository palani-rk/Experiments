import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/questionnaire_schema.dart';
import '../providers/navigation_provider.dart';
import '../providers/response_provider.dart';
import '../../../../shared/theme/app_theme.dart';

class NavigationButtonsWidget extends ConsumerWidget {
  final Question currentQuestion;
  final List<int> questionsPerSection;

  const NavigationButtonsWidget({
    super.key,
    required this.currentQuestion,
    required this.questionsPerSection,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final navigationState = ref.watch(navigationStateProvider);
    final navigationNotifier = ref.read(navigationStateProvider.notifier);
    final responseState = ref.watch(responseStateProvider);

    final canGoBack = navigationNotifier.canGoBack();
    final isLastQuestion = navigationNotifier.isLastQuestion(questionsPerSection);
    final canProceed = !currentQuestion.required || 
                      responseState.isQuestionAnswered(currentQuestion.id);

    return Padding(
      padding: const EdgeInsets.all(AppSizes.l),
      child: Row(
        children: [
          // Back Button
          if (canGoBack)
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: () => navigationNotifier.goToPreviousQuestion(questionsPerSection),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.m),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  ),
                  side: BorderSide(
                    color: theme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: AppSizes.iconM,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSizes.s),
                    Text(
                      'Back',
                      style: AppTextStyles.buttonText.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          if (canGoBack) const SizedBox(width: AppSizes.m),

          // Next/Continue Button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: canProceed ? () {
                if (isLastQuestion) {
                  // Complete questionnaire
                  ref.read(responseStateProvider.notifier).completeQuestionnaire();
                } else {
                  // Go to next question
                  navigationNotifier.goToNextQuestion(
                    questionsPerSection.length,
                    questionsPerSection,
                  );
                }
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canProceed 
                  ? theme.colorScheme.primary 
                  : theme.colorScheme.surfaceVariant,
                foregroundColor: canProceed 
                  ? theme.colorScheme.onPrimary 
                  : theme.colorScheme.onSurfaceVariant,
                padding: const EdgeInsets.symmetric(vertical: AppSizes.m),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                elevation: canProceed ? 2 : 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLastQuestion ? 'Complete' : 'Continue',
                    style: AppTextStyles.buttonText.copyWith(
                      color: canProceed 
                        ? theme.colorScheme.onPrimary 
                        : theme.colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  if (!isLastQuestion) ...[
                    const SizedBox(width: AppSizes.s),
                    Icon(
                      Icons.arrow_forward,
                      size: AppSizes.iconM,
                      color: canProceed 
                        ? theme.colorScheme.onPrimary 
                        : theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}