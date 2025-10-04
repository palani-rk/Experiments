import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../interfaces/simple_persistence_service.dart';
import '../../../data/models/support/chat_state.dart';

/// Local implementation of SimplePersistenceService
///
/// Uses SharedPreferences for local storage of the questionnaire session.
/// Provides a clean, simple implementation following KISS principles.
class SimpleLocalPersistenceService implements SimplePersistenceService {
  static const String _sessionKey = 'questionnaire_session';

  @override
  Future<ChatState?> loadSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = prefs.getString(_sessionKey);

      if (sessionJson == null) {
        return null;
      }

      final sessionMap = jsonDecode(sessionJson) as Map<String, dynamic>;
      return ChatState.fromJson(sessionMap);
    } catch (e) {
      // Log error in production
      print('Error loading session: $e');
      return null;
    }
  }

  @override
  Future<void> saveSession(ChatState state) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = jsonEncode(state.toJson());
      await prefs.setString(_sessionKey, sessionJson);
    } catch (e) {
      // Log error in production
      print('Error saving session: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_sessionKey);
    } catch (e) {
      // Log error in production
      print('Error clearing session: $e');
      rethrow;
    }
  }
}