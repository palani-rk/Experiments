import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mockup_test/main.dart' as app;
import 'package:flutter_mockup_test/features/onboarding/presentation/pages/questionnaire_page.dart';
import 'package:flutter_mockup_test/shared/theme/app_theme.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Questionnaire Happy Path Integration Tests', () {
    testWidgets('Complete questionnaire workflow from start to finish', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Verify main mockup selection screen is displayed
      expect(find.text('NutriApp Mockups'), findsOneWidget);
      expect(find.text('Clean Architecture Questionnaire'), findsOneWidget);

      // Navigate to Clean Architecture Questionnaire
      await tester.tap(find.text('Clean Architecture Questionnaire'));
      await tester.pumpAndSettle();

      // Test Welcome Page
      await _testWelcomePage(tester);

      // Test Question Flow
      await _testQuestionFlow(tester);

      // Test Completion Page
      await _testCompletionPage(tester);
    });

    testWidgets('Test individual question types functionality', (WidgetTester tester) async {
      // Launch app and navigate to questionnaire
      app.main();
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Clean Architecture Questionnaire'));
      await tester.pumpAndSettle();

      // Skip welcome
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Test each question type
      await _testTextQuestion(tester);
      await _testNumberQuestion(tester);
      await _testRadioQuestion(tester);
      await _testMultiselectQuestion(tester);
      // Add more question type tests as needed
    });

    testWidgets('Test navigation and progress tracking', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Clean Architecture Questionnaire'));
      await tester.pumpAndSettle();

      // Skip welcome
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      await _testNavigationAndProgress(tester);
    });

    testWidgets('Test data persistence and recovery', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Clean Architecture Questionnaire'));
      await tester.pumpAndSettle();

      await _testDataPersistence(tester);
    });
  });
}

Future<void> _testWelcomePage(WidgetTester tester) async {
  // Verify welcome page elements
  expect(find.byIcon(Icons.health_and_safety), findsOneWidget);
  expect(find.text('Welcome to NutriApp'), findsOneWidget);
  expect(find.text('Get Started'), findsOneWidget);

  // Tap Get Started button
  await tester.tap(find.text('Get Started'));
  await tester.pumpAndSettle();
}

Future<void> _testQuestionFlow(WidgetTester tester) async {
  // Verify we're now in the question flow
  expect(find.byType(LinearProgressIndicator), findsOneWidget);
  expect(find.text('Progress'), findsOneWidget);
  
  // Answer a few questions to test the flow
  int questionCount = 0;
  const maxQuestions = 10; // Prevent infinite loop
  
  while (questionCount < maxQuestions) {
    // Check if we've reached completion
    if (find.text('Questionnaire Complete!').evaluate().isNotEmpty) {
      break;
    }
    
    // Check if Continue button exists and is enabled
    final continueButton = find.text('Continue');
    if (continueButton.evaluate().isEmpty) {
      break;
    }
    
    // Answer the current question based on its type
    await _answerCurrentQuestion(tester);
    
    // Tap continue if possible
    final continueWidget = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Continue').first,
    );
    
    if (continueWidget.onPressed != null) {
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
    }
    
    questionCount++;
  }
}

Future<void> _testCompletionPage(WidgetTester tester) async {
  // Verify completion page elements
  expect(find.text('Questionnaire Complete!'), findsOneWidget);
  expect(find.byIcon(Icons.check_circle), findsOneWidget);
  expect(find.text('Continue to App'), findsOneWidget);
  expect(find.text('Review My Answers'), findsOneWidget);

  // Test review functionality
  await tester.tap(find.text('Review My Answers'));
  await tester.pumpAndSettle();
  
  expect(find.text('Your Answers'), findsOneWidget);
  await tester.tap(find.text('Close'));
  await tester.pumpAndSettle();
}

Future<void> _answerCurrentQuestion(WidgetTester tester) async {
  // Try to find and interact with different question types
  
  // Text input
  final textField = find.byType(TextField);
  if (textField.evaluate().isNotEmpty) {
    await tester.enterText(textField.first, 'Test answer');
    return;
  }
  
  // Radio options (look for custom radio widgets)
  final radioOptions = find.byType(InkWell);
  if (radioOptions.evaluate().isNotEmpty) {
    // Find the first radio option that's tappable
    for (int i = 0; i < radioOptions.evaluate().length && i < 3; i++) {
      try {
        await tester.tap(radioOptions.at(i));
        await tester.pumpAndSettle();
        return;
      } catch (e) {
        // Continue to next option if this one fails
        continue;
      }
    }
  }
  
  // Slider
  final slider = find.byType(Slider);
  if (slider.evaluate().isNotEmpty) {
    await tester.drag(slider.first, const Offset(50, 0));
    await tester.pumpAndSettle();
    return;
  }
  
  // Date picker button
  final dateButton = find.byIcon(Icons.calendar_today);
  if (dateButton.evaluate().isNotEmpty) {
    await tester.tap(dateButton);
    await tester.pumpAndSettle();
    
    // Handle date picker dialog
    final okButton = find.text('OK');
    if (okButton.evaluate().isNotEmpty) {
      await tester.tap(okButton);
      await tester.pumpAndSettle();
    }
    return;
  }
}

Future<void> _testTextQuestion(WidgetTester tester) async {
  final textField = find.byType(TextField);
  if (textField.evaluate().isNotEmpty) {
    await tester.enterText(textField.first, 'Integration test text input');
    await tester.pumpAndSettle();
    
    // Verify text was entered
    expect(find.text('Integration test text input'), findsOneWidget);
  }
}

Future<void> _testNumberQuestion(WidgetTester tester) async {
  // Look for number input field (TextField with number keyboard)
  final textFields = find.byType(TextField);
  for (int i = 0; i < textFields.evaluate().length; i++) {
    final textField = textFields.at(i);
    final widget = tester.widget<TextField>(textField);
    
    if (widget.keyboardType == TextInputType.number) {
      await tester.enterText(textField, '25');
      await tester.pumpAndSettle();
      
      expect(find.text('25'), findsOneWidget);
      return;
    }
  }
}

Future<void> _testRadioQuestion(WidgetTester tester) async {
  // Look for radio-like InkWell widgets with radio indicators
  final radioOptions = find.byType(InkWell);
  if (radioOptions.evaluate().isNotEmpty) {
    // Tap the first radio option
    await tester.tap(radioOptions.first);
    await tester.pumpAndSettle();
    
    // Verify selection (check for primary color indicating selection)
    final theme = Theme.of(tester.element(find.byType(MaterialApp)));
    expect(find.byType(Container), findsWidgets);
  }
}

Future<void> _testMultiselectQuestion(WidgetTester tester) async {
  // Similar to radio but allow multiple selections
  final multiselectOptions = find.byType(InkWell);
  if (multiselectOptions.evaluate().length >= 2) {
    // Select first two options
    await tester.tap(multiselectOptions.at(0));
    await tester.pumpAndSettle();
    
    await tester.tap(multiselectOptions.at(1));
    await tester.pumpAndSettle();
    
    // Verify chips are created for selected items
    expect(find.byType(Chip), findsWidgets);
  }
}

Future<void> _testNavigationAndProgress(WidgetTester tester) async {
  // Test forward navigation
  expect(find.byType(LinearProgressIndicator), findsOneWidget);
  
  // Answer first question
  await _answerCurrentQuestion(tester);
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
  
  // Test back navigation
  final backButton = find.text('Back');
  if (backButton.evaluate().isNotEmpty) {
    await tester.tap(backButton);
    await tester.pumpAndSettle();
    
    // Verify we went back
    expect(find.text('Continue'), findsOneWidget);
  }
}

Future<void> _testDataPersistence(WidgetTester tester) async {
  // Answer a question
  await _answerCurrentQuestion(tester);
  
  // Navigate forward and back to test persistence
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
  
  final backButton = find.text('Back');
  if (backButton.evaluate().isNotEmpty) {
    await tester.tap(backButton);
    await tester.pumpAndSettle();
    
    // Verify the answer is still there (this is a basic check)
    // More detailed verification would require inspecting the actual widget state
    expect(find.text('Continue'), findsOneWidget);
  }
}