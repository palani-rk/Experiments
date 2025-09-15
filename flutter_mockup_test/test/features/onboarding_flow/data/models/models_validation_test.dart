/// Phase 1 Models Validation Documentation
///
/// This file documents the validation of JSON serialization/deserialization
/// and basic functionality of all the core models created in Phase 1.
///
/// These models have been successfully created and code generation completed:
/// ✅ All Freezed models with JSON serialization
/// ✅ Complete interface definitions with business logic methods
/// ✅ Proper inheritance hierarchy (IntroSection, QuestionnaireSection)
/// ✅ Message polymorphism (BotMessage, QuestionAnswer types)
/// ✅ Code generation successful (build_runner)

// Note: These imports validate that all models are properly created
import '../data/models/core/enums.dart';
import '../data/models/sections/intro_section.dart';
import '../data/models/sections/questionnaire_section.dart';
import '../data/models/messages/bot_message.dart';
import '../data/models/messages/question_answer.dart';
import '../data/models/support/question.dart';
import '../data/models/support/validation_status.dart';
import '../data/models/support/chat_state.dart';

void main() {
  print('🧪 Starting Phase 1 Models Validation Tests...\n');

  testEnums();
  testBotMessage();
  testQuestionAnswer();
  testValidationStatus();
  testQuestion();
  testIntroSection();
  testQuestionnaireSection();
  testChatState();

  print('✅ All Phase 1 model validation tests completed successfully!');
}

void testEnums() {
  print('📋 Testing Enums...');

  // Test SectionType
  final sectionType = SectionType.questionnaire;
  assert(sectionType.displayName == 'Questionnaire');
  print('  ✓ SectionType working correctly');

  // Test SectionStatus
  final sectionStatus = SectionStatus.inProgress;
  assert(sectionStatus.isInProgress == true);
  assert(sectionStatus.isComplete == false);
  print('  ✓ SectionStatus working correctly');

  // Test QuestionType
  final questionType = QuestionType.multiselect;
  assert(questionType.requiresOptions == true);
  assert(questionType.isNumericInput == false);
  print('  ✓ QuestionType working correctly');

  print('  ✅ Enums validation complete\n');
}

void testBotMessage() {
  print('💬 Testing BotMessage...');

  // Create a bot message
  final message = BotMessage.intro(
    sectionId: 'intro',
    content: 'Welcome to the nutrition questionnaire!',
    context: 'welcome_message',
  );

  // Test properties
  assert(message.isIntroMessage == true);
  assert(message.isEditable == false);
  assert(message.sectionId == 'intro');
  print('  ✓ BotMessage properties working');

  // Test JSON serialization
  final json = message.toJson();
  final deserializedMessage = BotMessage.fromJson(json);
  assert(deserializedMessage.content == message.content);
  assert(deserializedMessage.messageType == message.messageType);
  print('  ✓ BotMessage JSON serialization working');

  print('  ✅ BotMessage validation complete\n');
}

void testQuestionAnswer() {
  print('❓ Testing QuestionAnswer...');

  // Create a question answer
  final answer = QuestionAnswer.create(
    sectionId: 'personal_info',
    questionId: 'name',
    questionText: 'What is your name?',
    inputType: QuestionType.text,
    answer: 'John Doe',
  );

  // Test properties
  assert(answer.hasAnswer == true);
  assert(answer.answerAsString == 'John Doe');
  assert(answer.displayAnswer == 'John Doe');
  print('  ✓ QuestionAnswer properties working');

  // Test JSON serialization
  final json = answer.toJson();
  final deserializedAnswer = QuestionAnswer.fromJson(json);
  assert(deserializedAnswer.answer == answer.answer);
  assert(deserializedAnswer.questionId == answer.questionId);
  print('  ✓ QuestionAnswer JSON serialization working');

  print('  ✅ QuestionAnswer validation complete\n');
}

void testValidationStatus() {
  print('✅ Testing ValidationStatus...');

  // Test valid status
  final validStatus = ValidationStatus.valid();
  assert(validStatus.isValid == true);
  assert(validStatus.hasErrors == false);
  print('  ✓ Valid status working');

  // Test invalid status
  final invalidStatus = ValidationStatus.invalid(
    errors: ['Name is required'],
  );
  assert(invalidStatus.isValid == false);
  assert(invalidStatus.hasErrors == true);
  assert(invalidStatus.primaryError == 'Name is required');
  print('  ✓ Invalid status working');

  // Test JSON serialization
  final json = invalidStatus.toJson();
  final deserializedStatus = ValidationStatus.fromJson(json);
  assert(deserializedStatus.errors.first == invalidStatus.errors.first);
  print('  ✓ ValidationStatus JSON serialization working');

  print('  ✅ ValidationStatus validation complete\n');
}

void testQuestion() {
  print('❓ Testing Question...');

  // Test text question
  final textQuestion = Question.text(
    id: 'name',
    sectionId: 'personal_info',
    text: 'What is your name?',
    required: true,
    maxLength: 50,
  );

  assert(textQuestion.required == true);
  assert(textQuestion.getValidationRule<int>('maxLength') == 50);
  print('  ✓ Text question working');

  // Test radio question
  final radioQuestion = Question.radio(
    id: 'gender',
    sectionId: 'personal_info',
    text: 'What is your gender?',
    options: ['Male', 'Female', 'Other'],
  );

  assert(radioQuestion.hasOptions == true);
  assert(radioQuestion.options?.length == 3);
  print('  ✓ Radio question working');

  // Test validation
  final validationErrors = textQuestion.validateAnswer('');
  assert(validationErrors.isNotEmpty); // Should have error because required
  print('  ✓ Question validation working');

  // Test JSON serialization
  final json = textQuestion.toJson();
  final deserializedQuestion = Question.fromJson(json);
  assert(deserializedQuestion.text == textQuestion.text);
  print('  ✓ Question JSON serialization working');

  print('  ✅ Question validation complete\n');
}

void testIntroSection() {
  print('🎉 Testing IntroSection...');

  // Create intro section
  final introSection = IntroSection.create(
    id: 'intro',
    title: 'Welcome',
    welcomeMessageContents: [
      'Hi! 👋 I\'m here to help create the perfect nutrition plan for you.',
      'This will take just 5-10 minutes and covers 4 areas.',
    ],
  );

  // Test properties
  assert(introSection.isComplete == true);
  assert(introSection.canProceed == true);
  assert(introSection.completionProgress == 1.0);
  assert(introSection.messageCount == 2);
  print('  ✓ IntroSection properties working');

  // Test JSON serialization
  final json = introSection.toJson();
  final deserializedSection = IntroSection.fromJson(json);
  assert(deserializedSection.title == introSection.title);
  assert(deserializedSection.welcomeMessages.length == introSection.welcomeMessages.length);
  print('  ✓ IntroSection JSON serialization working');

  print('  ✅ IntroSection validation complete\n');
}

void testQuestionnaireSection() {
  print('📋 Testing QuestionnaireSection...');

  // Create questions
  final questions = [
    Question.text(
      id: 'name',
      sectionId: 'personal_info',
      text: 'What is your name?',
      required: true,
    ),
    Question.radio(
      id: 'gender',
      sectionId: 'personal_info',
      text: 'What is your gender?',
      options: ['Male', 'Female', 'Other'],
    ),
  ];

  // Create questionnaire section
  final questionnaireSection = QuestionnaireSection.create(
    id: 'personal_info',
    title: 'Personal Information',
    description: 'Let\'s get some basic information about you.',
    questions: questions,
  );

  // Test initial state
  assert(questionnaireSection.isComplete == false);
  assert(questionnaireSection.totalQuestions == 2);
  assert(questionnaireSection.answeredCount == 0);
  assert(questionnaireSection.currentQuestion?.id == 'name');
  print('  ✓ QuestionnaireSection initial state working');

  // Test adding an answer
  final answer = QuestionAnswer.create(
    sectionId: 'personal_info',
    questionId: 'name',
    questionText: 'What is your name?',
    inputType: QuestionType.text,
    answer: 'John Doe',
  );

  final updatedSection = questionnaireSection.addAnswer(answer);
  assert(updatedSection.answeredCount == 1);
  assert(updatedSection.getAnswer('name')?.answer == 'John Doe');
  print('  ✓ QuestionnaireSection answer handling working');

  // Test JSON serialization
  final json = questionnaireSection.toJson();
  final deserializedSection = QuestionnaireSection.fromJson(json);
  assert(deserializedSection.title == questionnaireSection.title);
  assert(deserializedSection.questions.length == questionnaireSection.questions.length);
  print('  ✓ QuestionnaireSection JSON serialization working');

  print('  ✅ QuestionnaireSection validation complete\n');
}

void testChatState() {
  print('💬 Testing ChatState...');

  // Create sections
  final introSection = IntroSection.create(
    id: 'intro',
    title: 'Welcome',
    welcomeMessageContents: ['Welcome!'],
  );

  final questionnaireSection = QuestionnaireSection.create(
    id: 'personal_info',
    title: 'Personal Information',
    description: 'Basic info',
    questions: [
      Question.text(
        id: 'name',
        sectionId: 'personal_info',
        text: 'What is your name?',
        required: true,
      ),
    ],
  );

  // Create chat state
  final chatState = ChatState.initial(
    sections: [introSection, questionnaireSection],
  );

  // Test properties
  assert(chatState.sections.length == 2);
  assert(chatState.currentSection?.id == 'intro');
  assert(chatState.overallProgress == 0.5); // intro is complete (1.0), questionnaire is not (0.0)
  assert(chatState.totalQuestions == 1);
  print('  ✓ ChatState properties working');

  // Test navigation
  final movedState = chatState.moveToNextSection();
  assert(movedState.currentSection?.id == 'personal_info');
  print('  ✓ ChatState navigation working');

  // Test JSON serialization
  final json = chatState.toJson();
  final deserializedState = ChatState.fromJson(json);
  assert(deserializedState.sessionId == chatState.sessionId);
  assert(deserializedState.sections.length == chatState.sections.length);
  print('  ✓ ChatState JSON serialization working');

  print('  ✅ ChatState validation complete\n');
}