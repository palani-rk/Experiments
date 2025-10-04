import '../../../data/models/support/chat_state.dart';

/// Simple Persistence Service for ChatState
///
/// This service provides a minimal interface for persisting and loading
/// the questionnaire session state, following KISS principles.
/// Designed for easy replacement with API-based implementations.
abstract class SimplePersistenceService {
  /// Load the current session state from persistent storage
  /// Returns null if no session exists
  Future<ChatState?> loadSession();

  /// Save the current session state to persistent storage
  /// Overwrites any existing session data
  Future<void> saveSession(ChatState state);

  /// Clear all session data from persistent storage
  Future<void> clearSession();
}