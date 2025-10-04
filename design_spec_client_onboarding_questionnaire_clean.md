# Flutter Design Specification: Client Onboarding Questionnaire

**Generated**: 2025-09-21
**Complexity**: Medium
**Requirements Source**: Plans/Specs/Client_Onboarding_Questionnaire_Spec.md + Plans/Designs/Client_Onboarding_UX_Flow.md
**Flutter Version**: >=3.0.0
**Riverpod Version**: ^2.4.9

---

# CORE SPECIFICATIONS

## 1. Overview

| Field | Details |
|---|---|
| Feature Name | Client Onboarding Questionnaire |
| User Goal | Complete conversational-style questionnaire for nutritionist client onboarding |
| Success Metrics | 85%+ completion rate, 5-10 minute completion time |
| In Scope | Welcome screen, 4-section questionnaire flow, completion screen, editable responses, progress tracking |
| Out of Scope | User authentication, payment processing, appointment scheduling |
| Complexity Level | Medium - Multi-screen flows, complex validation, conditional logic, state persistence |
| Key Dependencies | Riverpod for state management, shared_preferences for persistence, go_router for navigation |

## 2. Screen Flow

| Route | Screen | Purpose | Entry Conditions | Exit/Navigation |
|---|---|---|---|---|
| `/onboarding` | WelcomeScreen | Introduction and time estimate | Direct app entry or deep link | → `/questionnaire` (start), ← Back (exit) |
| `/questionnaire` | QuestionnaireScreen | Chat-style question flow | From welcome or resume | → `/completion` (finished), ← Back (welcome) |
| `/completion` | CompletionScreen | Summary and submission | From questionnaire completion | → Home or restart |

## 3. State Management (Riverpod)

| Provider | Type | Purpose | Watchers | AutoDispose |
|---|---|---|---|---|
| `questionnaireProvider` | `AsyncNotifierProvider<QuestionnaireNotifier, QuestionnaireState>` | Manages questionnaire state and flow | QuestionnaireScreen | No (persistent) |
| `currentQuestionProvider` | `Provider<Question?>` | Current active question | QuestionnaireScreen | Yes |
| `responsesProvider` | `Provider<Map<String, dynamic>>` | All user responses | QuestionnaireScreen, CompletionScreen | No (persistent) |
| `progressProvider` | `Provider<ProgressInfo>` | Progress tracking and section completion | All screens | Yes |
| `brandingProvider` | `Provider<BrandingConfig>` | Clinic branding configuration | All screens | No |

### Provider Responsibilities

**QuestionnaireNotifier Methods:**
- `answerQuestion(questionId, answer)` - Process user response and advance flow
- `editResponse(questionId, newAnswer)` - Update existing response and recalculate flow
- `submitQuestionnaire()` - Submit completed responses to backend
- `_calculateNextQuestion()` - Handle conditional logic for question flow
- `_loadSavedState()` / `_saveState()` - Handle state persistence

**Provider Dependencies:**
- questionnaireProvider → currentQuestionProvider (derives current question)
- questionnaireProvider → responsesProvider (extracts responses map)
- questionnaireProvider → progressProvider (calculates progress metrics)

## 4. Data Models

| Model | Fields | Validation | Serialization | Equality |
|---|---|---|---|---|
| `QuestionnaireState` | currentQuestionId: String?, currentSectionIndex: int, responses: Map<String, dynamic>, isCompleted: bool, isSubmitted: bool | - | fromJson/toJson via freezed | freezed equality |
| `Question` | id: String, sectionId: String, sectionIndex: int, questionText: String, inputType: InputType, required: bool, options: List<String>?, conditionalLogic: ConditionalLogic?, validation: ValidationRules? | Based on inputType and rules | fromJson/toJson via freezed | freezed equality |
| `ConditionalLogic` | dependsOnQuestionId: String, showIfValues: List<dynamic> | dependsOnQuestionId must exist | fromJson/toJson via freezed | freezed equality |
| `ValidationRules` | minLength: int?, maxLength: int?, min: num?, max: num?, pattern: String? | Numeric ranges valid | fromJson/toJson via freezed | freezed equality |
| `BrandingConfig` | clinicName: String, nutritionistName: String, logoUrl: String?, primaryColor: Color, secondaryColor: Color | clinicName and nutritionistName required | Custom color serialization | freezed equality |
| `ProgressInfo` | currentSection: int, totalSections: int, overallProgress: double, sectionProgress: double | Progress between 0.0-1.0 | N/A | freezed equality |

### Input Types

| InputType | Purpose | Validation | UI Component |
|---|---|---|---|
| `textInput` | Single line text | minLength, maxLength, pattern | TextFormField |
| `textArea` | Multi-line text | maxLength | TextFormField (maxLines) |
| `numberInput` | Numeric values | min, max | TextFormField with inputFormatters |
| `singleSelect` | One option from list | required | Radio buttons or Dropdown |
| `multiSelect` | Multiple options | required (at least one) | CheckboxListTile group |
| `unitSelector` | Measurement units | required | Dropdown for units |
| `timeframeSelect` | Duration selection | required | Dropdown for timeframes |

## 5. Question Data Structure

### Section Organization
1. **Personal Info** (Section 0) - 4 questions (Q1-Q4)
2. **Goals** (Section 1) - 3 questions (Q5-Q7)
3. **Health Background** (Section 2) - 3 questions (Q8-Q10)
4. **Lifestyle** (Section 3) - 3 questions (Q11-Q13)

### Conditional Logic Examples
- **Q6** (weight loss amount) only shows if **Q5** = "Lose weight"
- **Q9** (medications) only shows if **Q8** contains medical conditions (not "None")

### Section Completion Messages
| Section | Completion Message |
|---|---|
| Personal Info | "Great! Personal info complete ✅ Now let's talk about what you want to achieve." |
| Goals | "Love your motivation! 💪 Now let's understand your health background." |
| Health Background | "Thanks for sharing! Almost done - just your lifestyle habits left 🏃‍♀️" |
| Lifestyle | "Amazing work! 🎉 You're all done. [NUTRITIONIST_NAME] will review your responses and create your personalized plan. You'll hear back within 24-48 hours!" |

## 6. Widget Structure

| Screen | Main Components | Key Props | Interactions |
|---|---|---|---|
| WelcomeScreen | BrandingHeader + WelcomeContent + TimeEstimateList + ActionButtons | brandingConfig, onStart | Start questionnaire, show info dialog |
| QuestionnaireScreen | ProgressIndicator + ChatInterface + CurrentQuestionInput | state, onAnswer, onEdit | Scroll chat, answer questions, edit responses |
| CompletionScreen | CompletionHeader + ResponsesSummary + SubmissionActions | responses, onSubmit, onReview | Review responses, submit form |

### Chat Interface Components
| Component | Purpose | Features |
|---|---|---|
| `ChatInterface` | Main conversation container | Scrollable history, section grouping |
| `SectionHeader` | Visual section separator | Section name, border styling |
| `QuestionBubble` | Bot question display | Left-aligned, bot avatar, question text |
| `AnswerBubble` | User response display | Right-aligned, user avatar, formatted answer, edit button |
| `CompletionMessage` | Section completion celebration | Encouraging message, emoji, progress indicator |
| `CurrentQuestionInput` | Active question input | Dynamic input type, validation, submit button |

### Input Components by Type
| Input Type | Component | Features |
|---|---|---|
| textInput | `TextFormField` | Character counter, real-time validation |
| numberInput | `TextFormField` | Numeric keyboard, input formatters, min/max hints |
| singleSelect | `RadioListTile` group or `DropdownButton` | Clear selection, option descriptions |
| multiSelect | `CheckboxListTile` group | Select all/none, "Other" option with text field |
| textArea | `TextFormField` | Multi-line, character counter, expandable |

## 7. Navigation & Routing

| Route Pattern | Deep Link | Guards | Transition | Back Behavior |
|---|---|---|---|---|
| `/onboarding` | `app://onboarding` | None | Fade in | Exit app |
| `/questionnaire` | `app://questionnaire` | Check if started | Slide left | Back to welcome with save prompt |
| `/completion` | `app://completion` | Must be completed | Slide up | No back (completed state) |

### Navigation Rules
- **Welcome to Questionnaire**: Direct navigation, auto-start first question
- **Questionnaire Back Navigation**: Show save prompt dialog before leaving
- **Completion Guard**: Redirect to questionnaire if not actually completed
- **Deep Links**: Support resuming questionnaire from any valid state

## 8. Form Validation & Error Handling

| Input Type | Validation Rules | Error Messages | Real-time Validation |
|---|---|---|---|
| Text Input | minLength, maxLength, required | "Please enter at least {min} characters" | Character count, instant feedback |
| Number Input | min, max, required | "Please enter a number between {min} and {max}" | Numeric format, range validation |
| Single Select | required | "Please select an option" | Selection required before continue |
| Multi Select | required (at least one) | "Please select at least one option" | Minimum selection validation |
| Text Area | maxLength | "Maximum {max} characters allowed" | Character counter with warning |

### Error Handling Strategy

| Error Type | User Feedback | Recovery Action | Logging | Retry Policy |
|---|---|---|---|---|
| Validation Error | Inline field error | Fix input and continue | Warning | Immediate |
| Network Error | SnackBar with retry | Retry submission | Error + stack | Manual retry |
| State Error | Dialog with explanation | Restart questionnaire | Critical | Manual only |
| Storage Error | Toast notification | Continue without saving | Warning | Automatic fallback |

## 9. Progress Tracking

### Progress Calculation
- **Overall Progress**: (Answered Questions / Total Questions) * 100
- **Section Progress**: (Answered in Section / Total in Section) * 100
- **Visual Indicators**: Progress bar, section checkmarks, completion badges

### Progress Display
- **Header Progress Bar**: Shows overall completion percentage
- **Section Indicators**: Visual completion status for each section
- **Question Counter**: "Question X of Y" within each section
- **Time Estimate**: Remaining time based on average completion

## 10. State Persistence

### What to Save
- Current question ID and section
- All user responses (validated and raw)
- Timestamp of last activity
- Branding configuration
- Progress state

### When to Save
- After each question response
- Before navigation away
- On app backgrounding
- Debounced during text input

### Storage Strategy
- **Primary**: SharedPreferences for simple key-value storage
- **Backup**: In-memory state for session continuity
- **Clear Conditions**: After successful submission or explicit reset

## 11. Accessibility Features

### Screen Reader Support
- Semantic labels for all interactive elements
- Progress announcements for section completion
- Question numbering and section context
- Answer format descriptions

### Keyboard Navigation
- Tab order through form elements
- Enter/Space activation for buttons
- Arrow key navigation for radio/checkbox groups
- Focus indicators for current element

### Visual Accessibility
- High contrast color schemes
- Scalable text support
- Clear focus indicators
- Color-independent status indicators

## 12. Performance Considerations

### Memory Management
- AutoDispose temporary providers
- Lazy loading of question metadata
- Efficient image caching for branding
- Dispose scroll controllers and text controllers

### Rendering Optimization
- ListView.builder for chat history
- Conditional rendering for large option lists
- Debounced text input validation
- Minimal rebuilds with granular providers

### Storage Efficiency
- Compress state before persistence
- Clean up expired session data
- Batch storage operations
- Efficient JSON serialization

---

# Package Requirements

## Core Dependencies
- **flutter_riverpod**: ^2.4.9 - State management
- **go_router**: ^14.0.0 - Navigation and routing
- **freezed**: ^2.4.6 + **json_annotation**: ^4.8.1 - Immutable models
- **shared_preferences**: ^2.2.2 - Local storage

## UI Enhancement
- **flutter_form_builder**: ^9.1.0 - Advanced form components
- **form_builder_validators**: ^9.1.0 - Pre-built validation rules
- **flutter_spinkit**: ^5.2.0 - Loading animations

## Development Tools
- **riverpod_generator**: ^2.3.0 + **build_runner**: ^2.4.7 - Code generation
- **flutter_lints**: ^3.0.0 - Code quality
- **mockito**: ^5.4.0 - Testing utilities

---

# Implementation Phases

## Phase 1: Core Structure
1. Set up data models with Freezed
2. Create Riverpod providers and state management
3. Build basic screen navigation with go_router
4. Implement question data structure

## Phase 2: UI Implementation
5. Build WelcomeScreen with branding
6. Create ChatInterface with message bubbles
7. Implement question input components
8. Add progress tracking and indicators

## Phase 3: Advanced Features
9. Add conditional question logic
10. Implement response editing functionality
11. Build completion and submission flow
12. Add state persistence

## Phase 4: Polish & Testing
13. Implement comprehensive validation
14. Add error handling and loading states
15. Accessibility improvements
16. Performance optimization and testing

---

# Success Criteria

- [ ] **Completion Rate**: 85%+ users complete entire questionnaire
- [ ] **Time Performance**: Average completion time 5-10 minutes
- [ ] **User Experience**: Smooth chat-like interaction with no UI lag
- [ ] **Data Quality**: 95%+ valid responses with proper validation
- [ ] **Accessibility**: Full screen reader compatibility
- [ ] **Reliability**: State persistence across app restarts
- [ ] **Responsive**: Works on all screen sizes from phone to tablet