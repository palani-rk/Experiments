import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../lib/main.dart' as app;
import '../shared/test_helpers.dart';
import 'helpers/onboarding_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding - Welcome Flow Integration Tests', () {
    testWidgets('Welcome Page: Display and interaction', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to questionnaire
      await TestHelpers.navigateToQuestionnaire(tester);

      // Test welcome page elements
      await OnboardingHelpers.testWelcomePageElements(tester);

      // Test welcome page interactions
      await OnboardingHelpers.testWelcomePageInteractions(tester);
    });

    testWidgets('Theme Integration: Welcome page theme consistency', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await TestHelpers.navigateToQuestionnaire(tester);

      // Test theme integration on welcome page
      await OnboardingHelpers.testWelcomePageTheme(tester);
    });

    testWidgets('Navigation: Welcome to questionnaire transition', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await TestHelpers.navigateToQuestionnaire(tester);

      // Test smooth transition from welcome to first question
      await OnboardingHelpers.testWelcomeToQuestionTransition(tester);
    });
  });
}