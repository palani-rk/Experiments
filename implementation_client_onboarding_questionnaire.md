# Flutter Implementation: Client Onboarding Questionnaire Code Samples

**Generated**: 2025-09-21
**Companion to**: design_spec_client_onboarding_questionnaire_clean.md
**Flutter Version**: >=3.0.0
**Riverpod Version**: ^2.4.9

This file contains all the code samples and implementation details for the Client Onboarding Questionnaire feature.

---

# STATE MANAGEMENT IMPLEMENTATION

## Riverpod Providers

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'questionnaire_provider.g.dart';

@riverpod
class QuestionnaireNotifier extends _$QuestionnaireNotifier {
  @override
  Future<QuestionnaireState> build() async {
    // Load saved state if exists
    final savedState = await _loadSavedState();
    return savedState ?? const QuestionnaireState.initial();
  }

  Future<void> answerQuestion(String questionId, dynamic answer) async {
    final currentState = state.value;
    if (currentState == null) return;

    // Update responses
    final updatedResponses = Map<String, dynamic>.from(currentState.responses);
    updatedResponses[questionId] = answer;

    // Calculate next question based on conditional logic
    final nextQuestion = _calculateNextQuestion(questionId, answer, updatedResponses);

    // Update state
    final updatedState = currentState.copyWith(
      responses: updatedResponses,
      currentQuestionId: nextQuestion?.id,
      currentSectionIndex: nextQuestion?.sectionIndex ?? currentState.currentSectionIndex,
      isCompleted: nextQuestion == null,
    );

    state = AsyncValue.data(updatedState);

    // Persist state
    await _saveState(updatedState);

    // Auto-advance if section completed
    if (_isSectionCompleted(updatedState)) {
      await _advanceToNextSection();
    }
  }

  Future<void> editResponse(String questionId, dynamic newAnswer) async {
    final currentState = state.value;
    if (currentState == null) return;

    final updatedResponses = Map<String, dynamic>.from(currentState.responses);
    updatedResponses[questionId] = newAnswer;

    // Recalculate flow from this point
    final updatedState = _recalculateFromQuestion(questionId, updatedResponses);

    state = AsyncValue.data(updatedState);
    await _saveState(updatedState);
  }

  Future<void> submitQuestionnaire() async {
    final currentState = state.value;
    if (currentState == null || !currentState.isCompleted) return;

    state = const AsyncValue.loading();

    try {
      // Submit to backend
      await _submitResponses(currentState.responses);

      // Clear saved state after successful submission
      await _clearSavedState();

      state = AsyncValue.data(currentState.copyWith(isSubmitted: true));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Question? _calculateNextQuestion(String currentQuestionId, dynamic answer, Map<String, dynamic> responses) {
    final questions = QuestionnaireData.questions;
    final currentIndex = questions.indexWhere((q) => q.id == currentQuestionId);

    if (currentIndex == -1 || currentIndex >= questions.length - 1) {
      return null; // No more questions
    }

    // Check for conditional logic on next questions
    for (int i = currentIndex + 1; i < questions.length; i++) {
      final question = questions[i];
      if (_shouldShowQuestion(question, responses)) {
        return question;
      }
    }

    return null;
  }

  bool _shouldShowQuestion(Question question, Map<String, dynamic> responses) {
    if (question.conditionalLogic == null) return true;

    final condition = question.conditionalLogic!;
    final dependentAnswer = responses[condition.dependsOnQuestionId];

    return condition.showIfValues.contains(dependentAnswer);
  }

  Future<QuestionnaireState?> _loadSavedState() async {
    // Implementation with shared_preferences
    return null; // Placeholder
  }

  Future<void> _saveState(QuestionnaireState state) async {
    // Implementation with shared_preferences
  }
}

@riverpod
Question? currentQuestion(CurrentQuestionRef ref) {
  final state = ref.watch(questionnaireProvider).value;
  if (state?.currentQuestionId == null) return null;

  return QuestionnaireData.questions
      .where((q) => q.id == state!.currentQuestionId)
      .firstOrNull;
}

@riverpod
Map<String, dynamic> responses(ResponsesRef ref) {
  return ref.watch(questionnaireProvider).value?.responses ?? {};
}

@riverpod
ProgressInfo progress(ProgressRef ref) {
  final state = ref.watch(questionnaireProvider).value;
  if (state == null) return const ProgressInfo.initial();

  final totalQuestions = QuestionnaireData.questions.length;
  final answeredCount = state.responses.length;

  return ProgressInfo(
    currentSection: state.currentSectionIndex,
    totalSections: 4,
    overallProgress: answeredCount / totalQuestions,
    sectionProgress: _calculateSectionProgress(state),
  );
}
```

---

# DATA MODELS

## Freezed Models

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'questionnaire_models.freezed.dart';
part 'questionnaire_models.g.dart';

@freezed
class QuestionnaireState with _$QuestionnaireState {
  const factory QuestionnaireState({
    String? currentQuestionId,
    @Default(0) int currentSectionIndex,
    @Default({}) Map<String, dynamic> responses,
    @Default(false) bool isCompleted,
    @Default(false) bool isSubmitted,
  }) = _QuestionnaireState;

  const factory QuestionnaireState.initial() = _QuestionnaireStateInitial;

  factory QuestionnaireState.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireStateFromJson(json);
}

@freezed
class Question with _$Question {
  const factory Question({
    required String id,
    required String sectionId,
    required int sectionIndex,
    required String questionText,
    required InputType inputType,
    @Default(true) bool required,
    List<String>? options,
    ConditionalLogic? conditionalLogic,
    ValidationRules? validation,
    String? placeholder,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}

enum InputType {
  @JsonValue('text_input')
  textInput,
  @JsonValue('text_area')
  textArea,
  @JsonValue('number_input')
  numberInput,
  @JsonValue('single_select')
  singleSelect,
  @JsonValue('multi_select')
  multiSelect,
  @JsonValue('unit_selector')
  unitSelector,
  @JsonValue('timeframe_select')
  timeframeSelect,
}

@freezed
class ConditionalLogic with _$ConditionalLogic {
  const factory ConditionalLogic({
    required String dependsOnQuestionId,
    required List<dynamic> showIfValues,
  }) = _ConditionalLogic;

  factory ConditionalLogic.fromJson(Map<String, dynamic> json) =>
      _$ConditionalLogicFromJson(json);
}

@freezed
class ValidationRules with _$ValidationRules {
  const factory ValidationRules({
    int? minLength,
    int? maxLength,
    num? min,
    num? max,
    String? pattern,
  }) = _ValidationRules;

  factory ValidationRules.fromJson(Map<String, dynamic> json) =>
      _$ValidationRulesFromJson(json);
}

@freezed
class BrandingConfig with _$BrandingConfig {
  const factory BrandingConfig({
    required String clinicName,
    required String nutritionistName,
    String? logoUrl,
    @Default(Color(0xFF2196F3)) Color primaryColor,
    @Default(Color(0xFF4CAF50)) Color secondaryColor,
  }) = _BrandingConfig;

  factory BrandingConfig.fromJson(Map<String, dynamic> json) =>
      _$BrandingConfigFromJson(json);
}

@freezed
class ProgressInfo with _$ProgressInfo {
  const factory ProgressInfo({
    required int currentSection,
    required int totalSections,
    required double overallProgress,
    required double sectionProgress,
  }) = _ProgressInfo;

  const factory ProgressInfo.initial() = _ProgressInfoInitial;
}
```

## Question Data Constants

```dart
// Questionnaire data constants
class QuestionnaireData {
  static const List<Question> questions = [
    // Personal Info Section
    Question(
      id: 'Q1',
      sectionId: 'personal_info',
      sectionIndex: 0,
      questionText: "What's your full name?",
      inputType: InputType.textInput,
      validation: ValidationRules(minLength: 2, maxLength: 100),
    ),
    Question(
      id: 'Q2',
      sectionId: 'personal_info',
      sectionIndex: 0,
      questionText: "How old are you?",
      inputType: InputType.numberInput,
      validation: ValidationRules(min: 18, max: 100),
    ),
    Question(
      id: 'Q3',
      sectionId: 'personal_info',
      sectionIndex: 0,
      questionText: "What's your current weight?",
      inputType: InputType.numberInput,
      validation: ValidationRules(min: 30, max: 500),
    ),
    Question(
      id: 'Q4',
      sectionId: 'personal_info',
      sectionIndex: 0,
      questionText: "And your height?",
      inputType: InputType.numberInput,
      validation: ValidationRules(min: 100, max: 250),
    ),

    // Goals Section
    Question(
      id: 'Q5',
      sectionId: 'goals',
      sectionIndex: 1,
      questionText: "What's your main health goal?",
      inputType: InputType.singleSelect,
      options: [
        'Lose weight',
        'Gain weight',
        'Build muscle',
        'Improve energy',
        'Manage medical condition',
        'General wellness',
        'Other'
      ],
    ),
    Question(
      id: 'Q6',
      sectionId: 'goals',
      sectionIndex: 1,
      questionText: "How much would you like to lose?",
      inputType: InputType.numberInput,
      conditionalLogic: ConditionalLogic(
        dependsOnQuestionId: 'Q5',
        showIfValues: ['Lose weight'],
      ),
      validation: ValidationRules(min: 1, max: 100),
    ),
    Question(
      id: 'Q7',
      sectionId: 'goals',
      sectionIndex: 1,
      questionText: "What's your biggest motivation right now?",
      inputType: InputType.multiSelect,
      options: [
        'Feel more confident',
        'Improve health numbers',
        'Have more energy',
        'Set good example for family',
        "Doctor's recommendation",
        'Other'
      ],
    ),

    // Health Background Section
    Question(
      id: 'Q8',
      sectionId: 'health_background',
      sectionIndex: 2,
      questionText: "Do you have any medical conditions?",
      inputType: InputType.multiSelect,
      options: [
        'None',
        'Diabetes',
        'High blood pressure',
        'Heart disease',
        'Thyroid issues',
        'Food allergies',
        'Other'
      ],
    ),
    Question(
      id: 'Q9',
      sectionId: 'health_background',
      sectionIndex: 2,
      questionText: "Are you taking any medications?",
      inputType: InputType.textArea,
      conditionalLogic: ConditionalLogic(
        dependsOnQuestionId: 'Q8',
        showIfValues: ['Diabetes', 'High blood pressure', 'Heart disease', 'Thyroid issues', 'Other'],
      ),
      placeholder: 'List any medications or supplements...',
    ),
    Question(
      id: 'Q10',
      sectionId: 'health_background',
      sectionIndex: 2,
      questionText: "Any foods you absolutely cannot or will not eat?",
      inputType: InputType.multiSelect,
      options: [
        'No restrictions',
        'Vegetarian',
        'Vegan',
        'Gluten-free',
        'Dairy-free',
        'Nut allergies',
        'Religious restrictions',
        'Other'
      ],
    ),

    // Lifestyle Section
    Question(
      id: 'Q11',
      sectionId: 'lifestyle',
      sectionIndex: 3,
      questionText: "How would you describe your activity level?",
      inputType: InputType.singleSelect,
      options: [
        'Sedentary (desk job, little exercise)',
        'Lightly active (light exercise 1-3 days/week)',
        'Moderately active (moderate exercise 3-5 days/week)',
        'Very active (hard exercise 6-7 days/week)'
      ],
    ),
    Question(
      id: 'Q12',
      sectionId: 'lifestyle',
      sectionIndex: 3,
      questionText: "How often do you cook at home?",
      inputType: InputType.singleSelect,
      options: [
        'Daily',
        '4-6 times/week',
        '2-3 times/week',
        'Once a week',
        'Rarely/Never'
      ],
    ),
    Question(
      id: 'Q13',
      sectionId: 'lifestyle',
      sectionIndex: 3,
      questionText: "What's your biggest challenge with eating healthy?",
      inputType: InputType.multiSelect,
      options: [
        'No time to cook',
        "Don't know what to eat",
        'Eating out too much',
        'Late night snacking',
        'Emotional eating',
        'Budget constraints',
        'Family preferences'
      ],
    ),
  ];

  static const Map<String, String> sectionCompletionMessages = {
    'personal_info': "Great! Personal info complete ✅ Now let's talk about what you want to achieve.",
    'goals': "Love your motivation! 💪 Now let's understand your health background.",
    'health_background': "Thanks for sharing! Almost done - just your lifestyle habits left 🏃‍♀️",
    'lifestyle': "Amazing work! 🎉 You're all done. [NUTRITIONIST_NAME] will review your responses and create your personalized plan. You'll hear back within 24-48 hours!",
  };
}
```

---

# WIDGET IMPLEMENTATIONS

## Welcome Screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Welcome Screen
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branding = ref.watch(brandingProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Branding Header
              BrandingHeader(config: branding),

              const SizedBox(height: 32),

              // Welcome Content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hi ${branding.clientName ?? "there"}! 👋',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "I'm here to help ${branding.nutritionistName} create the perfect nutrition plan for you.",
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Time estimate card
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              'This will take just 5-10 minutes and covers 4 areas:',
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            const _TimeEstimateList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => context.push('/questionnaire'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: branding.primaryColor,
                      ),
                      child: const Text(
                        "Yes, let's do this!",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _showInfoDialog(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('I have questions first'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About This Questionnaire'),
        content: const Text(
          'This questionnaire helps your nutritionist understand your goals, health background, and lifestyle to create a personalized nutrition plan. All information is kept confidential and secure.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class _TimeEstimateList extends StatelessWidget {
  const _TimeEstimateList();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Personal Info', '2 mins'),
      ('Your Goals', '2 mins'),
      ('Health Background', '3 mins'),
      ('Lifestyle', '3 mins'),
    ];

    return Column(
      children: items.map((item) =>
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(item.$1, style: Theme.of(context).textTheme.bodyMedium),
              ),
              Text(
                item.$2,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ).toList(),
    );
  }
}
```

## Questionnaire Screen

```dart
// Questionnaire Screen
class QuestionnaireScreen extends ConsumerWidget {
  const QuestionnaireScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionnaireAsync = ref.watch(questionnaireProvider);
    final progress = ref.watch(progressProvider);
    final branding = ref.watch(brandingProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Nutrition Plan Questionnaire'),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _handleBackPress(context, ref),
        ),
      ),
      body: questionnaireAsync.when(
        data: (state) => Column(
          children: [
            // Progress Indicator
            ProgressIndicator(progress: progress, branding: branding),

            // Chat Interface
            Expanded(
              child: ChatInterface(
                state: state,
                onAnswer: (questionId, answer) =>
                    ref.read(questionnaireProvider.notifier).answerQuestion(questionId, answer),
                onEdit: (questionId, newAnswer) =>
                    ref.read(questionnaireProvider.notifier).editResponse(questionId, newAnswer),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: ErrorDisplay(
            error: error,
            onRetry: () => ref.invalidate(questionnaireProvider),
          ),
        ),
      ),
    );
  }

  void _handleBackPress(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Questionnaire?'),
        content: const Text('Your progress will be saved and you can continue later.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }
}
```

## Chat Interface

```dart
// Chat Interface Component
class ChatInterface extends StatefulWidget {
  final QuestionnaireState state;
  final Function(String, dynamic) onAnswer;
  final Function(String, dynamic) onEdit;

  const ChatInterface({
    super.key,
    required this.state,
    required this.onAnswer,
    required this.onEdit,
  });

  @override
  State<ChatInterface> createState() => _ChatInterfaceState();
}

class _ChatInterfaceState extends State<ChatInterface> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chat History
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _buildChatItems().length,
            itemBuilder: (context, index) => _buildChatItems()[index],
          ),
        ),

        // Current Question Input
        if (!widget.state.isCompleted) _buildCurrentQuestionInput(),
      ],
    );
  }

  List<Widget> _buildChatItems() {
    final items = <Widget>[];
    final groupedBySection = <String, List<Question>>{};

    // Group answered questions by section
    for (final question in QuestionnaireData.questions) {
      if (widget.state.responses.containsKey(question.id)) {
        groupedBySection.putIfAbsent(question.sectionId, () => []).add(question);
      }
    }

    // Build chat items for each section
    for (final section in groupedBySection.keys) {
      items.add(_buildSectionHeader(section));

      for (final question in groupedBySection[section]!) {
        items.add(_buildQuestionBubble(question));
        items.add(_buildAnswerBubble(question, widget.state.responses[question.id]!));
      }

      // Add completion message if section is done
      if (_isSectionComplete(section)) {
        items.add(_buildCompletionMessage(section));
      }
    }

    return items;
  }

  Widget _buildSectionHeader(String sectionId) {
    final sectionNames = {
      'personal_info': 'PERSONAL INFO',
      'goals': 'YOUR GOALS',
      'health_background': 'HEALTH BACKGROUND',
      'lifestyle': 'LIFESTYLE',
    };

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        sectionNames[sectionId] ?? sectionId.toUpperCase(),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildQuestionBubble(Question question) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, right: 64),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🤖', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                question.questionText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerBubble(Question question, dynamic answer) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 64),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('👤', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _formatAnswer(answer, question.inputType),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _editResponse(question),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentQuestionInput() {
    // Implementation for current question input interface
    // This would include form fields, validation, and submit buttons
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: const QuestionInputWidget(), // Custom input widget based on question type
    );
  }

  String _formatAnswer(dynamic answer, InputType inputType) {
    switch (inputType) {
      case InputType.multiSelect:
        if (answer is List) {
          return answer.join(', ');
        }
        return answer.toString();
      default:
        return answer.toString();
    }
  }

  void _editResponse(Question question) {
    // Show edit dialog or inline editing
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => EditResponseSheet(
        question: question,
        currentAnswer: widget.state.responses[question.id],
        onSave: (newAnswer) => widget.onEdit(question.id, newAnswer),
      ),
    );
  }

  bool _isSectionComplete(String sectionId) {
    final sectionQuestions = QuestionnaireData.questions
        .where((q) => q.sectionId == sectionId)
        .toList();

    return sectionQuestions.every((q) => widget.state.responses.containsKey(q.id));
  }
}
```

## Completion Screen

```dart
// Completion Screen
class CompletionScreen extends ConsumerWidget {
  const CompletionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responses = ref.watch(responsesProvider);
    final branding = ref.watch(brandingProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Questionnaire Complete'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Completion Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text(
                    'Amazing work!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: branding.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You're all done. ${branding.nutritionistName} will review your responses and create your personalized plan.",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Text(
                      "You'll hear back within 24-48 hours!",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Response Summary
            ResponsesSummaryWidget(responses: responses),

            const SizedBox(height: 32),

            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _submitQuestionnaire(context, ref),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: branding.primaryColor,
                    ),
                    child: const Text(
                      'Send to Nutritionist',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _viewResponses(context, responses),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('View My Responses'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitQuestionnaire(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(questionnaireProvider.notifier).submitQuestionnaire();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Questionnaire submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to home or thank you page
        context.go('/');
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _viewResponses(BuildContext context, Map<String, dynamic> responses) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => ResponsesDetailSheet(
          responses: responses,
          scrollController: scrollController,
        ),
      ),
    );
  }
}
```

---

# NAVIGATION & ROUTING

## Go Router Configuration

```dart
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/questionnaire',
        builder: (context, state) => const QuestionnaireScreen(),
      ),
      GoRoute(
        path: '/completion',
        builder: (context, state) => const CompletionScreen(),
        redirect: (context, state) {
          // Ensure questionnaire is completed before accessing
          final questionnaireState = ref.read(questionnaireProvider).value;
          if (questionnaireState?.isCompleted != true) {
            return '/questionnaire';
          }
          return null;
        },
      ),
    ],
  );
}
```

---

# VALIDATION IMPLEMENTATION

## Question Validator

```dart
class QuestionValidator {
  static String? validate(Question question, dynamic value) {
    if (question.required && (value == null || value.toString().isEmpty)) {
      return 'This field is required';
    }

    final validation = question.validation;
    if (validation == null) return null;

    switch (question.inputType) {
      case InputType.textInput:
      case InputType.textArea:
        return _validateText(value?.toString() ?? '', validation);
      case InputType.numberInput:
        return _validateNumber(value, validation);
      case InputType.multiSelect:
        return _validateMultiSelect(value, validation, question.required);
      default:
        return null;
    }
  }

  static String? _validateText(String value, ValidationRules rules) {
    if (rules.minLength != null && value.length < rules.minLength!) {
      return 'Please enter at least ${rules.minLength} characters';
    }
    if (rules.maxLength != null && value.length > rules.maxLength!) {
      return 'Maximum ${rules.maxLength} characters allowed';
    }
    if (rules.pattern != null) {
      final regex = RegExp(rules.pattern!);
      if (!regex.hasMatch(value)) {
        return 'Please enter a valid format';
      }
    }
    return null;
  }

  static String? _validateNumber(dynamic value, ValidationRules rules) {
    final num? number = num.tryParse(value?.toString() ?? '');
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (rules.min != null && number < rules.min!) {
      return 'Please enter a number greater than or equal to ${rules.min}';
    }
    if (rules.max != null && number > rules.max!) {
      return 'Please enter a number less than or equal to ${rules.max}';
    }
    return null;
  }

  static String? _validateMultiSelect(dynamic value, ValidationRules rules, bool required) {
    if (required && (value == null || (value is List && value.isEmpty))) {
      return 'Please select at least one option';
    }
    return null;
  }
}
```

---

# UTILITY COMPONENTS

## Input Widgets

```dart
// Question Input Widget - Dynamic based on question type
class QuestionInputWidget extends StatefulWidget {
  final Question question;
  final dynamic initialValue;
  final Function(dynamic) onSubmit;

  const QuestionInputWidget({
    super.key,
    required this.question,
    this.initialValue,
    required this.onSubmit,
  });

  @override
  State<QuestionInputWidget> createState() => _QuestionInputWidgetState();
}

class _QuestionInputWidgetState extends State<QuestionInputWidget> {
  late final TextEditingController _textController;
  late dynamic _currentValue;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _textController = TextEditingController(
      text: widget.initialValue?.toString() ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.question.inputType) {
      case InputType.textInput:
        return _buildTextInput();
      case InputType.textArea:
        return _buildTextArea();
      case InputType.numberInput:
        return _buildNumberInput();
      case InputType.singleSelect:
        return _buildSingleSelect();
      case InputType.multiSelect:
        return _buildMultiSelect();
      default:
        return _buildTextInput();
    }
  }

  Widget _buildTextInput() {
    return Column(
      children: [
        TextFormField(
          controller: _textController,
          decoration: InputDecoration(
            hintText: widget.question.placeholder,
            errorText: _errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) => _currentValue = value,
        ),
        const SizedBox(height: 16),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildNumberInput() {
    return Column(
      children: [
        TextFormField(
          controller: _textController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: widget.question.placeholder,
            errorText: _errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) => _currentValue = num.tryParse(value),
        ),
        const SizedBox(height: 16),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildSingleSelect() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: widget.question.options!.map((option) =>
              RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: _currentValue,
                onChanged: (value) => setState(() => _currentValue = value),
              ),
            ).toList(),
          ),
        ),
        const SizedBox(height: 16),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildMultiSelect() {
    final selectedValues = (_currentValue as List<String>?) ?? <String>[];

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: widget.question.options!.map((option) =>
              CheckboxListTile(
                title: Text(option),
                value: selectedValues.contains(option),
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      selectedValues.add(option);
                    } else {
                      selectedValues.remove(option);
                    }
                    _currentValue = selectedValues;
                  });
                },
              ),
            ).toList(),
          ),
        ),
        const SizedBox(height: 16),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildTextArea() {
    return Column(
      children: [
        TextFormField(
          controller: _textController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: widget.question.placeholder,
            errorText: _errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) => _currentValue = value,
        ),
        const SizedBox(height: 16),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: _canSubmit() ? _handleSubmit : null,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('Continue'),
      ),
    );
  }

  bool _canSubmit() {
    if (widget.question.required &&
        (_currentValue == null || _currentValue.toString().isEmpty)) {
      return false;
    }

    final validationError = QuestionValidator.validate(widget.question, _currentValue);
    return validationError == null;
  }

  void _handleSubmit() {
    final validationError = QuestionValidator.validate(widget.question, _currentValue);

    if (validationError != null) {
      setState(() => _errorText = validationError);
      return;
    }

    setState(() => _errorText = null);
    widget.onSubmit(_currentValue);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
```

## Progress Indicator

```dart
class ProgressIndicator extends StatelessWidget {
  final ProgressInfo progress;
  final BrandingConfig branding;

  const ProgressIndicator({
    super.key,
    required this.progress,
    required this.branding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getSectionName(progress.currentSection),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(progress.overallProgress * 100).round()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: branding.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress.overallProgress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(branding.primaryColor),
          ),
        ],
      ),
    );
  }

  String _getSectionName(int sectionIndex) {
    const sectionNames = [
      'Personal Info',
      'Your Goals',
      'Health Background',
      'Lifestyle',
    ];
    return sectionNames[sectionIndex] ?? 'Section ${sectionIndex + 1}';
  }
}
```

---

This implementation file provides all the code samples needed to build the client onboarding questionnaire feature. The code follows Flutter best practices and uses modern Riverpod patterns for state management.