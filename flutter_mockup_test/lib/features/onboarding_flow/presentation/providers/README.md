# Chat Questionnaire Providers

This directory contains Riverpod providers for the chat-based questionnaire system. The providers follow a clean architecture pattern with clear separation of concerns.

## Architecture Overview

```
┌─────────────────────────┐
│   Widget Layer          │
├─────────────────────────┤
│   Provider Layer        │
│   - State Management    │
│   - Derived State       │
│   - Navigation Actions  │
├─────────────────────────┤
│   Service Layer         │
│   - Business Logic      │
│   - Data Operations     │
├─────────────────────────┤
│   Model Layer           │
│   - ChatState           │
│   - ChatSection         │
│   - SectionMessage      │
└─────────────────────────┘
```

## Core Providers

### Service Providers

```dart
// Core service instances
final persistenceServiceProvider = Provider<SimplePersistenceService>
final chatQuestionnaireServiceProvider = Provider<SimpleChatQuestionnaireService>
```

### State Management

```dart
// Main state notifier
final chatStateProvider = StateNotifierProvider<ChatStateNotifier, AsyncValue<ChatState?>>

// Current state (unwrapped from AsyncValue)
final currentChatStateProvider = Provider<ChatState?>
```

### Derived State Providers

```dart
// Current questionnaire elements
final currentSectionProvider = Provider<ChatSection?>
final currentQuestionProvider = Provider<Question?>
final sectionsProvider = Provider<List<ChatSection>>

// Status providers
final isQuestionnaireCompleteProvider = Provider<bool>
final isLoadingProvider = Provider<bool>
final errorProvider = Provider<Object?>

// Progress tracking
final progressDetailsProvider = FutureProvider<ProgressDetails?>
final progressPercentageProvider = Provider<double>

// Navigation helpers
final hasNextProvider = Provider<bool>
final canGoBackProvider = Provider<bool>
final currentMessageIdProvider = Provider<String?>
final currentSectionIdProvider = Provider<String?>
```

### Action Providers

```dart
// Navigation actions
final navigationActionsProvider = Provider<NavigationActions>
```

### Family Providers

```dart
// Get specific section by ID
final sectionProvider = Provider.family<ChatSection?, String>

// Get specific message by ID
final messageProvider = FutureProvider.family<SectionMessage?, String>
```

## Usage Patterns

### 1. Basic Widget Structure

```dart
class QuestionnaireWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(chatStateProvider);

    return asyncState.when(
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
      data: (chatState) => chatState != null
        ? QuestionnaireContent()
        : EmptyState(),
    );
  }
}
```

### 2. Listening to Current State

```dart
class CurrentQuestionWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentQuestion = ref.watch(currentQuestionProvider);
    final currentSection = ref.watch(currentSectionProvider);

    if (currentQuestion == null) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        Text(currentSection?.title ?? ''),
        Text(currentQuestion.questionText),
        // Question input widget
      ],
    );
  }
}
```

### 3. Progress Display

```dart
class ProgressWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressPercentageProvider);
    final progressDetails = ref.watch(progressDetailsProvider);

    return progressDetails.when(
      loading: () => LinearProgressIndicator(value: progress),
      error: (error, stack) => LinearProgressIndicator(value: progress),
      data: (details) => Column(
        children: [
          LinearProgressIndicator(value: progress),
          if (details != null)
            Text('${details.completedQuestions} / ${details.totalQuestions}'),
        ],
      ),
    );
  }
}
```

### 4. Navigation Actions

```dart
class NavigationButtons extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canGoBack = ref.watch(canGoBackProvider);
    final hasNext = ref.watch(hasNextProvider);
    final isComplete = ref.watch(isQuestionnaireCompleteProvider);
    final actions = ref.read(navigationActionsProvider);

    return Row(
      children: [
        if (canGoBack)
          ElevatedButton(
            onPressed: () {
              // Custom back navigation logic
            },
            child: Text('Back'),
          ),
        Spacer(),
        if (!isComplete)
          ElevatedButton(
            onPressed: () => actions.moveToNext(),
            child: Text(hasNext ? 'Next' : 'Complete'),
          ),
      ],
    );
  }
}
```

### 5. Answer Input Widget

```dart
class AnswerInputWidget extends ConsumerWidget {
  final String messageId;

  const AnswerInputWidget({required this.messageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(navigationActionsProvider);

    return TextFormField(
      onChanged: (value) {
        // Auto-save as user types
        actions.editAnswer(
          messageId: messageId,
          newAnswer: value,
        );
      },
      onFieldSubmitted: (value) {
        // Move to next when submitted
        actions.answerAndMoveNext(
          messageId: messageId,
          answer: value,
        );
      },
    );
  }
}
```

### 6. Error Handling

```dart
class ErrorHandlingWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = ref.watch(errorProvider);
    final actions = ref.read(navigationActionsProvider);

    if (error != null) {
      return ErrorDisplay(
        error: error,
        onRetry: () => actions.refresh(),
      );
    }

    return QuestionnaireContent();
  }
}
```

### 7. Auto-Save Pattern

```dart
class AutoSaveWrapper extends ConsumerWidget {
  final Widget child;

  const AutoSaveWrapper({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(navigationActionsProvider);

    // Auto-save every 30 seconds
    useEffect(() {
      final timer = Timer.periodic(
        Duration(seconds: 30),
        (_) => actions.saveProgress(),
      );
      return timer.cancel;
    }, []);

    return child;
  }
}
```

### 8. Section Navigation

```dart
class SectionListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(sectionsProvider);
    final currentSectionId = ref.watch(currentSectionIdProvider);
    final actions = ref.read(navigationActionsProvider);

    return ListView.builder(
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        final isActive = section.id == currentSectionId;

        return ListTile(
          title: Text(section.title),
          selected: isActive,
          onTap: section.isComplete || isActive ? () {
            // Navigate to first message in section
            final firstMessage = section.allMessages.firstOrNull;
            if (firstMessage != null) {
              actions.navigateTo(
                sectionId: section.id,
                messageId: firstMessage.id,
              );
            }
          } : null,
        );
      },
    );
  }
}
```

### 9. Message History

```dart
class MessageHistoryWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSection = ref.watch(currentSectionProvider);

    if (currentSection == null) return SizedBox.shrink();

    return ListView.builder(
      itemCount: currentSection.allMessages.length,
      itemBuilder: (context, index) {
        final message = currentSection.allMessages[index];

        return message.when(
          bot: (botMessage) => BotMessageBubble(message: botMessage),
          questionAnswer: (qa) => QuestionAnswerBubble(
            questionAnswer: qa,
            onEdit: qa.isComplete ? (newAnswer) {
              ref.read(navigationActionsProvider).editAnswer(
                messageId: qa.id,
                newAnswer: newAnswer,
              );
            } : null,
          ),
        );
      },
    );
  }
}
```

### 10. Specific Section/Message Access

```dart
class SpecificSectionWidget extends ConsumerWidget {
  final String sectionId;

  const SpecificSectionWidget({required this.sectionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section = ref.watch(sectionProvider(sectionId));

    if (section == null) {
      return Text('Section not found');
    }

    return Card(
      child: Column(
        children: [
          Text(section.title),
          Text('${section.allMessages.length} messages'),
          if (section.isComplete) Icon(Icons.check),
        ],
      ),
    );
  }
}
```

## Best Practices

### 1. Provider Scope

- Use `ref.watch()` in build methods for reactive UI updates
- Use `ref.read()` for one-time operations or in event handlers
- Use `ref.listen()` for side effects (navigation, snackbars, etc.)

### 2. Error Handling

- Always handle AsyncValue states (loading, error, data)
- Provide meaningful error messages and retry mechanisms
- Use try-catch in navigation actions

### 3. Performance

- Use family providers for specific data access
- Avoid watching entire state when only specific fields are needed
- Use `select` modifier for granular updates

### 4. State Persistence

- Auto-save critical user input
- Handle app lifecycle events (background/foreground)
- Provide manual save options for user peace of mind

### 5. Testing

- Mock service providers for unit tests
- Use ProviderContainer for widget testing
- Test state notifier logic independently

## Common Patterns

### Conditional UI Based on State

```dart
// Show different UI based on completion status
Consumer(
  builder: (context, ref, child) {
    final isComplete = ref.watch(isQuestionnaireCompleteProvider);
    return isComplete ? CompletionWidget() : QuestionnaireWidget();
  },
)

// Show loading overlay
Consumer(
  builder: (context, ref, child) {
    final isLoading = ref.watch(isLoadingProvider);
    return Stack(
      children: [
        QuestionnaireContent(),
        if (isLoading) LoadingOverlay(),
      ],
    );
  },
)
```

### Reactive Progress Updates

```dart
ref.listen(progressPercentageProvider, (previous, next) {
  if (next > 0.5 && (previous ?? 0) <= 0.5) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Halfway there!')),
    );
  }
});
```

This provider architecture provides a clean, reactive foundation for building chat-based questionnaire UIs with Flutter and Riverpod.