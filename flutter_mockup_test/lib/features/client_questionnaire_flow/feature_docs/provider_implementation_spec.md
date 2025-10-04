# Provider Implementation Spec

## Architecture Symbol Map

```
QuestionnaireNotifier(AsyncNotifier) → QuestionnaireState
├── config: QuestionnaireConfig?
├── sectionResponses: Map<String, SectionResponse>
├── currentQuestionId: String?
├── currentSectionIndex: int
├── isCompleted: bool
├── isSubmitted: bool
├── isLoading: bool
└── error: String?

Derived Providers:
currentQuestion → Question? | null if completed
allResponses → Map<String, SectionResponse>
progressInfo → ProgressInfo(currentSection, totalSections, overallProgress, sectionProgress)
currentSectionResponse → SectionResponse? | depends on currentQuestion
brandingConfig → BrandingConfig(static)

Service Providers:
questionnaireConfigService → QuestionnaireConfigServiceImpl
responsePersistenceService → ResponsePersistenceServiceImpl
```

## Widget-Provider Bindings

```
QuestionnairePage(ConsumerWidget)
├── watch: questionnaireNotifierProvider.when(data|loading|error)
├── watch: progressInfoProvider
├── watch: currentQuestionProvider
├── watch: brandingConfigProvider
└── actions: answerQuestion(), editResponse(), submitQuestionnaire()

BrandingHeader
├── input: brandingConfig
└── display: effectiveTitle, effectiveSubtitle

ProgressIndicator
├── input: progressInfo.{currentSection, totalSections, overallProgress}
└── display: progress bar, percentage, section name

CurrentQuestionArea
├── input: currentQuestion
├── callbacks: onValueChanged, onSubmit
└── triggers: questionnaireNotifier.answerQuestion()

SectionContainer
├── input: sectionResponse from allResponses[sectionId]
├── callback: onEdit(questionId)
└── triggers: questionnaireNotifier.editResponse()
```

## State Flow

```
User Action → Provider Method → State Update → UI Rebuild

Answer Question:
CurrentQuestionArea.onSubmit()
→ questionnaireNotifier.answerQuestion(id, value)
→ state.copyWith(responses++, currentQuestionId=next)
→ [currentQuestion, progressInfo, allResponses] rebuild

Edit Response:
SectionContainer.onEdit(questionId)
→ questionnaireNotifier.editResponse(id, newValue)
→ state.copyWith(responses.update(questionId))
→ [allResponses] rebuild

Submit:
CompletionArea.onSubmit()
→ questionnaireNotifier.submitQuestionnaire()
→ state.copyWith(isSubmitted=true)
→ UI shows success state
```

## Provider Dependencies

```
currentQuestion ← questionnaireNotifierProvider
allResponses ← questionnaireNotifierProvider
progressInfo ← questionnaireNotifierProvider
currentSectionResponse ← questionnaireNotifierProvider + currentQuestionProvider
brandingConfig ← static

questionnaireNotifier uses:
├── questionnaireConfigServiceProvider
└── responsePersistenceServiceProvider
```

## Key Methods

```
QuestionnaireNotifier:
├── build() → load config + saved state
├── answerQuestion(id, value) → update responses + advance
├── editResponse(id, newValue) → modify existing response
├── submitQuestionnaire() → persist + mark submitted
├── navigateToSection(index) → jump to section
└── resetQuestionnaire() → clear state

Service Layer:
├── QuestionnaireConfigService.loadQuestionnaireConfig() → QuestionnaireConfig
├── ResponsePersistenceService.saveState(state) → void
├── ResponsePersistenceService.loadSavedState() → QuestionnaireState?
└── ResponsePersistenceService.submitResponses(responses) → void
```

## Implementation Pattern

```
1. Provider Definition:
@riverpod
class QuestionnaireNotifier extends _$QuestionnaireNotifier {
  @override
  Future<QuestionnaireState> build() async { /* load logic */ }
  Future<void> answerQuestion(String id, dynamic value) async { /* update logic */ }
}

2. Widget Usage:
class QuestionnairePage extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(questionnaireNotifierProvider);
    final progress = ref.watch(progressInfoProvider);
    return state.when(data: (s) => UI, loading: () => Loading, error: (e,st) => Error);
  }
}

3. Action Trigger:
onSubmit: () => ref.read(questionnaireNotifierProvider.notifier).answerQuestion(id, value)
```