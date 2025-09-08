// Card-Based Layout - Material 3 Design with elevated cards
import 'package:flutter/material.dart';

class ClientOnboardingCardLayout extends StatefulWidget {
  @override
  _ClientOnboardingCardLayoutState createState() => _ClientOnboardingCardLayoutState();
}

class _ClientOnboardingCardLayoutState extends State<ClientOnboardingCardLayout> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  
  // Mock data for demo
  String clientName = "Sarah";
  String nutritionistName = "Dr. Smith";
  double progress = 0.5; // 50% complete
  String currentSection = "Personal Info";
  
  List<ChatMessage> messages = [
    ChatMessage(
      isBot: true, 
      text: "Hi Sarah! I'm here to help Dr. Smith create the perfect nutrition plan for you.",
      timestamp: DateTime.now().subtract(Duration(minutes: 5))
    ),
    ChatMessage(
      isBot: true,
      text: "This will take just 5-10 minutes and covers 4 areas: Personal Info, Goals, Health & Lifestyle. Ready to get started?",
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: _buildChatContainer(),
          ),
          _buildCurrentQuestionInput(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.teal[400],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.local_hospital, color: Colors.white, size: 24),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'CLINIC LOGO',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600]),
              ),
              Text(
                'Nutrition Plan Questionnaire',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PROGRESS BAR',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600]),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal[600]),
              ),
            ],
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[400]!),
          ),
          SizedBox(height: 8),
          Text(
            '$currentSection (${(progress * 100).toInt()}%)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildChatContainer() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16),
      itemCount: messages.length + 1, // +1 for section container
      itemBuilder: (context, index) {
        if (index < messages.length) {
          return _buildMessageCard(messages[index]);
        } else {
          return _buildSectionContainer();
        }
      },
    );
  }

  Widget _buildMessageCard(ChatMessage message) {
    return Align(
      alignment: message.isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        child: Card(
          elevation: message.isBot ? 1 : 2,
          color: message.isBot ? Colors.white : Colors.teal[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    message.isBot 
                      ? Icon(Icons.smart_toy, size: 20, color: Colors.teal[600])
                      : Icon(Icons.person, size: 20, color: Colors.blue[600]),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        message.text,
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                    if (message.isEditable) ...[
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.edit, size: 20, color: Colors.grey[600]),
                        onPressed: () {
                          // Handle edit action
                        },
                        constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContainer() {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.teal[200]!, width: 2),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_outline, color: Colors.teal[600]),
                SizedBox(width: 8),
                Text(
                  'PERSONAL INFO',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildCompletedQuestion("What's your full name?", "Sarah Johnson"),
            _buildCompletedQuestion("How old are you?", "28 years old"),
            _buildCompletedQuestion("What's your current weight?", "135 lbs"),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedQuestion(String question, String answer) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.smart_toy, size: 18, color: Colors.teal[600]),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  question,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person, size: 18, color: Colors.blue[600]),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  answer,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.edit, size: 16),
                label: Text('Edit', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                  minimumSize: Size(0, 32),
                  padding: EdgeInsets.symmetric(horizontal: 8),
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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.smart_toy, color: Colors.teal[600]),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "And your height?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _textController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Feet',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Inches',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  // Handle submit
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[400],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text('Submit'),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '▲ CURRENT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.teal[600],
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