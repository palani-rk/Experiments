# Technical Design Specification
## NutriApp Conversational Questionnaire System

### Document Information
- **Version**: 1.0.0
- **Created**: 2025-01-15
- **Architecture Type**: Hybrid Chat + Form Interface
- **Target Platform**: Flutter (Mobile + Web)
- **Estimated Development**: 2-3 weeks MVP, 4-6 weeks full features

---

## Executive Summary

This specification defines a hybrid conversational questionnaire system that combines chat UX with structured form inputs. The architecture balances the sophisticated metadata-driven approach with a simplified, user-friendly conversational interface optimized for 5-10 minute completion time.

### Key Design Decisions
- **Unified Data Model**: Single source of truth for questions and responses
- **3-Layer Architecture**: Presentation, Business Logic, Data persistence
- **Progressive Implementation**: MVP-first with extensible architecture
- **Mobile-First Design**: Responsive across devices with touch-optimized inputs

---

## System Architecture

### 🏗️ **Core Architecture Pattern**

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  ┌─────────────────┐ ┌─────────────────┐ ┌───────────────┐  │
│  │ Chat Interface  │ │ Input Factory   │ │ Progress UI   │  │
│  │ - Message List  │ │ - Dynamic       │ │ - Section     │  │
│  │ - Scroll View   │ │   Widgets       │ │   Tracking    │  │
│  │ - Edit History  │ │ - Validation    │ │ - Completion  │  │
│  └─────────────────┘ └─────────────────┘ └───────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                     BUSINESS LAYER                          │
│  ┌─────────────────┐ ┌─────────────────┐ ┌───────────────┐  │
│  │ Session Manager │ │ Flow Engine     │ │ Validation    │  │
│  │ - State Mgmt    │ │ - Conditional   │ │ - Real-time   │  │
│  │ - Navigation    │ │   Logic         │ │ - Submission  │  │
│  │ - Auto-save     │ │ - Branching     │ │ - Error Mgmt  │  │
│  └─────────────────┘ └─────────────────┘ └───────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                             │
│  ┌─────────────────┐ ┌─────────────────┐ ┌───────────────┐  │
│  │ Schema Parser   │ │ Local Storage   │ │ Analytics     │  │
│  │ - JSON Config   │ │ - Hive DB       │ │ - Progress    │  │
│  │ - Validation    │ │ - Auto-backup   │ │ - Metrics     │  │
│  │ - Versioning    │ │ - Sync Ready    │ │ - Export      │  │
│  └─────────────────┘ └─────────────────┘ └───────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## Data Model Design

### 🎯 **Unified Session Model**

```dart
// Primary container - single source of truth
class QuestionnaireSession {
  final String sessionId;
  final QuestionnaireSchema schema;      // Static structure
  final SessionState state;              // Dynamic data
  final ProgressTracker progress;        // Analytics
  final QuestionnaireConfig config;      // Behavior settings
  
  // Core methods
  QuestionResponse? getCurrentQuestion();
  void submitAnswer(String questionId, dynamic value);
  bool canNavigateBack();
  double getCompletionPercentage();
}

// Immutable question structure
class QuestionnaireSchema {
  final String questionnaireId;
  final String version;
  final WelcomeSection welcome;
  final List<Section> sections;
  final ConditionalFlows flows;
  
  static QuestionnaireSchema fromJson(Map<String, dynamic> json);
}

// Mutable session state
class SessionState {
  String currentSectionId;
  String currentQuestionId;
  Map<String, QuestionResponse> responses;
  DateTime startedAt;
  DateTime? lastUpdatedAt;
  
  // Navigation state
  List<String> questionHistory;
  Map<String, dynamic> conditionalState;
}

// Progress and analytics
class ProgressTracker {
  double overallProgress;
  Map<String, SectionProgress> sectionProgress;
  int totalTimeSpent;        // seconds
  int questionsAnswered;
  int questionsSkipped;
  List<String> errorQuestions;
}
```

### 📋 **Question Response Model**

```dart
class QuestionResponse {
  final String questionId;
  dynamic value;                    // Flexible typing
  bool isAnswered;
  DateTime? answeredAt;
  bool isValid;
  List<String> validationErrors;
  int editCount;
  
  // Chat-specific properties
  String? displayText;              // What user sees in chat
  bool isEditable;
  QuestionInputType inputType;
}

// Input type enumeration with factory
enum QuestionInputType {
  text, textArea, number, singleSelect, 
  multiSelect, unitSelector, timeframe
}
```

---

## Component Architecture

### 🎨 **Widget Hierarchy**

```dart
ChatQuestionnaireScreen
├── AppBar(progress, settings)
├── Column
│   ├── ChatMessageList (Expanded)
│   │   ├── WelcomeMessage
│   │   ├── SectionHeaderMessages
│   │   ├── CompletedQuestionBubbles (editable)
│   │   └── CompletionMessages
│   ├── CurrentQuestionWidget
│   │   ├── QuestionText
│   │   ├── QuestionInputFactory.create()
│   │   │   ├── TextQuestionInput
│   │   │   ├── RadioQuestionInput  
│   │   │   ├── MultiSelectQuestionInput
│   │   │   ├── NumberQuestionInput
│   │   │   └── UnitSelectorInput
│   │   └── ValidationErrorText
│   └── BottomActionBar
│       ├── BackButton (conditional)
│       ├── SkipButton (conditional)  
│       └── NextButton
```

### 🔧 **Input Widget Factory Pattern**

```dart
abstract class QuestionInputWidget<T> extends StatefulWidget {
  final Question question;
  final T? initialValue;
  final ValueChanged<T> onChanged;
  final VoidCallback? onSubmit;
  
  const QuestionInputWidget({
    required this.question,
    this.initialValue,
    required this.onChanged,
    this.onSubmit,
  });
}

class QuestionInputFactory {
  static Widget create(Question question, QuestionResponse? response) {
    switch (question.inputType) {
      case QuestionInputType.text:
        return TextQuestionInput(
          question: question,
          initialValue: response?.value,
          onChanged: (value) => _handleValueChange(question.id, value),
        );
      case QuestionInputType.singleSelect:
        return RadioQuestionInput(/* ... */);
      // ... other cases
      default:
        return UnsupportedQuestionWidget(question: question);
    }
  }
}
```

---

## State Management Strategy

### 🔄 **Bloc Pattern Implementation**

```dart
// Events
abstract class QuestionnaireEvent {}
class LoadQuestionnaire extends QuestionnaireEvent {
  final String schemaPath;
}
class AnswerQuestion extends QuestionnaireEvent {
  final String questionId;
  final dynamic value;
}
class NavigateToQuestion extends QuestionnaireEvent {
  final String questionId;
}
class EditPreviousAnswer extends QuestionnaireEvent {
  final String questionId;
}

// States  
abstract class QuestionnaireState {}
class QuestionnaireLoading extends QuestionnaireState {}
class QuestionnaireReady extends QuestionnaireState {
  final QuestionnaireSession session;
  final Question currentQuestion;
  final List<ChatMessage> chatHistory;
}
class QuestionnaireError extends QuestionnaireState {
  final String message;
}

// Bloc
class QuestionnaireBloc extends Bloc<QuestionnaireEvent, QuestionnaireState> {
  final QuestionnaireRepository repository;
  final ConditionalFlowEngine flowEngine;
  final ValidationEngine validationEngine;
  
  // Implementation handles all business logic
}
```

### 📱 **Supporting Services**

```dart
// Repository pattern for data persistence
class QuestionnaireRepository {
  final LocalStorageService localStorage;
  final AnalyticsService analytics;
  
  Future<QuestionnaireSchema> loadSchema(String path);
  Future<void> saveSession(QuestionnaireSession session);
  Future<QuestionnaireSession?> restoreSession(String sessionId);
  Stream<QuestionnaireSession> watchSession(String sessionId);
}

// Conditional logic engine
class ConditionalFlowEngine {
  bool shouldShowQuestion(Question question, SessionState state);
  List<String> getTriggeredFlows(String questionId, dynamic value);
  Question? getNextQuestion(SessionState state, QuestionnaireSchema schema);
}

// Validation engine
class ValidationEngine {
  ValidationResult validateAnswer(Question question, dynamic value);
  bool canProceedToNext(SessionState state);
  List<String> getRequiredQuestions(Section section);
}
```

---

## User Experience Implementation

### 💬 **Chat Interface Behavior**

```dart
class ChatMessage {
  final String id;
  final ChatMessageType type;
  final String content;
  final DateTime timestamp;
  final bool isEditable;
  final VoidCallback? onEdit;
}

enum ChatMessageType {
  welcome,           // "Hi John! I'm here to help..."
  sectionHeader,     // "Great! Personal info complete ✅"
  question,          // "What's your full name?"
  userResponse,      // "John Smith" (editable)
  encouragement,     // "Love your motivation! 💪"
  completion,        // "Amazing work! 🎉"
  error             // Validation error messages
}

// Chat behavior patterns
class ChatBehavior {
  static const Duration typingDelay = Duration(milliseconds: 800);
  static const Duration scrollAnimationDuration = Duration(milliseconds: 300);
  
  static String getEncouragementMessage(String sectionId);
  static String getErrorMessage(String questionId, List<String> errors);
  static String getCompletionMessage(String nutritionistName);
}
```

### 🎯 **Progressive Disclosure Pattern**

```dart
class ProgressiveDisclosure {
  // Show one question at a time
  // Reveal next question after valid answer
  // Maintain chat history for context
  // Allow editing previous responses
  
  static Widget buildQuestionFlow(
    QuestionnaireSession session,
    Function(String, dynamic) onAnswerChanged,
  ) {
    return Column(
      children: [
        // Chat history (completed questions)
        Expanded(
          child: ChatHistoryView(
            messages: _buildChatHistory(session),
            onEditResponse: (questionId) => _handleEdit(questionId),
          ),
        ),
        // Current question input
        if (session.getCurrentQuestion() != null)
          CurrentQuestionInput(
            question: session.getCurrentQuestion()!,
            onChanged: onAnswerChanged,
          ),
      ],
    );
  }
}
```

---

## Configuration & Extensibility

### ⚙️ **Configuration System**

```dart
class QuestionnaireConfig {
  // UX behavior
  final bool allowBackNavigation;
  final bool allowSkipOptional;
  final bool enableEditHistory;
  final Duration autoSaveInterval;
  
  // UI customization
  final ThemeData? customTheme;
  final String? nutritionistName;
  final String? clinicLogo;
  final Map<String, Color> brandColors;
  
  // Analytics
  final bool enableAnalytics;
  final bool enableDetailedTracking;
  final bool enablePerformanceMetrics;
  
  // Development
  final bool debugMode;
  final LogLevel logLevel;
  
  // Factory constructors for different environments
  factory QuestionnaireConfig.mvp() => QuestionnaireConfig(
    allowBackNavigation: true,
    enableAnalytics: false,
    autoSaveInterval: Duration(seconds: 30),
  );
  
  factory QuestionnaireConfig.production() => QuestionnaireConfig(
    allowBackNavigation: true,
    enableAnalytics: true,
    enableDetailedTracking: true,
    autoSaveInterval: Duration(seconds: 15),
  );
}
```

### 🔌 **Plugin Architecture**

```dart
// Extensible input types
abstract class QuestionInputPlugin {
  String get inputType;
  Widget buildWidget(Question question, QuestionResponse? response);
  ValidationResult validate(Question question, dynamic value);
}

class QuestionInputRegistry {
  static final Map<String, QuestionInputPlugin> _plugins = {};
  
  static void register(QuestionInputPlugin plugin) {
    _plugins[plugin.inputType] = plugin;
  }
  
  static Widget? createWidget(String inputType, Question question) {
    return _plugins[inputType]?.buildWidget(question, null);
  }
}

// Example custom plugin
class SliderQuestionPlugin extends QuestionInputPlugin {
  @override
  String get inputType => 'slider';
  
  @override
  Widget buildWidget(Question question, QuestionResponse? response) {
    return SliderQuestionInput(/* implementation */);
  }
}
```

---

## Performance & Optimization

### ⚡ **Performance Strategy**

```dart
// 1. Lazy loading of sections
class LazyQuestionLoader {
  final Map<String, Section> _cache = {};
  
  Future<Section> loadSection(String sectionId) async {
    if (_cache.containsKey(sectionId)) {
      return _cache[sectionId]!;
    }
    
    final section = await _loadSectionFromStorage(sectionId);
    _cache[sectionId] = section;
    return section;
  }
}

// 2. Response debouncing
class DebouncedResponseHandler {
  Timer? _debounceTimer;
  
  void handleResponse(String questionId, dynamic value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 300), () {
      _saveResponse(questionId, value);
    });
  }
}

// 3. Memory management
class QuestionnaireMemoryManager {
  void disposeCompletedSections(QuestionnaireSession session) {
    // Clear widgets for completed sections
    // Keep only current section + 1 previous in memory
    // Compress old responses for storage
  }
}
```

### 📊 **Analytics Implementation**

```dart
class AnalyticsTracker {
  // Simplified analytics for MVP
  void trackQuestionAnswered(String questionId, int timeSpent);
  void trackSectionCompleted(String sectionId, Duration timeSpent);
  void trackQuestionSkipped(String questionId, String reason);
  void trackValidationError(String questionId, String errorType);
  void trackSessionCompleted(Duration totalTime, double completionRate);
  
  // Export capabilities
  Future<Map<String, dynamic>> exportSessionData(String sessionId);
  Future<void> generateCompletionReport(QuestionnaireSession session);
}
```

---

## Implementation Roadmap

### 🚀 **Phase 1: MVP (Week 1-2)**
- [ ] Core data models (QuestionnaireSession, Question, Response)
- [ ] Basic JSON schema parser
- [ ] Simple chat UI container
- [ ] Text and single-select input widgets
- [ ] Local storage with Hive
- [ ] Basic navigation flow

### 📈 **Phase 2: Enhanced UX (Week 3-4)**
- [ ] Multi-select and number inputs
- [ ] Chat message editing functionality
- [ ] Progress tracking and analytics
- [ ] Auto-save and session recovery
- [ ] Validation engine with real-time feedback
- [ ] Custom theming support

### 🔧 **Phase 3: Advanced Features (Week 5-6)**
- [ ] Conditional flow engine
- [ ] Advanced input types (slider, date picker)
- [ ] Performance optimizations
- [ ] Comprehensive analytics dashboard
- [ ] Export functionality
- [ ] Plugin architecture for custom inputs

### 🧪 **Phase 4: Testing & Polish (Week 7-8)**
- [ ] Unit tests for all core components
- [ ] Integration tests for user flows
- [ ] Performance testing and optimization
- [ ] Accessibility improvements
- [ ] Documentation and examples

---

## File Structure

```
lib/features/onboarding/
├── models/
│   ├── questionnaire_session.dart
│   ├── question_models.dart
│   ├── response_models.dart
│   ├── progress_models.dart
│   └── config_models.dart
├── widgets/
│   ├── chat/
│   │   ├── chat_message_list.dart
│   │   ├── chat_message_bubble.dart
│   │   └── typing_indicator.dart
│   ├── inputs/
│   │   ├── question_input_base.dart
│   │   ├── text_question_input.dart
│   │   ├── radio_question_input.dart
│   │   ├── multiselect_question_input.dart
│   │   └── input_factory.dart
│   ├── progress/
│   │   ├── progress_indicator.dart
│   │   └── section_progress.dart
│   └── questionnaire_screen.dart
├── bloc/
│   ├── questionnaire_bloc.dart
│   ├── questionnaire_event.dart
│   └── questionnaire_state.dart
├── services/
│   ├── questionnaire_repository.dart
│   ├── conditional_flow_engine.dart
│   ├── validation_engine.dart
│   ├── analytics_tracker.dart
│   └── local_storage_service.dart
└── progress_specs/
    ├── questionnaire_design_spec.md
    ├── technical_design_spec.md        # This document
    └── implementation_progress.md
```

---

## Success Metrics

### 📊 **Key Performance Indicators**
- **Completion Rate**: Target 85%+ (simplified UX focus)
- **Time to Complete**: Average 5-10 minutes (client spec target)
- **Error Rate**: <5% validation errors per question
- **User Satisfaction**: Post-completion feedback >4.0/5.0
- **Technical Performance**: <100ms response time for input changes

### 🔍 **Quality Gates**
- **Code Coverage**: >80% unit test coverage
- **Performance**: <2MB memory usage, <50ms frame render time
- **Accessibility**: WCAG 2.1 AA compliance
- **Usability**: Completion without assistance by 90% of test users

---

## Conclusion

This technical design specification provides a balanced approach that:

1. **Combines the best of both specs**: Technical sophistication with user-friendly simplicity
2. **Scales gracefully**: MVP-first approach with extensible architecture
3. **Optimizes for mobile**: Touch-first design with responsive layouts
4. **Maintains performance**: Lazy loading, debouncing, and memory management
5. **Enables customization**: Plugin architecture and theming support

The unified data model approach with clear separation of concerns provides the foundation for a maintainable, scalable questionnaire system that can evolve with changing requirements while maintaining excellent user experience.