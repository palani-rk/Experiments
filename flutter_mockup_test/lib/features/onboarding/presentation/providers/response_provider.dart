import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/questionnaire_response.dart';
import 'questionnaire_provider.dart';

final responseStateProvider = StateNotifierProvider<ResponseNotifier, QuestionnaireResponse>((ref) {
  return ResponseNotifier(ref);
});

class ResponseNotifier extends StateNotifier<QuestionnaireResponse> {
  final Ref _ref;
  
  ResponseNotifier(this._ref) : super(QuestionnaireResponse(
    questionnaireId: 'default',
    answers: {},
    startTime: DateTime.now(),
  )) {
    _loadSavedResponse();
  }

  // Load saved response on initialization
  Future<void> _loadSavedResponse() async {
    try {
      final service = _ref.read(questionnaireServiceProvider);
      final savedResponse = await service.loadSavedResponse(state.questionnaireId);
      if (savedResponse != null) {
        state = savedResponse;
      }
    } catch (e) {
      // Continue with default state if can't load
    }
  }

  void setAnswer(String questionId, dynamic value) {
    final newAnswers = Map<String, dynamic>.from(state.answers);
    newAnswers[questionId] = value;
    
    state = state.copyWith(answers: newAnswers);
    
    // Auto-save after each answer
    _saveResponse();
  }

  dynamic getAnswer(String questionId) {
    return state.answers[questionId];
  }

  bool isQuestionAnswered(String questionId) {
    final answer = state.answers[questionId];
    if (answer == null) return false;
    if (answer is String) return answer.trim().isNotEmpty;
    if (answer is List) return answer.isNotEmpty;
    return true;
  }

  Future<void> completeQuestionnaire() async {
    state = state.copyWith(
      completedTime: DateTime.now(),
      status: QuestionnaireStatus.completed,
    );
    
    // Save completed response
    await _saveResponse();
  }

  void resetResponse() {
    state = QuestionnaireResponse(
      questionnaireId: state.questionnaireId,
      answers: {},
      startTime: DateTime.now(),
    );
    
    // Save reset state
    _saveResponse();
  }

  // Private method to save response
  Future<void> _saveResponse() async {
    try {
      final service = _ref.read(questionnaireServiceProvider);
      await service.saveResponse(state);
    } catch (e) {
      // Handle save error - could show snackbar or log
      // TODO: Implement proper error handling (show snackbar, etc.)
      // print('Failed to save response: $e');
    }
  }

  // Public method for manual save
  Future<void> saveResponse() async {
    await _saveResponse();
  }
}

// Computed providers for validation
final canProceedProvider = Provider.family<bool, String>((ref, questionId) {
  final response = ref.watch(responseStateProvider);
  // Add question-specific validation logic here
  return response.isQuestionAnswered(questionId);
});

// Provider for checking if response is saved
final isResponseSavedProvider = Provider<bool>((ref) {
  final response = ref.watch(responseStateProvider);
  return response.answers.isNotEmpty;
});