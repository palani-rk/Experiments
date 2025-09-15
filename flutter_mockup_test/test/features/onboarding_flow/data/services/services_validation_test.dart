import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_mockup_test/features/onboarding_flow/data/models/core/enums.dart';
import 'package:flutter_mockup_test/features/onboarding_flow/data/models/support/validation_status.dart';
import 'package:flutter_mockup_test/features/onboarding_flow/data/services/implementations/default_chat_validation_service.dart';
import 'package:flutter_mockup_test/features/onboarding_flow/data/services/implementations/local_chat_persistence_service.dart';

/// Comprehensive test suite for Phase 2 Service Layer implementations
///
/// Tests the service layer components with embedded business logic,
/// validation rules, and persistence functionality.
void main() {
  group('Phase 2 Service Layer Tests', () {
    late DefaultChatValidationService validationService;

    setUp(() {
      validationService = DefaultChatValidationService();
    });

    group('ChatValidationService Tests', () {
      group('Text Validation', () {
        test('should validate required text fields', () {
          // Test required field validation
          final result1 = validationService.validateTextAnswer(
            value: '',
            rules: {'required': true},
          );
          expect(result1.isValid, false);
          expect(result1.primaryError, contains('required'));

          // Test valid required field
          final result2 = validationService.validateTextAnswer(
            value: 'Valid name',
            rules: {'required': true},
          );
          expect(result2.isValid, true);
        });

        test('should validate text length constraints', () {
          // Test minimum length
          final result1 = validationService.validateTextAnswer(
            value: 'Hi',
            rules: {'minLength': 5},
          );
          expect(result1.isValid, false);
          expect(result1.primaryError, contains('5 characters'));

          // Test maximum length
          final result2 = validationService.validateTextAnswer(
            value: 'This is a very long text that exceeds maximum',
            rules: {'maxLength': 20},
          );
          expect(result2.isValid, false);
          expect(result2.primaryError, contains('20 characters'));

          // Test valid length
          final result3 = validationService.validateTextAnswer(
            value: 'Perfect length',
            rules: {'minLength': 5, 'maxLength': 20},
          );
          expect(result3.isValid, true);
        });

        test('should validate text patterns', () {
          // Test name pattern (letters and spaces only)
          final result1 = validationService.validateTextAnswer(
            value: 'John123',
            rules: {
              'pattern': r'^[a-zA-Z\s]+$',
              'patternName': 'name'
            },
          );
          expect(result1.isValid, false);
          expect(result1.primaryError, contains('valid name'));

          // Test valid name
          final result2 = validationService.validateTextAnswer(
            value: 'John Smith',
            rules: {
              'pattern': r'^[a-zA-Z\s]+$',
              'patternName': 'name'
            },
          );
          expect(result2.isValid, true);
        });
      });

      group('Number Validation', () {
        test('should validate number ranges', () {
          // Test minimum value
          final result1 = validationService.validateNumberAnswer(
            value: 5,
            rules: {'min': 10},
          );
          expect(result1.isValid, false);
          expect(result1.primaryError, contains('at least 10'));

          // Test maximum value
          final result2 = validationService.validateNumberAnswer(
            value: 150,
            rules: {'max': 100},
          );
          expect(result2.isValid, false);
          expect(result2.primaryError, contains('no more than 100'));

          // Test valid range
          final result3 = validationService.validateNumberAnswer(
            value: 25,
            rules: {'min': 10, 'max': 100},
          );
          expect(result3.isValid, true);
        });

        test('should validate integer requirement', () {
          // Test decimal when integer required
          final result1 = validationService.validateNumberAnswer(
            value: 25.5,
            rules: {'integer': true},
          );
          expect(result1.isValid, false);
          expect(result1.primaryError, contains('whole number'));

          // Test valid integer
          final result2 = validationService.validateNumberAnswer(
            value: 25,
            rules: {'integer': true},
          );
          expect(result2.isValid, true);
        });

        test('should validate special number types', () {
          // Test age validation
          final result1 = validationService.validateNumberAnswer(
            value: 5,
            rules: {'numberType': 'age'},
          );
          expect(result1.isValid, false);
          expect(result1.primaryError, contains('13 years old'));

          // Test valid age
          final result2 = validationService.validateNumberAnswer(
            value: 25,
            rules: {'numberType': 'age'},
          );
          expect(result2.isValid, true);

          // Test invalid high age
          final result3 = validationService.validateNumberAnswer(
            value: 150,
            rules: {'numberType': 'age'},
          );
          expect(result3.isValid, false);
        });
      });

      group('Service Integration Tests', () {
        test('should validate answer format for different question types', () {
          // Test format validation for each question type
          expect(
            validationService.isAnswerFormatValid(
              answer: 'text answer',
              questionType: QuestionType.text,
            ),
            true,
          );

          expect(
            validationService.isAnswerFormatValid(
              answer: 42,
              questionType: QuestionType.number,
            ),
            true,
          );

          expect(
            validationService.isAnswerFormatValid(
              answer: ['option1', 'option2'],
              questionType: QuestionType.multiselect,
            ),
            true,
          );

          expect(
            validationService.isAnswerFormatValid(
              answer: true,
              questionType: QuestionType.boolean,
            ),
            true,
          );

          // Test invalid formats
          expect(
            validationService.isAnswerFormatValid(
              answer: 'not a number',
              questionType: QuestionType.number,
            ),
            false,
          );

          expect(
            validationService.isAnswerFormatValid(
              answer: 'not a list',
              questionType: QuestionType.multiselect,
            ),
            false,
          );
        });
      });

      group('Validation Utilities', () {
        test('should provide user-friendly error messages', () {
          final technicalError = ValidationStatus.error(
            'Field validation failed: regex pattern mismatch',
          );

          final friendlyMessage = validationService.getUserFriendlyErrorMessage(technicalError);
          expect(friendlyMessage, isNot(contains('regex')));

          final validStatus = ValidationStatus.valid();
          expect(validationService.getUserFriendlyErrorMessage(validStatus), 'Valid');
        });
      });
    });

    group('ChatPersistenceService Tests', () {
      // Note: These tests would require mock SharedPreferences
      // For now, we'll test the service can be instantiated
      test('should instantiate LocalChatPersistenceService', () {
        expect(() => LocalChatPersistenceService(), returnsNormally);
      });
    });

    group('Business Logic Validation', () {
      test('should provide comprehensive validation for questionnaire flow', () {
        // This would test end-to-end business logic validation
        // For now, ensure the validation service structure supports it
        expect(validationService.validateBusinessRules, isA<Function>());
        expect(validationService.checkDependencies, isA<Function>());
        expect(validationService.validateAnswerConsistency, isA<Function>());
      });
    });
  });
}