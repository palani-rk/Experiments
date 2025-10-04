# Simple Service Design Specification v4.0
## KISS Principle Applied - Session-Based Architecture

### Document Overview
**Version**: 4.0
**Date**: September 2025
**Purpose**: Simplified session-based architecture using KISS principles
**Philosophy**: Build only what's needed, enhance incrementally

---

## 🎯 KISS Architecture Principles

### **Core Concept**
```
QuestionnaireSession {
  - List<Section> sections (with messages)
  - String currentSectionId
  - String? currentQuestionId
  - Simple completion flags
}

Section {
  - List<SectionMessage> messages
  - isComplete flag
}

SectionMessage {
  - isComplete flag (for QuestionAnswer)
  - answer data
}
```

### **Simple Operations**
1. **Load Session**: Get complete session with all sections + messages + position
2. **Update Answer**: Set answer on message, mark message complete, update position
3. **Save Session**: Persist entire session structure
4. **Clear Session**: Reset questionnaire

### **API Transition Benefits**
- **Local**: Save entire session to SharedPreferences (JSON)
- **API**: Send entire session to `PUT /api/questionnaire/session`
- **Same Structure**: Identical data model, different transport layer

---

## 📊 Existing Models Analysis

### **✅ What's Already Perfect**
Our current models are **90% ready** for the simplified approach:

1. **`ChatState`** - Already session-like with position tracking
2. **`ChatSection`** - Perfect sealed class (IntroSection/QuestionnaireSection)
3. **`SectionMessage`** - Great union types (BotMessage/QuestionAnswer)
4. **`ValidationStatus`** - Comprehensive validation system
5. **Rich Business Logic** - Progress calculation, completion detection

### **🎯 Minimal Gaps Identified**
Only **3 small additions** needed:
1. ✅ `isComplete` flag on `QuestionAnswer` messages
2. ✅ `ProgressDetails` helper class
3. ✅ Simple `PersistenceService` interface

---

## 🆕 Required Model Updates

### **1. Add Completion Flag to QuestionAnswer**

#### **Current Model** (section_message.dart)
```dart
const factory SectionMessage.questionAnswer({
  required String id,
  required String sectionId,
  required String questionId,
  required String questionText,
  required QuestionType inputType,
  required dynamic answer,
  required DateTime timestamp,
  @Default(MessageType.userAnswer) MessageType messageType,
  @Default(true) bool isEditable,
  String? formattedAnswer,
  ValidationStatus? validation,
  Map<String, dynamic>? questionMetadata,
}) = QuestionAnswer;
```

#### **Enhanced Model** (ADD ONE FIELD)
```dart
const factory SectionMessage.questionAnswer({
  required String id,
  required String sectionId,
  required String questionId,
  required String questionText,
  required QuestionType inputType,
  required dynamic answer,
  required DateTime timestamp,
  @Default(MessageType.userAnswer) MessageType messageType,
  @Default(true) bool isEditable,
  @Default(false) bool isComplete,  // 🆕 ADD THIS FIELD
  String? formattedAnswer,
  ValidationStatus? validation,
  Map<String, dynamic>? questionMetadata,
}) = QuestionAnswer;
```

### **2. Add Progress Details Helper Class**

#### **New Model** (support/progress_details.dart)
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'progress_details.freezed.dart';
part 'progress_details.g.dart';

@freezed
class ProgressDetails with _$ProgressDetails {
  const ProgressDetails._();

  const factory ProgressDetails({
    required int totalSections,
    required int completedSections,
    required int totalQuestions,
    required int answeredQuestions,
    required double currentSectionProgress,
    required Duration timeSpent,
  }) = _ProgressDetails;

  // Helper Properties
  double get overallProgress =>
    totalQuestions == 0 ? 0.0 : answeredQuestions / totalQuestions;

  double get sectionProgress =>
    totalSections == 0 ? 0.0 : completedSections / totalSections;

  int get remainingQuestions => totalQuestions - answeredQuestions;
  int get remainingSections => totalSections - completedSections;

  // Display Text
  String get progressText =>
    '$answeredQuestions of $totalQuestions questions completed';

  String get sectionProgressText =>
    '$completedSections of $totalSections sections completed';

  String get timeSpentText =>
    '${timeSpent.inMinutes} minutes spent';

  factory ProgressDetails.fromJson(Map<String, dynamic> json) =>
      _$ProgressDetailsFromJson(json);
}
```

### **3. Add ProgressDetails to ChatState**

#### **Enhancement to ChatState** (support/chat_state.dart)
```dart
// Add this getter to existing ChatState class
ProgressDetails get progressDetails => ProgressDetails(
  totalSections: sections.length,
  completedSections: sections.where((s) => s.isComplete).length,
  totalQuestions: totalQuestions,
  answeredQuestions: totalAnsweredQuestions,
  currentSectionProgress: currentSection?.completionProgress ?? 0.0,
  timeSpent: sessionDuration,
);

// Helper method for answered questions with completion flag
int get totalCompletedQuestions => questionnaireSections
    .expand((s) => s.allMessages.whereType<QuestionAnswer>())
    .where((qa) => qa.isComplete)  // 🆕 Use new completion flag
    .length;
```

---

## 🔧 Simple Service Architecture

### **1. Simple Persistence Interface**

#### **New Interface** (interfaces/persistence_service.dart)
```dart
/// Simple persistence service with just 3 methods
abstract class PersistenceService {
  /// Load complete questionnaire session
  /// Returns null if no session exists
  Future<ChatState?> loadSession();

  /// Save complete questionnaire session
  /// Overwrites existing session
  Future<void> saveSession(ChatState session);

  /// Clear all session data
  Future<void> clearSession();
}
```

### **2. Local Persistence Implementation**

#### **SharedPreferences Implementation** (implementations/local_persistence_service.dart)
```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../interfaces/persistence_service.dart';
import '../../models/support/chat_state.dart';

class LocalPersistenceService implements PersistenceService {
  static const String _sessionKey = 'questionnaire_session';

  @override
  Future<ChatState?> loadSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = prefs.getString(_sessionKey);

      if (sessionJson == null) return null;

      final sessionData = json.decode(sessionJson) as Map<String, dynamic>;
      return ChatState.fromJson(sessionData);
    } catch (e) {
      // Log error but don't throw - return null for fresh start
      print('Failed to load session: $e');
      return null;
    }
  }

  @override
  Future<void> saveSession(ChatState session) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = json.encode(session.toJson());
      await prefs.setString(_sessionKey, sessionJson);
    } catch (e) {
      throw Exception('Failed to save session: $e');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_sessionKey);
    } catch (e) {
      throw Exception('Failed to clear session: $e');
    }
  }
}
```

### **3. API Persistence Implementation**

#### **HTTP API Implementation** (implementations/api_persistence_service.dart)
```dart
import 'dart:convert';
import 'package:dio/dio.dart';
import '../interfaces/persistence_service.dart';
import '../../models/support/chat_state.dart';

class ApiPersistenceService implements PersistenceService {
  final String baseUrl;
  final Dio _dio;

  ApiPersistenceService({
    required this.baseUrl,
    Dio? dio,
  }) : _dio = dio ?? Dio();

  @override
  Future<ChatState?> loadSession() async {
    try {
      final response = await _dio.get('$baseUrl/api/questionnaire/session');

      if (response.statusCode == 200 && response.data != null) {
        return ChatState.fromJson(response.data as Map<String, dynamic>);
      }

      return null; // No session found
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null; // No session exists
      }
      throw Exception('Failed to load session: ${e.message}');
    }
  }

  @override
  Future<void> saveSession(ChatState session) async {
    try {
      final response = await _dio.put(
        '$baseUrl/api/questionnaire/session',
        data: session.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save session: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to save session: ${e.message}');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      final response = await _dio.delete('$baseUrl/api/questionnaire/session');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to clear session: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to clear session: ${e.message}');
    }
  }
}
```

### **4. Main Questionnaire Service**

#### **Business Logic Service** (questionnaire_service.dart)
```dart
import '../models/support/chat_state.dart';
import '../models/support/question.dart';
import '../models/support/validation_status.dart';
import '../models/core/section_message.dart';
import '../models/core/chat_section.dart';
import '../models/core/enums.dart';
import 'interfaces/persistence_service.dart';
import 'interfaces/validation_service.dart';

class QuestionnaireService {
  final PersistenceService _persistence;
  final ValidationService _validation;

  QuestionnaireService(this._persistence, this._validation);

  // ========================================================================
  // Core Operations
  // ========================================================================

  /// Initialize questionnaire - load existing or create new
  Future<ChatState> initialize() async {
    try {
      // Try to load existing session
      final existingSession = await _persistence.loadSession();
      if (existingSession != null) {
        return existingSession;
      }

      // Create new session
      final questionnaireStructure = await _loadQuestionnaireStructure();
      final newSession = ChatState.initial(sections: questionnaireStructure);

      // Save initial session
      await _persistence.saveSession(newSession);
      return newSession;
    } catch (e) {
      throw Exception('Failed to initialize questionnaire: $e');
    }
  }

  /// Submit answer for current question
  Future<ChatState> submitAnswer({
    required String questionId,
    required dynamic answer,
  }) async {
    try {
      // Load current session
      final currentSession = await getCurrentSession();

      // Validate answer
      final validation = await _validation.validateAnswer(
        questionId: questionId,
        answer: answer,
        inputType: _getQuestionType(questionId, currentSession),
      );

      if (!validation.isValid) {
        throw Exception('Invalid answer: ${validation.primaryError}');
      }

      // Create answer message
      final answerMessage = SectionMessage.questionAnswer(
        id: _generateId(),
        sectionId: currentSession.currentSectionId!,
        questionId: questionId,
        questionText: _getQuestionText(questionId, currentSession),
        inputType: _getQuestionType(questionId, currentSession),
        answer: answer,
        timestamp: DateTime.now(),
        isComplete: true,  // 🆕 Mark as complete
        formattedAnswer: _formatAnswer(answer),
        validation: validation,
      );

      // Add message to current section
      final updatedSession = _addMessageToSession(currentSession, answerMessage);

      // Update position to next question
      final finalSession = _moveToNextQuestion(updatedSession);

      // Save updated session
      await _persistence.saveSession(finalSession);
      return finalSession;
    } catch (e) {
      throw Exception('Failed to submit answer: $e');
    }
  }

  /// Get current session state
  Future<ChatState> getCurrentSession() async {
    final session = await _persistence.loadSession();
    if (session == null) {
      throw Exception('No active session found');
    }
    return session;
  }

  /// Reset questionnaire
  Future<void> reset() async {
    await _persistence.clearSession();
  }

  /// Get current question
  Future<Question?> getCurrentQuestion() async {
    final session = await getCurrentSession();
    return session.currentQuestion;
  }

  /// Check if questionnaire is complete
  Future<bool> isComplete() async {
    final session = await getCurrentSession();
    return session.isComplete;
  }

  /// Get progress details
  Future<ProgressDetails> getProgress() async {
    final session = await getCurrentSession();
    return session.progressDetails;
  }

  // ========================================================================
  // Private Helper Methods
  // ========================================================================

  /// Add message to session and return updated session
  ChatState _addMessageToSession(ChatState session, SectionMessage message) {
    final updatedSections = session.sections.map((section) {
      if (section.id == message.sectionId) {
        return section.when(
          intro: (id, title, welcomeMessages, sectionType, status, createdAt, completedAt) => section,
          questionnaire: (id, title, description, questions, messages, sectionType, status, createdAt, completedAt) {
            return ChatSection.questionnaire(
              id: id,
              title: title,
              description: description,
              questions: questions,
              messages: [...messages, message],
              sectionType: sectionType,
              status: status,
              createdAt: createdAt,
              completedAt: completedAt,
            );
          },
        );
      }
      return section;
    }).toList();

    return session.copyWith(
      sections: updatedSections,
      lastActivityAt: DateTime.now(),
    );
  }

  /// Move to next question or section
  ChatState _moveToNextQuestion(ChatState session) {
    final currentSection = session.currentSection;
    if (currentSection == null) return session;

    return currentSection.when(
      intro: (_, __, ___, ____, _____, ______, _______) {
        // Move to first questionnaire section
        final nextSection = session.sections.firstWhere(
          (s) => s.sectionType == SectionType.questionnaire,
          orElse: () => session.sections.first,
        );
        return session.copyWith(currentSectionId: nextSection.id);
      },
      questionnaire: (id, title, description, questions, messages, sectionType, status, createdAt, completedAt) {
        // Find next unanswered question in current section
        final answeredQuestionIds = messages
            .whereType<QuestionAnswer>()
            .where((qa) => qa.isComplete)  // 🆕 Use completion flag
            .map((qa) => qa.questionId)
            .toSet();

        final nextQuestion = questions.firstWhere(
          (q) => !answeredQuestionIds.contains(q.id),
          orElse: () => throw StateError('No more questions'),
        );

        // Check if current section is complete
        final sectionComplete = questions.every(
          (q) => answeredQuestionIds.contains(q.id),
        );

        if (sectionComplete) {
          // Mark section complete and move to next section
          final updatedSections = session.sections.map((s) {
            if (s.id == id) {
              return ChatSection.questionnaire(
                id: id,
                title: title,
                description: description,
                questions: questions,
                messages: messages,
                sectionType: sectionType,
                status: SectionStatus.completed,  // Mark complete
                createdAt: createdAt,
                completedAt: DateTime.now(),
              );
            }
            return s;
          }).toList();

          // Find next incomplete section
          final nextSection = updatedSections.firstWhere(
            (s) => !s.isComplete,
            orElse: () => throw StateError('All sections complete'),
          );

          return session.copyWith(
            sections: updatedSections,
            currentSectionId: nextSection.id,
            currentQuestionId: null,
          );
        } else {
          // Stay in current section, move to next question
          return session.copyWith(currentQuestionId: nextQuestion.id);
        }
      },
    );
  }

  /// Load questionnaire structure from assets
  Future<List<ChatSection>> _loadQuestionnaireStructure() async {
    // Implementation: Load from assets/questionnaire_data.json
    // Return parsed ChatSection list
    // This is where you'd load your questionnaire structure
    throw UnimplementedError('Load questionnaire structure from assets');
  }

  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}';
  }

  String _formatAnswer(dynamic answer) {
    if (answer is List) return answer.join(', ');
    if (answer is DateTime) return '${answer.day}/${answer.month}/${answer.year}';
    if (answer is bool) return answer ? 'Yes' : 'No';
    return answer.toString();
  }

  String _getQuestionText(String questionId, ChatState session) {
    // Implementation: Find question text by ID
    throw UnimplementedError();
  }

  QuestionType _getQuestionType(String questionId, ChatState session) {
    // Implementation: Find question type by ID
    throw UnimplementedError();
  }
}
```

---

## 🎛️ RiverPod Integration

### **Service Providers**
```dart
// Service configuration
@riverpod
bool useApiPersistence(UseApiPersistenceRef ref) => false; // Toggle local/API

// Persistence service provider
@riverpod
PersistenceService persistenceService(PersistenceServiceRef ref) {
  final useApi = ref.watch(useApiPersistenceProvider);

  if (useApi) {
    return ApiPersistenceService(baseUrl: 'https://api.example.com');
  } else {
    return LocalPersistenceService();
  }
}

// Validation service provider
@riverpod
ValidationService validationService(ValidationServiceRef ref) {
  return DefaultValidationService();
}

// Main questionnaire service
@riverpod
QuestionnaireService questionnaireService(QuestionnaireServiceRef ref) {
  final persistence = ref.watch(persistenceServiceProvider);
  final validation = ref.watch(validationServiceProvider);
  return QuestionnaireService(persistence, validation);
}
```

### **State Providers**
```dart
// Main session state
@riverpod
class QuestionnaireSession extends _$QuestionnaireSession {
  @override
  Future<ChatState> build() async {
    final service = ref.read(questionnaireServiceProvider);
    return await service.initialize();
  }

  Future<void> submitAnswer(String questionId, dynamic answer) async {
    final service = ref.read(questionnaireServiceProvider);
    final updatedState = await service.submitAnswer(
      questionId: questionId,
      answer: answer,
    );
    state = AsyncValue.data(updatedState);
  }

  Future<void> reset() async {
    final service = ref.read(questionnaireServiceProvider);
    await service.reset();

    // Reinitialize
    state = const AsyncValue.loading();
    final newState = await service.initialize();
    state = AsyncValue.data(newState);
  }
}

// Progress provider
@riverpod
Future<ProgressDetails> progress(ProgressRef ref) async {
  final service = ref.read(questionnaireServiceProvider);
  return await service.getProgress();
}

// Current question provider
@riverpod
Future<Question?> currentQuestion(CurrentQuestionRef ref) async {
  final service = ref.read(questionnaireServiceProvider);
  return await service.getCurrentQuestion();
}
```

---

## 🔄 Simple Control Flows

### **1. Initialize Flow**
```
[App Start]
    ↓
QuestionnaireService.initialize()
    ↓
PersistenceService.loadSession()
    ↓
if session exists:
    └── return existing ChatState
else:
    ├── load questionnaire structure from assets
    ├── create new ChatState.initial()
    ├── PersistenceService.saveSession()
    └── return new ChatState
```

### **2. Submit Answer Flow**
```
[User Submits Answer]
    ↓
QuestionnaireService.submitAnswer(questionId, answer)
    ↓
ValidationService.validateAnswer()
    ↓ (if valid)
create QuestionAnswer with isComplete=true
    ↓
add message to current section
    ↓
calculate next question/section position
    ↓
PersistenceService.saveSession(updatedSession)
    ↓
[UI updates via RiverPod]
```

### **3. Load State Flow**
```
[Get Current State]
    ↓
QuestionnaireService.getCurrentSession()
    ↓
PersistenceService.loadSession()
    ↓
return complete ChatState with all sections/messages
    ↓
[RiverPod providers update UI]
```

---

## 📈 API Endpoint Design

### **Simple REST API**
```yaml
# Session Management
GET    /api/questionnaire/session    # Load complete session
PUT    /api/questionnaire/session    # Save complete session
DELETE /api/questionnaire/session    # Clear session

# Optional: Export/Import
GET    /api/questionnaire/export     # Export session as JSON
POST   /api/questionnaire/import     # Import session from JSON
```

### **Example API Payloads**

#### **GET /api/questionnaire/session Response**
```json
{
  "sessionId": "session_1234567890_123",
  "sections": [
    {
      "type": "intro",
      "id": "welcome",
      "title": "Welcome",
      "welcomeMessages": [...],
      "sectionType": "intro",
      "status": "completed",
      "createdAt": "2025-09-16T10:00:00Z"
    },
    {
      "type": "questionnaire",
      "id": "personal_info",
      "title": "Personal Information",
      "description": "Tell us about yourself",
      "questions": [...],
      "messages": [
        {
          "type": "questionAnswer",
          "id": "qa_1234",
          "sectionId": "personal_info",
          "questionId": "age",
          "questionText": "What is your age?",
          "inputType": "number",
          "answer": 25,
          "isComplete": true,
          "timestamp": "2025-09-16T10:05:00Z",
          "formattedAnswer": "25"
        }
      ],
      "sectionType": "questionnaire",
      "status": "inProgress",
      "createdAt": "2025-09-16T10:00:00Z"
    }
  ],
  "currentSectionId": "personal_info",
  "currentQuestionId": "height",
  "status": "inProgress",
  "createdAt": "2025-09-16T10:00:00Z",
  "lastActivityAt": "2025-09-16T10:05:00Z"
}
```

---

## 🚀 Implementation Priority

### **Phase 1: Minimal Model Updates** (1-2 hours)
1. ✅ Add `isComplete` flag to `QuestionAnswer` in `section_message.dart`
2. ✅ Create `ProgressDetails` class in `support/progress_details.dart`
3. ✅ Add `progressDetails` getter to `ChatState`
4. ✅ Run `dart run build_runner build` to generate freezed code

### **Phase 2: Simple Services** (2-3 hours)
1. ✅ Create `PersistenceService` interface
2. ✅ Create `LocalPersistenceService` implementation
3. ✅ Create `QuestionnaireService` with core operations
4. ✅ Set up RiverPod providers

### **Phase 3: API Implementation** (1-2 hours)
1. ✅ Create `ApiPersistenceService` implementation
2. ✅ Add service configuration switching
3. ✅ Test local ↔ API transition

### **Phase 4: Integration** (1 hour)
1. ✅ Update existing widgets to use new services
2. ✅ Test complete flow from UI to persistence
3. ✅ Verify session resume functionality

**Total Effort: ~6 hours maximum**

---

## 🎉 Benefits of Simple Design

### **1. KISS Compliance**
- **3 persistence methods** instead of 20+
- **1 additional field** (`isComplete`)
- **Same data structure** for local and API
- **Minimal complexity** with maximum functionality

### **2. API-Ready Architecture**
- **Local**: JSON to SharedPreferences
- **API**: Same JSON to HTTP endpoint
- **Seamless transition** without data model changes
- **Future-proof** for backend scaling

### **3. Developer Experience**
- **Easy to understand**: Simple session concept
- **Easy to test**: Mock persistence interface
- **Easy to debug**: Single source of truth (session)
- **Easy to enhance**: Add features incrementally

### **4. User Experience**
- **Perfect resume**: Position tracking preserves exact state
- **Fast performance**: Single load/save operations
- **Reliable**: Simplified error handling
- **Offline-first**: Local storage always available

---

## 📝 Summary

This simplified design leverages **90% of your existing excellent models** and adds only **3 minimal enhancements**:

1. **One field**: `isComplete` on QuestionAnswer
2. **One helper class**: ProgressDetails
3. **One simple interface**: PersistenceService (3 methods)

The result is a **clean, maintainable, API-ready architecture** that follows KISS principles while providing all the functionality needed for a robust questionnaire system.

**Key Philosophy**: Start simple, enhance incrementally. Your existing v2 foundation was excellent - we're just adding the minimal session layer for backend transition.

---

**Document Version**: 4.0
**Last Updated**: September 2025
**Architecture**: KISS Session-Based Design
**Review Cycle**: As needed
**Implementation Status**: Ready to implement