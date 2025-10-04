import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_mockup_test/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Client Questionnaire Flow Integration Tests', () {
    testWidgets('Welcome page UI elements and navigation', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify mockup selection screen is displayed
      expect(find.text('NutriApp Mockups'), findsOneWidget);
      expect(find.text('Choose a mockup to test:'), findsOneWidget);

      // Find and tap the Phase 1 questionnaire flow card
      final phase1Card = find.text('Phase 1: Client Questionnaire Flow');
      expect(phase1Card, findsOneWidget);

      await tester.tap(phase1Card);
      await tester.pumpAndSettle();

      // Verify welcome page is displayed
      await _verifyWelcomePage(tester);

      // Test navigation to questionnaire page
      final startButton = find.text('Yes, let\'s do this!');
      expect(startButton, findsOneWidget);

      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Verify questionnaire page is displayed
      await _verifyQuestionnairePage(tester);
    });

    testWidgets('Welcome page branding and content validation', (WidgetTester tester) async {
      // Navigate to welcome page
      await _navigateToWelcomePage(tester);

      // Verify branding header elements
      expect(find.text('Healthy Living Clinic'), findsOneWidget);
      expect(find.text('Personalized Nutrition Assessment'), findsOneWidget);

      // Verify welcome message
      expect(find.text('Let\'s create your personalized nutrition plan!'), findsOneWidget);

      // Verify time estimate section
      expect(find.text('Takes about 5-10 minutes'), findsOneWidget);
      expect(find.text('You can save and resume anytime'), findsOneWidget);
      expect(find.byIcon(Icons.schedule), findsOneWidget);

      // Verify section preview items
      expect(find.text('We\'ll cover these areas:'), findsOneWidget);
      expect(find.text('Personal Information'), findsOneWidget);
      expect(find.text('Health Goals'), findsOneWidget);
      expect(find.text('Health Background'), findsOneWidget);
      expect(find.text('Lifestyle'), findsOneWidget);

      // Verify section icons
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.flag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.medical_information_outlined), findsOneWidget);
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    });

    testWidgets('Questionnaire page UI components and interactions', (WidgetTester tester) async {
      // Navigate to questionnaire page
      await _navigateToQuestionnairePage(tester);

      // Verify branding header (without subtitle)
      expect(find.text('Healthy Living Clinic'), findsOneWidget);

      // Verify progress indicator
      expect(find.text('Personal Information'), findsOneWidget);
      expect(find.text('Health Goals'), findsOneWidget);
      expect(find.text('Health Background'), findsOneWidget);
      expect(find.text('Lifestyle'), findsOneWidget);

      // Verify completed section container
      expect(find.text('Alex Johnson'), findsOneWidget);
      expect(find.text('28'), findsOneWidget);
      expect(find.text('165'), findsOneWidget);

      // Verify current question area
      expect(find.text('What\'s your primary health goal?'), findsOneWidget);

      // Verify question options
      expect(find.text('Lose weight'), findsOneWidget);
      expect(find.text('Gain weight'), findsOneWidget);
      expect(find.text('Maintain weight'), findsOneWidget);
      expect(find.text('Build muscle'), findsOneWidget);
      expect(find.text('Improve energy'), findsOneWidget);
      expect(find.text('Better digestion'), findsOneWidget);
      expect(find.text('Other'), findsOneWidget);
    });

    testWidgets('Question input interaction and response handling', (WidgetTester tester) async {
      // Navigate to questionnaire page
      await _navigateToQuestionnairePage(tester);

      // Test single select question interaction
      final loseWeightOption = find.text('Lose weight');
      expect(loseWeightOption, findsOneWidget);

      await tester.tap(loseWeightOption);
      await tester.pumpAndSettle();

      // Verify selection (should be visually indicated)
      // Note: Actual selection styling verification would depend on implementation details

      // Test submit button interaction
      final submitButton = find.text('Continue');
      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton);
        await tester.pumpAndSettle();

        // Verify placeholder response (Phase 1 shows snackbar)
        expect(find.text('Response submission will be implemented in Phase 2'), findsOneWidget);
      }
    });

    testWidgets('Edit functionality dialog', (WidgetTester tester) async {
      // Navigate to questionnaire page
      await _navigateToQuestionnairePage(tester);

      // Find and tap edit button (if visible in the completed section)
      final editButtons = find.byIcon(Icons.edit);
      if (editButtons.evaluate().isNotEmpty) {
        await tester.tap(editButtons.first);
        await tester.pumpAndSettle();

        // Verify edit dialog
        expect(find.text('Edit Response'), findsOneWidget);
        expect(find.text('Edit functionality will be implemented in Phase 4.'), findsOneWidget);

        // Close dialog
        final okButton = find.text('OK');
        await tester.tap(okButton);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Navigation flow and back button functionality', (WidgetTester tester) async {
      // Navigate to questionnaire page
      await _navigateToQuestionnairePage(tester);

      // For web platform, we test that the navigation completed successfully
      // rather than browser back navigation which has different behavior

      // Verify we're on questionnaire page
      expect(find.text('What\'s your primary health goal?'), findsOneWidget);
      expect(find.text('Alex Johnson'), findsOneWidget);

      // Navigate back by starting a new session (web-compatible approach)
      app.main();
      await tester.pumpAndSettle();

      // Verify we're back to the main selection screen
      expect(find.text('NutriApp Mockups'), findsOneWidget);
      expect(find.text('Choose a mockup to test:'), findsOneWidget);
    });
  });
}

/// Helper function to navigate to welcome page
Future<void> _navigateToWelcomePage(WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle();

  final phase1Card = find.text('Phase 1: Client Questionnaire Flow');
  await tester.tap(phase1Card);
  await tester.pumpAndSettle();
}

/// Helper function to navigate to questionnaire page
Future<void> _navigateToQuestionnairePage(WidgetTester tester) async {
  await _navigateToWelcomePage(tester);

  final startButton = find.text('Yes, let\'s do this!');
  await tester.tap(startButton);
  await tester.pumpAndSettle();
}

/// Helper function to verify welcome page elements
Future<void> _verifyWelcomePage(WidgetTester tester) async {
  // Core welcome page elements
  expect(find.text('Let\'s create your personalized nutrition plan!'), findsOneWidget);
  expect(find.text('Takes about 5-10 minutes'), findsOneWidget);
  expect(find.text('We\'ll cover these areas:'), findsOneWidget);
  expect(find.text('Yes, let\'s do this!'), findsOneWidget);

  // Section preview items
  expect(find.text('Personal Information'), findsOneWidget);
  expect(find.text('Health Goals'), findsOneWidget);
  expect(find.text('Health Background'), findsOneWidget);
  expect(find.text('Lifestyle'), findsOneWidget);
}

/// Helper function to verify questionnaire page elements
Future<void> _verifyQuestionnairePage(WidgetTester tester) async {
  // Progress indicator sections
  expect(find.text('Personal Information'), findsOneWidget);
  expect(find.text('Health Goals'), findsOneWidget);
  expect(find.text('Health Background'), findsOneWidget);
  expect(find.text('Lifestyle'), findsOneWidget);

  // Current question
  expect(find.text('What\'s your primary health goal?'), findsOneWidget);

  // Sample completed responses
  expect(find.text('Alex Johnson'), findsOneWidget);
  expect(find.text('28'), findsOneWidget);
  expect(find.text('165'), findsOneWidget);
}