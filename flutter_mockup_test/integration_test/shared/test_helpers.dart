import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// TimeoutException for test timeouts
class TimeoutException implements Exception {
  final String message;
  final Duration timeout;
  
  const TimeoutException(this.message, this.timeout);
  
  @override
  String toString() => 'TimeoutException: $message (timeout: $timeout)';
}

/// Shared test helper functions that can be used across all features
class TestHelpers {
  
  /// Navigate from main screen to the Clean Architecture Questionnaire
  static Future<void> navigateToQuestionnaire(WidgetTester tester) async {
    // Verify we're on the main mockup selection screen
    expect(find.text('NutriApp Mockups'), findsOneWidget);
    expect(find.text('Choose a mockup to test:'), findsOneWidget);
    
    // Find the Clean Architecture Questionnaire card
    final questionnaireCard = find.ancestor(
      of: find.text('Clean Architecture Questionnaire'),
      matching: find.byType(InkWell),
    );
    
    expect(questionnaireCard, findsOneWidget);
    
    // Tap the card to navigate
    await tester.tap(questionnaireCard);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  /// Navigate to a specific mockup by title
  static Future<void> navigateToMockup(WidgetTester tester, String mockupTitle) async {
    expect(find.text('NutriApp Mockups'), findsOneWidget);
    
    final mockupCard = find.ancestor(
      of: find.text(mockupTitle),
      matching: find.byType(InkWell),
    );
    
    expect(mockupCard, findsOneWidget);
    await tester.tap(mockupCard);
    await tester.pumpAndSettle();
  }

  /// Wait for a specific widget to appear with timeout
  static Future<void> waitForWidget(
    WidgetTester tester, 
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) async {
    final endTime = DateTime.now().add(timeout);
    
    while (DateTime.now().isBefore(endTime)) {
      if (finder.evaluate().isNotEmpty) {
        return;
      }
      await tester.pumpAndSettle(pollInterval);
    }
    
    throw TimeoutException('Widget not found within timeout', timeout);
  }

  /// Wait for loading to complete (no CircularProgressIndicator visible)
  static Future<void> waitForLoadingComplete(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final endTime = DateTime.now().add(timeout);
    
    while (DateTime.now().isBefore(endTime)) {
      await tester.pumpAndSettle();
      
      if (find.byType(CircularProgressIndicator).evaluate().isEmpty) {
        return;
      }
      
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    throw TimeoutException('Loading did not complete within timeout', timeout);
  }

  /// Verify app theme integration
  static void verifyThemeIntegration(WidgetTester tester) {
    final materialApp = find.byType(MaterialApp);
    expect(materialApp, findsOneWidget);
    
    final theme = Theme.of(tester.element(materialApp));
    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme, isNotNull);
  }

  /// Take a screenshot (useful for debugging)
  static Future<void> takeScreenshot(WidgetTester tester, String name) async {
    // This is a placeholder - actual screenshot implementation would depend on test environment
    debugPrint('Screenshot taken: $name');
    await tester.pumpAndSettle();
  }

  /// Scroll to find a widget that might not be currently visible
  static Future<void> scrollToFindWidget(
    WidgetTester tester, 
    Finder scrollableFinder, 
    Finder targetFinder,
  ) async {
    const scrollDistance = 300.0;
    const maxScrollAttempts = 10;
    
    for (int i = 0; i < maxScrollAttempts; i++) {
      if (targetFinder.evaluate().isNotEmpty) {
        return;
      }
      
      await tester.drag(scrollableFinder, const Offset(0, -scrollDistance));
      await tester.pumpAndSettle();
    }
    
    throw Exception('Target widget not found after scrolling');
  }

  /// Verify navigation back to main screen
  static Future<void> verifyNavigationToMainScreen(WidgetTester tester) async {
    // Look for back button or app bar back arrow
    final backButton = find.byTooltip('Back');
    if (backButton.evaluate().isNotEmpty) {
      await tester.tap(backButton);
      await tester.pumpAndSettle();
    }
    
    // Verify we're back to main screen
    expect(find.text('NutriApp Mockups'), findsOneWidget);
  }

  /// Generic method to fill form fields with test data
  static Future<void> fillFormFields(
    WidgetTester tester, 
    Map<String, String> formData,
  ) async {
    for (final entry in formData.entries) {
      final fieldFinder = find.byKey(Key(entry.key));
      if (fieldFinder.evaluate().isNotEmpty) {
        await tester.enterText(fieldFinder, entry.value);
        await tester.pumpAndSettle();
      }
    }
  }

  /// Verify error handling UI
  static Future<void> verifyErrorHandling(WidgetTester tester) async {
    // Check for error widgets
    final errorWidget = find.byIcon(Icons.error_outline);
    final retryButton = find.text('Try Again');
    
    if (errorWidget.evaluate().isNotEmpty) {
      expect(find.text('Oops! Something went wrong'), findsOneWidget);
      expect(retryButton, findsOneWidget);
      
      // Test retry functionality
      await tester.tap(retryButton);
      await tester.pumpAndSettle();
    }
  }

  /// Verify loading state UI
  static void verifyLoadingState(WidgetTester tester) {
    // Check for loading indicators
    final loadingIndicator = find.byType(CircularProgressIndicator);
    final loadingText = find.textContaining('Loading');
    
    if (loadingIndicator.evaluate().isNotEmpty) {
      expect(loadingText, findsWidgets);
    }
  }

  /// Generic method to test button states (enabled/disabled)
  static void verifyButtonState(
    WidgetTester tester, 
    String buttonText, 
    bool shouldBeEnabled,
  ) {
    final button = find.widgetWithText(ElevatedButton, buttonText);
    if (button.evaluate().isNotEmpty) {
      final buttonWidget = tester.widget<ElevatedButton>(button);
      
      if (shouldBeEnabled) {
        expect(buttonWidget.onPressed, isNotNull);
      } else {
        expect(buttonWidget.onPressed, isNull);
      }
    }
  }

  /// Verify text appears within a specific parent widget
  static void verifyTextInWidget(
    WidgetTester tester, 
    String text, 
    Type parentWidgetType,
  ) {
    final textFinder = find.text(text);
    final parentFinder = find.ancestor(
      of: textFinder,
      matching: find.byType(parentWidgetType),
    );
    
    expect(parentFinder, findsOneWidget);
  }

  /// Generic method to test widget animations
  static Future<void> testWidgetAnimation(
    WidgetTester tester, 
    Finder animatedWidget,
    Duration animationDuration,
  ) async {
    // Trigger animation
    await tester.pump();
    
    // Pump through animation frames
    await tester.pump(animationDuration * 0.5);
    await tester.pump(animationDuration);
    
    // Ensure animation completes
    await tester.pumpAndSettle();
  }

  /// Debug method to print current widget tree
  static void debugPrintWidgetTree(WidgetTester tester) {
    debugPrint('=== Current Widget Tree ===');
    final element = tester.allElements.first;
    debugPrint(element.toStringDeep());
    debugPrint('=========================');
  }
}