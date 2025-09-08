// Chat Bubble Layout - Refactored with Component Architecture
import 'package:flutter/material.dart';
import 'chat_widgets.dart';
import 'theme.dart';

class ClientOnboardingChatLayout extends StatefulWidget {
  @override
  _ClientOnboardingChatLayoutState createState() => _ClientOnboardingChatLayoutState();
}

class _ClientOnboardingChatLayoutState extends State<ClientOnboardingChatLayout> 
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();
  late AnimationController _animationController;
  
  // Mock data for demo
  String clientName = "Sarah";
  String nutritionistName = "Dr. Smith";
  double progress = 0.5;
  String currentSection = "Personal Info";
  
  List<ChatMessage> messages = [
    ChatMessage(
      isBot: true, 
      text: "Hi Sarah! 👋 I'm here to help Dr. Smith create the perfect nutrition plan for you.",
      timestamp: DateTime.now().subtract(const Duration(minutes: 5))
    ),
    ChatMessage(
      isBot: true,
      text: "This will take just 5-10 minutes and covers 4 areas:\n• Personal Info (2 mins)\n• Your Goals (2 mins)\n• Health Background (3 mins)\n• Lifestyle (3 mins)",
      timestamp: DateTime.now().subtract(const Duration(minutes: 4))
    ),
    ChatMessage(
      isBot: true,
      text: "Ready to get started?",
      timestamp: DateTime.now().subtract(const Duration(minutes: 4))
    ),
    ChatMessage(
      isBot: false,
      text: "Yes, let's do this!",
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      isEditable: true
    ),
  ];

  // Sample Q&A data
  final List<Map<String, String>> completedQAs = [
    {"question": "What's your full name?", "answer": "Sarah Johnson"},
    {"question": "How old are you?", "answer": "28 years old"},
    {"question": "What's your current weight?", "answer": "135 lbs"},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppDurations.normal,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _feetController.dispose();
    _inchesController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: Column(
          children: [
            ChatHeader(
              title: 'Nutrition Assistant',
              subtitle: 'Creating your plan with $nutritionistName',
              isOnline: true,
            ),
            OnboardingProgressBar(
              currentSection: currentSection,
              progress: progress,
            ),
            Expanded(
              child: _buildChatMessages(),
            ),
            CurrentQuestionInput(
              question: "And your height?",
              inputFields: _buildHeightInputs(),
              onSubmit: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSizes.l),
      itemCount: messages.length + 1,
      itemBuilder: (context, index) {
        if (index < messages.length) {
          final message = messages[index];
          return ChatBubble(
            text: message.text,
            isBot: message.isBot,
            isEditable: message.isEditable,
            onEdit: message.isEditable ? () => _handleEditMessage(index) : null,
          );
        } else {
          return _buildCompletedSection();
        }
      },
    );
  }

  Widget _buildCompletedSection() {
    return OnboardingSectionCard(
      title: 'PERSONAL INFO',
      icon: Icons.person_outline,
      isCompleted: true,
      children: completedQAs.map((qa) => QuestionAnswerTile(
        question: qa['question']!,
        answer: qa['answer']!,
        onEdit: () => _handleEditAnswer(qa['question']!),
      )).toList(),
    );
  }

  List<Widget> _buildHeightInputs() {
    final theme = Theme.of(context);
    
    return [
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _feetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '5 ft',
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.l,
                  vertical: AppSizes.m,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.m),
          Expanded(
            child: TextFormField(
              controller: _inchesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '7 in',
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.l,
                  vertical: AppSizes.m,
                ),
              ),
            ),
          ),
        ],
      ),
    ];
  }

  void _handleSubmit() {
    // Handle form submission
    final feet = _feetController.text;
    final inches = _inchesController.text;
    print('Height submitted: $feet ft $inches in');
    
    // Add user's response to messages
    setState(() {
      messages.add(ChatMessage(
        isBot: false,
        text: '$feet ft $inches in',
        timestamp: DateTime.now(),
      ));
    });
    
    // Clear input fields
    _feetController.clear();
    _inchesController.clear();
  }

  void _handleEditMessage(int index) {
    // Handle editing a chat message
    print('Edit message at index: $index');
  }

  void _handleEditAnswer(String question) {
    // Handle editing a Q&A answer
    print('Edit answer for: $question');
  }
}

class ChatMessage {
  final bool isBot;
  final String text;
  final DateTime timestamp;
  final bool isEditable;

  ChatMessage({
    required this.isBot,
    required this.text,
    required this.timestamp,
    this.isEditable = false,
  });
}