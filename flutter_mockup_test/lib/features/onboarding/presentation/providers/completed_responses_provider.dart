import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/completed_response.dart';
import '../../data/models/questionnaire_response.dart';
import '../../data/models/questionnaire_schema.dart';
import 'questionnaire_provider.dart';
import 'response_provider.dart';

/// Provider for managing response groups and their state
final responseGroupsProvider = StateNotifierProvider<ResponseGroupsNotifier, List<ResponseGroup>>((ref) {
  return ResponseGroupsNotifier(ref);
});

/// Provider for overall progress across all response groups
final overallProgressProvider = Provider<OverallProgress>((ref) {
  final groups = ref.watch(responseGroupsProvider);
  final navigationState = ref.watch(navigationStateProvider);
  final schema = ref.watch(questionnaireSchemaProvider).value;

  // Calculate total questions if schema is available
  int? totalQuestions;
  if (schema != null) {
    totalQuestions = schema.sections.fold<int>(
      0, (sum, section) => sum + section.questions.length);
  }

  return OverallProgress(
    groups: groups,
    currentSectionIndex: navigationState.currentSectionIndex,
    currentQuestionIndex: navigationState.currentQuestionIndex,
    totalQuestions: totalQuestions,
    lastUpdated: DateTime.now(),
  );
});

/// Provider for checking if responses panel should be collapsible on mobile
final shouldShowCollapsibleResponsesProvider = Provider<bool>((ref) {
  final groups = ref.watch(responseGroupsProvider);
  return groups.any((group) => group.responses.isNotEmpty);
});

/// Provider for completed sections count
final completedSectionsCountProvider = Provider<int>((ref) {
  final groups = ref.watch(responseGroupsProvider);
  return groups.where((group) => group.isCompleted).length;
});

/// State notifier for managing response groups
class ResponseGroupsNotifier extends StateNotifier<List<ResponseGroup>> {
  final Ref _ref;

  ResponseGroupsNotifier(this._ref) : super([]) {
    _initializeGroups();

    // Listen to response changes and update groups accordingly
    _ref.listen(responseStateProvider, (previous, next) {
      _updateGroupsFromResponses(next);
    });

    // Listen to schema changes to rebuild groups
    _ref.listen(questionnaireSchemaProvider, (previous, next) {
      next.whenData((schema) => _rebuildGroupsFromSchema(schema));
    });
  }

  /// Initialize response groups from current schema and responses
  Future<void> _initializeGroups() async {
    try {
      final schemaAsync = _ref.read(questionnaireSchemaProvider);
      final currentResponse = _ref.read(responseStateProvider);

      await schemaAsync.when(
        data: (schema) async {
          await _rebuildGroupsFromSchema(schema);
          _updateGroupsFromResponses(currentResponse);
        },
        loading: () => {},
        error: (error, stack) {
          // Handle error by creating empty state
          state = [];
        },
      );
    } catch (e) {
      // Fallback to empty state on any error
      state = [];
    }
  }

  /// Rebuild groups structure from schema
  Future<void> _rebuildGroupsFromSchema(QuestionnaireSchema schema) async {
    try {
      final currentResponse = _ref.read(responseStateProvider);
      final newGroups = <ResponseGroup>[];

      for (int i = 0; i < schema.sections.length; i++) {
        final section = schema.sections[i];

        // Find existing group to preserve expansion state
        final existingGroup = state.cast<ResponseGroup?>().firstWhere(
          (g) => g?.sectionId == section.id,
          orElse: () => null,
        );

        // Create completed responses for this section
        final sectionResponses = <CompletedResponse>[];

        for (final question in section.questions) {
          if (currentResponse.isQuestionAnswered(question.id)) {
            final answer = currentResponse.getAnswer(question.id);
            sectionResponses.add(
              CompletedResponse(
                questionId: question.id,
                questionText: question.text,
                answer: answer,
                sectionId: section.id,
                sectionTitle: section.title,
                answeredAt: DateTime.now(), // TODO: Store actual answer time
                isEditable: true,
              ),
            );
          }
        }

        newGroups.add(
          ResponseGroup(
            sectionId: section.id,
            sectionTitle: section.title,
            responses: sectionResponses,
            isExpanded: existingGroup?.isExpanded ?? false,
            totalQuestions: section.questions.length,
            orderIndex: i,
          ),
        );
      }

      state = newGroups;
    } catch (e) {
      // Keep existing state on error
      // TODO: Add proper error logging
    }
  }

  /// Update groups based on current response state
  void _updateGroupsFromResponses(QuestionnaireResponse response) {
    try {
      final schemaAsync = _ref.read(questionnaireSchemaProvider);

      schemaAsync.whenData((schema) {
        final updatedGroups = state.map((group) {
          final section = schema.sections.firstWhere(
            (s) => s.id == group.sectionId,
            orElse: () => throw StateError('Section not found: ${group.sectionId}'),
          );

          // Update responses for this section
          final sectionResponses = <CompletedResponse>[];

          for (final question in section.questions) {
            if (response.isQuestionAnswered(question.id)) {
              final answer = response.getAnswer(question.id);
              sectionResponses.add(
                CompletedResponse(
                  questionId: question.id,
                  questionText: question.text,
                  answer: answer,
                  sectionId: section.id,
                  sectionTitle: section.title,
                  answeredAt: DateTime.now(), // TODO: Store actual answer time
                  isEditable: true,
                ),
              );
            }
          }

          return group.copyWith(responses: sectionResponses);
        }).toList();

        state = updatedGroups;
      });
    } catch (e) {
      // Keep existing state on error
      // TODO: Add proper error logging
    }
  }

  /// Toggle expansion state of a specific group
  void toggleSection(String sectionId) {
    try {
      state = state.map((group) {
        if (group.sectionId == sectionId) {
          return group.toggleExpansion();
        }
        return group;
      }).toList();
    } catch (e) {
      // TODO: Add proper error handling
    }
  }

  /// Expand a specific section
  void expandSection(String sectionId) {
    try {
      state = state.map((group) {
        if (group.sectionId == sectionId) {
          return group.copyWith(isExpanded: true);
        }
        return group;
      }).toList();
    } catch (e) {
      // TODO: Add proper error handling
    }
  }

  /// Collapse a specific section
  void collapseSection(String sectionId) {
    try {
      state = state.map((group) {
        if (group.sectionId == sectionId) {
          return group.copyWith(isExpanded: false);
        }
        return group;
      }).toList();
    } catch (e) {
      // TODO: Add proper error handling
    }
  }

  /// Expand all sections
  void expandAll() {
    try {
      state = state.map((group) => group.copyWith(isExpanded: true)).toList();
    } catch (e) {
      // TODO: Add proper error handling
    }
  }

  /// Collapse all sections
  void collapseAll() {
    try {
      state = state.map((group) => group.copyWith(isExpanded: false)).toList();
    } catch (e) {
      // TODO: Add proper error handling
    }
  }

  /// Update a specific response within a group
  void updateResponse(CompletedResponse updatedResponse) {
    try {
      state = state.map((group) {
        if (group.sectionId == updatedResponse.sectionId) {
          return group.updateResponse(updatedResponse);
        }
        return group;
      }).toList();
    } catch (e) {
      // TODO: Add proper error handling
    }
  }

  /// Remove a response from its group
  void removeResponse(String questionId, String sectionId) {
    try {
      state = state.map((group) {
        if (group.sectionId == sectionId) {
          return group.removeResponse(questionId);
        }
        return group;
      }).toList();

      // Also remove from the main response state
      // This will trigger an update back to this notifier
      final responseNotifier = _ref.read(responseStateProvider.notifier);
      final currentResponse = _ref.read(responseStateProvider);
      final newAnswers = Map<String, dynamic>.from(currentResponse.answers);
      newAnswers.remove(questionId);

      responseNotifier.state = currentResponse.copyWith(answers: newAnswers);
    } catch (e) {
      // TODO: Add proper error handling
    }
  }

  /// Refresh groups from current state
  void refresh() {
    _initializeGroups();
  }

  /// Get a specific group by section ID
  ResponseGroup? getGroupBySection(String sectionId) {
    try {
      return state.firstWhere((group) => group.sectionId == sectionId);
    } catch (e) {
      return null;
    }
  }

  /// Get a specific response by question ID
  CompletedResponse? getResponseByQuestion(String questionId) {
    try {
      for (final group in state) {
        for (final response in group.responses) {
          if (response.questionId == questionId) {
            return response;
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

/// Provider for navigation state management
final navigationStateProvider = StateNotifierProvider<NavigationNotifier, NavigationState>((ref) {
  return NavigationNotifier();
});

/// Navigation state notifier
class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(const NavigationState());

  void goToSection(int sectionIndex) {
    state = state.copyWith(
      currentSectionIndex: sectionIndex,
      currentQuestionIndex: 0,
    );
  }

  void goToQuestion(int questionIndex) {
    state = state.copyWith(currentQuestionIndex: questionIndex);
  }

  void nextSection() {
    state = state.copyWith(
      currentSectionIndex: state.currentSectionIndex + 1,
      currentQuestionIndex: 0,
    );
  }

  void previousSection() {
    if (state.currentSectionIndex > 0) {
      state = state.copyWith(
        currentSectionIndex: state.currentSectionIndex - 1,
        currentQuestionIndex: 0,
      );
    }
  }

  void nextQuestion() {
    state = state.copyWith(
      currentQuestionIndex: state.currentQuestionIndex + 1,
    );
  }

  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex - 1,
      );
    }
  }

  void startQuestionnaire() {
    state = state.copyWith(showWelcome: false);
  }

  void completeQuestionnaire() {
    state = state.copyWith(isCompleted: true);
  }

  void resetToWelcome() {
    state = const NavigationState();
  }
}