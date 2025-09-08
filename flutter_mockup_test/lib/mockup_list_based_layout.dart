// List-Based Layout - Compact, data-focused design with ListTiles
import 'package:flutter/material.dart';

class ClientOnboardingListLayout extends StatefulWidget {
  @override
  _ClientOnboardingListLayoutState createState() => _ClientOnboardingListLayoutState();
}

class _ClientOnboardingListLayoutState extends State<ClientOnboardingListLayout> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  
  // Mock data for demo
  String clientName = "Sarah";
  String nutritionistName = "Dr. Smith";
  double progress = 0.5;
  String currentSection = "Personal Info";
  
  List<QuestionResponse> responses = [
    QuestionResponse(
      question: "What's your full name?",
      answer: "Sarah Johnson",
      isCompleted: true,
      sectionIcon: Icons.person_outline,
    ),
    QuestionResponse(
      question: "How old are you?",
      answer: "28 years old",
      isCompleted: true,
      sectionIcon: Icons.person_outline,
    ),
    QuestionResponse(
      question: "What's your current weight?",
      answer: "135 lbs",
      isCompleted: true,
      sectionIcon: Icons.person_outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildProgressCard(),
          Expanded(
            child: _buildQuestionsList(),
          ),
          _buildCurrentQuestion(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 1,
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal[300]!, Colors.teal[500]!],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.local_hospital, color: Theme.of(context).colorScheme.surface, size: 24),
        ),
        title: Text(
          'Nutrition Questionnaire',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        subtitle: Text(
          'for $nutritionistName',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Chip(
                    label: Text(
                      '${(progress * 100).toInt()}% Complete',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.surface),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
              SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary!),
                minHeight: 6,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.checklist, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    'Section: $currentSection',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionsList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: responses.length + 1, // +1 for section header
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildSectionHeader();
        }
        final response = responses[index - 1];
        return _buildQuestionTile(response, index - 1);
      },
    );
  }

  Widget _buildSectionHeader() {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      elevation: 1,
      color: Colors.teal[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.teal[200]!, width: 1),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: Icon(Icons.person_outline, color: Colors.teal[700]),
        title: Text(
          'PERSONAL INFO',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.teal[800],
            letterSpacing: 0.5,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green[500], size: 20),
            SizedBox(width: 8),
            Icon(Icons.expand_more, color: Colors.teal[600]),
          ],
        ),
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Basic information to personalize your nutrition plan',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionTile(QuestionResponse response, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      elevation: response.isCompleted ? 0.5 : 2,
      color: response.isCompleted ? Theme.of(context).colorScheme.surfaceContainerLowest : Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: response.isCompleted 
            ? Colors.green[100] 
            : Colors.orange[100],
          child: Icon(
            response.isCompleted ? Icons.check : Icons.help_outline,
            color: response.isCompleted 
              ? Colors.green[600] 
              : Colors.orange[600],
            size: 20,
          ),
        ),
        title: Text(
          response.question,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: response.isCompleted ? Colors.grey[700] : Colors.black87,
          ),
        ),
        subtitle: response.isCompleted 
          ? Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!, width: 1),
              ),
              child: Text(
                response.answer!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[800],
                ),
              ),
            )
          : null,
        trailing: response.isCompleted
          ? PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, size: 20, color: Colors.grey[600]),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, size: 16, color: Colors.blue[600]),
                      SizedBox(width: 8),
                      Text('Edit Response'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete_outline, size: 16, color: Colors.red[600]),
                      SizedBox(width: 8),
                      Text('Clear Response'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                // Handle menu selection
              },
            )
          : null,
      ),
    );
  }

  Widget _buildCurrentQuestion() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.teal[50]!, Theme.of(context).colorScheme.surface],
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.quiz, color: Theme.of(context).colorScheme.surface, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Question',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.teal[700],
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          "And your height?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Input Format',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _textController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Feet',
                        hintText: '5',
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Inches',
                        hintText: '7',
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle submit
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Submit Response',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '◆ ACTIVE QUESTION',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionResponse {
  final String question;
  final String? answer;
  final bool isCompleted;
  final IconData sectionIcon;

  QuestionResponse({
    required this.question,
    this.answer,
    required this.isCompleted,
    required this.sectionIcon,
  });
}