import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/questionnaire_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/response_provider.dart';
import 'welcome_page.dart';
import 'completion_page.dart';
import '../widgets/question_flow_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class QuestionnairePage extends ConsumerWidget {
  const QuestionnairePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schemaAsync = ref.watch(questionnaireSchemaProvider);
    final navigationState = ref.watch(navigationStateProvider);

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
          return WelcomePage(welcome: schema.welcome);
        }
        
        return QuestionFlowWidget(schema: schema);
      },
    );
  }
}