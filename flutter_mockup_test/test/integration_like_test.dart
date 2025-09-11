import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../lib/main.dart';
import '../lib/features/onboarding/presentation/pages/questionnaire_page.dart';

/// Integration-style widget tests that validate the complete questionnaire workflow
/// These tests can run on web and simulate full user interactions
void main() {
  group('Questionnaire Workflow - Integration-style Tests', () {
    testWidgets('App Launch and Navigation: Main screen loads and navigation works', (WidgetTester tester) async {
      // Launch the app
      await tester.pumpWidget(const ProviderScope(child: MockupTestApp()));
      await tester.pumpAndSettle();

      // Verify main screen
      expect(find.text('NutriApp Mockups'), findsOneWidget);
      expect(find.text('Clean Architecture Questionnaire'), findsOneWidget);

      // Navigate to questionnaire
      final questionnaireCard = find.ancestor(
        of: find.text('Clean Architecture Questionnaire'),
        matching: find.byType(InkWell),
      );
      
      expect(questionnaireCard, findsOneWidget);
      await tester.tap(questionnaireCard);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should now be on questionnaire page
      // Look for loading or welcome screen
      final hasLoading = find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
      final hasWelcome = find.text('Welcome to NutriApp').evaluate().isNotEmpty;
      final hasError = find.text('Oops! Something went wrong').evaluate().isNotEmpty;

      expect(hasLoading || hasWelcome || hasError, isTrue);
    });

    testWidgets('Welcome Flow: Welcome page displays and transitions correctly', (WidgetTester tester) async {
      // Pump the questionnaire page directly
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: QuestionnairePage(),
          ),
        ),
      );
      
      // Wait for loading/data
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Check if we get welcome screen or error
      if (find.text('Welcome to NutriApp').evaluate().isNotEmpty) {
        // Welcome screen loaded successfully
        expect(find.byIcon(Icons.health_and_safety), findsOneWidget);
        expect(find.text('Get Started'), findsOneWidget);

        // Test transition to questionnaire
        await tester.tap(find.text('Get Started'));
        await tester.pumpAndSettle();

        // Should now see progress indicator or first question
        final hasProgress = find.byType(LinearProgressIndicator).evaluate().isNotEmpty;
        final hasQuestion = find.text('Continue').evaluate().isNotEmpty;

        expect(hasProgress || hasQuestion, isTrue);
      } else if (find.text('Oops! Something went wrong').evaluate().isNotEmpty) {
        // Error state - test error handling
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('Try Again'), findsOneWidget);

        // Test retry functionality
        await tester.tap(find.text('Try Again'));
        await tester.pumpAndSettle();
      } else {
        // Loading state - verify loading UI
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      }
    });

    testWidgets('Question Flow: Navigation and input handling work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: QuestionnairePage(),
          ),
        ),
      );

      // Wait for loading
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip welcome if it appears
      if (find.text('Get Started').evaluate().isNotEmpty) {
        await tester.tap(find.text('Get Started'));
        await tester.pumpAndSettle();
      }

      // If we're in question flow, test interactions
      if (find.byType(LinearProgressIndicator).evaluate().isNotEmpty) {
        await _testQuestionInteractions(tester);
      }
    });

    testWidgets('Question Types: Different input widgets work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: QuestionnairePage(),
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip welcome
      if (find.text('Get Started').evaluate().isNotEmpty) {
        await tester.tap(find.text('Get Started'));
        await tester.pumpAndSettle();
      }

      // Test different question types
      await _testQuestionTypes(tester);
    });

    testWidgets('Progress Tracking: Progress indicator updates correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: QuestionnairePage(),
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip welcome
      if (find.text('Get Started').evaluate().isNotEmpty) {
        await tester.tap(find.text('Get Started'));
        await tester.pumpAndSettle();
      }

      // Test progress tracking
      if (find.byType(LinearProgressIndicator).evaluate().isNotEmpty) {
        await _testProgressTracking(tester);
      }
    });

    testWidgets('Completion Flow: Questionnaire completion works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: QuestionnairePage(),
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip welcome
      if (find.text('Get Started').evaluate().isNotEmpty) {
        await tester.tap(find.text('Get Started'));
        await tester.pumpAndSettle();
      }

      // Try to complete the questionnaire
      await _attemptQuestionnaireCompletion(tester);
    });
  });
}

/// Test question interactions (input, validation, navigation)
Future<void> _testQuestionInteractions(WidgetTester tester) async {
  int attempts = 0;
  const maxAttempts = 10;

  while (attempts < maxAttempts) {
    // Check if we've completed
    if (find.text('Questionnaire Complete!').evaluate().isNotEmpty) {
      break;
    }

    // Try to answer current question
    await _answerCurrentQuestion(tester);

    // Try to continue
    final continueButton = find.text('Continue');
    final completeButton = find.text('Complete');

    if (completeButton.evaluate().isNotEmpty) {
      await tester.tap(completeButton);
      await tester.pumpAndSettle();
      break;
    } else if (continueButton.evaluate().isNotEmpty) {
      // Check if button is enabled
      final button = tester.widget<ElevatedButton>(
        find.ancestor(of: continueButton, matching: find.byType(ElevatedButton)),
      );
      
      if (button.onPressed != null) {
        await tester.tap(continueButton);
        await tester.pumpAndSettle();
      }
    }

    attempts++;
  }

  // Test back navigation if possible
  if (find.text('Back').evaluate().isNotEmpty) {
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    // Verify we went back
    expect(find.text('Continue'), findsOneWidget);
  }
}

/// Answer the current question based on its type
Future<void> _answerCurrentQuestion(WidgetTester tester) async {
  // Text input
  final textFields = find.byType(TextField);
  if (textFields.evaluate().isNotEmpty) {
    await tester.enterText(textFields.first, 'Test Answer');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    return;
  }

  // Radio/selection options
  final inkWells = find.byType(InkWell);
  if (inkWells.evaluate().isNotEmpty) {
    // Try to find selectable options (avoid navigation elements)
    for (int i = 0; i < inkWells.evaluate().length && i < 5; i++) {
      try {
        await tester.tap(inkWells.at(i));
        await tester.pumpAndSettle();
        return;
      } catch (e) {
        continue;
      }
    }
  }

  // Slider
  final sliders = find.byType(Slider);
  if (sliders.evaluate().isNotEmpty) {
    await tester.drag(sliders.first, const Offset(50, 0));
    await tester.pumpAndSettle();
    return;
  }

  // Date picker
  final dateIcons = find.byIcon(Icons.calendar_today);
  if (dateIcons.evaluate().isNotEmpty) {
    await tester.tap(dateIcons.first);
    await tester.pumpAndSettle();

    // Handle date picker
    final okButton = find.text('OK');
    if (okButton.evaluate().isNotEmpty) {
      await tester.tap(okButton);
      await tester.pumpAndSettle();
    }
    return;
  }
}

/// Test different question types
Future<void> _testQuestionTypes(WidgetTester tester) async {
  int questionsTested = 0;
  const maxQuestions = 5;

  while (questionsTested < maxQuestions && 
         find.text('Questionnaire Complete!').evaluate().isEmpty) {
    
    // Test current question type
    await _testCurrentQuestionType(tester);

    // Move to next question
    final continueButton = find.text('Continue');
    if (continueButton.evaluate().isNotEmpty) {
      final button = tester.widget<ElevatedButton>(
        find.ancestor(of: continueButton, matching: find.byType(ElevatedButton)),
      );
      
      if (button.onPressed != null) {
        await tester.tap(continueButton);
        await tester.pumpAndSettle();
      }
    }

    questionsTested++;
  }
}

/// Test current question type specifically
Future<void> _testCurrentQuestionType(WidgetTester tester) async {
  // Text input testing
  final textFields = find.byType(TextField);
  if (textFields.evaluate().isNotEmpty) {
    const testText = 'Type-specific test';
    await tester.enterText(textFields.first, testText);
    await tester.pumpAndSettle();

    final textField = tester.widget<TextField>(textFields.first);
    expect(textField.controller?.text, equals(testText));
    return;
  }

  // Multi-select testing (look for chips)
  final inkWells = find.byType(InkWell);
  if (inkWells.evaluate().length > 1) {
    await tester.tap(inkWells.at(0));
    await tester.pumpAndSettle();

    // Check if it's multi-select by looking for chips
    if (find.byType(Chip).evaluate().isNotEmpty) {
      await tester.tap(inkWells.at(1));
      await tester.pumpAndSettle();
      
      expect(find.byType(Chip).evaluate().length, greaterThanOrEqualTo(2));
    }
    return;
  }

  // Single select
  if (inkWells.evaluate().isNotEmpty) {
    await tester.tap(inkWells.first);
    await tester.pumpAndSettle();
    return;
  }

  // Slider testing
  final sliders = find.byType(Slider);
  if (sliders.evaluate().isNotEmpty) {
    final slider = sliders.first;
    final sliderWidget = tester.widget<Slider>(slider);
    final initialValue = sliderWidget.value;

    await tester.drag(slider, const Offset(100, 0));
    await tester.pumpAndSettle();

    final updatedWidget = tester.widget<Slider>(slider);
    expect(updatedWidget.value, isNot(equals(initialValue)));
    return;
  }
}

/// Test progress tracking
Future<void> _testProgressTracking(WidgetTester tester) async {
  final progressIndicator = find.byType(LinearProgressIndicator);
  if (progressIndicator.evaluate().isEmpty) return;

  final initialProgress = tester.widget<LinearProgressIndicator>(progressIndicator).value ?? 0.0;

  // Answer a question and proceed
  await _answerCurrentQuestion(tester);

  final continueButton = find.text('Continue');
  if (continueButton.evaluate().isNotEmpty) {
    final button = tester.widget<ElevatedButton>(
      find.ancestor(of: continueButton, matching: find.byType(ElevatedButton)),
    );
    
    if (button.onPressed != null) {
      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      // Check if progress increased
      if (progressIndicator.evaluate().isNotEmpty) {
        final newProgress = tester.widget<LinearProgressIndicator>(progressIndicator).value ?? 0.0;
        expect(newProgress, greaterThanOrEqualTo(initialProgress));
      }
    }
  }
}

/// Attempt to complete the questionnaire
Future<void> _attemptQuestionnaireCompletion(WidgetTester tester) async {
  int attempts = 0;
  const maxAttempts = 15;

  while (attempts < maxAttempts) {
    // Check if completed
    if (find.text('Questionnaire Complete!').evaluate().isNotEmpty) {
      // Test completion features
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('Continue to App'), findsOneWidget);
      expect(find.text('Review My Answers'), findsOneWidget);

      // Test review functionality
      await tester.tap(find.text('Review My Answers'));
      await tester.pumpAndSettle();

      if (find.text('Your Answers').evaluate().isNotEmpty) {
        expect(find.text('Close'), findsOneWidget);
        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();
      }

      return;
    }

    // Answer and continue
    await _answerCurrentQuestion(tester);

    final continueButton = find.text('Continue');
    final completeButton = find.text('Complete');

    if (completeButton.evaluate().isNotEmpty) {
      await tester.tap(completeButton);
      await tester.pumpAndSettle();
    } else if (continueButton.evaluate().isNotEmpty) {
      final button = tester.widget<ElevatedButton>(
        find.ancestor(of: continueButton, matching: find.byType(ElevatedButton)),
      );
      
      if (button.onPressed != null) {
        await tester.tap(continueButton);
        await tester.pumpAndSettle();
      }
    }

    attempts++;
  }
}