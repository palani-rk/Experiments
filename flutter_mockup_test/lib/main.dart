import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mockup_card_based_layout.dart';
import 'mockup_chat_bubble_layout.dart';
import 'mockup_list_based_layout.dart';
import 'shared/theme/app_theme.dart';
import 'features/client_questionnaire_flow/presentation/pages/welcome_page.dart' as phase1;

void main() {
  runApp(const ProviderScope(
    child: MockupTestApp(),
  ));
}

class MockupTestApp extends StatelessWidget {
  const MockupTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final materialTheme = MaterialTheme(Typography.material2021().black);
    
    return MaterialApp(
      title: 'NutriApp UI Mockup Test',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,
      home: const MockupSelectionScreen(),
    );
  }
}

class MockupSelectionScreen extends StatelessWidget {
  const MockupSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('NutriApp Mockups'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            const Text(
              'Choose a mockup to test:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildMockupCard(
              context,
              'Card-Based Layout',
              'Material 3 design with elevated cards',
              Icons.credit_card,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClientOnboardingCardLayout(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildMockupCard(
              context,
              'Chat Bubble Layout (Original)',
              'Authentic messaging app experience',
              Icons.chat_bubble_outline,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClientOnboardingChatLayout(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildMockupCard(
              context,
              'List-Based Layout',
              'Compact, data-focused design',
              Icons.list,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClientOnboardingListLayout(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildMockupCard(
              context,
              'Phase 1: Client Questionnaire Flow',
              'Design spec implementation - Static UI with proper components',
              Icons.assignment_outlined,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const phase1.WelcomePage(),
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }

  Widget _buildMockupCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}