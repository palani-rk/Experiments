import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper functions specific to the onboarding feature
class OnboardingHelpers {
  
  /// Complete the welcome flow by verifying elements and tapping Get Started
  static Future<void> completeWelcomeFlow(WidgetTester tester) async {
    // Verify welcome page elements
    await testWelcomePageElements(tester);
    
    // Tap Get Started button
    final getStartedButton = find.widgetWithText(ElevatedButton, 'Get Started');
    expect(getStartedButton, findsOneWidget);
    
    await tester.tap(getStartedButton);
    await tester.pumpAndSettle(const Duration(seconds: 1));
  }

  /// Test welcome page elements are displayed correctly
  static Future<void> testWelcomePageElements(WidgetTester tester) async {
    // Verify welcome page UI elements
    expect(find.byIcon(Icons.health_and_safety), findsOneWidget);
    expect(find.text('Welcome to NutriApp'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    
    // Verify welcome message is displayed
    expect(find.textContaining('personalized recommendations'), findsOneWidget);
  }

  /// Test welcome page interactions
  static Future<void> testWelcomePageInteractions(WidgetTester tester) async {
    // Test button hover/focus states
    final getStartedButton = find.widgetWithText(ElevatedButton, 'Get Started');
    
    // Verify button is enabled
    final buttonWidget = tester.widget<ElevatedButton>(getStartedButton);
    expect(buttonWidget.onPressed, isNotNull);
  }

  /// Test welcome page theme integration
  static Future<void> testWelcomePageTheme(WidgetTester tester) async {
    final theme = Theme.of(tester.element(find.byType(MaterialApp)));
    
    // Verify icon uses primary color
    final healthIcon = tester.widget<Icon>(find.byIcon(Icons.health_and_safety));
    expect(healthIcon.color, equals(theme.colorScheme.primary));
    
    // Verify button uses theme colors
    final button = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Get Started'));
    expect(button.style?.backgroundColor?.resolve({}), equals(theme.colorScheme.primary));
  }

  /// Test smooth transition from welcome to first question
  static Future<void> testWelcomeToQuestionTransition(WidgetTester tester) async {
    // Complete welcome flow
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    
    // Verify we're now in question flow
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
  }

  /// Complete the entire questionnaire flow with provided answers
  static Future<void> completeQuestionnaireFlow(
    WidgetTester tester, 
    Map<String, dynamic> answers,
  ) async {
    int questionsAnswered = 0;
    const maxQuestions = 15; // Safety limit

    while (questionsAnswered < maxQuestions) {
      // Check if we've reached completion
      if (find.text('Questionnaire Complete!').evaluate().isNotEmpty) {
        break;
      }

      // Verify we're in question flow
      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      // Answer current question
      await _answerCurrentQuestion(tester, answers);

      // Try to proceed
      final continueButton = find.text('Continue');
      final completeButton = find.text('Complete');

      if (completeButton.evaluate().isNotEmpty) {
        await tester.tap(completeButton);
        await tester.pumpAndSettle();
        break;
      } else if (continueButton.evaluate().isNotEmpty) {
        final buttonWidget = tester.widget<ElevatedButton>(
          find.ancestor(of: continueButton, matching: find.byType(ElevatedButton)),
        );

        if (buttonWidget.onPressed != null) {
          await tester.tap(continueButton);
          await tester.pumpAndSettle();
        }
      }

      questionsAnswered++;
    }
  }

  /// Test forward and backward navigation between questions
  static Future<void> testQuestionNavigation(WidgetTester tester) async {
    // Answer first question
    await _answerCurrentQuestion(tester, {'default': 'test'});
    
    // Go forward
    final continueButton = find.text('Continue');
    if (continueButton.evaluate().isNotEmpty) {
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      
      // Test back navigation
      final backButton = find.text('Back');
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();
        
        // Verify we went back
        expect(find.text('Continue'), findsOneWidget);
        
        // Go forward again
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
      }
    }
  }

  /// Test progress bar updates correctly
  static Future<void> testProgressTracking(WidgetTester tester) async {
    // Get initial progress
    final progressIndicator = find.byType(LinearProgressIndicator);
    expect(progressIndicator, findsOneWidget);
    
    final initialProgress = tester.widget<LinearProgressIndicator>(progressIndicator).value ?? 0.0;
    
    // Answer a question and proceed
    await _answerCurrentQuestion(tester, {'test': 'value'});
    
    final continueButton = find.text('Continue');
    if (continueButton.evaluate().isNotEmpty) {
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      
      // Verify progress increased
      final newProgress = tester.widget<LinearProgressIndicator>(progressIndicator).value ?? 0.0;
      expect(newProgress, greaterThan(initialProgress));
    }
  }

  /// Test answer persistence across navigation
  static Future<void> testAnswerPersistence(
    WidgetTester tester, 
    Map<String, dynamic> testAnswers,
  ) async {
    // Answer first question with specific data
    const testText = 'Persistence Test Answer';
    final textFields = find.byType(TextField);
    
    if (textFields.evaluate().isNotEmpty) {
      await tester.enterText(textFields.first, testText);
      await tester.pumpAndSettle();
      
      // Navigate forward
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      
      // Navigate back
      final backButton = find.text('Back');
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();
        
        // Verify answer persisted
        final textField = tester.widget<TextField>(textFields.first);
        expect(textField.controller?.text, equals(testText));
      }
    }
  }

  /// Test all question types systematically
  static Future<void> testAllQuestionTypes(
    WidgetTester tester, 
    Map<String, dynamic> questionTypeData,
  ) async {
    int questionsTested = 0;
    const maxQuestions = 10;

    while (questionsTested < maxQuestions) {
      if (find.text('Questionnaire Complete!').evaluate().isNotEmpty) {
        break;
      }

      // Test current question type
      await _testCurrentQuestionType(tester);

      // Move to next question
      final continueButton = find.text('Continue');
      if (continueButton.evaluate().isNotEmpty) {
        final buttonWidget = tester.widget<ElevatedButton>(
          find.ancestor(of: continueButton, matching: find.byType(ElevatedButton)),
        );

        if (buttonWidget.onPressed != null) {
          await tester.tap(continueButton);
          await tester.pumpAndSettle();
        }
      }

      questionsTested++;
    }
  }

  /// Test validation behavior for required fields
  static Future<void> testValidationBehavior(WidgetTester tester) async {
    // Check if current question is required
    final requiredIndicator = find.text('Required');
    if (requiredIndicator.evaluate().isNotEmpty) {
      // Try to continue without answering
      final continueButton = find.text('Continue');
      if (continueButton.evaluate().isNotEmpty) {
        final buttonWidget = tester.widget<ElevatedButton>(
          find.ancestor(of: continueButton, matching: find.byType(ElevatedButton)),
        );

        // Button should be disabled for required unanswered questions
        expect(buttonWidget.onPressed, isNull);

        // Answer the question
        await _answerCurrentQuestion(tester, {'required_test': 'value'});
        await tester.pumpAndSettle();

        // Button should now be enabled
        final updatedButtonWidget = tester.widget<ElevatedButton>(
          find.ancestor(of: continueButton, matching: find.byType(ElevatedButton)),
        );
        expect(updatedButtonWidget.onPressed, isNotNull);
      }
    }
  }

  /// Test error handling scenarios
  static Future<void> testErrorHandling(WidgetTester tester) async {
    // Test loading state
    expect(find.byType(CircularProgressIndicator), findsAny);
    
    // Wait for loading to complete
    await tester.pumpAndSettle(const Duration(seconds: 3));
    
    // Verify no error state is shown (for happy path)
    expect(find.text('Oops! Something went wrong'), findsNothing);
  }

  /// Verify completion page elements and functionality
  static Future<void> verifyCompletionPage(WidgetTester tester) async {
    // Verify completion page elements
    expect(find.text('Questionnaire Complete!'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.text('Continue to App'), findsOneWidget);
    expect(find.text('Review My Answers'), findsOneWidget);
  }

  /// Test completion page features
  static Future<void> testCompletionFeatures(WidgetTester tester) async {
    // Test review answers functionality
    await tester.tap(find.text('Review My Answers'));
    await tester.pumpAndSettle();

    expect(find.text('Your Answers'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // Test continue to app functionality
    expect(find.text('Continue to App'), findsOneWidget);
  }

  /// Private helper to answer current question based on its type
  static Future<void> _answerCurrentQuestion(
    WidgetTester tester, 
    Map<String, dynamic> answers,
  ) async {
    await tester.pumpAndSettle();

    // Text input
    final textFields = find.byType(TextField);
    if (textFields.evaluate().isNotEmpty) {
      await tester.enterText(textFields.first, 'Test Answer');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      return;
    }

    // Radio/Multi-select options (InkWell containers)
    final inkWells = find.byType(InkWell);
    for (int i = 0; i < inkWells.evaluate().length && i < 3; i++) {
      try {
        await tester.tap(inkWells.at(i));
        await tester.pumpAndSettle();
        return;
      } catch (e) {
        continue;
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
    final calendarIcons = find.byIcon(Icons.calendar_today);
    if (calendarIcons.evaluate().isNotEmpty) {
      await tester.tap(calendarIcons.first);
      await tester.pumpAndSettle();

      final okButton = find.text('OK');
      if (okButton.evaluate().isNotEmpty) {
        await tester.tap(okButton);
        await tester.pumpAndSettle();
      }
      return;
    }
  }

  /// Private helper to test current question type specifically
  static Future<void> _testCurrentQuestionType(WidgetTester tester) async {
    // Text input testing
    final textFields = find.byType(TextField);
    if (textFields.evaluate().isNotEmpty) {
      const testInput = 'Specific Test Input';
      await tester.enterText(textFields.first, testInput);
      await tester.pumpAndSettle();

      // Verify input was accepted
      final textFieldWidget = tester.widget<TextField>(textFields.first);
      expect(textFieldWidget.controller?.text, equals(testInput));
      return;
    }

    // Multi-select testing
    final inkWells = find.byType(InkWell);
    if (inkWells.evaluate().length > 1) {
      // Select multiple options for multi-select
      await tester.tap(inkWells.at(0));
      await tester.pumpAndSettle();

      await tester.tap(inkWells.at(1));
      await tester.pumpAndSettle();

      // Check for chips (indicates multi-select)
      final chips = find.byType(Chip);
      if (chips.evaluate().isNotEmpty) {
        expect(chips.evaluate().length, greaterThanOrEqualTo(2));
      }
      return;
    }

    // Single select (radio) testing
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

      await tester.drag(slider, const Offset(50, 0));
      await tester.pumpAndSettle();

      // Verify slider value changed
      final updatedSliderWidget = tester.widget<Slider>(slider);
      expect(updatedSliderWidget.value, isNot(equals(initialValue)));
      return;
    }
  }
}