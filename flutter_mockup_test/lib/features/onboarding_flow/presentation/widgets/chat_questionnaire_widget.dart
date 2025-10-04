import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_questionnaire_providers.dart';
import '../../data/models/core/section_message.dart';
import '../../data/models/core/enums.dart';

/// Main chat questionnaire widget demonstrating provider usage
class ChatQuestionnaireWidget extends ConsumerWidget {
  const ChatQuestionnaireWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(chatStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Questionnaire'),
        actions: [
          // Progress indicator in app bar
          Consumer(
            builder: (context, ref, child) {
              final progress = ref.watch(progressPercentageProvider);
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorWidget(
          error: error,
          onRetry: () => ref.read(chatStateProvider.notifier).refreshState(),
        ),
        data: (chatState) => chatState != null
            ? const ChatQuestionnaireContent()
            : const EmptyStateWidget(),
      ),
      bottomNavigationBar: const NavigationBar(),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final actions = ref.read(navigationActionsProvider);
          return FloatingActionButton(
            onPressed: () => actions.saveProgress(),
            child: const Icon(Icons.save),
            tooltip: 'Save Progress',
          );
        },
      ),
    );
  }
}

/// Main content area for the questionnaire
class ChatQuestionnaireContent extends ConsumerWidget {
  const ChatQuestionnaireContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isComplete = ref.watch(isQuestionnaireCompleteProvider);

    if (isComplete) {
      return const CompletionWidget();
    }

    return const Column(
      children: [
        ProgressBanner(),
        Expanded(child: MessageListView()),
        CurrentQuestionInput(),
      ],
    );
  }
}

/// Progress banner showing overall progress
class ProgressBanner extends ConsumerWidget {
  const ProgressBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressPercentageProvider);
    final progressAsync = ref.watch(progressDetailsProvider);

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            progressAsync.when(
              loading: () => const Text('Calculating progress...'),
              error: (error, stack) => Text('Progress: ${(progress * 100).toInt()}%'),
              data: (details) => details != null
                  ? Text(
                      'Question ${details.currentQuestionIndex + 1} of ${details.totalQuestions}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  : Text('Progress: ${(progress * 100).toInt()}%'),
            ),
          ],
        ),
      ),
    );
  }
}

/// List view showing message history
class MessageListView extends ConsumerWidget {
  const MessageListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSection = ref.watch(currentSectionProvider);

    if (currentSection == null) {
      return const Center(child: Text('No section loaded'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: currentSection.allMessages.length,
      itemBuilder: (context, index) {
        final message = currentSection.allMessages[index];
        return MessageBubble(message: message);
      },
    );
  }
}

/// Individual message bubble
class MessageBubble extends ConsumerWidget {
  final SectionMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return message.when(
      bot: (botMessage) => BotMessageBubble(message: botMessage),
      questionAnswer: (qa) => QuestionAnswerBubble(questionAnswer: qa),
    );
  }
}

/// Bot message bubble
class BotMessageBubble extends StatelessWidget {
  final BotMessage message;

  const BotMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12.0),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Text(
          message.content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

/// Question answer bubble with edit capability
class QuestionAnswerBubble extends ConsumerWidget {
  final QuestionAnswer questionAnswer;

  const QuestionAnswerBubble({super.key, required this.questionAnswer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(navigationActionsProvider);

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12.0),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionAnswer.questionText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 4),
            if (questionAnswer.answer != null)
              Text(
                questionAnswer.answer.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              )
            else
              Text(
                'No answer yet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
                  fontStyle: FontStyle.italic,
                ),
              ),
            if (questionAnswer.isComplete)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showEditDialog(
                    context,
                    questionAnswer,
                    actions,
                  ),
                  child: const Text('Edit'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    QuestionAnswer qa,
    NavigationActions actions,
  ) {
    final controller = TextEditingController(text: qa.answer?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Answer'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your answer',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              actions.editAnswer(
                messageId: qa.id,
                newAnswer: controller.text,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

/// Current question input area
class CurrentQuestionInput extends ConsumerWidget {
  const CurrentQuestionInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentQuestion = ref.watch(currentQuestionProvider);
    final currentMessageId = ref.watch(currentMessageIdProvider);

    if (currentQuestion == null || currentMessageId == null) {
      return const SizedBox.shrink();
    }

    return QuestionInputWidget(
      question: currentQuestion,
      messageId: currentMessageId,
    );
  }
}

/// Question input widget based on question type
class QuestionInputWidget extends ConsumerStatefulWidget {
  final Question question;
  final String messageId;

  const QuestionInputWidget({
    super.key,
    required this.question,
    required this.messageId,
  });

  @override
  ConsumerState<QuestionInputWidget> createState() => _QuestionInputWidgetState();
}

class _QuestionInputWidgetState extends ConsumerState<QuestionInputWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actions = ref.read(navigationActionsProvider);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
      ),
      child: widget.question.when(
        text: (id, text, isRequired, validation, metadata) => _buildTextInput(actions),
        number: (id, text, isRequired, validation, metadata, min, max, step) =>
          _buildNumberInput(actions, min, max),
        multiselect: (id, text, isRequired, validation, metadata, options, min, max) =>
          _buildMultiselectInput(actions, options),
        radio: (id, text, isRequired, validation, metadata, options) =>
          _buildRadioInput(actions, options),
        date: (id, text, isRequired, validation, metadata, earliest, latest) =>
          _buildDateInput(actions),
        slider: (id, text, isRequired, validation, metadata, min, max, divisions, label) =>
          _buildSliderInput(actions, min, max, divisions),
      ),
    );
  }

  Widget _buildTextInput(NavigationActions actions) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Type your answer...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
            onSubmitted: (value) => _submitAnswer(actions, value),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => _submitAnswer(actions, _controller.text),
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }

  Widget _buildNumberInput(NavigationActions actions, double? min, double? max) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter a number${min != null ? ' (min: $min)' : ''}${max != null ? ' (max: $max)' : ''}',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
            onSubmitted: (value) => _submitAnswer(actions, double.tryParse(value)),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => _submitAnswer(actions, double.tryParse(_controller.text)),
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }

  Widget _buildMultiselectInput(NavigationActions actions, List<String> options) {
    return Column(
      children: [
        ...options.map((option) => CheckboxListTile(
          title: Text(option),
          value: false, // TODO: Track selected options
          onChanged: (selected) {
            // TODO: Handle multiselect
          },
        )),
        ElevatedButton(
          onPressed: () => _submitAnswer(actions, []), // TODO: Get selected options
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildRadioInput(NavigationActions actions, List<String> options) {
    return Column(
      children: [
        ...options.map((option) => RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: null, // TODO: Track selected option
          onChanged: (value) => _submitAnswer(actions, value),
        )),
      ],
    );
  }

  Widget _buildDateInput(NavigationActions actions) {
    return ElevatedButton(
      onPressed: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          _submitAnswer(actions, date.toIso8601String());
        }
      },
      child: const Text('Select Date'),
    );
  }

  Widget _buildSliderInput(NavigationActions actions, double min, double max, int? divisions) {
    double currentValue = min;
    return StatefulBuilder(
      builder: (context, setState) => Column(
        children: [
          Text('Value: ${currentValue.toStringAsFixed(1)}'),
          Slider(
            value: currentValue,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: (value) => setState(() => currentValue = value),
            onChangeEnd: (value) => _submitAnswer(actions, value),
          ),
        ],
      ),
    );
  }

  void _submitAnswer(NavigationActions actions, dynamic answer) {
    if (answer != null) {
      actions.answerAndMoveNext(
        messageId: widget.messageId,
        answer: answer,
      );
      _controller.clear();
    }
  }
}

/// Navigation bar at bottom
class NavigationBar extends ConsumerWidget {
  const NavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canGoBack = ref.watch(canGoBackProvider);
    final hasNext = ref.watch(hasNextProvider);
    final isComplete = ref.watch(isQuestionnaireCompleteProvider);
    final actions = ref.read(navigationActionsProvider);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          if (canGoBack)
            OutlinedButton(
              onPressed: () {
                // TODO: Implement back navigation
              },
              child: const Text('Back'),
            ),
          const Spacer(),
          if (!isComplete)
            ElevatedButton(
              onPressed: () => actions.moveToNext(),
              child: Text(hasNext ? 'Next' : 'Complete'),
            ),
        ],
      ),
    );
  }
}

/// Completion widget shown when questionnaire is done
class CompletionWidget extends ConsumerWidget {
  const CompletionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressPercentageProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.celebration,
            size: 100,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Questionnaire Complete!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            'Progress: ${(progress * 100).toInt()}%',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to results or restart
            },
            child: const Text('View Results'),
          ),
        ],
      ),
    );
  }
}

/// Empty state widget
class EmptyStateWidget extends ConsumerWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(navigationActionsProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 100,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 24),
          Text(
            'No Questionnaire Loaded',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            'Start a new questionnaire or resume an existing one.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => actions.startNew(),
                child: const Text('Start New'),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () => actions.resume(),
                child: const Text('Resume'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Error widget with retry functionality
class ErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const ErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 100,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 24),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}