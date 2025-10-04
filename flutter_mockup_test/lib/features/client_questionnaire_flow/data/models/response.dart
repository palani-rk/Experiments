import 'package:freezed_annotation/freezed_annotation.dart';

part 'response.freezed.dart';
part 'response.g.dart';

/// Individual question response
@freezed
class Response with _$Response {
  const factory Response({
    required String questionId,
    required dynamic value,
    required DateTime timestamp,
  }) = _Response;

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);
}

/// Extension methods for Response - Pure data access only
extension ResponseExtension on Response {
  /// Gets the response value as a string
  String get valueAsString => value?.toString() ?? '';

  /// Gets the response value as a number (if valid)
  num? get valueAsNumber => num.tryParse(valueAsString);

  /// Gets the response value as a list (for multi-select)
  List<String> get valueAsList {
    if (value is List) {
      return (value as List).map((e) => e.toString()).toList();
    }
    return [valueAsString];
  }

  /// Checks if the response has a non-empty value
  bool get hasValue {
    if (value == null) return false;
    if (value is String) return (value as String).isNotEmpty;
    if (value is List) return (value as List).isNotEmpty;
    return true;
  }
}