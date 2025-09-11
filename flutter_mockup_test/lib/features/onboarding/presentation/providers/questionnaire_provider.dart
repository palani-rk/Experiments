import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/questionnaire_schema.dart';
import '../../data/services/questionnaire_service.dart';

// Service Provider - Easy to swap implementations
final questionnaireServiceProvider = Provider<QuestionnaireService>((ref) {
  // Current: Local JSON + SharedPreferences
  return const LocalQuestionnaireService();
  
  // Future: Just uncomment this line and comment above
  // return ApiQuestionnaireService(baseUrl: 'https://your-api.com');
});

// Schema Provider (AsyncNotifier for loading state)
final questionnaireSchemaProvider = AsyncNotifierProvider<QuestionnaireSchemaNotifier, QuestionnaireSchema>(() {
  return QuestionnaireSchemaNotifier();
});

class QuestionnaireSchemaNotifier extends AsyncNotifier<QuestionnaireSchema> {
  @override
  Future<QuestionnaireSchema> build() async {
    final service = ref.watch(questionnaireServiceProvider); // Direct service access
    return await service.loadQuestionnaire();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

// Response persistence provider
final responsePersistenceProvider = Provider<QuestionnaireService>((ref) {
  return ref.watch(questionnaireServiceProvider);
});