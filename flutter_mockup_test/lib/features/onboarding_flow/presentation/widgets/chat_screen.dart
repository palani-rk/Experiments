import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_questionnaire_providers.dart';
import '../../data/models/core/chat_section.dart';
import '../../data/models/core/section_message.dart';
import '../../data/models/core/enums.dart';
import '../../data/models/support/question.dart';

/// Main chat screen implementing the UX design from Client_Onboarding_UX_Flow.md
class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(chatStateProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Column(
          children: [
            // Clinic Logo Placeholder
            Icon(
              Icons.local_hospital,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              'Nutrition Plan Questionnaire',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ChatErrorWidget(error: error),
        data: (chatState) => chatState != null
            ? const ChatContent()
            : const ChatEmptyState(),
      ),
    );
  }
}

/// Main chat content with progress indicator and messages
class ChatContent extends ConsumerWidget {
  const ChatContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      children: [
        // Progress Indicator
        ChatProgressIndicator(),
        // Messages and Current Question
        Expanded(
          child: ChatInterface(),
        ),
      ],
    );
  }
}

/// Progress indicator as per UX design
class ChatProgressIndicator extends ConsumerWidget {
  const ChatProgressIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressPercentageProvider);
    final currentSection = ref.watch(currentSectionProvider);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'PROGRESS BAR',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          if (currentSection != null)
            Text(
              _formatSectionName(currentSection.title),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  String _formatSectionName(String title) {
    // Convert section title to match UX design format
    return title.toUpperCase().replaceAll('_', ' ');
  }
}

/// Main chat interface with scrollable messages
class ChatInterface extends ConsumerWidget {
  const ChatInterface({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Stack(
      children: [
        // Scrollable message list
        Positioned.fill(
          bottom: 120, // Leave space for current question
          child: ChatMessageList(),
        ),
        // Current question at bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: CurrentQuestionWidget(),
        ),
      ],
    );
  }
}

/// Scrollable list of completed messages grouped by sections
class ChatMessageList extends ConsumerWidget {
  const ChatMessageList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(sectionsProvider);
    final currentSectionId = ref.watch(currentSectionIdProvider);

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        final isCurrentSection = section.id == currentSectionId;
        final isCompleted = section.isComplete;

        return Column(
          children: [
            // Welcome message for first section
            if (index == 0) _buildWelcomeMessage(context),

            // Section container
            SectionContainer(
              section: section,
              isCurrentSection: isCurrentSection,
              isCompleted: isCompleted,
            ),

            // Section completion celebration
            if (isCompleted && !isCurrentSection)
              SectionCompletionMessage(section: section),

            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildWelcomeMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        children: [
          BotMessageBubble(
            message: "Hi there! I'm here to help create the perfect nutrition plan for you.",
            isIntro: true,
          ),
          const SizedBox(height: 12),
          BotMessageBubble(
            message: "This will take just 5-10 minutes and covers 4 areas: Personal Info, Goals, Health & Lifestyle. Ready to get started?",
            isIntro: true,
          ),
          const SizedBox(height: 12),
          const UserMessageBubble(
            message: "Yes, let's do this!",
            showEditButton: false,
          ),
        ],
      ),
    );
  }
}

/// Container for each section with proper styling
class SectionContainer extends ConsumerWidget {
  final ChatSection section;
  final bool isCurrentSection;
  final bool isCompleted;

  const SectionContainer({
    super.key,
    required this.section,
    required this.isCurrentSection,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentQuestionId = ref.watch(currentMessageIdProvider);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isCurrentSection
              ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
              : Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: isCurrentSection ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isCompleted
            ? Theme.of(context).colorScheme.surfaceContainerLowest
            : Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: isCurrentSection
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Text(
                  section.title.toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    color: isCurrentSection
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                if (isCompleted)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
              ],
            ),
          ),

          // Section Messages
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: section.allMessages.map((message) {
                final isCurrentMessage = message.id == currentQuestionId && isCurrentSection;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: message.when(
                    bot: (id, sectionId, content, messageType, timestamp, isEditable, order, context, metadata) => BotMessageBubble(
                      message: content,
                    ),
                    questionAnswer: (id, sectionId, questionId, questionText, inputType, answer, timestamp, messageType, isEditable, isComplete, order, formattedAnswer, validation, questionMetadata) => QuestionAnswerItem(
                      questionAnswer: message as QuestionAnswer,
                      isCurrent: isCurrentMessage,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bot message bubble
class BotMessageBubble extends StatelessWidget {
  final String message;
  final bool isIntro;

  const BotMessageBubble({
    super.key,
    required this.message,
    this.isIntro = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bot icon
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.smart_toy,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),

        // Message bubble
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// User message bubble with edit functionality
class UserMessageBubble extends ConsumerWidget {
  final String message;
  final bool showEditButton;
  final VoidCallback? onEdit;

  const UserMessageBubble({
    super.key,
    required this.message,
    this.showEditButton = true,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Message bubble
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ),

              // Edit button
              if (showEditButton)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IconButton(
                    onPressed: onEdit,
                    icon: Icon(
                      Icons.edit,
                      size: 16,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    tooltip: 'Edit',
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // User icon
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }
}

/// Question and answer item with edit capability
class QuestionAnswerItem extends ConsumerWidget {
  final QuestionAnswer questionAnswer;
  final bool isCurrent;

  const QuestionAnswerItem({
    super.key,
    required this.questionAnswer,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(navigationActionsProvider);

    return Column(
      children: [
        // Bot question
        BotMessageBubble(message: questionAnswer.questionText),

        const SizedBox(height: 12),

        // User answer (if provided)
        if (questionAnswer.answer != null)
          UserMessageBubble(
            message: _formatAnswer(questionAnswer.answer),
            onEdit: () => _showEditDialog(context, questionAnswer, actions),
          ),
      ],
    );
  }

  String _formatAnswer(dynamic answer) {
    if (answer is List) {
      return answer.join(', ');
    }
    return answer.toString();
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              qa.questionText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter your answer',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
              maxLines: null,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
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

/// Section completion celebration message
class SectionCompletionMessage extends StatelessWidget {
  final ChatSection section;

  const SectionCompletionMessage({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${section.title} Complete! ${_getEncouragingMessage(section.title)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getEncouragingMessage(String sectionTitle) {
    switch (sectionTitle.toLowerCase()) {
      case 'personal info':
        return "Now let's talk about your goals 💪";
      case 'goals':
        return "Great! Let's learn about your health 🏥";
      case 'health':
        return "Perfect! Now for your lifestyle 🌟";
      default:
        return "Excellent progress! 🎉";
    }
  }
}

/// Current question widget at bottom of screen
class CurrentQuestionWidget extends ConsumerWidget {
  const CurrentQuestionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentQuestion = ref.watch(currentQuestionProvider);
    final currentMessageId = ref.watch(currentMessageIdProvider);
    final isComplete = ref.watch(isQuestionnaireCompleteProvider);

    if (isComplete) {
      return _buildCompletionWidget(context);
    }

    if (currentQuestion == null || currentMessageId == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Current label
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.keyboard_arrow_up,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'CURRENT',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          // Question input
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CurrentQuestionInput(
              question: currentQuestion,
              messageId: currentMessageId,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.celebration,
            color: Theme.of(context).colorScheme.primary,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Questionnaire Complete!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thank you for providing your information. Your personalized nutrition plan will be ready soon!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Current question input based on question type
class CurrentQuestionInput extends ConsumerStatefulWidget {
  final Question question;
  final String messageId;

  const CurrentQuestionInput({
    super.key,
    required this.question,
    required this.messageId,
  });

  @override
  ConsumerState<CurrentQuestionInput> createState() => _CurrentQuestionInputState();
}

class _CurrentQuestionInputState extends ConsumerState<CurrentQuestionInput> {
  late TextEditingController _controller;
  final Set<String> _selectedOptions = {};
  String? _selectedRadioOption;
  double _sliderValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _initializeFromQuestion();
  }

  void _initializeFromQuestion() {
    switch (widget.question.inputType) {
      case QuestionType.multiselect:
        _selectedOptions.clear();
        break;
      case QuestionType.slider:
        // Initialize with default value
        _sliderValue = 0;
        break;
      default:
        // Default initialization
        break;
    }
  }

  Widget _buildInputForQuestionType(NavigationActions actions) {
    switch (widget.question.inputType) {
      case QuestionType.text:
        return _buildTextInput(actions);
      case QuestionType.number:
        return _buildNumberInput(actions, null, null);
      case QuestionType.multiselect:
        return _buildMultiselectInput(actions, widget.question.options ?? []);
      case QuestionType.radio:
        return _buildRadioInput(actions, widget.question.options ?? []);
      case QuestionType.date:
        return _buildDateInput(actions);
      case QuestionType.slider:
        return _buildSliderInput(actions, 0, 100, null);
      default:
        return _buildTextInput(actions);
    }
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
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question text
          Text(
            widget.question.text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          // Input based on question type
          _buildInputForQuestionType(actions),
        ],
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
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            onSubmitted: (value) => _submitAnswer(actions, value),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: () => _submitAnswer(actions, _controller.text),
          child: const Text('Submit'),
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
              hintText: 'Enter number${min != null ? ' (min: $min)' : ''}${max != null ? ' (max: $max)' : ''}',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            onSubmitted: (value) => _submitAnswer(actions, double.tryParse(value)),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: () => _submitAnswer(actions, double.tryParse(_controller.text)),
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildMultiselectInput(NavigationActions actions, List<String> options) {
    return Column(
      children: [
        ...options.map((option) => CheckboxListTile(
          title: Text(option),
          value: _selectedOptions.contains(option),
          onChanged: (selected) {
            setState(() {
              if (selected == true) {
                _selectedOptions.add(option);
              } else {
                _selectedOptions.remove(option);
              }
            });
          },
        )),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _selectedOptions.isNotEmpty
                ? () => _submitAnswer(actions, _selectedOptions.toList())
                : null,
            child: const Text('Submit'),
          ),
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
          groupValue: _selectedRadioOption,
          onChanged: (value) {
            setState(() => _selectedRadioOption = value);
            if (value != null) {
              _submitAnswer(actions, value);
            }
          },
        )),
      ],
    );
  }

  Widget _buildDateInput(NavigationActions actions) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
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
        icon: const Icon(Icons.calendar_today),
        label: const Text('Select Date'),
      ),
    );
  }

  Widget _buildSliderInput(NavigationActions actions, double min, double max, int? divisions) {
    return Column(
      children: [
        Text(
          'Value: ${_sliderValue.toStringAsFixed(1)}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Slider(
          value: _sliderValue,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: (value) => setState(() => _sliderValue = value),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => _submitAnswer(actions, _sliderValue),
            child: const Text('Submit'),
          ),
        ),
      ],
    );
  }

  void _submitAnswer(NavigationActions actions, dynamic answer) {
    if (answer != null && answer.toString().isNotEmpty) {
      actions.answerAndMoveNext(
        messageId: widget.messageId,
        answer: answer,
      );

      // Reset form
      _controller.clear();
      _selectedOptions.clear();
      _selectedRadioOption = null;
      setState(() {});
    }
  }
}

/// Error widget for chat screen
class ChatErrorWidget extends ConsumerWidget {
  final Object error;

  const ChatErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(navigationActionsProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => actions.refresh(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state for chat screen
class ChatEmptyState extends ConsumerWidget {
  const ChatEmptyState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(navigationActionsProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 24),
            Text(
              'Ready to get started?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Let\'s create your personalized nutrition plan together.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => actions.startNew(),
              child: const Text('Start Questionnaire'),
            ),
          ],
        ),
      ),
    );
  }
}