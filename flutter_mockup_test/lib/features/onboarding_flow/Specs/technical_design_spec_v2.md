# Technical Design Specification v2.0
## Chat-Based Questionnaire Architecture

### Document Overview
**Version**: 2.0  
**Date**: September 2025  
**Purpose**: Unified section-based chat interface for questionnaire system  
**Architecture**: Clean Architecture with Interface-Based Polymorphism  

---

## 🏗️ Core Architecture Principles

### **1. Unified Section Model**
```
Everything is a Section → Sections contain Messages → Messages have Types
```

### **2. Interface-Based Design**
- **Polymorphic Sections**: IntroSection, QuestionnaireSection, MediaSection
- **Polymorphic Messages**: BotMessage, QuestionAnswer, MediaMessage
- **Factory Patterns**: Section widgets, message widgets, service implementations

### **3. Simplified 3-Layer Architecture**
```
Presentation Layer (Widgets + Providers)
    ↓
Service Layer (Business Logic + Data Access)
    ↓  
Data Layer (Models + External APIs/Storage)
```

**Rationale**: Service layer embedding business logic provides optimal balance of simplicity and functionality for this questionnaire system. Domain layer can be extracted later if complexity justifies additional abstraction.

---

## 📁 File Structure Architecture

### **Complete Directory Layout**
```
lib/features/onboarding/
├── data/
│   ├── models/
│   │   ├── core/
│   │   │   ├── chat_section.dart              # Abstract base classes
│   │   │   ├── section_message.dart           # Message interfaces
│   │   │   └── enums.dart                     # Shared enums
│   │   ├── sections/
│   │   │   ├── intro_section.dart             # Welcome/intro section
│   │   │   ├── questionnaire_section.dart     # Q&A section
│   │   │   └── media_section.dart             # Future: media content
│   │   ├── messages/
│   │   │   ├── bot_message.dart               # Bot messages
│   │   │   ├── question_answer.dart           # Q&A messages
│   │   │   └── media_message.dart             # Future: media messages
│   │   ├── support/
│   │   │   ├── question.dart                  # Question model
│   │   │   ├── validation_status.dart         # Validation results
│   │   │   └── chat_state.dart                # Main state model
│   │   └── generated/                         # Freezed generated files
│   │       ├── *.freezed.dart
│   │       └── *.g.dart
│   └── services/
│       ├── interfaces/
│       │   ├── chat_questionnaire_service.dart    # Service interface
│       │   ├── chat_persistence_service.dart      # Persistence interface
│       │   └── chat_validation_service.dart       # Validation interface
│       ├── implementations/
│       │   ├── local_chat_questionnaire_service.dart
│       │   ├── api_chat_questionnaire_service.dart
│       │   ├── local_chat_persistence_service.dart
│       │   └── default_chat_validation_service.dart
│       └── exceptions/
│           ├── questionnaire_exceptions.dart       # Service exceptions
│           └── validation_exceptions.dart
├── presentation/
│   ├── providers/
│   │   ├── chat_state_provider.dart               # Main state provider
│   │   ├── chat_service_providers.dart            # Service providers
│   │   ├── computed_providers.dart                # Derived state providers
│   │   └── validation_providers.dart              # Validation providers
│   ├── pages/
│   │   ├── chat_questionnaire_view.dart           # Main orchestration page
│   │   └── chat_completion_view.dart              # Completion page
│   ├── widgets/
│   │   ├── core/
│   │   │   ├── chat_header_widget.dart            # Progress + info header
│   │   │   ├── chat_history_widget.dart           # Scrollable section list
│   │   │   ├── chat_progress_indicator.dart       # Overall progress
│   │   │   ├── chat_loading_widget.dart           # Loading states
│   │   │   └── chat_error_widget.dart             # Error states
│   │   ├── sections/
│   │   │   ├── base_section_widget.dart           # Abstract section widget
│   │   │   ├── intro_section_widget.dart          # Intro section
│   │   │   ├── questionnaire_section_widget.dart  # Q&A section
│   │   │   └── section_widget_factory.dart        # Section factory
│   │   ├── messages/
│   │   │   ├── bot_message_widget.dart            # Bot message bubbles
│   │   │   ├── question_answer_widget.dart        # Q&A display
│   │   │   ├── media_message_widget.dart          # Future: media
│   │   │   └── message_widget_factory.dart        # Message factory
│   │   ├── input/
│   │   │   ├── current_question_input_widget.dart # Bottom input area
│   │   │   ├── question_input_factory.dart        # Input widget factory
│   │   │   └── question_inputs/                   # Specific input widgets
│   │   │       ├── text_input_widget.dart
│   │   │       ├── number_input_widget.dart
│   │   │       ├── radio_input_widget.dart
│   │   │       ├── multiselect_input_widget.dart
│   │   │       ├── slider_input_widget.dart
│   │   │       └── date_input_widget.dart
│   │   └── common/
│   │       ├── section_header_widget.dart         # Section title + status
│   │       ├── progress_widgets.dart              # Progress components
│   │       └── validation_widgets.dart            # Validation UI
│   └── utils/
│       ├── chat_navigation_helper.dart            # Navigation logic
│       ├── message_formatter.dart                 # Display formatting
│       └── validation_helper.dart                 # UI validation helpers
├── assets/
│   └── questionnaire_v2.json                     # Questionnaire data
└── progress_specs/
    ├── Implementation_Progress.md                 # Current progress tracking
    └── technical_design_spec_v2.md                # This document
```

### **File Organization Principles**

#### **1. Layer Separation**
- **data/**: Models, services (with embedded business logic), external data handling
- **presentation/**: UI components, state management, user interactions

#### **2. Feature Grouping**
- **Core Components**: Shared base classes and interfaces
- **Specific Implementations**: Concrete section/message types
- **Supporting Elements**: Utilities, exceptions, validation

#### **3. Scalability Structure**
- **Factory Patterns**: Easy addition of new types
- **Interface Separation**: Clean dependency management
- **Generated Code Isolation**: Freezed files in dedicated folder

---

## 🌳 Widget Hierarchy Diagram

### **Complete Widget Tree Structure**

```
📱 ChatQuestionnaireView (Main Orchestration)
│
├── 🏠 ChatHeaderWidget
│   ├── 👤 NutritionistInfoWidget
│   ├── 📊 OverallProgressWidget
│   └── 🔄 StatusIndicatorWidget
│
├── 📏 ChatProgressIndicator
│   ├── 🎯 ProgressBarWidget
│   └── 📈 PercentageDisplayWidget
│
├── 📜 ChatHistoryWidget (Scrollable List)
│   └── 📦 SectionWidgetFactory.create()
│       │
│       ├── 🎉 IntroSectionWidget
│       │   └── 💬 BotMessageWidget(s)
│       │       ├── 🤖 BotAvatarWidget
│       │       ├── 💭 MessageBubbleWidget
│       │       └── ⏰ TimestampWidget
│       │
│       └── 📋 QuestionnaireSectionWidget
│           ├── 🏷️ SectionHeaderWidget
│           │   ├── 🎯 SectionTitleWidget
│           │   ├── 📊 SectionProgressWidget
│           │   └── ✅ SectionStatusIconWidget
│           │
│           └── 📝 SectionContentWidget
│               └── 💬 MessageWidgetFactory.create()
│                   │
│                   ├── 💬 BotMessageWidget
│                   │   ├── 🤖 BotAvatarWidget
│                   │   ├── 💭 MessageBubbleWidget
│                   │   └── ⏰ TimestampWidget
│                   │
│                   └── 🗣️ QuestionAnswerWidget
│                       ├── ❓ QuestionRowWidget
│                       │   ├── 🤖 BotAvatarWidget (Small)
│                       │   └── 📝 QuestionTextWidget
│                       │
│                       └── 💭 AnswerRowWidget
│                           ├── 👤 UserAvatarWidget (Small)
│                           ├── 📄 AnswerDisplayWidget
│                           └── ✏️ EditButtonWidget
│
└── ⌨️ CurrentQuestionInputWidget (Fixed Bottom)
    ├── 🎯 CurrentIndicatorWidget
    │   ├── ⬆️ ArrowUpIcon
    │   └── 🏷️ "CURRENT" LabelWidget
    │
    ├── ❓ QuestionHeaderWidget
    │   ├── 🤖 BotAvatarWidget
    │   ├── 📝 QuestionTextWidget
    │   └── ⭐ RequiredIndicatorWidget (conditional)
    │
    ├── 📦 QuestionInputContainer
    │   └── 🏭 QuestionInputFactory.create()
    │       │
    │       ├── ✏️ TextInputWidget
    │       │   ├── 📝 TextFormField
    │       │   └── 🔤 CharacterCountWidget
    │       │
    │       ├── 🔢 NumberInputWidget  
    │       │   ├── 🔢 NumberFormField
    │       │   └── 📊 RangeIndicatorWidget
    │       │
    │       ├── 📻 RadioInputWidget
    │       │   └── 🔘 RadioListTile(s)
    │       │
    │       ├── ☑️ MultiselectInputWidget
    │       │   └── 🏷️ ChoiceChip(s)
    │       │
    │       ├── 🎚️ SliderInputWidget
    │       │   ├── 🎚️ Slider
    │       │   └── 📊 ValueDisplayWidget
    │       │
    │       └── 📅 DateInputWidget
    │           ├── 📅 DatePickerField
    │           └── 🗓️ CalendarIconWidget
    │
    └── 🚀 SubmitButtonWidget
        ├── ✅ ValidSubmitButton (enabled)
        └── ❌ DisabledSubmitButton (validation errors)
```

### **Widget Hierarchy Principles**

#### **1. Composition Over Inheritance**
- **Factory Patterns**: Dynamic widget creation based on data types
- **Atomic Components**: Small, reusable widgets with single responsibilities
- **Flexible Assembly**: Widgets combine to create complex UI structures

#### **2. State Management Integration**
- **Provider Consumption**: Widgets consume specific slices of state
- **Reactive Updates**: Automatic rebuilds when dependent state changes
- **Computed Properties**: Derived state calculated in providers

#### **3. Theme Integration**
- **Material 3 Compliance**: All widgets follow design system
- **Consistent Spacing**: Using AppSizes constants throughout
- **Semantic Colors**: Theme-aware color usage for states and content

### **Widget Communication Patterns**

```
📱 Parent Widget (ConsumerWidget)
│
├── 📊 ref.watch(provider) → Reactive State Access
├── 🔧 ref.read(provider.notifier) → Action Dispatch  
├── 🎯 Provider Family → Parameterized State
└── ⚡ AsyncValue.when() → Loading/Error/Data Handling

🔄 Data Flow:
User Interaction → Widget Event → Provider Action → Service Call → State Update → UI Rebuild
```

### **Scalability Features**

#### **1. Factory Extensibility**
```dart
// Adding new section type
SectionWidgetFactory.create() {
  switch (section.runtimeType) {
    case NewSectionType:
      return NewSectionWidget(section: section);
    // ... existing cases
  }
}
```

#### **2. Message Type Extension**
```dart
// Adding new message type
MessageWidgetFactory.create() {
  switch (message.messageType) {
    case MessageType.newType:
      return NewMessageWidget(message: message);
    // ... existing cases  
  }
}
```

#### **3. Input Widget Extension**
```dart
// Adding new question input type
QuestionInputFactory.create() {
  switch (question.inputType) {
    case QuestionType.newInput:
      return NewInputWidget(question: question);
    // ... existing cases
  }
}
```

This hierarchical structure ensures maintainable, scalable, and testable widget architecture while following Flutter best practices and Clean Architecture principles.

---

## 📊 Data Models Architecture

### **Core Interfaces**

#### **ChatSection Interface**
```dart
abstract class ChatSection {
  String get id;
  String get title;
  SectionType get sectionType;
  SectionStatus get status;
  List<SectionMessage> get messages;
  DateTime get createdAt;
  DateTime? get completedAt;
  
  // Business Logic
  bool get isComplete;
  bool get canProceed;
  double get completionProgress;
  
  // State Management
  void addMessage(SectionMessage message);
  void updateMessage(String messageId, SectionMessage updatedMessage);
  void removeMessage(String messageId);
  ChatSection copyWith({/* parameters */});
}

enum SectionType { intro, questionnaire, media, review, completion }
enum SectionStatus { pending, inProgress, completed, skipped }
```

#### **SectionMessage Interface**
```dart
abstract class SectionMessage {
  String get id;
  String get sectionId;
  MessageType get messageType;
  DateTime get timestamp;
  bool get isEditable;
  
  SectionMessage copyWith({/* parameters */});
}

enum MessageType { 
  botIntro,           // Section introduction
  botQuestion,        // Question prompt (shown in input area)
  userAnswer,         // User's response
  botWrapup,          // Section completion message
  mediaContent,       // Images, videos, documents
  systemNotification  // Progress updates, errors
}
```

### **Section Implementations**

#### **IntroSection**
```dart
@freezed
class IntroSection extends ChatSection with _$IntroSection {
  const factory IntroSection({
    required String id,
    required String title,
    required List<BotMessage> welcomeMessages,
    @Default(SectionType.intro) SectionType sectionType,
    @Default(SectionStatus.completed) SectionStatus status,
    required DateTime createdAt,
  }) = _IntroSection;

  // Business Logic Methods
  @override
  bool get isComplete => true;
  
  @override
  double get completionProgress => 1.0;
  
  @override
  List<SectionMessage> get messages => welcomeMessages.cast<SectionMessage>();

  factory IntroSection.fromJson(Map<String, dynamic> json) => 
      _$IntroSectionFromJson(json);
}
```

#### **QuestionnaireSection**
```dart
@freezed  
class QuestionnaireSection extends ChatSection with _$QuestionnaireSection {
  const factory QuestionnaireSection({
    required String id,
    required String title,
    required String description,
    required List<Question> questions,
    @Default([]) List<SectionMessage> messages,
    @Default(SectionType.questionnaire) SectionType sectionType,
    @Default(SectionStatus.pending) SectionStatus status,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _QuestionnaireSection;

  // Business Logic Methods  
  @override
  bool get isComplete => questions.every((q) => _hasAnswer(q.id));
  
  @override
  double get completionProgress => 
      _answeredQuestions.length / questions.length;
      
  List<QuestionAnswer> get answeredQuestions => 
      messages.whereType<QuestionAnswer>().toList();
      
  List<Question> get pendingQuestions => 
      questions.where((q) => !_hasAnswer(q.id)).toList();
      
  Question? get currentQuestion => pendingQuestions.firstOrNull;

  factory QuestionnaireSection.fromJson(Map<String, dynamic> json) => 
      _$QuestionnaireSectionFromJson(json);
}
```

### **Message Implementations**

#### **BotMessage**
```dart
@freezed
class BotMessage extends SectionMessage with _$BotMessage {
  const factory BotMessage({
    required String id,
    required String sectionId,
    required String content,
    required MessageType messageType,
    required DateTime timestamp,
    @Default(false) bool isEditable,
    String? context,              // Additional context for message
    Map<String, dynamic>? metadata, // Extensible data
  }) = _BotMessage;

  factory BotMessage.intro({
    required String sectionId,
    required String content,
    String? context,
  }) => BotMessage(
    id: _generateId(),
    sectionId: sectionId,
    content: content,
    messageType: MessageType.botIntro,
    timestamp: DateTime.now(),
    context: context,
  );

  factory BotMessage.wrapup({
    required String sectionId, 
    required String content,
  }) => BotMessage(
    id: _generateId(),
    sectionId: sectionId,
    content: content,
    messageType: MessageType.botWrapup,
    timestamp: DateTime.now(),
  );

  factory BotMessage.fromJson(Map<String, dynamic> json) => 
      _$BotMessageFromJson(json);
}
```

#### **QuestionAnswer**
```dart
@freezed
class QuestionAnswer extends SectionMessage with _$QuestionAnswer {
  const factory QuestionAnswer({
    required String id,
    required String sectionId, 
    required String questionId,
    required String questionText,
    required QuestionType inputType,
    required dynamic answer,
    required DateTime timestamp,
    @Default(MessageType.userAnswer) MessageType messageType,
    @Default(true) bool isEditable,
    String? formattedAnswer,      // Display-friendly version
    ValidationStatus? validation,
  }) = _QuestionAnswer;

  // Business Logic
  String get displayAnswer => formattedAnswer ?? _formatAnswer(answer);
  bool get isValid => validation?.isValid ?? true;

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) => 
      _$QuestionAnswerFromJson(json);
}

@freezed
class ValidationStatus with _$ValidationStatus {
  const factory ValidationStatus({
    required bool isValid,
    String? errorMessage,
    List<String>? warnings,
  }) = _ValidationStatus;
}
```

#### **Supporting Models**
```dart
@freezed
class Question with _$Question {
  const factory Question({
    required String id,
    required String sectionId,
    required String text,
    required QuestionType inputType,
    @Default(false) bool required,
    String? hint,
    List<String>? options,
    Map<String, dynamic>? validation,
    Map<String, dynamic>? metadata,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) => 
      _$QuestionFromJson(json);
}

enum QuestionType {
  text,
  number, 
  email,
  phone,
  date,
  radio,
  multiselect,
  slider,
  scale,
  boolean
}
```

---

## 🔧 Service Layer Architecture

### **Core Service Interfaces**

#### **ChatQuestionnaireService** (Enhanced with Business Logic)
```dart
abstract class ChatQuestionnaireService {
  // Core Operations (Business Logic + Data Access)
  Future<ChatState> initializeQuestionnaire();
  Future<void> submitAnswer(String questionId, dynamic answer);
  Future<void> navigateToQuestion(String questionId);
  Future<void> editAnswer(String sectionId, String messageId, dynamic newAnswer);
  
  // Section Management
  Future<List<ChatSection>> loadQuestionnaire();
  Future<void> saveSection(ChatSection section);
  Future<ChatSection?> getSection(String sectionId);
  Future<List<ChatSection>> getAllSections();
  
  // Message Management
  Future<void> addMessage(String sectionId, SectionMessage message);
  Future<void> updateMessage(String sectionId, String messageId, SectionMessage message);
  Future<void> deleteMessage(String sectionId, String messageId);
  
  // Answer Management & Business Rules
  Future<void> saveAnswer(String sectionId, String questionId, dynamic answer);
  Future<QuestionAnswer?> getAnswer(String sectionId, String questionId);
  Future<List<QuestionAnswer>> getSectionAnswers(String sectionId);
  Future<bool> canProceedToNextSection(String sectionId);
  Future<List<Question>> getConditionalQuestions(String sectionId, List<Answer> previousAnswers);
  
  // Progress Management & Calculation
  Future<void> markSectionComplete(String sectionId);
  Future<void> updateSectionStatus(String sectionId, SectionStatus status);
  Future<double> getOverallProgress();
  Future<double> getSectionProgress(String sectionId);
  
  // Validation & Business Rules
  Future<ValidationStatus> validateAnswer(String questionId, dynamic answer);
  Future<List<ValidationStatus>> validateSection(String sectionId);
  Future<bool> shouldShowQuestion(Question question, List<Answer> previousAnswers);
  Future<ValidationStatus> validateBusinessRules(ChatState state);
  
  // State Management
  Future<ChatState> getCurrentState();
  Future<void> saveCurrentState(ChatState state);
  Future<void> clearState();
}
```

#### **ChatPersistenceService**
```dart
abstract class ChatPersistenceService {
  // State Persistence
  Future<void> saveChatState(ChatState state);
  Future<ChatState?> loadChatState();
  Future<void> clearChatState();
  
  // Session Management
  Future<String> createSession();
  Future<void> saveSession(String sessionId, ChatState state);
  Future<ChatState?> loadSession(String sessionId);
  Future<List<String>> getSessions();
  Future<void> deleteSession(String sessionId);
  
  // Backup & Recovery
  Future<void> backupState(String backupId);
  Future<ChatState?> restoreState(String backupId);
  Future<List<String>> getBackups();
}
```

#### **ChatValidationService**
```dart
abstract class ChatValidationService {
  // Answer Validation
  ValidationStatus validateTextAnswer(String value, Map<String, dynamic>? rules);
  ValidationStatus validateNumberAnswer(num value, Map<String, dynamic>? rules);
  ValidationStatus validateEmailAnswer(String value);
  ValidationStatus validatePhoneAnswer(String value);
  ValidationStatus validateDateAnswer(DateTime value, Map<String, dynamic>? rules);
  ValidationStatus validateSelectionAnswer(dynamic value, List<String> options, bool multiselect);
  
  // Section Validation
  Future<List<ValidationStatus>> validateSection(QuestionnaireSection section);
  Future<ValidationStatus> validateQuestionnaire(List<ChatSection> sections);
  
  // Business Rules
  Future<ValidationStatus> validateBusinessRules(ChatState state);
  ValidationStatus checkDependencies(Question question, List<QuestionAnswer> answers);
}
```

### **Service Implementations**

#### **LocalChatQuestionnaireService** (Enhanced Implementation)
```dart
class LocalChatQuestionnaireService implements ChatQuestionnaireService {
  final ChatPersistenceService _persistenceService;
  final ChatValidationService _validationService;
  final String _assetPath = 'assets/questionnaire_v2.json';
  
  LocalChatQuestionnaireService(this._persistenceService, this._validationService);

  @override
  Future<ChatState> initializeQuestionnaire() async {
    try {
      // Load existing state or create new
      final existingState = await _persistenceService.loadChatState();
      if (existingState != null) {
        return existingState;
      }
      
      // Initialize new questionnaire
      final sections = await loadQuestionnaire();
      final chatState = ChatState(
        sessionId: _generateSessionId(),
        sections: sections,
        currentSectionId: _findFirstActiveSection(sections)?.id,
        status: ChatStatus.inProgress,
        createdAt: DateTime.now(),
      );
      
      await _persistenceService.saveChatState(chatState);
      return chatState;
    } catch (e) {
      throw QuestionnaireLoadException('Failed to initialize questionnaire: $e');
    }
  }

  @override
  Future<void> submitAnswer(String questionId, dynamic answer) async {
    try {
      // Business Logic: Validate answer
      final validation = await _validationService.validateAnswer(questionId, answer);
      if (!validation.isValid) {
        throw ValidationException('Invalid answer: ${validation.errorMessage}');
      }
      
      // Business Logic: Find current section and question
      final currentState = await getCurrentState();
      final currentSection = currentState.currentSection as QuestionnaireSection?;
      if (currentSection == null) {
        throw StateException('No active section found');
      }
      
      // Business Logic: Create and save answer
      final qaMessage = QuestionAnswer(
        id: _generateId(),
        sectionId: currentSection.id,
        questionId: questionId,
        questionText: await _getQuestionText(questionId),
        inputType: await _getQuestionType(questionId),
        answer: answer,
        timestamp: DateTime.now(),
        validation: validation,
      );
      
      await addMessage(currentSection.id, qaMessage);
      
      // Business Logic: Check section completion and progression
      if (await _isSectionComplete(currentSection.id)) {
        await _handleSectionCompletion(currentSection.id);
      }
      
      // Auto-save state
      final updatedState = await getCurrentState();
      await _persistenceService.saveChatState(updatedState);
      
    } catch (e) {
      throw ResponseSaveException('Failed to submit answer: $e');
    }
  }

  @override
  Future<bool> canProceedToNextSection(String sectionId) async {
    try {
      final section = await getSection(sectionId) as QuestionnaireSection?;
      if (section == null) return false;
      
      // Business Logic: Check all required questions answered
      final requiredQuestions = section.questions.where((q) => q.required).toList();
      final answeredQuestions = section.answeredQuestions;
      
      return requiredQuestions.every((q) => 
        answeredQuestions.any((a) => a.questionId == q.id)
      );
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Question>> getConditionalQuestions(String sectionId, List<Answer> previousAnswers) async {
    // Business Logic: Implement conditional question display
    final section = await getSection(sectionId) as QuestionnaireSection?;
    if (section == null) return [];
    
    final List<Question> visibleQuestions = [];
    
    for (final question in section.questions) {
      if (await shouldShowQuestion(question, previousAnswers)) {
        visibleQuestions.add(question);
      }
    }
    
    return visibleQuestions;
  }

  @override
  Future<bool> shouldShowQuestion(Question question, List<Answer> previousAnswers) async {
    // Business Logic: Question visibility rules
    if (question.metadata == null || !question.metadata!.containsKey('showIf')) {
      return true; // Always show if no conditions
    }
    
    final showIf = question.metadata!['showIf'] as Map<String, dynamic>;
    final dependentQuestionId = showIf['questionId'] as String;
    final expectedValue = showIf['value'];
    
    final dependentAnswer = previousAnswers.firstWhereOrNull(
      (a) => a.questionId == dependentQuestionId
    );
    
    return dependentAnswer?.answer == expectedValue;
  }

  @override
  Future<double> getOverallProgress() async {
    final sections = await getAllSections();
    final questionnaireSections = sections.whereType<QuestionnaireSection>().toList();
    
    if (questionnaireSections.isEmpty) return 0.0;
    
    final totalProgress = questionnaireSections
        .map((s) => s.completionProgress)
        .reduce((a, b) => a + b);
        
    return totalProgress / questionnaireSections.length;
  }

  @override
  Future<ValidationStatus> validateBusinessRules(ChatState state) async {
    // Business Logic: Cross-section validation rules
    try {
      final errors = <String>[];
      
      // Example: Age-dependent question validation
      final personalSection = state.sections.firstWhereOrNull((s) => s.id == 'personal_info') as QuestionnaireSection?;
      final healthSection = state.sections.firstWhereOrNull((s) => s.id == 'health_goals') as QuestionnaireSection?;
      
      if (personalSection != null && healthSection != null) {
        final ageAnswer = personalSection.answeredQuestions.firstWhereOrNull((a) => a.questionId == 'age');
        final activityAnswer = healthSection.answeredQuestions.firstWhereOrNull((a) => a.questionId == 'activity_level');
        
        if (ageAnswer != null && activityAnswer != null) {
          final age = int.tryParse(ageAnswer.answer.toString()) ?? 0;
          final activity = activityAnswer.answer.toString();
          
          // Business Rule: High intensity not recommended for seniors
          if (age > 65 && activity == 'high_intensity') {
            errors.add('High intensity activities may not be suitable for age 65+');
          }
        }
      }
      
      return ValidationStatus(
        isValid: errors.isEmpty,
        errorMessage: errors.isNotEmpty ? errors.first : null,
        warnings: errors.length > 1 ? errors.skip(1).toList() : null,
      );
    } catch (e) {
      return ValidationStatus(
        isValid: false,
        errorMessage: 'Business rule validation failed: $e',
      );
    }
  }

  // Private Business Logic Methods
  Future<void> _handleSectionCompletion(String sectionId) async {
    // Add completion message
    final section = await getSection(sectionId) as QuestionnaireSection?;
    if (section == null) return;
    
    final wrapupMessage = BotMessage.wrapup(
      sectionId: sectionId,
      content: "Perfect! ${section.title} is complete.",
    );
    
    await addMessage(sectionId, wrapupMessage);
    await markSectionComplete(sectionId);
    
    // Move to next section
    final nextSection = await _findNextSection(sectionId);
    if (nextSection != null) {
      await _startNextSection(nextSection.id);
    }
  }

  Future<bool> _isSectionComplete(String sectionId) async {
    final section = await getSection(sectionId) as QuestionnaireSection?;
    return section?.isComplete ?? false;
  }
}
```

#### **ApiChatQuestionnaireService** (Future Implementation)
```dart
class ApiChatQuestionnaireService implements ChatQuestionnaireService {
  final String baseUrl;
  final AuthService authService;
  final ApiClient apiClient;
  
  ApiChatQuestionnaireService({
    required this.baseUrl,
    required this.authService, 
    required this.apiClient,
  });

  @override
  Future<List<ChatSection>> loadQuestionnaire() async {
    final response = await apiClient.get('/questionnaire/sections');
    // Parse API response to ChatSection objects
    return _parseApiResponse(response.data);
  }

  @override  
  Future<void> saveAnswer(String sectionId, String questionId, dynamic answer) async {
    await apiClient.post('/questionnaire/answers', data: {
      'sectionId': sectionId,
      'questionId': questionId,
      'answer': answer,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  // ... other API implementations
}
```

---

## 🎛️ State Management Architecture

### **Core Providers**

#### **ChatStateProvider**
```dart
@riverpod
class ChatStateNotifier extends _$ChatStateNotifier {
  @override
  Future<ChatState> build() async {
    // Load existing state or initialize new
    final persistenceService = ref.read(chatPersistenceServiceProvider);
    final existingState = await persistenceService.loadChatState();
    
    if (existingState != null) {
      return existingState;
    }
    
    // Initialize new questionnaire
    return await _initializeNewQuestionnaire();
  }

  Future<ChatState> _initializeNewQuestionnaire() async {
    final questionnaireService = ref.read(chatQuestionnaireServiceProvider);
    return await questionnaireService.initializeQuestionnaire();
  }

  // Section Management
  Future<void> startSection(String sectionId) async {
    final currentState = await future;
    final section = _findSection(sectionId);
    
    if (section == null) return;
    
    // Add intro message if questionnaire section
    if (section is QuestionnaireSection) {
      final introMessage = BotMessage.intro(
        sectionId: sectionId,
        content: section.description,
      );
      
      await _addMessageToSection(sectionId, introMessage);
    }
    
    state = AsyncValue.data(currentState.copyWith(
      currentSectionId: sectionId,
      sections: _updateSectionStatus(currentState.sections, sectionId, SectionStatus.inProgress),
    ));
  }

  Future<void> completeSection(String sectionId) async {
    final currentState = await future;
    final section = _findSection(sectionId) as QuestionnaireSection?;
    
    if (section == null) return;
    
    // Add completion message
    final wrapupMessage = BotMessage.wrapup(
      sectionId: sectionId,
      content: "Perfect! ${section.title} is complete.",
    );
    
    await _addMessageToSection(sectionId, wrapupMessage);
    
    // Mark section complete
    final questionnaireService = ref.read(chatQuestionnaireServiceProvider);
    await questionnaireService.markSectionComplete(sectionId);
    
    // Move to next section
    final nextSection = _findNextSection(currentState.sections, sectionId);
    
    state = AsyncValue.data(currentState.copyWith(
      sections: _updateSectionStatus(currentState.sections, sectionId, SectionStatus.completed),
      currentSectionId: nextSection?.id,
    ));
    
    // Start next section if exists
    if (nextSection != null) {
      await startSection(nextSection.id);
    } else {
      await _completeQuestionnaire();
    }
  }

  // Answer Management (Delegated to Service Business Logic)
  Future<void> submitAnswer(String questionId, dynamic answer) async {
    try {
      final questionnaireService = ref.read(chatQuestionnaireServiceProvider);
      
      // Service handles all business logic: validation, state updates, section completion
      await questionnaireService.submitAnswer(questionId, answer);
      
      // Refresh UI state
      await _refreshCurrentState();
      
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Message Management
  Future<void> addMessage(String sectionId, SectionMessage message) async {
    final questionnaireService = ref.read(chatQuestionnaireServiceProvider);
    await questionnaireService.addMessage(sectionId, message);
    await _refreshCurrentState();
  }

  Future<void> editAnswer(String sectionId, String messageId, dynamic newAnswer) async {
    final currentState = await future;
    final section = _findSection(sectionId) as QuestionnaireSection?;
    final message = section?.messages.firstWhere((m) => m.id == messageId) as QuestionAnswer?;
    
    if (message == null) return;
    
    final updatedMessage = message.copyWith(
      answer: newAnswer,
      timestamp: DateTime.now(),
    );
    
    final questionnaireService = ref.read(chatQuestionnaireServiceProvider);
    await questionnaireService.updateMessage(sectionId, messageId, updatedMessage);
    await _refreshCurrentState();
  }

  // Progress Management
  Future<double> getProgress() async {
    final questionnaireService = ref.read(chatQuestionnaireServiceProvider);
    return await questionnaireService.getOverallProgress();
  }

  // Private helpers
  Future<void> _refreshCurrentState() async {
    final questionnaireService = ref.read(chatQuestionnaireServiceProvider);
    final sections = await questionnaireService.getAllSections();
    final currentState = await future;
    
    state = AsyncValue.data(currentState.copyWith(sections: sections));
  }
}

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    required String sessionId,
    required List<ChatSection> sections,
    String? currentSectionId,
    String? currentQuestionId,
    @Default(ChatStatus.notStarted) ChatStatus status,
    required DateTime createdAt,
    DateTime? completedAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _ChatState;

  // Computed Properties
  ChatSection? get currentSection => sections.firstWhereOrNull((s) => s.id == currentSectionId);
  Question? get currentQuestion => _getCurrentQuestion();
  double get overallProgress => _calculateProgress();
  bool get isComplete => status == ChatStatus.completed;
  
  factory ChatState.fromJson(Map<String, dynamic> json) => _$ChatStateFromJson(json);
}

enum ChatStatus { notStarted, inProgress, completed, abandoned }
```

#### **Supporting Providers**

```dart
// Service Providers
@riverpod
ChatQuestionnaireService chatQuestionnaireService(ChatQuestionnaireServiceRef ref) {
  final persistenceService = ref.read(chatPersistenceServiceProvider);
  final validationService = ref.read(chatValidationServiceProvider);
  
  return LocalChatQuestionnaireService(persistenceService, validationService);
}

@riverpod
ChatPersistenceService chatPersistenceService(ChatPersistenceServiceRef ref) {
  return LocalChatPersistenceService();
}

@riverpod
ChatValidationService chatValidationService(ChatValidationServiceRef ref) {
  return DefaultChatValidationService();
}

// Computed Providers
@riverpod
Future<Question?> currentQuestion(CurrentQuestionRef ref) async {
  final chatState = await ref.watch(chatStateNotifierProvider.future);
  final currentSection = chatState.currentSection as QuestionnaireSection?;
  return currentSection?.currentQuestion;
}

@riverpod
Future<double> overallProgress(OverallProgressRef ref) async {
  final chatState = await ref.watch(chatStateNotifierProvider.future);
  return chatState.overallProgress;
}

@riverpod
Future<bool> canProceedToNext(CanProceedToNextRef ref, String sectionId) async {
  final chatState = await ref.watch(chatStateNotifierProvider.future);
  final section = chatState.sections.firstWhereOrNull((s) => s.id == sectionId);
  return section?.canProceed ?? false;
}

@riverpod
Future<List<ValidationStatus>> currentValidationErrors(CurrentValidationErrorsRef ref) async {
  final chatState = await ref.watch(chatStateNotifierProvider.future);
  final validationService = ref.read(chatValidationServiceProvider);
  
  if (chatState.currentSection is QuestionnaireSection) {
    return await validationService.validateSection(chatState.currentSection as QuestionnaireSection);
  }
  
  return [];
}
```

---

## 🎨 Widget Architecture

### **Main Orchestration Widget**

#### **ChatQuestionnaireView**
```dart
class ChatQuestionnaireView extends ConsumerWidget {
  const ChatQuestionnaireView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatStateAsync = ref.watch(chatStateNotifierProvider);
    
    return chatStateAsync.when(
      loading: () => const ChatLoadingWidget(),
      error: (error, stack) => ChatErrorWidget(
        error: error,
        onRetry: () => ref.refresh(chatStateNotifierProvider),
      ),
      data: (chatState) => _buildChatInterface(context, ref, chatState),
    );
  }

  Widget _buildChatInterface(BuildContext context, WidgetRef ref, ChatState chatState) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: Column(
          children: [
            ChatHeaderWidget(chatState: chatState),
            _buildProgressIndicator(context, ref),
            Expanded(
              child: ChatHistoryWidget(sections: chatState.sections),
            ),
            _buildCurrentQuestionInput(context, ref, chatState),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final progressAsync = ref.watch(overallProgressProvider);
        return progressAsync.when(
          loading: () => const LinearProgressIndicator(value: null),
          error: (_, __) => const SizedBox.shrink(),
          data: (progress) => ChatProgressIndicator(progress: progress),
        );
      },
    );
  }

  Widget _buildCurrentQuestionInput(BuildContext context, WidgetRef ref, ChatState chatState) {
    if (chatState.isComplete) {
      return const ChatCompletionWidget();
    }
    
    return Consumer(
      builder: (context, ref, child) {
        final currentQuestionAsync = ref.watch(currentQuestionProvider);
        return currentQuestionAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (question) => question != null 
            ? CurrentQuestionInputWidget(question: question)
            : const SizedBox.shrink(),
        );
      },
    );
  }
}
```

### **Section Widget Architecture**

#### **Base Section Widget**
```dart
abstract class BaseSectionWidget extends ConsumerWidget {
  final ChatSection section;
  
  const BaseSectionWidget({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.m,
        vertical: AppSizes.s,
      ),
      decoration: BoxDecoration(
        color: _getSectionBackgroundColor(theme),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(
          color: _getSectionBorderColor(theme),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.outline.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_shouldShowHeader()) _buildSectionHeader(context, ref),
          ..._buildSectionContent(context, ref),
        ],
      ),
    );
  }

  // Abstract methods to be implemented by concrete sections
  bool _shouldShowHeader();
  Widget? _buildSectionHeader(BuildContext context, WidgetRef ref);
  List<Widget> _buildSectionContent(BuildContext context, WidgetRef ref);
  
  Color _getSectionBackgroundColor(ThemeData theme);
  Color _getSectionBorderColor(ThemeData theme);
}
```

#### **Concrete Section Widgets**

```dart
// Intro Section Widget
class IntroSectionWidget extends BaseSectionWidget {
  const IntroSectionWidget({super.key, required super.section});

  @override
  bool _shouldShowHeader() => false;

  @override
  Widget? _buildSectionHeader(BuildContext context, WidgetRef ref) => null;

  @override
  List<Widget> _buildSectionContent(BuildContext context, WidgetRef ref) {
    final introSection = section as IntroSection;
    
    return introSection.welcomeMessages.map((message) => 
      BotMessageWidget(message: message)
    ).toList();
  }

  @override
  Color _getSectionBackgroundColor(ThemeData theme) => theme.colorScheme.surface;
  
  @override
  Color _getSectionBorderColor(ThemeData theme) => Colors.transparent;
}

// Questionnaire Section Widget  
class QuestionnaireSectionWidget extends BaseSectionWidget {
  const QuestionnaireSectionWidget({super.key, required super.section});

  @override
  bool _shouldShowHeader() => true;

  @override
  Widget _buildSectionHeader(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final questionnaireSection = section as QuestionnaireSection;
    
    return Container(
      padding: const EdgeInsets.all(AppSizes.m),
      decoration: BoxDecoration(
        color: _getHeaderBackgroundColor(theme, questionnaireSection.status),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusL - 2),
          topRight: Radius.circular(AppSizes.radiusL - 2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getSectionIcon(questionnaireSection.status),
            color: _getHeaderTextColor(theme, questionnaireSection.status),
            size: 20,
          ),
          const SizedBox(width: AppSizes.s),
          Expanded(
            child: Text(
              questionnaireSection.title.toUpperCase(),
              style: AppTextStyles.sectionHeader.copyWith(
                color: _getHeaderTextColor(theme, questionnaireSection.status),
                letterSpacing: 0.5,
              ),
            ),
          ),
          _buildStatusIcon(theme, questionnaireSection.status),
          if (questionnaireSection.status == SectionStatus.inProgress)
            _buildProgressIndicator(questionnaireSection),
        ],
      ),
    );
  }

  @override
  List<Widget> _buildSectionContent(BuildContext context, WidgetRef ref) {
    final questionnaireSection = section as QuestionnaireSection;
    
    return [
      Padding(
        padding: const EdgeInsets.all(AppSizes.m),
        child: Column(
          children: questionnaireSection.messages.map((message) => 
            MessageWidgetFactory.create(message)
          ).toList(),
        ),
      ),
    ];
  }

  Widget _buildProgressIndicator(QuestionnaireSection section) {
    return Container(
      margin: const EdgeInsets.only(left: AppSizes.s),
      child: CircularProgressIndicator(
        value: section.completionProgress,
        strokeWidth: 2,
        backgroundColor: Colors.white.withOpacity(0.3),
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  @override
  Color _getSectionBackgroundColor(ThemeData theme) => theme.colorScheme.surface;
  
  @override
  Color _getSectionBorderColor(ThemeData theme) {
    final questionnaireSection = section as QuestionnaireSection;
    switch (questionnaireSection.status) {
      case SectionStatus.completed:
        return theme.colorScheme.primary;
      case SectionStatus.inProgress:
        return theme.colorScheme.secondary;
      default:
        return theme.colorScheme.outline.withOpacity(0.3);
    }
  }
}
```

### **Message Widget Architecture**

#### **Message Widget Factory**
```dart
class MessageWidgetFactory {
  static Widget create(SectionMessage message) {
    switch (message.messageType) {
      case MessageType.botIntro:
      case MessageType.botWrapup:
        return BotMessageWidget(message: message as BotMessage);
      case MessageType.userAnswer:
        return QuestionAnswerWidget(message: message as QuestionAnswer);
      case MessageType.mediaContent:
        return MediaMessageWidget(message: message as MediaMessage);
      case MessageType.systemNotification:
        return SystemMessageWidget(message: message);
      default:
        return Container(); // Fallback
    }
  }
}
```

#### **Message Widgets**

```dart
// Bot Message Widget
class BotMessageWidget extends StatelessWidget {
  final BotMessage message;
  
  const BotMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.m),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(
              Icons.smart_toy,
              size: 16,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppSizes.s),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(AppSizes.radiusM),
                  bottomLeft: Radius.circular(AppSizes.radiusM),
                  bottomRight: Radius.circular(AppSizes.radiusM),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.m,
                vertical: AppSizes.s,
              ),
              child: Text(
                message.content,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Question Answer Widget
class QuestionAnswerWidget extends ConsumerWidget {
  final QuestionAnswer message;
  
  const QuestionAnswerWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question
          _buildQuestionRow(context, theme),
          const SizedBox(height: AppSizes.xs),
          // Answer
          _buildAnswerRow(context, ref, theme),
        ],
      ),
    );
  }

  Widget _buildQuestionRow(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 8,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.smart_toy,
            size: 10,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: AppSizes.s),
        Expanded(
          child: Text(
            message.questionText,
            style: AppTextStyles.bodySmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerRow(BuildContext context, WidgetRef ref, ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 8,
          backgroundColor: theme.colorScheme.tertiaryContainer,
          child: Icon(
            Icons.person,
            size: 10,
            color: theme.colorScheme.tertiary,
          ),
        ),
        const SizedBox(width: AppSizes.s),
        Expanded(
          child: Text(
            message.displayAnswer,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        if (message.isEditable) _buildEditButton(context, ref, theme),
      ],
    );
  }

  Widget _buildEditButton(BuildContext context, WidgetRef ref, ThemeData theme) {
    return InkWell(
      onTap: () => _handleEdit(context, ref),
      borderRadius: BorderRadius.circular(AppSizes.radiusS),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s,
          vertical: AppSizes.xs,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppSizes.radiusS),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit,
              size: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 2),
            Text(
              'Edit',
              style: AppTextStyles.labelSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleEdit(BuildContext context, WidgetRef ref) {
    // Navigate back to edit this specific question
    // Implementation depends on navigation strategy
  }
}
```

### **Current Question Input Widget**

```dart
class CurrentQuestionInputWidget extends ConsumerStatefulWidget {
  final Question question;
  
  const CurrentQuestionInputWidget({
    super.key,
    required this.question,
  });

  @override
  ConsumerState<CurrentQuestionInputWidget> createState() =>
      _CurrentQuestionInputWidgetState();
}

class _CurrentQuestionInputWidgetState 
    extends ConsumerState<CurrentQuestionInputWidget> {
  
  dynamic _currentValue;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppSizes.m),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.outline.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusL),
          topRight: Radius.circular(AppSizes.radiusL),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCurrentIndicator(context, theme),
          const SizedBox(height: AppSizes.m),
          _buildQuestionHeader(context, theme),
          const SizedBox(height: AppSizes.m),
          _buildQuestionInput(context, theme),
          const SizedBox(height: AppSizes.m),
          _buildSubmitButton(context, theme),
        ],
      ),
    );
  }

  Widget _buildCurrentIndicator(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.keyboard_arrow_up,
          color: theme.colorScheme.primary,
          size: 16,
        ),
        Text(
          'CURRENT',
          style: AppTextStyles.labelSmall.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionHeader(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.smart_toy,
            size: 16,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: AppSizes.s),
        Expanded(
          child: Text(
            widget.question.text,
            style: AppTextStyles.currentQuestionText.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        if (widget.question.required)
          Icon(
            Icons.star,
            size: 12,
            color: theme.colorScheme.error,
          ),
      ],
    );
  }

  Widget _buildQuestionInput(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.m),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Form(
        key: _formKey,
        child: QuestionInputWidgetFactory.create(
          question: widget.question,
          currentValue: _currentValue,
          onChanged: (value) => setState(() => _currentValue = value),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, ThemeData theme) {
    final validationErrors = ref.watch(currentValidationErrorsProvider);
    
    return validationErrors.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (errors) {
        final hasErrors = errors.any((e) => !e.isValid);
        
        return ElevatedButton(
          onPressed: _canSubmit() && !hasErrors ? _handleSubmit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: AppSizes.m),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            elevation: 0,
          ),
          child: Text(
            'Submit',
            style: AppTextStyles.buttonText,
          ),
        );
      },
    );
  }

  bool _canSubmit() {
    if (widget.question.required && _currentValue == null) return false;
    return _formKey.currentState?.validate() ?? false;
  }

  void _handleSubmit() {
    if (!_canSubmit()) return;
    
    ref.read(chatStateNotifierProvider.notifier)
        .submitAnswer(widget.question.id, _currentValue);
  }
}
```

---

## 🔄 Integration Points & Data Flow

### **End-to-End Flow Diagram**
```
User Action → Widget Event → Provider Method → Service Call → Data Update → State Refresh → UI Update

Example: Answer Submission
1. User taps Submit in CurrentQuestionInputWidget
2. Widget calls ref.read(chatStateNotifierProvider.notifier).submitAnswer()
3. Provider validates and calls ChatQuestionnaireService.saveAnswer()
4. Service saves to persistence and updates section
5. Provider refreshes state and triggers section completion check
6. UI rebuilds with updated section progress and new current question
```

### **Key Integration Patterns**

#### **Service Layer Integration** (Enhanced with Business Logic)
- **Interface Abstraction**: Easy switching between Local/API implementations
- **Business Logic Centralization**: All domain rules embedded in service layer
- **Error Handling**: Consistent exception handling across service boundaries  
- **Validation Pipeline**: Centralized validation through ChatValidationService
- **State Persistence**: Automatic state saving with business rule enforcement
- **Conditional Logic**: Question visibility and section progression rules

#### **State Management Integration**  
- **Reactive Updates**: Riverpod providers automatically rebuild dependent widgets
- **Computed Properties**: Derived state (progress, current question) calculated automatically
- **Error Boundaries**: AsyncValue provides loading/error/data states
- **Cache Management**: Provider caching prevents unnecessary service calls

#### **Widget Communication**
- **Factory Patterns**: Consistent widget creation through factories
- **Theme Integration**: Full Material 3 compliance across all components
- **Accessibility**: Screen reader support and semantic labeling
- **Responsive Design**: Adaptive layouts for different screen sizes

---

## 🎯 Future Extensions & Scalability

### **Planned Enhancements**
1. **Advanced Question Types**: File upload, signature capture, location picker
2. **Conditional Logic**: Skip questions based on previous answers
3. **Multi-language Support**: Internationalization with dynamic content loading
4. **Offline Sync**: Robust offline-first architecture with conflict resolution
5. **Analytics Integration**: User interaction tracking and completion metrics
6. **Accessibility**: Enhanced screen reader support and keyboard navigation

### **Scalability Considerations**
- **Memory Management**: Efficient handling of large questionnaires through pagination
- **Performance**: Lazy loading of sections and optimized state updates
- **Testing**: Comprehensive unit, widget, and integration test coverage
- **Monitoring**: Error tracking, performance metrics, and user experience analytics

## 🎯 Architecture Decision Summary

### **Simplified 3-Layer Benefits Realized**

#### **✅ Development Velocity**
- **Direct Communication**: Providers → Services (no use case abstraction)
- **Business Logic Centralized**: All domain rules in service implementations
- **Fewer Files**: ~40% reduction in architecture files vs full Clean Architecture

#### **✅ Maintainability** 
- **Single Responsibility**: Services own their business logic + data access
- **Clear Boundaries**: Presentation ↔ Services ↔ Data
- **Evolution Path**: Can extract domain layer when complexity justifies it

#### **✅ Business Logic Examples in Services**
```dart
// Conditional question logic
Future<bool> shouldShowQuestion(Question question, List<Answer> previousAnswers)

// Section progression rules  
Future<void> submitAnswer(String questionId, dynamic answer)

// Cross-section validation
Future<ValidationStatus> validateBusinessRules(ChatState state)

// Progress calculation
Future<double> getOverallProgress()
```

### **When to Add Domain Layer Later**
- Business rules exceed 5+ complex conditions per operation
- Multi-platform code sharing requirements emerge  
- External system integrations multiply beyond 3-4 services
- Team size grows beyond 6-8 developers
- Regulatory compliance requires detailed audit trails

### **Evolution Strategy**
Start with service-embedded business logic, extract domain layer only when business complexity genuinely warrants additional abstraction. This approach balances simplicity with scalability.

---

This unified architecture provides a solid, maintainable foundation for the chat-based questionnaire system while preserving flexibility for future enhancements when justified by actual business needs.

---

**Document Version**: 2.0  
**Last Updated**: September 2025  
**Architecture**: Simplified 3-Layer with Service-Embedded Business Logic  
**Review Cycle**: Quarterly  
**Next Review**: December 2025