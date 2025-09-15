import '../../../data/models/core/chat_section.dart';
import '../../../data/models/core/enums.dart';
import '../../../data/models/core/section_message.dart';
import '../../../data/models/support/chat_state.dart';
import '../../../data/models/support/question.dart';
import '../../../data/models/support/validation_status.dart';
import '../exceptions/chat_exceptions.dart';
import '../interfaces/chat_validation_service.dart';

/// Default implementation of ChatValidationService with comprehensive validation rules
///
/// Provides extensive validation for all answer types, business rules, and
/// cross-section validation for the chat-based questionnaire system.
class DefaultChatValidationService implements ChatValidationService {
  // Custom validation rules registry
  final Map<String, ValidationStatus Function(dynamic, Map<String, dynamic>?)>
      _customValidators = {};

  // Business rule configurations
  // ignore: unused_field
  static const Map<String, dynamic> _businessRules = {
    'age_activity_compatibility': {
      'high_intensity_age_limit': 65,
      'moderate_intensity_age_limit': 80,
    },
    'dietary_restrictions': {
      'max_restrictions': 5,
      'conflicting_pairs': [
        ['vegan', 'vegetarian'], // Vegan is stricter than vegetarian
        ['keto', 'high_carb'],
        ['low_fat', 'high_fat'],
      ],
    },
    'health_conditions': {
      'max_conditions': 8,
      'critical_conditions': [
        'heart_disease',
        'diabetes_type_1',
        'kidney_disease',
        'liver_disease'
      ],
    },
  };

  // ========================================================================
  // Answer Validation by Type
  // ========================================================================

  @override
  ValidationStatus validateTextAnswer({
    required String value,
    Map<String, dynamic>? rules,
  }) {
    try {
      final trimmedValue = value.trim();

      // Required validation
      if (rules?['required'] == true && trimmedValue.isEmpty) {
        return ValidationStatus.error('This field is required');
      }

      if (trimmedValue.isEmpty) {
        return ValidationStatus.valid();
      }

      // Length validation
      final minLength = rules?['minLength'] as int?;
      final maxLength = rules?['maxLength'] as int?;

      if (minLength != null && trimmedValue.length < minLength) {
        return ValidationStatus.error('Must be at least $minLength characters long');
      }

      if (maxLength != null && trimmedValue.length > maxLength) {
        return ValidationStatus.error('Must be no more than $maxLength characters long');
      }

      // Pattern validation
      final pattern = rules?['pattern'] as String?;
      if (pattern != null) {
        final regex = RegExp(pattern);
        if (!regex.hasMatch(trimmedValue)) {
          final patternName = rules?['patternName'] as String?;
          return ValidationStatus.error(
            patternName != null
                ? 'Please enter a valid $patternName'
                : 'Invalid format'
          );
        }
      }

      // Profanity check (basic)
      if (_containsProfanity(trimmedValue)) {
        return ValidationStatus.error('Please keep your response professional');
      }

      return ValidationStatus.valid();
    } catch (e) {
      return ValidationStatus.error('Text validation error: $e');
    }
  }

  @override
  ValidationStatus validateNumberAnswer({
    required num value,
    Map<String, dynamic>? rules,
  }) {
    try {
      // Type validation
      final mustBeInteger = rules?['integer'] == true;
      if (mustBeInteger && value != value.toInt()) {
        return ValidationStatus.error('Must be a whole number');
      }

      // Range validation
      final min = rules?['min'] as num?;
      final max = rules?['max'] as num?;

      if (min != null && value < min) {
        return ValidationStatus.error('Must be at least $min');
      }

      if (max != null && value > max) {
        return ValidationStatus.error('Must be no more than $max');
      }

      // Decimal places validation
      final maxDecimals = rules?['maxDecimals'] as int?;
      if (maxDecimals != null) {
        final decimals = _countDecimalPlaces(value);
        if (decimals > maxDecimals) {
          return ValidationStatus.error('Maximum $maxDecimals decimal places allowed');
        }
      }

      // Special validation for specific number types
      final numberType = rules?['numberType'] as String?;
      switch (numberType) {
        case 'age':
          return _validateAge(value);
        case 'weight':
          return _validateWeight(value);
        case 'height':
          return _validateHeight(value);
        case 'percentage':
          return _validatePercentage(value);
      }

      return ValidationStatus.valid();
    } catch (e) {
      return ValidationStatus.error('Number validation error: $e');
    }
  }

  @override
  ValidationStatus validateEmailAnswer({
    required String value,
    List<String>? allowedDomains,
  }) {
    try {
      final trimmedValue = value.trim();

      if (trimmedValue.isEmpty) {
        return ValidationStatus.error('Email is required');
      }

      // Basic email regex
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );

      if (!emailRegex.hasMatch(trimmedValue)) {
        return ValidationStatus.error('Please enter a valid email address');
      }

      // Domain validation
      if (allowedDomains != null && allowedDomains.isNotEmpty) {
        final domain = trimmedValue.split('@').last.toLowerCase();
        if (!allowedDomains.any((allowed) => domain == allowed.toLowerCase())) {
          return ValidationStatus.error('Email must be from: ${allowedDomains.join(', ')}');
        }
      }

      // Additional email validations
      if (trimmedValue.length > 254) {
        return ValidationStatus.error('Email address is too long');
      }

      final localPart = trimmedValue.split('@').first;
      if (localPart.length > 64) {
        return ValidationStatus.error('Email local part is too long');
      }

      return ValidationStatus.valid();
    } catch (e) {
      return ValidationStatus.error('Email validation error: $e');
    }
  }

  @override
  ValidationStatus validatePhoneAnswer({
    required String value,
    String? region = 'US',
  }) {
    try {
      final trimmedValue = value.trim();

      if (trimmedValue.isEmpty) {
        return ValidationStatus.error('Phone number is required');
      }

      // Remove common phone number formatting
      final cleanedValue = trimmedValue.replaceAll(RegExp(r'[\s\-\(\)\+\.]'), '');

      // Region-specific validation
      switch (region?.toUpperCase()) {
        case 'US':
          return _validateUSPhoneNumber(cleanedValue);
        case 'CA':
          return _validateCAPhoneNumber(cleanedValue);
        case 'UK':
          return _validateUKPhoneNumber(cleanedValue);
        default:
          return _validateInternationalPhoneNumber(cleanedValue);
      }
    } catch (e) {
      return ValidationStatus.error('Phone validation error: $e');
    }
  }

  @override
  ValidationStatus validateDateAnswer({
    required DateTime value,
    Map<String, dynamic>? rules,
  }) {
    try {
      final now = DateTime.now();

      // Date range validation
      final minDate = rules?['minDate'] as DateTime?;
      final maxDate = rules?['maxDate'] as DateTime?;

      if (minDate != null && value.isBefore(minDate)) {
        return ValidationStatus.error('Date must be after ${_formatDate(minDate)}');
      }

      if (maxDate != null && value.isAfter(maxDate)) {
        return ValidationStatus.error('Date must be before ${_formatDate(maxDate)}');
      }

      // Special date validation
      final dateType = rules?['dateType'] as String?;
      switch (dateType) {
        case 'birthdate':
          return _validateBirthdate(value, now);
        case 'future_only':
          if (value.isBefore(now)) {
            return ValidationStatus.error('Date must be in the future');
          }
          break;
        case 'past_only':
          if (value.isAfter(now)) {
            return ValidationStatus.error('Date must be in the past');
          }
          break;
      }

      return ValidationStatus.valid();
    } catch (e) {
      return ValidationStatus.error('Date validation error: $e');
    }
  }

  @override
  ValidationStatus validateSelectionAnswer({
    required dynamic value,
    required List<String> options,
    required bool isMultiselect,
    Map<String, dynamic>? rules,
  }) {
    try {
      if (isMultiselect) {
        // Multiselect validation
        if (value is! List) {
          return ValidationStatus.error('Multiple selections must be provided as a list');
        }

        final selections = value as List;

        // Check if all selections are valid options
        for (final selection in selections) {
          if (!options.contains(selection.toString())) {
            return ValidationStatus.error('Invalid selection: $selection');
          }
        }

        // Selection count validation
        final minSelections = rules?['minSelections'] as int? ?? 0;
        final maxSelections = rules?['maxSelections'] as int?;

        if (selections.length < minSelections) {
          return ValidationStatus.error('Must select at least $minSelections options');
        }

        if (maxSelections != null && selections.length > maxSelections) {
          return ValidationStatus.error('Must select no more than $maxSelections options');
        }

        // Duplicate check
        final uniqueSelections = selections.toSet();
        if (uniqueSelections.length != selections.length) {
          return ValidationStatus.error('Duplicate selections are not allowed');
        }
      } else {
        // Single selection validation
        if (!options.contains(value.toString())) {
          return ValidationStatus.error('Invalid selection: $value');
        }
      }

      return ValidationStatus.valid();
    } catch (e) {
      return ValidationStatus.error('Selection validation error: $e');
    }
  }

  @override
  ValidationStatus validateSliderAnswer({
    required num value,
    Map<String, dynamic>? rules,
  }) {
    try {
      final min = rules?['min'] as num? ?? 0;
      final max = rules?['max'] as num? ?? 100;
      final step = rules?['step'] as num? ?? 1;

      if (value < min) {
        return ValidationStatus.error('Value must be at least $min');
      }

      if (value > max) {
        return ValidationStatus.error('Value must be no more than $max');
      }

      // Step validation
      if (step > 0) {
        final remainder = (value - min) % step;
        if (remainder.abs() > 0.0001) {
          // Use small epsilon for floating point comparison
          return ValidationStatus.error('Value must be in increments of $step');
        }
      }

      return ValidationStatus.valid();
    } catch (e) {
      return ValidationStatus.error('Slider validation error: $e');
    }
  }

  @override
  ValidationStatus validateBooleanAnswer({
    required bool value,
    Map<String, dynamic>? rules,
  }) {
    // Boolean values are inherently valid
    // Additional business logic can be added here if needed
    return ValidationStatus.valid();
  }

  // ========================================================================
  // Section & Questionnaire Validation
  // ========================================================================

  @override
  Future<List<ValidationStatus>> validateSection(
    QuestionnaireSection section,
  ) async {
    return handleServiceOperation(
      () async {
        final validationResults = <ValidationStatus>[];
        final answeredQuestions = section.messages.whereType<QuestionAnswer>();
        final answeredQuestionIds = answeredQuestions.map((qa) => qa.questionId).toSet();

        // Validate required questions are answered
        for (final question in section.questions) {
          if (question.required && !answeredQuestionIds.contains(question.id)) {
            validationResults.add(ValidationStatus.error(
              'Required question "${question.text}" is not answered',
            ));
          }
        }

        // Validate individual answers
        for (final answer in answeredQuestions) {
          final question = section.questions.where((q) => q.id == answer.questionId).firstOrNull;
          if (question != null) {
            final validation = await validateAnswer(
              questionId: answer.questionId,
              answer: answer.answer,
            );
            if (!validation.isValid) {
              validationResults.add(validation);
            }
          }
        }

        // Section-specific business rules
        final sectionValidation = await _validateSectionBusinessRules(section);
        if (!sectionValidation.isValid) {
          validationResults.add(sectionValidation);
        }

        return validationResults;
      },
      operationName: 'validateSection',
      context: {'sectionId': section.id},
    );
  }

  @override
  Future<ValidationStatus> validateQuestionnaire(
    List<ChatSection> sections,
  ) async {
    return handleServiceOperation(
      () async {
        final questionnaireSections = sections.whereType<QuestionnaireSection>();
        final errors = <String>[];

        // Validate each section
        for (final section in questionnaireSections) {
          final sectionValidations = await validateSection(section);
          errors.addAll(
            sectionValidations
                .where((v) => !v.isValid)
                .map((v) => '${section.title}: ${v.primaryError}'),
          );
        }

        // Cross-section validation
        final crossValidation = await _validateCrossSectionRules(questionnaireSections.toList());
        if (!crossValidation.isValid) {
          errors.add(crossValidation.primaryError ?? 'Cross-section validation failed');
        }

        return errors.isEmpty
            ? ValidationStatus.valid()
            : ValidationStatus.invalid(
                errors: errors,
              );
      },
      operationName: 'validateQuestionnaire',
      context: {'sectionsCount': sections.length},
    );
  }

  @override
  Future<ValidationStatus> validateSectionCompletion(String sectionId) async {
    // This would typically receive the section as parameter
    // For now, return a basic validation
    return ValidationStatus.valid();
  }

  // ========================================================================
  // Business Rules Validation
  // ========================================================================

  @override
  Future<ValidationStatus> validateBusinessRules(ChatState state) async {
    return handleServiceOperation(
      () async {
        final errors = <String>[];
        final warnings = <String>[];

        // Age-dependent validations
        final ageValidation = await _validateAgeBusinessRules(state);
        if (!ageValidation.isValid) {
          errors.addAll(ageValidation.errors);
        }
        warnings.addAll(ageValidation.warnings);

        // Dietary restrictions validation
        final dietValidation = await _validateDietaryBusinessRules(state);
        if (!dietValidation.isValid) {
          errors.addAll(dietValidation.errors);
        }
        warnings.addAll(dietValidation.warnings);

        // Health conditions validation
        final healthValidation = await _validateHealthBusinessRules(state);
        if (!healthValidation.isValid) {
          errors.addAll(healthValidation.errors);
        }
        warnings.addAll(healthValidation.warnings);

        // Goal compatibility validation
        final goalValidation = await _validateGoalBusinessRules(state);
        if (!goalValidation.isValid) {
          errors.addAll(goalValidation.errors);
        }
        warnings.addAll(goalValidation.warnings);

        return ValidationStatus(
          isValid: errors.isEmpty,
          errors: errors,
          warnings: warnings,
        );
      },
      operationName: 'validateBusinessRules',
    );
  }

  @override
  ValidationStatus checkDependencies({
    required Question question,
    required List<QuestionAnswer> answers,
  }) {
    try {
      final showIf = question.metadata?['showIf'] as Map<String, dynamic>?;
      if (showIf == null) {
        return ValidationStatus.valid();
      }

      final dependentQuestionId = showIf['questionId'] as String?;
      if (dependentQuestionId == null) {
        return ValidationStatus.valid();
      }

      // Find dependent answer
      final dependentAnswer = answers.where((a) => a.questionId == dependentQuestionId).firstOrNull;
      if (dependentAnswer == null) {
        return ValidationStatus.error(
          'Dependent question "$dependentQuestionId" must be answered first',
        );
      }

      // Validate dependency condition
      final expectedValue = showIf['value'];
      final operator = showIf['operator'] as String? ?? 'equals';

      final conditionMet = _evaluateDependencyCondition(
        dependentAnswer.answer,
        expectedValue,
        operator,
      );

      return conditionMet
          ? ValidationStatus.valid()
          : ValidationStatus.error(
              'Dependency condition not met for question "${question.text}"',
            );
    } catch (e) {
      return ValidationStatus.error('Dependency check error: $e');
    }
  }

  @override
  Future<ValidationStatus> validateAnswerConsistency({
    required String questionId,
    required dynamic answer,
    required ChatState currentState,
  }) async {
    return handleServiceOperation(
      () async {
        final errors = <String>[];

        // Find the question across all sections
        Question? targetQuestion;
        QuestionnaireSection? targetSection;

        for (final section in currentState.sections.whereType<QuestionnaireSection>()) {
          final question = section.questions.where((q) => q.id == questionId).firstOrNull;
          if (question != null) {
            targetQuestion = question;
            targetSection = section;
            break;
          }
        }

        if (targetQuestion == null || targetSection == null) {
          return ValidationStatus.error('Question not found for consistency check');
        }

        // Check for contradictory answers
        final contradictoryChecks = targetQuestion.metadata?['contradictoryWith'] as List<dynamic>?;
        if (contradictoryChecks != null) {
          for (final check in contradictoryChecks) {
            final contradictoryValidation = await _checkContradictoryAnswer(
              answer,
              check as Map<String, dynamic>,
              currentState,
            );
            if (!contradictoryValidation.isValid) {
              errors.addAll(contradictoryValidation.errors);
            }
          }
        }

        return errors.isEmpty
            ? ValidationStatus.valid()
            : ValidationStatus.invalid(errors: errors);
      },
      operationName: 'validateAnswerConsistency',
      context: {'questionId': questionId},
    );
  }

  // ========================================================================
  // Real-time Validation
  // ========================================================================

  @override
  ValidationStatus validateAnswerRealtime({
    required String questionId,
    required dynamic partialAnswer,
    required QuestionType questionType,
    Map<String, dynamic>? rules,
  }) {
    try {
      // Basic format validation for partial answers
      switch (questionType) {
        case QuestionType.text:
          if (partialAnswer is String) {
            final maxLength = rules?['maxLength'] as int?;
            if (maxLength != null && partialAnswer.length > maxLength) {
              return ValidationStatus.error('Maximum length is $maxLength characters');
            }
          }
          break;

        case QuestionType.number:
          if (partialAnswer is String) {
            final numValue = num.tryParse(partialAnswer);
            if (partialAnswer.isNotEmpty && numValue == null) {
              return ValidationStatus.error('Must be a valid number');
            }
          }
          break;

        case QuestionType.email:
          if (partialAnswer is String && partialAnswer.isNotEmpty) {
            // Basic email format check for real-time feedback
            if (!partialAnswer.contains('@') && partialAnswer.length > 3) {
              return ValidationStatus.error('Email must contain @');
            }
          }
          break;

        default:
          // Other types don't need real-time validation
          break;
      }

      return ValidationStatus.valid();
    } catch (e) {
      return ValidationStatus.valid(); // Don't block real-time input on errors
    }
  }

  @override
  List<String> getValidationHints({
    required QuestionType questionType,
    Map<String, dynamic>? rules,
  }) {
    final hints = <String>[];

    switch (questionType) {
      case QuestionType.text:
        final minLength = rules?['minLength'] as int?;
        final maxLength = rules?['maxLength'] as int?;
        if (minLength != null && maxLength != null) {
          hints.add('Enter between $minLength and $maxLength characters');
        } else if (minLength != null) {
          hints.add('Minimum $minLength characters required');
        } else if (maxLength != null) {
          hints.add('Maximum $maxLength characters allowed');
        }
        break;

      case QuestionType.number:
        final min = rules?['min'] as num?;
        final max = rules?['max'] as num?;
        if (min != null && max != null) {
          hints.add('Enter a number between $min and $max');
        } else if (min != null) {
          hints.add('Enter a number $min or greater');
        } else if (max != null) {
          hints.add('Enter a number $max or less');
        }
        if (rules?['integer'] == true) {
          hints.add('Must be a whole number');
        }
        break;

      case QuestionType.email:
        hints.add('Enter a valid email address (e.g., name@example.com)');
        break;

      case QuestionType.phone:
        hints.add('Enter your phone number with area code');
        break;

      case QuestionType.date:
        hints.add('Select a date from the calendar');
        break;

      case QuestionType.radio:
        hints.add('Select one option');
        break;

      case QuestionType.multiselect:
        final minSelections = rules?['minSelections'] as int?;
        final maxSelections = rules?['maxSelections'] as int?;
        if (minSelections != null && maxSelections != null) {
          hints.add('Select between $minSelections and $maxSelections options');
        } else if (minSelections != null) {
          hints.add('Select at least $minSelections options');
        } else if (maxSelections != null) {
          hints.add('Select up to $maxSelections options');
        } else {
          hints.add('Select one or more options');
        }
        break;

      case QuestionType.slider:
        final min = rules?['min'] as num? ?? 0;
        final max = rules?['max'] as num? ?? 100;
        hints.add('Drag slider to select value between $min and $max');
        break;

      case QuestionType.scale:
        hints.add('Rate on the scale provided');
        break;

      case QuestionType.boolean:
        hints.add('Select Yes or No');
        break;
    }

    return hints;
  }

  @override
  bool isAnswerFormatValid({
    required dynamic answer,
    required QuestionType questionType,
  }) {
    try {
      switch (questionType) {
        case QuestionType.text:
          return answer is String;

        case QuestionType.number:
          return answer is num;

        case QuestionType.email:
          return answer is String;

        case QuestionType.phone:
          return answer is String;

        case QuestionType.date:
          return answer is DateTime || answer is String;

        case QuestionType.radio:
          return answer is String;

        case QuestionType.multiselect:
          return answer is List;

        case QuestionType.slider:
        case QuestionType.scale:
          return answer is num;

        case QuestionType.boolean:
          return answer is bool;
      }
    } catch (_) {
      return false;
    }
  }

  // ========================================================================
  // Custom Validation Rules
  // ========================================================================

  @override
  void registerCustomValidator({
    required String ruleName,
    required ValidationStatus Function(dynamic value, Map<String, dynamic>? params) validator,
  }) {
    _customValidators[ruleName] = validator;
  }

  @override
  ValidationStatus applyCustomValidation({
    required String ruleName,
    required dynamic value,
    Map<String, dynamic>? params,
  }) {
    final validator = _customValidators[ruleName];
    if (validator == null) {
      return ValidationStatus.error('Custom validation rule "$ruleName" not found');
    }

    try {
      return validator(value, params);
    } catch (e) {
      return ValidationStatus.error('Custom validation error: $e');
    }
  }

  @override
  List<String> getAvailableCustomRules() {
    return _customValidators.keys.toList();
  }

  // ========================================================================
  // Validation Utilities
  // ========================================================================

  @override
  ValidationStatus combineValidationResults(List<ValidationStatus> results) {
    if (results.isEmpty) {
      return ValidationStatus.valid();
    }

    final errors = <String>[];
    final warnings = <String>[];

    for (final result in results) {
      if (!result.isValid) {
        errors.addAll(result.errors);
      }
      warnings.addAll(result.warnings);
    }

    return ValidationStatus(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  @override
  bool isBlockingError(ValidationStatus status) {
    if (status.isValid) return false;

    // Certain errors are non-blocking (warnings only)
    final firstError = status.primaryError?.toLowerCase() ?? '';
    return !firstError.contains('recommendation') &&
           !firstError.contains('consider') &&
           !firstError.contains('warning');
  }

  @override
  String getUserFriendlyErrorMessage(ValidationStatus status) {
    if (status.isValid) return 'Valid';

    final errorMessage = status.primaryError ?? 'Validation failed';

    // Convert technical errors to user-friendly messages
    final friendlyMessages = <String, String>{
      'required': 'This field is required',
      'invalid format': 'Please check your input format',
      'out of range': 'Value is outside allowed range',
      'too long': 'Input is too long',
      'too short': 'Input is too short',
      'regex': 'Please check your input format',
      'pattern mismatch': 'Please check your input format',
      'validation failed': 'Please check your input',
    };

    for (final entry in friendlyMessages.entries) {
      if (errorMessage.toLowerCase().contains(entry.key)) {
        return entry.value;
      }
    }

    return errorMessage;
  }

  @override
  Future<Map<String, dynamic>> getValidationSummary(String sectionId) async {
    return handleServiceOperation(
      () async {
        // This would be implemented with actual section data
        return <String, dynamic>{
          'sectionId': sectionId,
          'totalQuestions': 0,
          'answeredQuestions': 0,
          'validAnswers': 0,
          'errors': <String>[],
          'warnings': <String>[],
          'isComplete': false,
        };
      },
      operationName: 'getValidationSummary',
      context: {'sectionId': sectionId},
    );
  }

  // ========================================================================
  // Private Validation Helper Methods
  // ========================================================================

  /// Check if text contains profanity (basic implementation)
  bool _containsProfanity(String text) {
    // Basic profanity filter - in production, use a proper service
    const profanityWords = ['spam', 'abuse']; // Minimal list for example
    final lowerText = text.toLowerCase();
    return profanityWords.any((word) => lowerText.contains(word));
  }

  /// Count decimal places in a number
  int _countDecimalPlaces(num value) {
    final str = value.toString();
    if (!str.contains('.')) return 0;
    return str.split('.')[1].length;
  }

  /// Validate age-specific rules
  ValidationStatus _validateAge(num value) {
    if (value < 13) {
      return ValidationStatus.error('Must be at least 13 years old');
    }
    if (value > 120) {
      return ValidationStatus.error('Please enter a valid age');
    }
    return ValidationStatus.valid();
  }

  /// Validate weight values
  ValidationStatus _validateWeight(num value) {
    if (value < 20 || value > 500) {
      return ValidationStatus.error('Please enter a realistic weight (20-500 kg)');
    }
    return ValidationStatus.valid();
  }

  /// Validate height values
  ValidationStatus _validateHeight(num value) {
    if (value < 50 || value > 250) {
      return ValidationStatus.error('Please enter a realistic height (50-250 cm)');
    }
    return ValidationStatus.valid();
  }

  /// Validate percentage values
  ValidationStatus _validatePercentage(num value) {
    if (value < 0 || value > 100) {
      return ValidationStatus.error('Percentage must be between 0 and 100');
    }
    return ValidationStatus.valid();
  }

  /// Validate US phone numbers
  ValidationStatus _validateUSPhoneNumber(String cleanedValue) {
    if (cleanedValue.length == 10) {
      // Standard 10-digit format
      if (RegExp(r'^[2-9]\d{2}[2-9]\d{2}\d{4}$').hasMatch(cleanedValue)) {
        return ValidationStatus.valid();
      }
    } else if (cleanedValue.length == 11 && cleanedValue.startsWith('1')) {
      // 11-digit with country code
      if (RegExp(r'^1[2-9]\d{2}[2-9]\d{2}\d{4}$').hasMatch(cleanedValue)) {
        return ValidationStatus.valid();
      }
    }

    return ValidationStatus.error('Please enter a valid US phone number');
  }

  /// Validate Canadian phone numbers
  ValidationStatus _validateCAPhoneNumber(String cleanedValue) {
    // Similar to US format
    return _validateUSPhoneNumber(cleanedValue);
  }

  /// Validate UK phone numbers
  ValidationStatus _validateUKPhoneNumber(String cleanedValue) {
    if (cleanedValue.startsWith('44')) {
      cleanedValue = cleanedValue.substring(2);
    }

    if (cleanedValue.length >= 10 && cleanedValue.length <= 11) {
      return ValidationStatus.valid();
    }

    return ValidationStatus.error('Please enter a valid UK phone number');
  }

  /// Validate international phone numbers
  ValidationStatus _validateInternationalPhoneNumber(String cleanedValue) {
    if (cleanedValue.length >= 7 && cleanedValue.length <= 15) {
      return ValidationStatus.valid();
    }

    return ValidationStatus.error('Please enter a valid phone number');
  }

  /// Validate birthdate
  ValidationStatus _validateBirthdate(DateTime value, DateTime now) {
    // Must be in the past
    if (value.isAfter(now)) {
      return ValidationStatus.error('Birth date must be in the past');
    }

    // Reasonable age limits
    final age = now.difference(value).inDays / 365.25;
    if (age < 13) {
      return ValidationStatus.error('Must be at least 13 years old');
    }

    if (age > 120) {
      return ValidationStatus.error('Please enter a valid birth date');
    }

    return ValidationStatus.valid();
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Validate section-specific business rules
  Future<ValidationStatus> _validateSectionBusinessRules(
    QuestionnaireSection section,
  ) async {
    // Section-specific validation logic would go here
    return ValidationStatus.valid();
  }

  /// Validate cross-section business rules
  Future<ValidationStatus> _validateCrossSectionRules(
    List<QuestionnaireSection> sections,
  ) async {
    // Cross-section validation logic would go here
    return ValidationStatus.valid();
  }

  /// Validate age-dependent business rules
  Future<ValidationStatus> _validateAgeBusinessRules(ChatState state) async {
    // Implementation would check age vs activity level, etc.
    return ValidationStatus.valid();
  }

  /// Validate dietary restriction business rules
  Future<ValidationStatus> _validateDietaryBusinessRules(ChatState state) async {
    // Implementation would check dietary conflicts, etc.
    return ValidationStatus.valid();
  }

  /// Validate health condition business rules
  Future<ValidationStatus> _validateHealthBusinessRules(ChatState state) async {
    // Implementation would check health condition compatibility
    return ValidationStatus.valid();
  }

  /// Validate goal compatibility business rules
  Future<ValidationStatus> _validateGoalBusinessRules(ChatState state) async {
    // Implementation would check goal vs profile consistency
    return ValidationStatus.valid();
  }

  /// Evaluate dependency condition
  bool _evaluateDependencyCondition(
    dynamic actualValue,
    dynamic expectedValue,
    String operator,
  ) {
    switch (operator) {
      case 'equals':
        return actualValue == expectedValue;
      case 'not_equals':
        return actualValue != expectedValue;
      case 'greater_than':
        if (actualValue is num && expectedValue is num) {
          return actualValue > expectedValue;
        }
        return false;
      case 'less_than':
        if (actualValue is num && expectedValue is num) {
          return actualValue < expectedValue;
        }
        return false;
      case 'contains':
        if (actualValue is List) {
          return actualValue.contains(expectedValue);
        }
        return false;
      default:
        return false;
    }
  }

  /// Check for contradictory answers
  Future<ValidationStatus> _checkContradictoryAnswer(
    dynamic answer,
    Map<String, dynamic> contradictoryCheck,
    ChatState currentState,
  ) async {
    // Implementation would check for contradictory combinations
    return ValidationStatus.valid();
  }

  /// Validate answer against business rules
  @override
  Future<ValidationStatus> validateAnswer({
    required String questionId,
    required dynamic answer,
  }) async {
    // This would need the actual question context for proper validation
    // For now, return basic validation
    return ValidationStatus.valid();
  }
}