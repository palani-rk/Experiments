import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../lib/main.dart' as app;
import 'shared/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('NutriApp - Main App Integration Tests', () {
    testWidgets('App Launch: Main screen loads correctly', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify main screen elements
      expect(find.text('NutriApp Mockups'), findsOneWidget);
      expect(find.text('Choose a mockup to test:'), findsOneWidget);
      
      // Verify all mockup options are present
      expect(find.text('Card-Based Layout'), findsOneWidget);
      expect(find.text('Chat Bubble Layout (Original)'), findsOneWidget);
      expect(find.text('List-Based Layout'), findsOneWidget);
      expect(find.text('Clean Architecture Questionnaire'), findsOneWidget);

      // Verify theme integration
      TestHelpers.verifyThemeIntegration(tester);
    });

    testWidgets('Navigation: All mockup navigation works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test navigation to each mockup
      final mockups = [
        'Card-Based Layout',
        'Chat Bubble Layout (Original)',
        'List-Based Layout',
        'Clean Architecture Questionnaire',
      ];

      for (final mockup in mockups) {
        // Navigate to mockup
        await TestHelpers.navigateToMockup(tester, mockup);
        
        // Verify navigation succeeded (we're no longer on main screen)
        expect(find.text('NutriApp Mockups'), findsNothing);
        
        // Navigate back to main screen
        await TestHelpers.verifyNavigationToMainScreen(tester);
        
        // Verify we're back
        expect(find.text('NutriApp Mockups'), findsOneWidget);
      }
    });

    testWidgets('Theme: Material 3 theme consistency', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify Material 3 components
      TestHelpers.verifyThemeIntegration(tester);
      
      // Check for Material 3 specific elements
      expect(find.byType(Card), findsWidgets);
      expect(find.byType(InkWell), findsWidgets);
      
      // Verify color scheme consistency
      final theme = Theme.of(tester.element(find.byType(MaterialApp)));
      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.primary, isNotNull);
      expect(theme.colorScheme.surface, isNotNull);
    });

    testWidgets('Responsiveness: App works on different screen sizes', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test with different screen sizes
      await tester.binding.setSurfaceSize(const Size(320, 568)); // iPhone SE
      await tester.pumpAndSettle();
      expect(find.text('NutriApp Mockups'), findsOneWidget);

      await tester.binding.setSurfaceSize(const Size(414, 896)); // iPhone 11
      await tester.pumpAndSettle();
      expect(find.text('NutriApp Mockups'), findsOneWidget);

      await tester.binding.setSurfaceSize(const Size(1024, 768)); // iPad
      await tester.pumpAndSettle();
      expect(find.text('NutriApp Mockups'), findsOneWidget);

      // Reset to original size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('Performance: App loads within acceptable time', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();
      
      app.main();
      await TestHelpers.waitForLoadingComplete(tester);
      
      stopwatch.stop();
      
      // Verify app loads within 5 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
      
      // Verify main screen is displayed
      expect(find.text('NutriApp Mockups'), findsOneWidget);
    });
  });
}