/// Base exception class for all chat questionnaire service errors
abstract class ChatServiceException implements Exception {
  final String message;
  final String? code;
  final Object? cause;
  final StackTrace? stackTrace;

  const ChatServiceException(
    this.message, {
    this.code,
    this.cause,
    this.stackTrace,
  });

  @override
  String toString() {
    final buffer = StringBuffer('$runtimeType: $message');
    if (code != null) {
      buffer.write(' (Code: $code)');
    }
    if (cause != null) {
      buffer.write('\nCause: $cause');
    }
    return buffer.toString();
  }
}

/// Concrete implementation of ChatServiceException
class _ChatServiceExceptionImpl extends ChatServiceException {
  const _ChatServiceExceptionImpl(
    super.message, {
    super.code,
    super.cause,
    super.stackTrace,
  });
}

// ========================================================================
// Data & Storage Exceptions
// ========================================================================

/// Exception thrown when questionnaire data cannot be loaded
class QuestionnaireLoadException extends ChatServiceException {
  const QuestionnaireLoadException(
    super.message, {
    super.code = 'QUESTIONNAIRE_LOAD_FAILED',
    super.cause,
    super.stackTrace,
  });
}

/// Exception thrown when state cannot be saved
class StateSaveException extends ChatServiceException {
  const StateSaveException(
    super.message, {
    super.code = 'STATE_SAVE_FAILED',
    super.cause,
    super.stackTrace,
  });
}

/// Exception thrown when state cannot be loaded
class StateLoadException extends ChatServiceException {
  const StateLoadException(
    super.message, {
    super.code = 'STATE_LOAD_FAILED',
    super.cause,
    super.stackTrace,
  });
}

/// Exception thrown when storage operations fail
class StorageException extends ChatServiceException {
  const StorageException(
    super.message, {
    super.code = 'STORAGE_FAILED',
    super.cause,
    super.stackTrace,
  });
}

/// Exception thrown when JSON parsing fails
class JsonParsingException extends ChatServiceException {
  final String jsonString;

  const JsonParsingException(
    super.message,
    this.jsonString, {
    super.code = 'JSON_PARSING_FAILED',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() {
    return '${super.toString()}\nJSON: ${jsonString.length > 100 ? '${jsonString.substring(0, 100)}...' : jsonString}';
  }
}

// ========================================================================
// Validation Exceptions
// ========================================================================

/// Exception thrown when answer validation fails
class ValidationException extends ChatServiceException {
  final String questionId;
  final dynamic invalidAnswer;
  final List<String> validationErrors;

  const ValidationException(
    super.message,
    this.questionId,
    this.invalidAnswer, {
    this.validationErrors = const [],
    super.code = 'VALIDATION_FAILED',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() {
    final buffer = StringBuffer(super.toString());
    buffer.write('\nQuestion ID: $questionId');
    buffer.write('\nInvalid Answer: $invalidAnswer');
    if (validationErrors.isNotEmpty) {
      buffer.write('\nValidation Errors:');
      for (final error in validationErrors) {
        buffer.write('\n  - $error');
      }
    }
    return buffer.toString();
  }
}

/// Exception thrown when business rules are violated
class BusinessRuleException extends ChatServiceException {
  final String ruleId;
  final Map<String, dynamic> ruleData;

  const BusinessRuleException(
    super.message,
    this.ruleId, {
    this.ruleData = const {},
    super.code = 'BUSINESS_RULE_VIOLATION',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() {
    final buffer = StringBuffer(super.toString());
    buffer.write('\nRule ID: $ruleId');
    if (ruleData.isNotEmpty) {
      buffer.write('\nRule Data: $ruleData');
    }
    return buffer.toString();
  }
}

/// Exception thrown when required questions are not answered
class IncompleteSectionException extends ChatServiceException {
  final String sectionId;
  final List<String> missingQuestionIds;

  const IncompleteSectionException(
    super.message,
    this.sectionId,
    this.missingQuestionIds, {
    super.code = 'INCOMPLETE_SECTION',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() {
    final buffer = StringBuffer(super.toString());
    buffer.write('\nSection ID: $sectionId');
    buffer.write('\nMissing Questions: ${missingQuestionIds.join(', ')}');
    return buffer.toString();
  }
}

// ========================================================================
// Navigation & State Exceptions
// ========================================================================

/// Exception thrown when navigation is invalid
class InvalidNavigationException extends ChatServiceException {
  final String fromState;
  final String toState;
  final String reason;

  const InvalidNavigationException(
    super.message,
    this.fromState,
    this.toState,
    this.reason, {
    super.code = 'INVALID_NAVIGATION',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() {
    return '${super.toString()}\nFrom: $fromState → To: $toState\nReason: $reason';
  }
}

/// Exception thrown when questionnaire state is invalid
class InvalidStateException extends ChatServiceException {
  final String currentState;
  final String expectedState;

  const InvalidStateException(
    super.message,
    this.currentState,
    this.expectedState, {
    super.code = 'INVALID_STATE',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() {
    return '${super.toString()}\nCurrent: $currentState\nExpected: $expectedState';
  }
}

/// Exception thrown when session operations fail
class SessionException extends ChatServiceException {
  final String sessionId;

  const SessionException(
    super.message,
    this.sessionId, {
    super.code = 'SESSION_FAILED',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() {
    return '${super.toString()}\nSession ID: $sessionId';
  }
}

// ========================================================================
// Resource & Configuration Exceptions
// ========================================================================

/// Exception thrown when required resources are not found
class ResourceNotFoundException extends ChatServiceException {
  final String resourcePath;
  final String resourceType;

  const ResourceNotFoundException(
    super.message,
    this.resourcePath,
    this.resourceType, {
    super.code = 'RESOURCE_NOT_FOUND',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() {
    return '${super.toString()}\nResource: $resourcePath (Type: $resourceType)';
  }
}

/// Exception thrown when configuration is invalid
class ConfigurationException extends ChatServiceException {
  final String configKey;
  final dynamic invalidValue;

  const ConfigurationException(
    super.message,
    this.configKey,
    this.invalidValue, {
    super.code = 'INVALID_CONFIGURATION',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() {
    return '${super.toString()}\nConfig Key: $configKey\nInvalid Value: $invalidValue';
  }
}

// ========================================================================
// Service Operation Exceptions
// ========================================================================

/// Exception thrown when answer cannot be saved
class AnswerSaveException extends ChatServiceException {
  final String questionId;
  final dynamic answer;

  const AnswerSaveException(
    super.message,
    this.questionId,
    this.answer, {
    super.code = 'ANSWER_SAVE_FAILED',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() {
    return '${super.toString()}\nQuestion ID: $questionId\nAnswer: $answer';
  }
}

/// Exception thrown when message operations fail
class MessageException extends ChatServiceException {
  final String sectionId;
  final String? messageId;

  const MessageException(
    super.message,
    this.sectionId, {
    this.messageId,
    super.code = 'MESSAGE_OPERATION_FAILED',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() {
    final buffer = StringBuffer(super.toString());
    buffer.write('\nSection ID: $sectionId');
    if (messageId != null) {
      buffer.write('\nMessage ID: $messageId');
    }
    return buffer.toString();
  }
}

/// Exception thrown when section operations fail
class SectionException extends ChatServiceException {
  final String sectionId;

  const SectionException(
    super.message,
    this.sectionId, {
    super.code = 'SECTION_OPERATION_FAILED',
    super.cause,
    super.stackTrace,
  });

  @override
  String toString() {
    return '${super.toString()}\nSection ID: $sectionId';
  }
}

// ========================================================================
// Utility Functions
// ========================================================================

/// Helper function to wrap operations with exception handling
Future<T> handleServiceOperation<T>(
  Future<T> Function() operation, {
  required String operationName,
  Map<String, dynamic>? context,
}) async {
  try {
    return await operation();
  } catch (e, stackTrace) {
    // Log the error (implementation would use proper logging)
    print('Service operation failed: $operationName');
    print('Context: $context');
    print('Error: $e');
    print('StackTrace: $stackTrace');

    // Re-throw as appropriate service exception
    if (e is ChatServiceException) {
      rethrow;
    } else {
      throw _ChatServiceExceptionImpl(
        'Unexpected error in $operationName: $e',
        code: 'UNEXPECTED_ERROR',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }
}

/// Helper function to validate operation preconditions
void validatePrecondition(
  bool condition,
  String message, {
  String? code,
  Object? cause,
}) {
  if (!condition) {
    throw _ChatServiceExceptionImpl(
      message,
      code: code ?? 'PRECONDITION_FAILED',
      cause: cause,
    );
  }
}