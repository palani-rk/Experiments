import '../../../data/models/support/chat_state.dart';

/// Chat Persistence Service Interface
///
/// Handles all persistent storage operations for chat state, sessions,
/// and backup/recovery functionality.
abstract class ChatPersistenceService {
  // ========================================================================
  // State Persistence
  // ========================================================================

  /// Save current chat state to persistent storage
  Future<void> saveChatState(ChatState state);

  /// Load chat state from persistent storage
  /// Returns null if no saved state exists
  Future<ChatState?> loadChatState();

  /// Clear all saved chat state
  Future<void> clearChatState();

  /// Check if saved state exists
  Future<bool> hasSavedState();

  // ========================================================================
  // Session Management
  // ========================================================================

  /// Create a new session with unique identifier
  Future<String> createSession();

  /// Save session data with identifier
  Future<void> saveSession({
    required String sessionId,
    required ChatState state,
  });

  /// Load specific session by ID
  Future<ChatState?> loadSession(String sessionId);

  /// Get list of all saved session IDs
  Future<List<String>> getSessions();

  /// Delete specific session
  Future<void> deleteSession(String sessionId);

  /// Get session metadata (creation time, completion status, etc.)
  Future<Map<String, dynamic>?> getSessionMetadata(String sessionId);

  // ========================================================================
  // Backup & Recovery
  // ========================================================================

  /// Create backup of current state
  Future<void> backupState(String backupId);

  /// Restore state from backup
  Future<ChatState?> restoreState(String backupId);

  /// Get list of available backups
  Future<List<String>> getBackups();

  /// Delete specific backup
  Future<void> deleteBackup(String backupId);

  /// Auto-backup current state (called periodically)
  Future<void> autoBackup();

  // ========================================================================
  // Storage Management
  // ========================================================================

  /// Get storage usage statistics
  Future<Map<String, int>> getStorageStats();

  /// Clean up old or expired data
  Future<void> cleanup();

  /// Clear all persistent data (factory reset)
  Future<void> clearAll();

  /// Check storage health and integrity
  Future<bool> validateStorageIntegrity();

  // ========================================================================
  // Configuration Management
  // ========================================================================

  /// Save user preferences and settings
  Future<void> saveUserPreferences(Map<String, dynamic> preferences);

  /// Load user preferences
  Future<Map<String, dynamic>?> loadUserPreferences();

  /// Save questionnaire configuration
  Future<void> saveQuestionnaireConfig(Map<String, dynamic> config);

  /// Load questionnaire configuration
  Future<Map<String, dynamic>?> loadQuestionnaireConfig();
}