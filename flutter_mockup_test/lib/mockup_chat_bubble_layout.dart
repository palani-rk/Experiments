// Chat Bubble Layout - Authentic messaging app experience
import 'package:flutter/material.dart';

class ClientOnboardingChatLayout extends StatefulWidget {
  @override
  _ClientOnboardingChatLayoutState createState() => _ClientOnboardingChatLayoutState();
}

class _ClientOnboardingChatLayoutState extends State<ClientOnboardingChatLayout> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
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
      timestamp: DateTime.now().subtract(Duration(minutes: 5))
    ),
    ChatMessage(
      isBot: true,
      text: "This will take just 5-10 minutes and covers 4 areas:\n• Personal Info (2 mins)\n• Your Goals (2 mins)\n• Health Background (3 mins)\n• Lifestyle (3 mins)",
      timestamp: DateTime.now().subtract(Duration(minutes: 4))
    ),
    ChatMessage(
      isBot: true,
      text: "Ready to get started?",
      timestamp: DateTime.now().subtract(Duration(minutes: 4))
    ),
    ChatMessage(
      isBot: false,
      text: "Yes, let's do this!",
      timestamp: DateTime.now().subtract(Duration(minutes: 4)),
      isEditable: true
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
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
            _buildChatHeader(),
            _buildProgressBar(),
            Expanded(
              child: _buildChatMessages(),
            ),
            _buildCurrentQuestionInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.local_hospital, color: Theme.of(context).colorScheme.onPrimary, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nutrition Assistant',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Creating your plan with $nutritionistName',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentSection,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              Text(
                '${(progress * 100).toInt()}% complete',
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ],
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[400]!),
            minHeight: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16),
      itemCount: messages.length + 1,
      itemBuilder: (context, index) {
        if (index < messages.length) {
          return _buildChatBubble(messages[index], index);
        } else {
          return _buildSectionGroup();
        }
      },
    );
  }

  Widget _buildChatBubble(ChatMessage message, int index) {
    final isBot = message.isBot;
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(Icons.smart_toy, size: 16, color: Theme.of(context).colorScheme.primary),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isBot ? Colors.white : Colors.teal[400],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isBot ? 4 : 18),
                  topRight: Radius.circular(isBot ? 18 : 4),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 15,
                      color: isBot ? Colors.black87 : Colors.white,
                    ),
                  ),
                  if (message.isEditable) ...[
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        // Handle edit
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit, size: 14, color: isBot ? Colors.grey[600] : Colors.white70),
                          SizedBox(width: 4),
                          Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 12,
                              color: isBot ? Colors.grey[600] : Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (!isBot) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.person, size: 16, color: Colors.blue[600]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionGroup() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal[200]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.person_outline, color: Theme.of(context).colorScheme.onPrimaryContainer, size: 20),
                SizedBox(width: 8),
                Text(
                  'PERSONAL INFO',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    letterSpacing: 0.5,
                  ),
                ),
                Spacer(),
                Icon(Icons.check_circle, color: Colors.green[500], size: 20),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildQuestionAnswer("What's your full name?", "Sarah Johnson"),
                _buildQuestionAnswer("How old are you?", "28 years old"),
                _buildQuestionAnswer("What's your current weight?", "135 lbs"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionAnswer(String question, String answer) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 8,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(Icons.smart_toy, size: 10, color: Theme.of(context).colorScheme.primary),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  question,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              CircleAvatar(
                radius: 8,
                backgroundColor: Colors.blue[100],
                child: Icon(Icons.person, size: 10, color: Colors.blue[600]),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  answer,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, size: 12, color: Colors.grey[600]),
                      SizedBox(width: 2),
                      Text(
                        'Edit',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentQuestionInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(Icons.smart_toy, size: 16, color: Theme.of(context).colorScheme.primary),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "And your height?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal[200]!, width: 2),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _textController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '5 ft',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '7 in',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle submit
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.keyboard_arrow_up, color: Colors.teal[400], size: 16),
                    Text(
                      'CURRENT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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