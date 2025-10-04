import 'dart:convert';
import 'package:http/http.dart' as http;
import '../interfaces/simple_persistence_service.dart';
import '../../../data/models/support/chat_state.dart';

/// API implementation of SimplePersistenceService
///
/// Provides HTTP-based persistence for the questionnaire session.
/// Designed for seamless replacement of local storage implementation.
class SimpleApiPersistenceService implements SimplePersistenceService {
  final String baseUrl;
  final String userId;
  final Map<String, String> headers;

  SimpleApiPersistenceService({
    required this.baseUrl,
    required this.userId,
    this.headers = const {
      'Content-Type': 'application/json',
    },
  });

  @override
  Future<ChatState?> loadSession() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/questionnaire/session/$userId'),
        headers: headers,
      );

      if (response.statusCode == 404) {
        return null; // No session exists
      }

      if (response.statusCode != 200) {
        throw Exception('Failed to load session: ${response.statusCode}');
      }

      final sessionMap = jsonDecode(response.body) as Map<String, dynamic>;
      return ChatState.fromJson(sessionMap);
    } catch (e) {
      print('Error loading session from API: $e');
      return null;
    }
  }

  @override
  Future<void> saveSession(ChatState state) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/questionnaire/session/$userId'),
        headers: headers,
        body: jsonEncode(state.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to save session: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving session to API: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/questionnaire/session/$userId'),
        headers: headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to clear session: ${response.statusCode}');
      }
    } catch (e) {
      print('Error clearing session from API: $e');
      rethrow;
    }
  }
}