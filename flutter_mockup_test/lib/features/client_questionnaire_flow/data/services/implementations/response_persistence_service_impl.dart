import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../interfaces/response_persistence_service.dart';
import '../../models/section_response.dart';

/// Simple implementation of QuestionnaireState for persistence
class SimpleQuestionnaireState implements QuestionnaireState {
  @override
  final Map<String, SectionResponse> sectionResponses;

  @override
  final String? currentQuestionId;

  @override
  final int currentSectionIndex;

  @override
  final bool isCompleted;

  @override
  final bool isSubmitted;

  const SimpleQuestionnaireState({
    required this.sectionResponses,
    this.currentQuestionId,
    this.currentSectionIndex = 0,
    this.isCompleted = false,
    this.isSubmitted = false,
  });
}

/// Implementation of ResponsePersistenceService for testing mode
/// Handles local file storage for state persistence and response submission
class ResponsePersistenceServiceImpl implements ResponsePersistenceService {
  static const String _stateFileName = 'questionnaire_state.json';
  static const String _submissionsFileName = 'questionnaire_submissions.json';

  @override
  Future<void> saveState(QuestionnaireState state) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_stateFileName');

      final now = DateTime.now();

      // Calculate progress metadata
      final totalResponses = state.sectionResponses.values
          .expand((sr) => sr.responses)
          .length;

      // Convert state to JSON (excluding config to avoid circular references)
      final stateJson = {
        'sectionResponses': state.sectionResponses.map((key, value) => MapEntry(key, value.toJson())),
        'currentQuestionId': state.currentQuestionId,
        'currentSectionIndex': state.currentSectionIndex,
        'isCompleted': state.isCompleted,
        'isSubmitted': state.isSubmitted,
        'savedAt': now.toIso8601String(),
        'metadata': {
          'version': '1.0',
          'questionnaireId': 'nutrition_assessment_v1',
          'answeredQuestionsCount': totalResponses,
          'lastSavedTimestamp': now.millisecondsSinceEpoch,
        },
      };

      await file.writeAsString(json.encode(stateJson));
    } catch (e) {
      throw Exception('Failed to save state: $e');
    }
  }

  @override
  Future<QuestionnaireState?> loadSavedState() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_stateFileName');

      if (!await file.exists()) {
        return null;
      }

      final jsonString = await file.readAsString();
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;

      // Validate metadata if present
      final metadata = jsonData['metadata'] as Map<String, dynamic>?;
      if (metadata != null) {
        final savedQuestionnaireId = metadata['questionnaireId'] as String?;
        // Validate questionnaire ID matches (for future version compatibility)
        if (savedQuestionnaireId != null && savedQuestionnaireId != 'nutrition_assessment_v1') {
          // Different questionnaire version - clear and return null
          await clearSavedState();
          return null;
        }
      }

      // Parse section responses
      final sectionResponsesJson = jsonData['sectionResponses'] as Map<String, dynamic>? ?? {};
      final sectionResponses = <String, SectionResponse>{};

      for (final entry in sectionResponsesJson.entries) {
        sectionResponses[entry.key] = SectionResponse.fromJson(entry.value as Map<String, dynamic>);
      }

      return SimpleQuestionnaireState(
        sectionResponses: sectionResponses,
        currentQuestionId: jsonData['currentQuestionId'] as String?,
        currentSectionIndex: jsonData['currentSectionIndex'] as int? ?? 0,
        isCompleted: jsonData['isCompleted'] as bool? ?? false,
        isSubmitted: jsonData['isSubmitted'] as bool? ?? false,
      );
    } catch (e) {
      // Return null if loading fails - will trigger fresh questionnaire load
      return null;
    }
  }

  @override
  Future<void> clearSavedState() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_stateFileName');

      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Ignore errors when clearing state
    }
  }

  @override
  Future<void> submitResponses(Map<String, SectionResponse> responses) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_submissionsFileName');

      // Load existing submissions
      List<Map<String, dynamic>> submissions = [];
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonData = json.decode(jsonString) as List<dynamic>;
        submissions = jsonData.cast<Map<String, dynamic>>();
      }

      // Add new submission
      final newSubmission = {
        'submittedAt': DateTime.now().toIso8601String(),
        'responses': responses.map((key, value) => MapEntry(key, value.toJson())),
      };

      submissions.add(newSubmission);

      // Save updated submissions
      await file.writeAsString(json.encode(submissions));
    } catch (e) {
      throw Exception('Failed to submit responses: $e');
    }
  }

  @override
  Future<List<Map<String, SectionResponse>>> getSubmissionHistory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_submissionsFileName');

      if (!await file.exists()) {
        return [];
      }

      final jsonString = await file.readAsString();
      final jsonData = json.decode(jsonString) as List<dynamic>;

      final submissions = <Map<String, SectionResponse>>[];
      for (final submissionJson in jsonData) {
        final responsesJson = submissionJson['responses'] as Map<String, dynamic>;
        final responses = <String, SectionResponse>{};

        for (final entry in responsesJson.entries) {
          responses[entry.key] = SectionResponse.fromJson(entry.value as Map<String, dynamic>);
        }

        submissions.add(responses);
      }

      return submissions;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<String> exportResponsesToJson(Map<String, SectionResponse> responses) async {
    try {
      final exportData = {
        'exportedAt': DateTime.now().toIso8601String(),
        'responses': responses.map((key, value) => MapEntry(key, value.toJson())),
      };

      return json.encode(exportData);
    } catch (e) {
      throw Exception('Failed to export responses: $e');
    }
  }
}