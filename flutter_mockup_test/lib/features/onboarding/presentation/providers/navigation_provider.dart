import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/questionnaire_response.dart';

final navigationStateProvider = StateNotifierProvider<NavigationNotifier, NavigationState>((ref) {
  return NavigationNotifier();
});

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(const NavigationState());

  void startQuestionnaire() {
    state = state.copyWith(showWelcome: false);
  }

  void goToNextQuestion(int totalSections, List<int> questionsPerSection) {
    final currentSection = state.currentSectionIndex;
    final currentQuestion = state.currentQuestionIndex;
    final questionsInCurrentSection = questionsPerSection[currentSection];

    if (currentQuestion < questionsInCurrentSection - 1) {
      // Next question in same section
      state = state.copyWith(currentQuestionIndex: currentQuestion + 1);
    } else if (currentSection < totalSections - 1) {
      // Next section
      state = state.copyWith(
        currentSectionIndex: currentSection + 1,
        currentQuestionIndex: 0,
      );
    } else {
      // Questionnaire completed
      state = state.copyWith(isCompleted: true);
    }
  }

  void goToPreviousQuestion(List<int> questionsPerSection) {
    final currentSection = state.currentSectionIndex;
    final currentQuestion = state.currentQuestionIndex;

    if (currentQuestion > 0) {
      // Previous question in same section
      state = state.copyWith(currentQuestionIndex: currentQuestion - 1);
    } else if (currentSection > 0) {
      // Previous section
      final previousSection = currentSection - 1;
      final lastQuestionInPreviousSection = questionsPerSection[previousSection] - 1;
      state = state.copyWith(
        currentSectionIndex: previousSection,
        currentQuestionIndex: lastQuestionInPreviousSection,
      );
    }
  }

  double getProgress(List<int> questionsPerSection) {
    final totalQuestions = questionsPerSection.fold(0, (a, b) => a + b);
    int answeredQuestions = 0;
    
    for (int i = 0; i < state.currentSectionIndex; i++) {
      answeredQuestions += questionsPerSection[i];
    }
    answeredQuestions += state.currentQuestionIndex;
    
    return totalQuestions > 0 ? answeredQuestions / totalQuestions : 0.0;
  }

  bool canGoBack() {
    return state.currentSectionIndex > 0 || state.currentQuestionIndex > 0;
  }

  bool isLastQuestion(List<int> questionsPerSection) {
    final lastSectionIndex = questionsPerSection.length - 1;
    final lastQuestionIndex = questionsPerSection[lastSectionIndex] - 1;
    
    return state.currentSectionIndex == lastSectionIndex && 
           state.currentQuestionIndex == lastQuestionIndex;
  }
}