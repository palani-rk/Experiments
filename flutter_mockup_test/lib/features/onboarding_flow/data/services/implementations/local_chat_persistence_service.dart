import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/core/enums.dart';
import '../../../data/models/support/chat_state.dart';
import '../exceptions/chat_exceptions.dart';
import '../interfaces/chat_persistence_service.dart';

/// Local implementation of ChatPersistenceService using SharedPreferences
///
/// Handles all persistent storage operations for chat state, sessions,
/// and backup/recovery using SharedPreferences for local device storage.
class LocalChatPersistenceService implements ChatPersistenceService {
  // Storage keys
  static const String _currentStateKey = 'chat_current_state';
  static const String _sessionPrefix = 'chat_session_';
  static const String _backupPrefix = 'chat_backup_';
  static const String _preferencesKey = 'chat_user_preferences';
  static const String _configKey = 'chat_questionnaire_config';
  static const String _sessionMetadataPrefix = 'chat_session_meta_';

  // Storage limits
  static const int _maxSessions = 10;
  static const int _maxBackups = 5;
  static const Duration _autoBackupInterval = Duration(hours: 1);

  // ========================================================================
  // State Persistence
  // ========================================================================

  @override
  Future<void> saveChatState(ChatState state) async {
    return handleServiceOperation(
      () async {
        final prefs = await SharedPreferences.getInstance();
        final stateJson = json.encode(state.toJson());

        final success = await prefs.setString(_currentStateKey, stateJson);
        if (!success) {
          throw StateSaveException(
            'Failed to save chat state to SharedPreferences',
          );
        }

        // Update last save timestamp for monitoring
        await prefs.setInt(
          '${_currentStateKey}_timestamp',
          DateTime.now().millisecondsSinceEpoch,
        );
      },
      operationName: 'saveChatState',
      context: {'sessionId': state.sessionId, 'status': state.status.toString()},
    );
  }

  @override
  Future<ChatState?> loadChatState() async {
    return handleServiceOperation(
      () async {
        final prefs = await SharedPreferences.getInstance();
        final stateJson = prefs.getString(_currentStateKey);

        if (stateJson == null) {
          return null;
        }

        try {
          final stateData = json.decode(stateJson) as Map<String, dynamic>;
          return ChatState.fromJson(stateData);
        } catch (e) {
          throw JsonParsingException(
            'Failed to parse chat state JSON',
            stateJson,
            cause: e,
          );
        }
      },
      operationName: 'loadChatState',
    );
  }

  @override
  Future<void> clearChatState() async {
    return handleServiceOperation(
      () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_currentStateKey);
        await prefs.remove('${_currentStateKey}_timestamp');
      },
      operationName: 'clearChatState',
    );
  }

  @override
  Future<bool> hasSavedState() async {
    return handleServiceOperation(
      () async {
        final prefs = await SharedPreferences.getInstance();
        return prefs.containsKey(_currentStateKey);
      },
      operationName: 'hasSavedState',
    );
  }

  // ========================================================================
  // Session Management
  // ========================================================================

  @override
  Future<String> createSession() async {
    return handleServiceOperation(
      () async {
        final sessionId = _generateSessionId();

        // Create session metadata
        final metadata = {
          'id': sessionId,
          'createdAt': DateTime.now().toIso8601String(),
          'status': 'created',
          'version': '2.0',
        };

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          '$_sessionMetadataPrefix$sessionId',
          json.encode(metadata),
        );

        return sessionId;
      },
      operationName: 'createSession',
    );
  }

  @override
  Future<void> saveSession({
    required String sessionId,
    required ChatState state,
  }) async {
    return handleServiceOperation(
      () async {
        // Validate session limit
        await _enforceSessionLimit();

        final prefs = await SharedPreferences.getInstance();
        final sessionKey = '$_sessionPrefix$sessionId';
        final stateJson = json.encode(state.toJson());

        final success = await prefs.setString(sessionKey, stateJson);
        if (!success) {
          throw SessionException(
            'Failed to save session to SharedPreferences',
            sessionId,
          );
        }

        // Update session metadata
        final metadata = {
          'id': sessionId,
          'lastSaved': DateTime.now().toIso8601String(),
          'status': state.status.toString(),
          'sectionsCount': state.sections.length,
          'currentSectionId': state.currentSectionId,
          'progress': await _calculateSessionProgress(state),
        };

        await prefs.setString(
          '$_sessionMetadataPrefix$sessionId',
          json.encode(metadata),
        );
      },
      operationName: 'saveSession',
      context: {'sessionId': sessionId},
    );
  }

  @override
  Future<ChatState?> loadSession(String sessionId) async {
    return handleServiceOperation(
      () async {
        final prefs = await SharedPreferences.getInstance();
        final sessionKey = '$_sessionPrefix$sessionId';
        final stateJson = prefs.getString(sessionKey);

        if (stateJson == null) {
          return null;
        }

        try {
          final stateData = json.decode(stateJson) as Map<String, dynamic>;
          return ChatState.fromJson(stateData);
        } catch (e) {
          throw JsonParsingException(
            'Failed to parse session state JSON',
            stateJson,
            cause: e,
          );
        }
      },
      operationName: 'loadSession',
      context: {'sessionId': sessionId},
    );
  }

  @override
  Future<List<String>> getSessions() async {
    return handleServiceOperation(
      () async {
        final prefs = await SharedPreferences.getInstance();
        final keys = prefs.getKeys();

        final sessionIds = keys
            .where((key) => key.startsWith(_sessionPrefix))
            .map((key) => key.substring(_sessionPrefix.length))
            .toList();

        // Sort by creation time (most recent first)
        sessionIds.sort((a, b) {
          final metadataA = _getSessionMetadataSync(prefs, a);
          final metadataB = _getSessionMetadataSync(prefs, b);

          final timeA = metadataA?['createdAt'] as String?;
          final timeB = metadataB?['createdAt'] as String?;

          if (timeA == null || timeB == null) return 0;

          return DateTime.parse(timeB).compareTo(DateTime.parse(timeA));
        });

        return sessionIds;
      },
      operationName: 'getSessions',
    );
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    return handleServiceOperation(
      () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('$_sessionPrefix$sessionId');
        await prefs.remove('$_sessionMetadataPrefix$sessionId');
      },
      operationName: 'deleteSession',
      context: {'sessionId': sessionId},
    );
  }

  @override
  Future<Map<String, dynamic>?> getSessionMetadata(String sessionId) async {
    return handleServiceOperation(
      () async {
        final prefs = await SharedPreferences.getInstance();
        final metadataJson = prefs.getString('$_sessionMetadataPrefix$sessionId');

        if (metadataJson == null) {
          return null;
        }

        try {
          return json.decode(metadataJson) as Map<String, dynamic>;
        } catch (e) {
          throw JsonParsingException(
            'Failed to parse session metadata JSON',
            metadataJson,
            cause: e,
          );
        }
      },
      operationName: 'getSessionMetadata',
      context: {'sessionId': sessionId},
    );
  }

  // ========================================================================
  // Backup & Recovery
  // ========================================================================

  @override
  Future<void> backupState(String backupId) async {
    return handleServiceOperation(
      () async {
        final currentState = await loadChatState();
        if (currentState == null) {
          throw StateLoadException('No current state to backup');
        }

        // Enforce backup limit
        await _enforceBackupLimit();

        final prefs = await SharedPreferences.getInstance();
        final backupKey = '$_backupPrefix$backupId';
        final stateJson = json.encode(currentState.toJson());

        final success = await prefs.setString(backupKey, stateJson);
        if (!success) {
          throw StorageException('Failed to create backup');
        }

        // Store backup metadata
        final metadata = {
          'id': backupId,
          'createdAt': DateTime.now().toIso8601String(),
          'sessionId': currentState.sessionId,
          'status': currentState.status.toString(),
          'size': stateJson.length,
        };

        await prefs.setString(
          '${backupKey}_meta',
          json.encode(metadata),
        );
      },
      operationName: 'backupState',
      context: {'backupId': backupId},
    );
  }

  @override
  Future<ChatState?> restoreState(String backupId) async {
    return handleServiceOperation(
      () async {
        final prefs = await SharedPreferences.getInstance();
        final backupKey = '$_backupPrefix$backupId';
        final stateJson = prefs.getString(backupKey);

        if (stateJson == null) {
          return null;
        }

        try {
          final stateData = json.decode(stateJson) as Map<String, dynamic>;
          return ChatState.fromJson(stateData);
        } catch (e) {
          throw JsonParsingException(
            'Failed to parse backup state JSON',
            stateJson,
            cause: e,
          );
        }
      },
      operationName: 'restoreState',
      context: {'backupId': backupId},
    );
  }

  @override
  Future<List<String>> getBackups() async {
    return handleServiceOperation(
      () async {
        final prefs = await SharedPreferences.getInstance();
        final keys = prefs.getKeys();

        final backupIds = keys
            .where((key) => key.startsWith(_backupPrefix) && !key.endsWith('_meta'))
            .map((key) => key.substring(_backupPrefix.length))
            .toList();

        // Sort by creation time (most recent first)
        backupIds.sort((a, b) {
          final metadataA = _getBackupMetadataSync(prefs, a);
          final metadataB = _getBackupMetadataSync(prefs, b);

          final timeA = metadataA?['createdAt'] as String?;
          final timeB = metadataB?['createdAt'] as String?;

          if (timeA == null || timeB == null) return 0;

          return DateTime.parse(timeB).compareTo(DateTime.parse(timeA));
        });

        return backupIds;
      },
      operationName: 'getBackups',
    );
  }

  @override
  Future<void> deleteBackup(String backupId) async {
    return handleServiceOperation(
      () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('$_backupPrefix$backupId');
        await prefs.remove('${_backupPrefix}${backupId}_meta');
      },
      operationName: 'deleteBackup',
      context: {'backupId': backupId},
    );
  }

  @override
  Future<void> autoBackup() async {
    return handleServiceOperation(
      () async {
        final prefs = await SharedPreferences.getInstance();
        final lastBackupTime = prefs.getInt('last_auto_backup') ?? 0;
        final now = DateTime.now().millisecondsSinceEpoch;

        // Check if enough time has passed since last auto-backup
        if (now - lastBackupTime < _autoBackupInterval.inMilliseconds) {
          return; // Too soon for auto-backup
        }

        // Create auto-backup
        final backupId = 'auto_${DateTime.now().millisecondsSinceEpoch}';
        await backupState(backupId);

        // Update last backup timestamp
        await prefs.setInt('last_auto_backup', now);

        // Clean up old auto-backups (keep only 3 most recent)
        await _cleanupAutoBackups();
      },
      operationName: 'autoBackup',
    );
  }

  // ========================================================================
  // Storage Management
  // ========================================================================

  @override
  Future<Map<String, int>> getStorageStats() async {
    return handleServiceOperation(
      () async {
        final prefs = await SharedPreferences.getInstance();
        final keys = prefs.getKeys();

        int stateSize = 0;
        int sessionsCount = 0;
        int sessionsTotalSize = 0;
        int backupsCount = 0;
        int backupsTotalSize = 0;

        for (final key in keys) {
          final value = prefs.getString(key);
          if (value == null) continue;

          if (key == _currentStateKey) {
            stateSize = value.length;
          } else if (key.startsWith(_sessionPrefix)) {
            sessionsCount++;
            sessionsTotalSize += value.length;
          } else if (key.startsWith(_backupPrefix) && !key.endsWith('_meta')) {
            backupsCount++;
            backupsTotalSize += value.length;
          }
        }

        return {
          'currentStateSize': stateSize,
          'sessionsCount': sessionsCount,
          'sessionsTotalSize': sessionsTotalSize,
          'backupsCount': backupsCount,
          'backupsTotalSize': backupsTotalSize,
          'totalSize': stateSize + sessionsTotalSize + backupsTotalSize,
        };
      },
      operationName: 'getStorageStats',
    );
  }

  @override
  Future<void> cleanup() async {
    return handleServiceOperation(
      () async {
        // Clean up expired sessions and backups
        await _cleanupExpiredData();

        // Enforce limits
        await _enforceSessionLimit();
        await _enforceBackupLimit();

        // Clean up orphaned metadata
        await _cleanupOrphanedMetadata();
      },
      operationName: 'cleanup',
    );
  }

  @override
  Future<void> clearAll() async {
    return handleServiceOperation(
      () async {
        final prefs = await SharedPreferences.getInstance();
        final keys = prefs.getKeys().toList();

        // Remove all chat-related keys
        for (final key in keys) {
          if (key.startsWith('chat_')) {
            await prefs.remove(key);
          }
        }
      },
      operationName: 'clearAll',
    );
  }

  @override
  Future<bool> validateStorageIntegrity() async {
    return handleServiceOperation(
      () async {
        try {
          final prefs = await SharedPreferences.getInstance();
          final keys = prefs.getKeys();

          // Validate current state if exists
          if (keys.contains(_currentStateKey)) {
            final state = await loadChatState();
            if (state == null) return false;

            // Basic validation
            if (state.sessionId.isEmpty || state.sections.isEmpty) {
              return false;
            }
          }

          // Validate sessions
          final sessionKeys = keys.where((key) => key.startsWith(_sessionPrefix));
          for (final sessionKey in sessionKeys) {
            final sessionId = sessionKey.substring(_sessionPrefix.length);
            final session = await loadSession(sessionId);
            if (session == null) return false;
          }

          return true;
        } catch (e) {
          return false;
        }
      },
      operationName: 'validateStorageIntegrity',
    );
  }

  // ========================================================================
  // Configuration Management
  // ========================================================================

  @override
  Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    return handleServiceOperation(
      () async {
        final prefs = await SharedPreferences.getInstance();
        final preferencesJson = json.encode(preferences);

        final success = await prefs.setString(_preferencesKey, preferencesJson);
        if (!success) {
          throw StorageException('Failed to save user preferences');
        }
      },
      operationName: 'saveUserPreferences',
      context: {'preferencesCount': preferences.length},
    );
  }

  @override
  Future<Map<String, dynamic>?> loadUserPreferences() async {
    return handleServiceOperation(
      () async {
        final prefs = await SharedPreferences.getInstance();
        final preferencesJson = prefs.getString(_preferencesKey);

        if (preferencesJson == null) {
          return null;
        }

        try {
          return json.decode(preferencesJson) as Map<String, dynamic>;
        } catch (e) {
          throw JsonParsingException(
            'Failed to parse user preferences JSON',
            preferencesJson,
            cause: e,
          );
        }
      },
      operationName: 'loadUserPreferences',
    );
  }

  @override
  Future<void> saveQuestionnaireConfig(Map<String, dynamic> config) async {
    return handleServiceOperation(
      () async {
        final prefs = await SharedPreferences.getInstance();
        final configJson = json.encode(config);

        final success = await prefs.setString(_configKey, configJson);
        if (!success) {
          throw StorageException('Failed to save questionnaire configuration');
        }
      },
      operationName: 'saveQuestionnaireConfig',
      context: {'configKeys': config.keys.length},
    );
  }

  @override
  Future<Map<String, dynamic>?> loadQuestionnaireConfig() async {
    return handleServiceOperation(
      () async {
        final prefs = await SharedPreferences.getInstance();
        final configJson = prefs.getString(_configKey);

        if (configJson == null) {
          return null;
        }

        try {
          return json.decode(configJson) as Map<String, dynamic>;
        } catch (e) {
          throw JsonParsingException(
            'Failed to parse questionnaire config JSON',
            configJson,
            cause: e,
          );
        }
      },
      operationName: 'loadQuestionnaireConfig',
    );
  }

  // ========================================================================
  // Private Helper Methods
  // ========================================================================

  /// Generate unique session ID
  String _generateSessionId() {
    return 'session_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }

  /// Calculate session progress for metadata
  Future<double> _calculateSessionProgress(ChatState state) async {
    final questionnaireSections = state.sections.where(
      (section) => section.sectionType == SectionType.questionnaire,
    );

    if (questionnaireSections.isEmpty) return 0.0;

    final completedSections = questionnaireSections.where(
      (section) => section.status == SectionStatus.completed,
    ).length;

    return completedSections / questionnaireSections.length;
  }

  /// Get session metadata synchronously for sorting
  Map<String, dynamic>? _getSessionMetadataSync(
    SharedPreferences prefs,
    String sessionId,
  ) {
    final metadataJson = prefs.getString('$_sessionMetadataPrefix$sessionId');
    if (metadataJson == null) return null;

    try {
      return json.decode(metadataJson) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Get backup metadata synchronously for sorting
  Map<String, dynamic>? _getBackupMetadataSync(
    SharedPreferences prefs,
    String backupId,
  ) {
    final metadataJson = prefs.getString('${_backupPrefix}${backupId}_meta');
    if (metadataJson == null) return null;

    try {
      return json.decode(metadataJson) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Enforce maximum session limit
  Future<void> _enforceSessionLimit() async {
    final sessions = await getSessions();
    if (sessions.length <= _maxSessions) return;

    // Remove oldest sessions
    final sessionsToRemove = sessions.skip(_maxSessions);
    for (final sessionId in sessionsToRemove) {
      await deleteSession(sessionId);
    }
  }

  /// Enforce maximum backup limit
  Future<void> _enforceBackupLimit() async {
    final backups = await getBackups();
    if (backups.length <= _maxBackups) return;

    // Remove oldest backups
    final backupsToRemove = backups.skip(_maxBackups);
    for (final backupId in backupsToRemove) {
      await deleteBackup(backupId);
    }
  }

  /// Clean up old auto-backups
  Future<void> _cleanupAutoBackups() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    final autoBackupKeys = keys
        .where((key) =>
            key.startsWith(_backupPrefix) &&
            key.contains('auto_') &&
            !key.endsWith('_meta'))
        .toList();

    // Sort by creation time and keep only 3 most recent
    autoBackupKeys.sort((a, b) {
      final timeA = RegExp(r'auto_(\d+)').firstMatch(a)?.group(1) ?? '0';
      final timeB = RegExp(r'auto_(\d+)').firstMatch(b)?.group(1) ?? '0';
      return int.parse(timeB).compareTo(int.parse(timeA));
    });

    // Remove old auto-backups
    for (final key in autoBackupKeys.skip(3)) {
      final backupId = key.substring(_backupPrefix.length);
      await deleteBackup(backupId);
    }
  }

  /// Clean up expired data based on age
  Future<void> _cleanupExpiredData() async {
    const maxAge = Duration(days: 30);
    final cutoffTime = DateTime.now().subtract(maxAge);

    // Clean up old sessions
    final sessions = await getSessions();
    for (final sessionId in sessions) {
      final metadata = await getSessionMetadata(sessionId);
      if (metadata != null) {
        final createdAt = metadata['createdAt'] as String?;
        if (createdAt != null) {
          final createTime = DateTime.parse(createdAt);
          if (createTime.isBefore(cutoffTime)) {
            await deleteSession(sessionId);
          }
        }
      }
    }

    // Clean up old backups (except manual ones)
    final backups = await getBackups();
    for (final backupId in backups) {
      if (backupId.startsWith('auto_')) {
        final timestamp = int.tryParse(
          RegExp(r'auto_(\d+)').firstMatch(backupId)?.group(1) ?? '0',
        );
        if (timestamp != null) {
          final backupTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
          if (backupTime.isBefore(cutoffTime)) {
            await deleteBackup(backupId);
          }
        }
      }
    }
  }

  /// Clean up orphaned metadata entries
  Future<void> _cleanupOrphanedMetadata() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().toList();

    // Clean up session metadata without corresponding sessions
    final metadataKeys = keys.where((key) => key.startsWith(_sessionMetadataPrefix));
    for (final metaKey in metadataKeys) {
      final sessionId = metaKey.substring(_sessionMetadataPrefix.length);
      final sessionKey = '$_sessionPrefix$sessionId';
      if (!keys.contains(sessionKey)) {
        await prefs.remove(metaKey);
      }
    }

    // Clean up backup metadata without corresponding backups
    final backupMetaKeys = keys.where((key) =>
        key.startsWith(_backupPrefix) && key.endsWith('_meta'));
    for (final metaKey in backupMetaKeys) {
      final backupKey = metaKey.substring(0, metaKey.length - 5); // Remove '_meta'
      if (!keys.contains(backupKey)) {
        await prefs.remove(metaKey);
      }
    }
  }
}