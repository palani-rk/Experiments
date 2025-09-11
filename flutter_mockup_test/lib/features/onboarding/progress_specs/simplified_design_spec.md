# Simplified Questionnaire Design
## 4-Step Implementation Approach

### Core Principle: Keep It Simple
- JSON Schema → Sections → Questions → Responses
- No complex state management, just basic data flow
- Focus on essential features only

---

## Step 1: Schema Loading

### 🔄 **Simple Schema Structure**
```dart
class QuestionnaireSchema {
  final WelcomeSection welcome;
  final List<QuestionSection> sections;
  
  // Load from JSON (local assets initially)
  factory QuestionnaireSchema.fromJson(Map<String, dynamic> json) {
    return QuestionnaireSchema(
      welcome: WelcomeSection.fromJson(json['welcome']),
      sections: (json['sections'] as List)
          .map((s) => QuestionSection.fromJson(s))
          .toList(),
    );
  }
}

class WelcomeSection {
  final String title;
  final String message;
  final String buttonText;
}

class QuestionSection {
  final String id;
  final String title;
  final List<Question> questions;
}

class Question {
  final String id;
  final String text;
  final String inputType; // 'text', 'radio', 'multiselect', 'number'
  final List<String>? options; // for radio/multiselect
  final bool required;
}
```

### 📁 **JSON Schema Example**
```json
{
  "welcome": {
    "title": "Welcome to Your Health Journey",
    "message": "This will take just 5-10 minutes and covers 4 areas...",
    "buttonText": "Start Assessment"
  },
  "sections": [
    {
      "id": "personal_info",
      "title": "Personal Information",
      "questions": [
        {
          "id": "name",
          "text": "What's your full name?",
          "inputType": "text",
          "required": true
        },
        {
          "id": "age",
          "text": "How old are you?",
          "inputType": "number",
          "required": true
        }
      ]
    }
  ]
}
```

---

## Step 2: Data Models

### 📊 **Simple Response Storage**
```dart
// Just track responses - nothing fancy
class QuestionnaireResponses {
  final Map<String, dynamic> answers = {};
  int currentSectionIndex = 0;
  int currentQuestionIndex = 0;
  
  // Simple methods
  void setAnswer(String questionId, dynamic value) {
    answers[questionId] = value;
  }
  
  dynamic getAnswer(String questionId) {
    return answers[questionId];
  }
  
  bool isQuestionAnswered(String questionId) {
    return answers.containsKey(questionId) && answers[questionId] != null;
  }
}
```

---

## Step 3: Simple UI Flow

### 🎨 **Basic Widget Structure**
```dart
class QuestionnaireScreen extends StatefulWidget {
  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  QuestionnaireSchema? schema;
  QuestionnaireResponses responses = QuestionnaireResponses();
  bool showWelcome = true;
  
  @override
  void initState() {
    super.initState();
    _loadSchema();
  }
  
  Future<void> _loadSchema() async {
    // Step 1: Load schema from JSON
    final jsonString = await rootBundle.loadString('assets/questionnaire.json');
    final json = jsonDecode(jsonString);
    setState(() {
      schema = QuestionnaireSchema.fromJson(json);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (schema == null) return LoadingScreen();
    
    if (showWelcome) {
      return WelcomeScreen(
        welcome: schema!.welcome,
        onStart: () => setState(() => showWelcome = false),
      );
    }
    
    return QuestionFlow(
      schema: schema!,
      responses: responses,
      onAnswerChanged: (questionId, value) {
        setState(() {
          responses.setAnswer(questionId, value);
        });
      },
    );
  }
}
```

### 📱 **Question Flow Widget**
```dart
class QuestionFlow extends StatelessWidget {
  final QuestionnaireSchema schema;
  final QuestionnaireResponses responses;
  final Function(String, dynamic) onAnswerChanged;
  
  @override
  Widget build(BuildContext context) {
    final currentSection = schema.sections[responses.currentSectionIndex];
    final currentQuestion = currentSection.questions[responses.currentQuestionIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(currentSection.title),
        // Simple progress: "Question 3 of 12"
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: _getProgress(),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Question text
            Text(
              currentQuestion.text,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 24),
            
            // Input widget based on type
            Expanded(
              child: _buildInputWidget(currentQuestion),
            ),
            
            // Navigation buttons
            Row(
              children: [
                if (responses.currentQuestionIndex > 0 || responses.currentSectionIndex > 0)
                  TextButton(
                    onPressed: _goToPreviousQuestion,
                    child: Text('Back'),
                  ),
                Spacer(),
                ElevatedButton(
                  onPressed: _canGoNext() ? _goToNextQuestion : null,
                  child: Text(_isLastQuestion() ? 'Complete' : 'Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInputWidget(Question question) {
    switch (question.inputType) {
      case 'text':
        return TextFormField(
          initialValue: responses.getAnswer(question.id)?.toString(),
          onChanged: (value) => onAnswerChanged(question.id, value),
          decoration: InputDecoration(
            hintText: 'Enter your answer...',
          ),
        );
      
      case 'number':
        return TextFormField(
          initialValue: responses.getAnswer(question.id)?.toString(),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final number = int.tryParse(value);
            if (number != null) {
              onAnswerChanged(question.id, number);
            }
          },
        );
      
      case 'radio':
        return Column(
          children: question.options!.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: responses.getAnswer(question.id),
              onChanged: (value) => onAnswerChanged(question.id, value),
            );
          }).toList(),
        );
      
      case 'multiselect':
        final selectedOptions = responses.getAnswer(question.id) as List<String>? ?? [];
        return Column(
          children: question.options!.map((option) {
            return CheckboxListTile(
              title: Text(option),
              value: selectedOptions.contains(option),
              onChanged: (checked) {
                List<String> newSelection = List.from(selectedOptions);
                if (checked == true) {
                  newSelection.add(option);
                } else {
                  newSelection.remove(option);
                }
                onAnswerChanged(question.id, newSelection);
              },
            );
          }).toList(),
        );
      
      default:
        return Text('Unsupported question type: ${question.inputType}');
    }
  }
}
```

---

## Step 4: Navigation Logic

### ➡️ **Simple Navigation Methods**
```dart
class _QuestionFlowState extends State<QuestionFlow> {
  
  bool _canGoNext() {
    final currentSection = widget.schema.sections[widget.responses.currentSectionIndex];
    final currentQuestion = currentSection.questions[widget.responses.currentQuestionIndex];
    
    if (currentQuestion.required) {
      return widget.responses.isQuestionAnswered(currentQuestion.id);
    }
    return true; // Optional questions can be skipped
  }
  
  void _goToNextQuestion() {
    setState(() {
      final currentSection = widget.schema.sections[widget.responses.currentSectionIndex];
      
      if (widget.responses.currentQuestionIndex < currentSection.questions.length - 1) {
        // Next question in same section
        widget.responses.currentQuestionIndex++;
      } else if (widget.responses.currentSectionIndex < widget.schema.sections.length - 1) {
        // Next section
        widget.responses.currentSectionIndex++;
        widget.responses.currentQuestionIndex = 0;
      } else {
        // Questionnaire complete
        _completeQuestionnaire();
      }
    });
  }
  
  void _goToPreviousQuestion() {
    setState(() {
      if (widget.responses.currentQuestionIndex > 0) {
        // Previous question in same section
        widget.responses.currentQuestionIndex--;
      } else if (widget.responses.currentSectionIndex > 0) {
        // Previous section
        widget.responses.currentSectionIndex--;
        widget.responses.currentQuestionIndex = 
            widget.schema.sections[widget.responses.currentSectionIndex].questions.length - 1;
      }
    });
  }
  
  bool _isLastQuestion() {
    return widget.responses.currentSectionIndex == widget.schema.sections.length - 1 &&
           widget.responses.currentQuestionIndex == 
           widget.schema.sections[widget.responses.currentSectionIndex].questions.length - 1;
  }
  
  double _getProgress() {
    int totalQuestions = widget.schema.sections
        .map((s) => s.questions.length)
        .reduce((a, b) => a + b);
    
    int answeredQuestions = 0;
    for (int i = 0; i < widget.responses.currentSectionIndex; i++) {
      answeredQuestions += widget.schema.sections[i].questions.length;
    }
    answeredQuestions += widget.responses.currentQuestionIndex;
    
    return answeredQuestions / totalQuestions;
  }
  
  void _completeQuestionnaire() {
    // Show completion screen or navigate away
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CompletionScreen(responses: widget.responses),
      ),
    );
  }
}
```

---

## Complete File Structure (Simplified)

```
lib/features/onboarding/
├── models/
│   ├── questionnaire_schema.dart    # Schema + Question models
│   └── questionnaire_responses.dart # Response storage
├── screens/
│   ├── questionnaire_screen.dart    # Main orchestrator
│   ├── welcome_screen.dart          # Welcome UI
│   ├── question_flow.dart           # Question display + navigation
│   └── completion_screen.dart       # Results/completion
└── assets/
    └── questionnaire.json           # Schema definition
```

---

## Implementation Steps

### 🚀 **Week 1: Core Functionality**
1. Create basic models (Schema, Responses)
2. Build JSON loader
3. Create welcome screen
4. Implement text + number inputs

### 📱 **Week 2: Complete MVP**
5. Add radio + multiselect inputs
6. Implement navigation (next/back)
7. Add progress indicator
8. Create completion screen

### ✨ **Week 3: Polish**
9. Add validation messages
10. Improve UI styling
11. Add loading states
12. Test on different screen sizes

---

## Key Benefits of This Approach

### ✅ **Simple & Clear**
- Only 4 core classes
- Straightforward data flow
- No complex state management
- Easy to understand and modify

### ✅ **Extensible**
- JSON schema can be modified without code changes
- New input types can be added to switch statement
- Backend API integration is just changing the JSON loader

### ✅ **Fast Development**
- Can build MVP in 1-2 weeks
- No over-engineering
- Focus on user experience

### ✅ **Maintainable**
- Clear separation of concerns
- Minimal dependencies
- Simple debugging

This simplified approach gives you exactly what you need: load schema, display questions, collect responses, navigate through sections. Nothing more, nothing less!