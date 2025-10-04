# NutriApp Chat Questionnaire - Riverpod & Widget Design Specification

## 1. Executive Summary

This document provides a comprehensive design specification for implementing Riverpod state management and widget architecture for the NutriApp chat-based questionnaire system. The design follows Clean Architecture principles with reactive state management and follows the existing Simple Chat Questionnaire Service interface.

## 2. Architecture Overview

### 2.1 Layer Structure
```
┌─────────────────────────────────────────┐
│               Presentation              │
│  ┌─────────────┐ ┌─────────────────────┐ │
│  │   Widgets   │ │  Riverpod Providers │ │
│  └─────────────┘ └─────────────────────┘ │
├─────────────────────────────────────────┤
│               Domain                    │
│  ┌─────────────┐ ┌─────────────────────┐ │
│  │  Use Cases  │ │      Models        │ │
│  └─────────────┘ └─────────────────────┘ │
├─────────────────────────────────────────┤
│                Data                     │
│  ┌─────────────┐ ┌─────────────────────┐ │
│  │  Services   │ │   Persistence      │ │
│  └─────────────┘ └─────────────────────┘ │
└─────────────────────────────────────────┘
```

### 2.2 Key Principles
- **Reactive State Management**: Immediate UI updates when state changes
- **KISS Implementation**: Minimal complexity following the simple service interface
- **Type Safety**: Comprehensive type safety with Freezed models
- **Error Handling**: Graceful error handling with AsyncValue
- **Performance**: Efficient rebuilds with granular provider watching

## 3. Riverpod Provider Architecture

### 3.1 Core Providers

#### 3.1.1 Service Provider
```dart
// Core service provider
final simpleChatQuestionnaireServiceProvider = Provider<SimpleChatQuestionnaireService>((ref) {
  final persistenceService = ref.watch(simplePersistenceServiceProvider);
  return SimpleChatQuestionnaireServiceImpl(persistenceService);
});

final simplePersistenceServiceProvider = Provider<SimplePersistenceService>((ref) {
  return LocalSimplePersistenceServiceImpl();
});
```

#### 3.1.2 Chat State Provider
```dart
// Main state provider
final chatStateProvider = StateNotifierProvider<ChatStateNotifier, AsyncValue<ChatState?>>((ref) {
  final service = ref.watch(simpleChatQuestionnaireServiceProvider);
  return ChatStateNotifier(service);
});

// Current section provider
final currentSectionProvider = Provider<ChatSection?>((ref) {
  final asyncState = ref.watch(chatStateProvider);
  return asyncState.when(
    data: (state) => state?.currentSection,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Current question provider
final currentQuestionProvider = Provider<Question?>((ref) {
  final asyncState = ref.watch(chatStateProvider);
  return asyncState.when(
    data: (state) => state?.currentQuestion,
    loading: () => null,
    error: (_, __) => null,
  );
});
```

#### 3.1.3 Progress Providers
```dart
// Progress details provider
final progressDetailsProvider = FutureProvider<ProgressDetails>((ref) async {
  final service = ref.watch(simpleChatQuestionnaireServiceProvider);
  return await service.getProgress();
});

// Completion status provider
final isCompleteProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(simpleChatQuestionnaireServiceProvider);
  return await service.isComplete();
});

// Progress percentage provider
final progressPercentageProvider = Provider<double>((ref) {
  final progress = ref.watch(progressDetailsProvider);
  return progress.when(
    data: (details) => details.overallProgress,
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});
```

#### 3.1.4 Navigation Providers
```dart
// Navigation state provider
final navigationStateProvider = StateNotifierProvider<NavigationStateNotifier, NavigationState>((ref) {
  return NavigationStateNotifier();
});

// Can proceed provider
final canProceedProvider = Provider<bool>((ref) {
  final section = ref.watch(currentSectionProvider);
  return section?.canProceed ?? false;
});
```

### 3.2 State Notifiers

#### 3.2.1 ChatStateNotifier
```dart
class ChatStateNotifier extends StateNotifier<AsyncValue<ChatState?>> {
  final SimpleChatQuestionnaireService _service;

  ChatStateNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadQuestionnaire() async {
    state = const AsyncValue.loading();
    try {
      final chatState = await _service.loadQuestionnaire();
      state = AsyncValue.data(chatState);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadExistingState() async {
    state = const AsyncValue.loading();
    try {
      final existingState = await _service.loadChatState();
      state = AsyncValue.data(existingState);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateAnswer({
    required String messageId,
    required dynamic answer,
  }) async {
    try {
      await _service.updateMessage(messageId: messageId, answer: answer);
      await _refreshState();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> editAnswer({
    required String messageId,
    required dynamic newAnswer,
  }) async {
    try {
      await _service.editMessage(messageId: messageId, newAnswer: newAnswer);
      await _refreshState();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> moveToNext() async {
    try {
      await _service.moveToNext();
      await _refreshState();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> setCurrentPosition({
    required String sectionId,
    required String messageId,
  }) async {
    try {
      await _service.setCurrentPosition(
        sectionId: sectionId,
        messageId: messageId,
      );
      await _refreshState();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> _refreshState() async {
    try {
      final currentState = await _service.getCurrentState();
      state = AsyncValue.data(currentState);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
```

#### 3.2.2 NavigationStateNotifier
```dart
@freezed
class NavigationState with _$NavigationState {
  const factory NavigationState({
    @Default(false) bool isLoading,
    @Default(false) bool canGoBack,
    @Default(false) bool canGoForward,
    String? currentSectionId,
    String? currentMessageId,
  }) = _NavigationState;
}

class NavigationStateNotifier extends StateNotifier<NavigationState> {
  NavigationStateNotifier() : super(const NavigationState());

  void updateNavigation({
    bool? isLoading,
    bool? canGoBack,
    bool? canGoForward,
    String? currentSectionId,
    String? currentMessageId,
  }) {
    state = state.copyWith(
      isLoading: isLoading ?? state.isLoading,
      canGoBack: canGoBack ?? state.canGoBack,
      canGoForward: canGoForward ?? state.canGoForward,
      currentSectionId: currentSectionId ?? state.currentSectionId,
      currentMessageId: currentMessageId ?? state.currentMessageId,
    );
  }
}
```

## 4. Widget Architecture

### 4.1 Widget Hierarchy

```
ChatQuestionnaireScreen
├── ChatAppBar
│   ├── ProgressIndicator
│   └── NavigationActions
├── ChatBody
│   ├── MessagesList
│   │   ├── BotMessageWidget
│   │   └── QuestionAnswerWidget
│   ├── CurrentQuestionWidget
│   └── AnswerInputWidget
├── ChatBottomBar
│   ├── NavigationButtons
│   └── ProgressSummary
└── LoadingOverlay
```

### 4.2 Core Widgets

#### 4.2.1 ChatQuestionnaireScreen
```dart
class ChatQuestionnaireScreen extends ConsumerWidget {
  const ChatQuestionnaireScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatStateProvider);

    return Scaffold(
      appBar: const ChatAppBar(),
      body: chatState.when(
        data: (state) => state != null
          ? const ChatBody()
          : const EmptyStateWidget(),
        loading: () => const LoadingWidget(),
        error: (error, _) => ErrorWidget(error: error),
      ),
      bottomNavigationBar: const ChatBottomBar(),
    );
  }
}
```

#### 4.2.2 ChatAppBar
```dart
class ChatAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressPercentageProvider);
    final section = ref.watch(currentSectionProvider);

    return AppBar(
      title: Text(section?.title ?? 'Questionnaire'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: LinearProgressIndicator(value: progress),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: () => _showProgressDialog(context, ref),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4.0);
}
```

#### 4.2.3 ChatBody
```dart
class ChatBody extends ConsumerWidget {
  const ChatBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section = ref.watch(currentSectionProvider);

    return Column(
      children: [
        Expanded(
          child: MessagesList(section: section),
        ),
        if (section is QuestionnaireSection)
          const CurrentQuestionWidget(),
      ],
    );
  }
}
```

#### 4.2.4 MessagesList
```dart
class MessagesList extends ConsumerWidget {
  final ChatSection? section;

  const MessagesList({super.key, this.section});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (section == null) return const SizedBox.shrink();

    final messages = section!.allMessages;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return message.when(
          bot: (botMessage) => BotMessageWidget(message: botMessage),
          questionAnswer: (qa) => QuestionAnswerWidget(message: qa),
        );
      },
    );
  }
}
```

#### 4.2.5 BotMessageWidget
```dart
class BotMessageWidget extends StatelessWidget {
  final BotMessage message;

  const BotMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.smart_toy, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

#### 4.2.6 QuestionAnswerWidget
```dart
class QuestionAnswerWidget extends ConsumerWidget {
  final QuestionAnswer message;

  const QuestionAnswerWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Question bubble
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.help_outline, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message.questionText,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Answer bubble
          if (message.answer != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 56),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.displayContent,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
```

#### 4.2.7 CurrentQuestionWidget
```dart
class CurrentQuestionWidget extends ConsumerWidget {
  const CurrentQuestionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final question = ref.watch(currentQuestionProvider);
    final chatNotifier = ref.read(chatStateProvider.notifier);

    if (question == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            question.text,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _buildAnswerInput(context, question, chatNotifier),
        ],
      ),
    );
  }

  Widget _buildAnswerInput(
    BuildContext context,
    Question question,
    ChatStateNotifier chatNotifier,
  ) {
    switch (question.inputType) {
      case QuestionType.text:
        return _TextAnswerInput(question: question, notifier: chatNotifier);
      case QuestionType.number:
        return _NumberAnswerInput(question: question, notifier: chatNotifier);
      case QuestionType.singleChoice:
        return _SingleChoiceAnswerInput(question: question, notifier: chatNotifier);
      case QuestionType.multipleChoice:
        return _MultipleChoiceAnswerInput(question: question, notifier: chatNotifier);
      case QuestionType.scale:
        return _ScaleAnswerInput(question: question, notifier: chatNotifier);
      case QuestionType.date:
        return _DateAnswerInput(question: question, notifier: chatNotifier);
    }
  }
}
```

### 4.3 Input Widgets

#### 4.3.1 Text Answer Input
```dart
class _TextAnswerInput extends ConsumerStatefulWidget {
  final Question question;
  final ChatStateNotifier notifier;

  const _TextAnswerInput({required this.question, required this.notifier});

  @override
  ConsumerState<_TextAnswerInput> createState() => _TextAnswerInputState();
}

class _TextAnswerInputState extends ConsumerState<_TextAnswerInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Type your answer...',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: _submitAnswer,
            ),
          ),
          onSubmitted: (_) => _submitAnswer(),
        ),
      ],
    );
  }

  void _submitAnswer() {
    if (_controller.text.trim().isNotEmpty) {
      widget.notifier.updateAnswer(
        messageId: widget.question.id,
        answer: _controller.text.trim(),
      );
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

#### 4.3.2 Single Choice Answer Input
```dart
class _SingleChoiceAnswerInput extends ConsumerWidget {
  final Question question;
  final ChatStateNotifier notifier;

  const _SingleChoiceAnswerInput({required this.question, required this.notifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = question.options ?? [];

    return Column(
      children: options.map((option) {
        return ListTile(
          title: Text(option),
          leading: Radio<String>(
            value: option,
            groupValue: null, // Would need to track current selection
            onChanged: (value) {
              if (value != null) {
                notifier.updateAnswer(
                  messageId: question.id,
                  answer: value,
                );
              }
            },
          ),
        );
      }).toList(),
    );
  }
}
```

### 4.4 Navigation and Progress Widgets

#### 4.4.1 ChatBottomBar
```dart
class ChatBottomBar extends ConsumerWidget {
  const ChatBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canProceed = ref.watch(canProceedProvider);
    final navigationState = ref.watch(navigationStateProvider);
    final chatNotifier = ref.read(chatStateProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          if (navigationState.canGoBack)
            ElevatedButton(
              onPressed: () => _navigateBack(ref),
              child: const Text('Back'),
            ),
          const Spacer(),
          if (canProceed)
            ElevatedButton(
              onPressed: () => chatNotifier.moveToNext(),
              child: const Text('Next'),
            ),
        ],
      ),
    );
  }

  void _navigateBack(WidgetRef ref) {
    // Implementation for navigating back
  }
}
```

## 5. Error Handling Strategy

### 5.1 Error Types
```dart
@freezed
class ChatError with _$ChatError {
  const factory ChatError.network(String message) = NetworkError;
  const factory ChatError.persistence(String message) = PersistenceError;
  const factory ChatError.validation(String message) = ValidationError;
  const factory ChatError.unknown(String message) = UnknownError;
}
```

### 5.2 Error Display Widget
```dart
class ErrorWidget extends ConsumerWidget {
  final Object error;

  const ErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            _getErrorMessage(error),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _retry(ref),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _getErrorMessage(Object error) {
    if (error is ChatError) {
      return error.when(
        network: (message) => 'Network error: $message',
        persistence: (message) => 'Storage error: $message',
        validation: (message) => 'Validation error: $message',
        unknown: (message) => 'Unknown error: $message',
      );
    }
    return error.toString();
  }

  void _retry(WidgetRef ref) {
    ref.read(chatStateProvider.notifier).loadExistingState();
  }
}
```

## 6. Performance Considerations

### 6.1 Provider Optimization
- **Granular Providers**: Separate providers for different aspects (progress, navigation, current question)
- **Selective Watching**: Widgets watch only the specific providers they need
- **Caching**: Use `family` modifiers for caching based on IDs

### 6.2 Widget Optimization
- **ConsumerWidget**: Use `ConsumerWidget` for reactive widgets
- **const Constructors**: Use const constructors where possible
- **Key Management**: Proper key management for list items

### 6.3 Memory Management
- **Dispose Logic**: Proper disposal of controllers and listeners
- **State Cleanup**: Clean up state when not needed
- **Image Caching**: Efficient image caching for media content

## 7. Testing Strategy

### 7.1 Provider Testing
```dart
void main() {
  group('ChatStateNotifier', () {
    late MockSimpleChatQuestionnaireService mockService;
    late ProviderContainer container;

    setUp(() {
      mockService = MockSimpleChatQuestionnaireService();
      container = ProviderContainer(
        overrides: [
          simpleChatQuestionnaireServiceProvider.overrideWithValue(mockService),
        ],
      );
    });

    test('should load questionnaire successfully', () async {
      // Test implementation
    });
  });
}
```

### 7.2 Widget Testing
```dart
void main() {
  group('ChatQuestionnaireScreen', () {
    testWidgets('should display loading state initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ChatQuestionnaireScreen(),
          ),
        ),
      );

      expect(find.byType(LoadingWidget), findsOneWidget);
    });
  });
}
```

## 8. Implementation Phases

### Phase 1: Core Infrastructure
1. Set up Riverpod providers
2. Implement ChatStateNotifier
3. Create basic widget structure
4. Implement error handling

### Phase 2: UI Components
1. Implement message widgets
2. Create input widgets
3. Add navigation components
4. Implement progress indicators

### Phase 3: Advanced Features
1. Add form validation
2. Implement persistence
3. Add animations and transitions
4. Performance optimization

### Phase 4: Testing & Polish
1. Unit tests for providers
2. Widget tests for components
3. Integration testing
4. Performance testing

## 9. File Structure

```
lib/
├── features/
│   └── onboarding_flow/
│       ├── presentation/
│       │   ├── providers/
│       │   │   ├── chat_state_provider.dart
│       │   │   ├── navigation_provider.dart
│       │   │   └── progress_provider.dart
│       │   ├── widgets/
│       │   │   ├── chat_app_bar.dart
│       │   │   ├── chat_body.dart
│       │   │   ├── chat_bottom_bar.dart
│       │   │   ├── messages/
│       │   │   │   ├── bot_message_widget.dart
│       │   │   │   └── question_answer_widget.dart
│       │   │   └── inputs/
│       │   │       ├── text_answer_input.dart
│       │   │       ├── choice_answer_input.dart
│       │   │       └── scale_answer_input.dart
│       │   └── screens/
│       │       └── chat_questionnaire_screen.dart
│       ├── data/ (existing)
│       └── domain/ (existing)
└── shared/
    ├── widgets/
    │   ├── loading_widget.dart
    │   └── error_widget.dart
    └── providers/
        └── app_providers.dart
```

## 10. Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.4.9
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

dev_dependencies:
  riverpod_generator: ^2.3.9
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  mockito: ^5.4.2
```

This design specification provides a complete blueprint for implementing the Riverpod state management and widget architecture for the NutriApp chat questionnaire system. The architecture is designed to be maintainable, testable, and performant while following the existing service interface patterns.