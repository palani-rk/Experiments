import 'package:freezed_annotation/freezed_annotation.dart';
import 'response.dart';
import 'enums.dart';

part 'section_response.freezed.dart';
part 'section_response.g.dart';

/// Section-level response containing all responses for a section
@freezed
class SectionResponse with _$SectionResponse {
  const factory SectionResponse({
    required String sectionId,
    required List<Response> responses,
    required SectionStatus status,
    DateTime? completedAt,
    required DateTime savedAt,
  }) = _SectionResponse;

  factory SectionResponse.fromJson(Map<String, dynamic> json) =>
      _$SectionResponseFromJson(json);
}

/// Extension methods for SectionResponse - Pure data access only
extension SectionResponseExtension on SectionResponse {
  /// Gets the number of responses in this section
  int get responseCount => responses.length;

  /// Gets a response by question ID
  Response? getResponseByQuestionId(String questionId) {
    try {
      return responses.firstWhere((r) => r.questionId == questionId);
    } catch (e) {
      return null;
    }
  }

  /// Checks if this section has a response for the given question
  bool hasResponseForQuestion(String questionId) {
    return getResponseByQuestionId(questionId) != null;
  }

  /// Gets all responses with non-empty values
  List<Response> get validResponses {
    return responses.where((r) => r.hasValue).toList();
  }
}