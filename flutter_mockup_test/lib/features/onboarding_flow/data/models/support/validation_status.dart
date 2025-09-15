import 'package:freezed_annotation/freezed_annotation.dart';

part 'validation_status.freezed.dart';
part 'validation_status.g.dart';

/// Validation status for questions, answers, and sections
///
/// Represents the validation state with detailed error and warning information
/// for comprehensive feedback to users and business logic decisions.
@freezed
class ValidationStatus with _$ValidationStatus {
  const ValidationStatus._();

  const factory ValidationStatus({
    required bool isValid,
    @Default([]) List<String> errors,
    @Default([]) List<String> warnings,
    @Default([]) List<String> info,
    String? context,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) = _ValidationStatus;

  // Factory constructors for common validation states
  factory ValidationStatus.valid({
    List<String>? warnings,
    List<String>? info,
    String? context,
  }) {
    return ValidationStatus(
      isValid: true,
      warnings: warnings ?? [],
      info: info ?? [],
      context: context,
      timestamp: DateTime.now(),
    );
  }

  factory ValidationStatus.invalid({
    required List<String> errors,
    List<String>? warnings,
    List<String>? info,
    String? context,
  }) {
    return ValidationStatus(
      isValid: false,
      errors: errors,
      warnings: warnings ?? [],
      info: info ?? [],
      context: context,
      timestamp: DateTime.now(),
    );
  }

  factory ValidationStatus.error(
    String errorMessage, {
    String? context,
  }) {
    return ValidationStatus(
      isValid: false,
      errors: [errorMessage],
      context: context,
      timestamp: DateTime.now(),
    );
  }

  factory ValidationStatus.warning(
    String warningMessage, {
    String? context,
  }) {
    return ValidationStatus(
      isValid: true,
      warnings: [warningMessage],
      context: context,
      timestamp: DateTime.now(),
    );
  }

  // JSON serialization
  factory ValidationStatus.fromJson(Map<String, dynamic> json) =>
      _$ValidationStatusFromJson(json);


  // Business logic properties
  bool get hasErrors => errors.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasInfo => info.isNotEmpty;
  bool get hasAnyMessages => hasErrors || hasWarnings || hasInfo;

  /// Get the primary error message (first error if any)
  String? get primaryError => errors.isNotEmpty ? errors.first : null;

  /// Get the primary warning message (first warning if any)
  String? get primaryWarning => warnings.isNotEmpty ? warnings.first : null;

  /// Get all messages combined
  List<String> get allMessages => [...errors, ...warnings, ...info];

  /// Get summary message based on validation state
  String get summary {
    if (isValid && !hasWarnings && !hasInfo) return 'Valid';
    if (isValid && hasWarnings) return 'Valid with warnings';
    if (!isValid && hasErrors) return primaryError!;
    return 'Unknown validation state';
  }

  /// Get severity level (0 = info, 1 = warning, 2 = error)
  int get severity {
    if (hasErrors) return 2;
    if (hasWarnings) return 1;
    return 0;
  }

  /// Check if validation is recent (within last 5 minutes)
  bool get isRecent {
    if (timestamp == null) return false;
    return DateTime.now().difference(timestamp!).inMinutes < 5;
  }

  /// Combine this validation with another
  ValidationStatus combine(ValidationStatus other) {
    return ValidationStatus(
      isValid: isValid && other.isValid,
      errors: [...errors, ...other.errors],
      warnings: [...warnings, ...other.warnings],
      info: [...info, ...other.info],
      context: context ?? other.context,
      timestamp: DateTime.now(),
      metadata: {
        ...?metadata,
        ...?other.metadata,
      },
    );
  }

  /// Add an error to this validation
  ValidationStatus addError(String error) {
    return ValidationStatus(
      isValid: false,
      errors: [...errors, error],
      warnings: warnings,
      info: info,
      context: context,
      timestamp: DateTime.now(),
      metadata: metadata,
    );
  }

  /// Add a warning to this validation
  ValidationStatus addWarning(String warning) {
    return ValidationStatus(
      isValid: isValid,
      errors: errors,
      warnings: [...warnings, warning],
      info: info,
      context: context,
      timestamp: DateTime.now(),
      metadata: metadata,
    );
  }

  /// Add info to this validation
  ValidationStatus addInfo(String infoMessage) {
    return ValidationStatus(
      isValid: isValid,
      errors: errors,
      warnings: warnings,
      info: [...info, infoMessage],
      context: context,
      timestamp: DateTime.now(),
      metadata: metadata,
    );
  }

  /// Clear all messages but keep validity state
  ValidationStatus clearMessages() {
    return ValidationStatus(
      isValid: isValid,
      errors: [],
      warnings: [],
      info: [],
      context: context,
      timestamp: DateTime.now(),
      metadata: metadata,
    );
  }

  /// Convert to a more severe state (valid -> invalid)
  ValidationStatus toInvalid(String errorMessage) {
    return ValidationStatus(
      isValid: false,
      errors: [errorMessage, ...errors],
      warnings: warnings,
      info: info,
      context: context,
      timestamp: DateTime.now(),
      metadata: metadata,
    );
  }

  /// Convert to valid state (removes errors)
  ValidationStatus toValid() {
    return ValidationStatus(
      isValid: true,
      errors: [],
      warnings: warnings,
      info: info,
      context: context,
      timestamp: DateTime.now(),
      metadata: metadata,
    );
  }

  /// Get metadata value
  T? getMetadata<T>(String key) {
    try {
      return metadata?[key] as T?;
    } catch (e) {
      return null;
    }
  }

  /// Set metadata value
  ValidationStatus setMetadata(String key, dynamic value) {
    return ValidationStatus(
      isValid: isValid,
      errors: errors,
      warnings: warnings,
      info: info,
      context: context,
      timestamp: timestamp,
      metadata: {
        ...?metadata,
        key: value,
      },
    );
  }

  /// Get formatted message for display
  String getFormattedMessage({
    String errorPrefix = '❌ ',
    String warningPrefix = '⚠️ ',
    String infoPrefix = 'ℹ️ ',
    String separator = '\n',
  }) {
    final messages = <String>[];

    for (final error in errors) {
      messages.add('$errorPrefix$error');
    }
    for (final warning in warnings) {
      messages.add('$warningPrefix$warning');
    }
    for (final infoMessage in info) {
      messages.add('$infoPrefix$infoMessage');
    }

    return messages.join(separator);
  }

  @override
  String toString() {
    final status = isValid ? 'VALID' : 'INVALID';
    final messageCount = allMessages.length;
    final contextStr = context != null ? ' ($context)' : '';
    return '$status ($messageCount messages)$contextStr';
  }
}