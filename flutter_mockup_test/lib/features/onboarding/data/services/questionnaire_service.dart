import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/questionnaire_schema.dart';
import '../models/questionnaire_response.dart';

abstract class QuestionnaireService {
  Future<QuestionnaireSchema> loadQuestionnaire();
  Future<void> saveResponse(QuestionnaireResponse response);
  Future<QuestionnaireResponse?> loadSavedResponse(String questionnaireId);
}

// Current implementation: Local JSON + SharedPreferences
class LocalQuestionnaireService implements QuestionnaireService {
  final String assetPath;
  
  const LocalQuestionnaireService({
    this.assetPath = 'assets/questionnaire.json',
  });

  @override
  Future<QuestionnaireSchema> loadQuestionnaire() async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return QuestionnaireSchema.fromJson(json);
    } catch (e) {
      throw QuestionnaireLoadException('Failed to load questionnaire: $e');
    }
  }

  @override
  Future<void> saveResponse(QuestionnaireResponse response) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final responseJson = jsonEncode(response.toJson());
      await prefs.setString('questionnaire_response_${response.questionnaireId}', responseJson);
    } catch (e) {
      throw ResponseSaveException('Failed to save response: $e');
    }
  }

  @override
  Future<QuestionnaireResponse?> loadSavedResponse(String questionnaireId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final responseJson = prefs.getString('questionnaire_response_$questionnaireId');
      if (responseJson != null) {
        final json = jsonDecode(responseJson) as Map<String, dynamic>;
        return QuestionnaireResponse.fromJson(json);
      }
      return null;
    } catch (e) {
      // Return null if can't load - don't throw error for optional functionality
      return null;
    }
  }
}

// Future implementation: API calls
class ApiQuestionnaireService implements QuestionnaireService {
  final String baseUrl;
  // Add your HTTP client here (dio, http, etc.)
  
  const ApiQuestionnaireService({required this.baseUrl});

  @override
  Future<QuestionnaireSchema> loadQuestionnaire() async {
    // TODO: Replace with actual API call
    // final response = await dio.get('$baseUrl/questionnaire');
    // return QuestionnaireSchema.fromJson(response.data);
    throw UnimplementedError('API service not yet implemented');
  }

  @override
  Future<void> saveResponse(QuestionnaireResponse response) async {
    // TODO: Replace with actual API call
    // await dio.post('$baseUrl/responses', data: response.toJson());
    throw UnimplementedError('API service not yet implemented');
  }

  @override
  Future<QuestionnaireResponse?> loadSavedResponse(String questionnaireId) async {
    // TODO: Replace with actual API call
    // final response = await dio.get('$baseUrl/responses/$questionnaireId');
    // return QuestionnaireResponse.fromJson(response.data);
    throw UnimplementedError('API service not yet implemented');
  }
}

// Custom exceptions
class QuestionnaireLoadException implements Exception {
  final String message;
  QuestionnaireLoadException(this.message);
  
  @override
  String toString() => 'QuestionnaireLoadException: $message';
}

class ResponseSaveException implements Exception {
  final String message;
  ResponseSaveException(this.message);
  
  @override
  String toString() => 'ResponseSaveException: $message';
}