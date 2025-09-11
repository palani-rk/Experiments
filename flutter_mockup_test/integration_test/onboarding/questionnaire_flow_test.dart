import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import the app
import '../../lib/main.dart' as app;
import '../shared/test_helpers.dart';
import '../shared/test_data.dart';
import 'helpers/onboarding_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding - Questionnaire Flow Integration Tests', () {
    testWidgets('Happy Path: Complete questionnaire from start to finish', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to questionnaire
      await TestHelpers.navigateToQuestionnaire(tester);

      // Complete welcome flow
      await OnboardingHelpers.completeWelcomeFlow(tester);

      // Answer all questions with happy path data
      await OnboardingHelpers.completeQuestionnaireFlow(
        tester, 
        TestData.happyPathAnswers,
      );

      // Verify completion
      await OnboardingHelpers.verifyCompletionPage(tester);

      // Test completion features (review answers, etc.)
      await OnboardingHelpers.testCompletionFeatures(tester);
    });

    testWidgets('Navigation: Forward and backward question navigation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await TestHelpers.navigateToQuestionnaire(tester);
      await OnboardingHelpers.completeWelcomeFlow(tester);
      
      // Test bidirectional navigation
      await OnboardingHelpers.testQuestionNavigation(tester);
    });

    testWidgets('Progress Tracking: Verify progress bar updates', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await TestHelpers.navigateToQuestionnaire(tester);
      await OnboardingHelpers.completeWelcomeFlow(tester);
      
      // Test progress indicator functionality
      await OnboardingHelpers.testProgressTracking(tester);
    });

    testWidgets('Data Persistence: Answer persistence across navigation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await TestHelpers.navigateToQuestionnaire(tester);
      await OnboardingHelpers.completeWelcomeFlow(tester);
      
      // Test answer persistence
      await OnboardingHelpers.testAnswerPersistence(
        tester, 
        TestData.persistenceTestAnswers,
      );
    });

    testWidgets('Question Types: Test all input widget types', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await TestHelpers.navigateToQuestionnaire(tester);
      await OnboardingHelpers.completeWelcomeFlow(tester);
      
      // Test each question type systematically
      await OnboardingHelpers.testAllQuestionTypes(tester, TestData.questionTypeTestData);
    });

    testWidgets('Validation: Required field validation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await TestHelpers.navigateToQuestionnaire(tester);
      await OnboardingHelpers.completeWelcomeFlow(tester);
      
      // Test validation behavior
      await OnboardingHelpers.testValidationBehavior(tester);
    });

    testWidgets('Error Handling: Loading and error states', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test error scenarios
      await OnboardingHelpers.testErrorHandling(tester);
    });
  });
}