# Architecture Sequence Flow
## Complete Method Call Tracing: Onboarding Link → Completion

### 🎯 **Flow Overview**
```
User Click → Page Load → Provider Init → Service Calls → UI Updates → Navigation → Completion
```

---

## 1️⃣ **Initial App Launch & Onboarding Link Click**

### **User Action: Clicks Onboarding Link**
```dart
// Main app navigation
Navigator.push(context, MaterialPageRoute(
  builder: (_) => QuestionnairePage(),
));
```

### **Page Load Sequence:**
```
QuestionnairePage() constructor called
├─ ConsumerWidget.build() triggered
└─ Riverpod providers start initializing
```

---

## 2️⃣ **Provider Initialization Cascade**

### **Step 1: Service Provider Init**
```dart
// 1. questionnaireServiceProvider is read
final questionnaireServiceProvider = Provider<QuestionnaireService>((ref) {
  return const LocalQuestionnaireService(); // ← CALLED FIRST
});
```
**Method Called:** `LocalQuestionnaireService()` constructor

### **Step 2: Schema Provider Init** 
```dart
// 2. questionnaireSchemaProvider is watched
final questionnaireSchemaProvider = AsyncNotifierProvider<QuestionnaireSchemaNotifier, QuestionnaireSchema>(() {
  return QuestionnaireSchemaNotifier(); // ← CALLED SECOND
});
```
**Method Called:** `QuestionnaireSchemaNotifier()` constructor

### **Step 3: Schema Notifier Build Method**
```dart
class QuestionnaireSchemaNotifier extends AsyncNotifier<QuestionnaireSchema> {
  @override
  Future<QuestionnaireSchema> build() async { // ← CALLED THIRD
    final service = ref.watch(questionnaireServiceProvider);
    return await service.loadQuestionnaire(); // ← CALLS SERVICE
  }
}
```

### **Step 4: Service Method Execution**
```dart
class LocalQuestionnaireService implements QuestionnaireService {
  @override
  Future<QuestionnaireSchema> loadQuestionnaire() async { // ← CALLED FOURTH
    try {
      final jsonString = await rootBundle.loadString(assetPath); // ← FILE READ
      final json = jsonDecode(jsonString) as Map<String, dynamic>; // ← JSON PARSE
      return QuestionnaireSchema.fromJson(json); // ← MODEL CREATION
    } catch (e) {
      throw QuestionnaireLoadException('Failed to load questionnaire: $e');
    }
  }
}
```

### **Step 5: Navigation Provider Init**
```dart
// 3. navigationStateProvider initializes
final navigationStateProvider = StateNotifierProvider<NavigationNotifier, NavigationState>((ref) {
  return NavigationNotifier(); // ← CALLED FIFTH
});

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(const NavigationState()); // ← CALLED SIXTH - showWelcome: true by default
}
```

### **Step 6: Response Provider Init**
```dart
// 4. responseStateProvider initializes  
final responseStateProvider = StateNotifierProvider<ResponseNotifier, QuestionnaireResponse>((ref) {
  return ResponseNotifier(ref); // ← CALLED SEVENTH
});

class ResponseNotifier extends StateNotifier<QuestionnaireResponse> {
  ResponseNotifier(this._ref) : super(QuestionnaireResponse(
    questionnaireId: 'default',
    answers: {},
    startTime: DateTime.now(),
  )) {
    _loadSavedResponse(); // ← CALLED EIGHTH - tries to load saved data
  }
}
```

### **Step 7: Saved Response Loading**
```dart
Future<void> _loadSavedResponse() async { // ← CALLED EIGHTH
  try {
    final service = _ref.read(questionnaireServiceProvider);
    final savedResponse = await service.loadSavedResponse('default'); // ← CALLS SERVICE AGAIN
    if (savedResponse != null) {
      state = savedResponse; // ← UPDATES STATE IF FOUND
    }
  } catch (e) {
    // Continue with default state if can't load
  }
}
```

---

## 3️⃣ **Initial UI Rendering**

### **QuestionnairePage Build Method**
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final schemaAsync = ref.watch(questionnaireSchemaProvider); // ← WATCHES ASYNC STATE
  final navigationState = ref.watch(navigationStateProvider); // ← WATCHES NAVIGATION

  return Scaffold(
    body: schemaAsync.when(
      loading: () => const QuestionnaireLoadingWidget(), // ← SHOWS LOADING FIRST
      error: (error, stack) => QuestionnaireErrorWidget(...),
      data: (schema) {
        if (navigationState.isCompleted) {
          return const CompletionPage();
        }
        
        if (navigationState.showWelcome) { // ← TRUE BY DEFAULT
          return WelcomePage(welcome: schema.welcome); // ← RENDERS WELCOME PAGE
        }
        
        return QuestionFlowWidget(schema: schema);
      },
    ),
  );
}
```

**Call Sequence:**
1. `schemaAsync.when()` - Initially returns `loading: true`
2. Shows `QuestionnaireLoadingWidget()`
3. When schema loads, `data` callback executes
4. `navigationState.showWelcome` is `true`
5. **Result: `WelcomePage` is rendered**

---

## 4️⃣ **Welcome Page Interaction**

### **WelcomePage Renders**
```dart
class WelcomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // UI elements...
              ElevatedButton(
                onPressed: () => ref.read(navigationStateProvider.notifier).startQuestionnaire(), // ← USER CLICKS THIS
                child: Text(welcome.buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### **User Action: Clicks "Start Assessment" Button**
```dart
// Button onPressed callback executes:
ref.read(navigationStateProvider.notifier).startQuestionnaire() // ← METHOD CALLED
```

### **Navigation State Update**
```dart
class NavigationNotifier extends StateNotifier<NavigationState> {
  void startQuestionnaire() { // ← CALLED
    state = state.copyWith(showWelcome: false); // ← STATE UPDATED
  }
}
```

### **UI Rebuild Triggered**
```dart
// QuestionnairePage.build() called again due to state change
@override
Widget build(BuildContext context, WidgetRef ref) {
  final navigationState = ref.watch(navigationStateProvider); // ← DETECTS showWelcome: false
  
  return schemaAsync.when(
    data: (schema) {
      if (navigationState.showWelcome) { // ← NOW FALSE
        return WelcomePage(welcome: schema.welcome);
      }
      
      return QuestionFlowWidget(schema: schema); // ← NOW RENDERS THIS
    },
  );
}
```

**Result: `QuestionFlowWidget` is now displayed**

---

## 5️⃣ **Question Flow - First Question Display**

### **QuestionFlowWidget Build**
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final navigationState = ref.watch(navigationStateProvider); // ← currentSectionIndex: 0, currentQuestionIndex: 0
  final responseState = ref.watch(responseStateProvider); // ← WATCHES RESPONSES
  
  final currentSection = schema.sections[navigationState.currentSectionIndex]; // ← sections[0]
  final currentQuestion = currentSection.questions[navigationState.currentQuestionIndex]; // ← questions[0]
  
  final questionsPerSection = schema.sections.map((s) => s.questions.length).toList(); // ← [2, 3, 1] etc.
  final progress = ref.read(navigationStateProvider.notifier).getProgress(questionsPerSection); // ← CALCULATES PROGRESS
  
  return Scaffold(
    appBar: AppBar(
      title: Text(currentSection.title), // ← "Personal Information"
      bottom: PreferredSize(
        child: QuestionnaireProgressIndicator(progress: progress), // ← 0.0 initially
      ),
    ),
    body: Column(
      children: [
        Text(currentQuestion.text), // ← "What's your full name?"
        
        Expanded(
          child: QuestionWidgetFactory.create( // ← CREATES INPUT WIDGET
            question: currentQuestion,
            currentValue: responseState.getAnswer(currentQuestion.id), // ← null initially
            onChanged: (value) {
              ref.read(responseStateProvider.notifier).setAnswer( // ← CALLBACK FOR CHANGES
                currentQuestion.id,
                value,
              );
            },
          ),
        ),
        
        NavigationButtonsWidget(...), // ← BACK/NEXT BUTTONS
      ],
    ),
  );
}
```

### **Question Widget Creation**
```dart
class QuestionWidgetFactory {
  static Widget create({...}) {
    switch (question.inputType) {
      case QuestionType.text: // ← FOR "name" QUESTION
        return TextQuestionWidget(
          question: question,
          currentValue: currentValue as String?, // ← null
          onChanged: onChanged,
        );
    }
  }
}
```

---

## 6️⃣ **User Interaction: Answering Questions**

### **User Action: Types in Text Field**
```dart
// In TextQuestionWidget:
TextFormField(
  initialValue: currentValue, // ← null initially
  onChanged: (value) => onChanged(value), // ← TRIGGERS ON EACH KEYSTROKE
  decoration: InputDecoration(
    hintText: 'Enter your answer...',
  ),
)
```

### **Response Update Chain**
```dart
// Each keystroke triggers:
onChanged("John") // ← USER TYPES "John"
  ↓
ref.read(responseStateProvider.notifier).setAnswer("name", "John") // ← PROVIDER METHOD
  ↓
void setAnswer(String questionId, dynamic value) { // ← IN ResponseNotifier
  final newAnswers = Map<String, dynamic>.from(state.answers);
  newAnswers[questionId] = value; // ← {"name": "John"}
  
  state = state.copyWith(answers: newAnswers); // ← STATE UPDATED
  
  _saveResponse(); // ← AUTO-SAVE TRIGGERED
}
  ↓
Future<void> _saveResponse() async { // ← SAVE METHOD
  try {
    final service = _ref.read(questionnaireServiceProvider);
    await service.saveResponse(state); // ← CALLS SERVICE
  } catch (e) {
    print('Failed to save response: $e');
  }
}
  ↓
// In LocalQuestionnaireService:
@override
Future<void> saveResponse(QuestionnaireResponse response) async { // ← SERVICE METHOD
  try {
    final prefs = await SharedPreferences.getInstance();
    final responseJson = jsonEncode(response.toJson()); // ← SERIALIZE TO JSON
    await prefs.setString('questionnaire_response_${response.questionnaireId}', responseJson); // ← SAVE TO STORAGE
  } catch (e) {
    throw ResponseSaveException('Failed to save response: $e');
  }
}
```

**Result: Answer saved locally after each keystroke**

---

## 7️⃣ **Navigation: Next Question**

### **User Action: Clicks "Next" Button**
```dart
// In NavigationButtonsWidget:
ElevatedButton(
  onPressed: _canGoNext() ? _goToNextQuestion : null, // ← VALIDATION FIRST
  child: Text(_isLastQuestion() ? 'Complete' : 'Next'),
)
```

### **Validation Check**
```dart
bool _canGoNext() {
  final currentQuestion = getCurrentQuestion();
  if (currentQuestion.required) {
    return ref.read(responseStateProvider).isQuestionAnswered(currentQuestion.id); // ← CHECKS IF ANSWERED
  }
  return true;
}

// In ResponseNotifier:
bool isQuestionAnswered(String questionId) {
  final answer = state.answers[questionId]; // ← answers["name"] = "John"
  if (answer == null) return false;
  if (answer is String) return answer.trim().isNotEmpty; // ← "John" is not empty, returns true
  return true;
}
```

### **Navigation Update**
```dart
void _goToNextQuestion() {
  ref.read(navigationStateProvider.notifier).goToNextQuestion(totalSections, questionsPerSection); // ← NAVIGATION METHOD
}

// In NavigationNotifier:
void goToNextQuestion(int totalSections, List<int> questionsPerSection) {
  final currentSection = state.currentSectionIndex; // ← 0
  final currentQuestion = state.currentQuestionIndex; // ← 0
  final questionsInCurrentSection = questionsPerSection[currentSection]; // ← 2 questions in section 0

  if (currentQuestion < questionsInCurrentSection - 1) { // ← 0 < 1, TRUE
    // Next question in same section
    state = state.copyWith(currentQuestionIndex: currentQuestion + 1); // ← currentQuestionIndex: 1
  } else if (currentSection < totalSections - 1) {
    // Next section
    state = state.copyWith(
      currentSectionIndex: currentSection + 1,
      currentQuestionIndex: 0,
    );
  } else {
    // Questionnaire completed
    state = state.copyWith(isCompleted: true);
  }
}
```

### **UI Rebuild for Next Question**
```dart
// QuestionFlowWidget rebuilds due to navigation state change:
final navigationState = ref.watch(navigationStateProvider); // ← currentQuestionIndex: 1
final currentSection = schema.sections[0]; // ← Same section
final currentQuestion = currentSection.questions[1]; // ← Second question: "How old are you?"
```

**Result: Second question displays ("How old are you?")**

---

## 8️⃣ **Progress Through All Questions**

### **Continued Navigation Pattern**
For each subsequent question, the same pattern repeats:
1. **User answers** → `setAnswer()` → `_saveResponse()` → Local storage updated
2. **User clicks Next** → `_canGoNext()` validation → `goToNextQuestion()` → UI rebuilds
3. **Progress updates** → `getProgress()` calculates completion percentage

### **Section Transitions**
When moving to next section:
```dart
} else if (currentSection < totalSections - 1) { // ← At end of section
  // Next section
  state = state.copyWith(
    currentSectionIndex: currentSection + 1, // ← Move to next section
    currentQuestionIndex: 0, // ← Reset to first question of new section
  );
}
```

---

## 9️⃣ **Questionnaire Completion**

### **Last Question Detection**
```dart
bool _isLastQuestion() {
  return navigationState.currentSectionIndex == schema.sections.length - 1 && // ← Last section
         navigationState.currentQuestionIndex == 
         schema.sections[navigationState.currentSectionIndex].questions.length - 1; // ← Last question
}

// Button text changes:
child: Text(_isLastQuestion() ? 'Complete' : 'Next'), // ← Shows "Complete"
```

### **Final Submission**
```dart
void _goToNextQuestion() {
  // ... same validation
  if (_isLastQuestion()) {
    ref.read(navigationStateProvider.notifier).goToNextQuestion(...); // ← FINAL CALL
  }
}

// In NavigationNotifier:
void goToNextQuestion(...) {
  // ... navigation logic
  } else {
    // Questionnaire completed
    state = state.copyWith(isCompleted: true); // ← MARKS COMPLETE
  }
}
```

### **Response Completion**
```dart
// Somewhere in the completion flow:
await ref.read(responseStateProvider.notifier).completeQuestionnaire(); // ← FINAL SAVE

Future<void> completeQuestionnaire() async {
  state = state.copyWith(
    completedTime: DateTime.now(),
    status: QuestionnaireStatus.completed,
  );
  
  await _saveResponse(); // ← FINAL SAVE TO STORAGE
}
```

### **UI Transition to Completion**
```dart
// QuestionnairePage detects completion:
@override
Widget build(BuildContext context, WidgetRef ref) {
  final navigationState = ref.watch(navigationStateProvider);
  
  return schemaAsync.when(
    data: (schema) {
      if (navigationState.isCompleted) { // ← NOW TRUE
        return const CompletionPage(); // ← FINAL PAGE DISPLAYED
      }
      // ...
    },
  );
}
```

---

## 🔄 **Complete Method Call Summary**

### **Initialization (App Launch)**
1. `QuestionnairePage()` constructor
2. `LocalQuestionnaireService()` constructor  
3. `QuestionnaireSchemaNotifier()` constructor
4. `QuestionnaireSchemaNotifier.build()` 
5. `LocalQuestionnaireService.loadQuestionnaire()` 
6. `NavigationNotifier()` constructor
7. `ResponseNotifier()` constructor
8. `ResponseNotifier._loadSavedResponse()`
9. `LocalQuestionnaireService.loadSavedResponse()`

### **Per User Interaction**
10. **Answer Input**: `ResponseNotifier.setAnswer()` → `_saveResponse()` → `LocalQuestionnaireService.saveResponse()`
11. **Navigation**: `NavigationNotifier.goToNextQuestion()` → UI rebuild → New question displays
12. **Progress**: `NavigationNotifier.getProgress()` → Progress bar updates

### **Completion**
13. **Final Answer**: Same as step 10
14. **Complete Button**: `NavigationNotifier.goToNextQuestion()` → `isCompleted: true`  
15. **Final Save**: `ResponseNotifier.completeQuestionnaire()` → `_saveResponse()`
16. **UI Transition**: `CompletionPage()` displays

This architecture ensures **data persistence at every step**, **smooth navigation flow**, and **clear separation of concerns** while maintaining **simplicity** and **testability**.