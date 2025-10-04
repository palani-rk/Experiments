# Flutter Design Specification: Client Onboarding Questionnaire

**Generated**: 2025-01-26
**Status**: In Progress - Interactive Design Phase
**Complexity**: Medium
**Requirements Source**: Plans/Specs/Client_Onboarding_Questionnaire_Spec.md + Plans/Designs/Client_Onboarding_UX_Flow.md
**Flutter Version**: TBD (from pubspec.yaml)
**Riverpod Version**: TBD (from pubspec.yaml)
**Target Platform**: Mobile-first

---

## Specification Sections

### ✅ Completed Sections
- [x] 1. Overview & Scope
- [x] 2. Screen Flow & Navigation
- [x] 3. State Management Architecture
- [x] 4. Data Models & Validation
- [x] 5. Widget Structure & UI Patterns
- [x] 6. API Requirements & Integration
- [x] 7. Services & Repository Layer

### 🔄 Extended Sections (Medium Complexity)
- [ ] 8. Navigation & Routing Strategy
- [ ] 9. Error Handling & Recovery
- [ ] 10. Form Controllers & Validation

---

## 1. Overview & Scope

| Field | Details |
|---|---|
| Feature Name | Client Onboarding Questionnaire |
| User Goal | Complete nutrition assessment questionnaire in conversational chat format within 5-10 minutes |
| Success Metrics | 85%+ completion rate, 5-10 minute completion time, high data quality and completeness |
| In Scope | 4-section questionnaire flow (Personal Info, Goals, Health Background, Lifestyle), conversational chat UI, inline editing of responses, progress tracking, section-level persistence, dual-mode operation (testing/production), compile-time branding |
| Out of Scope | Complex conditional logic beyond basic branching, runtime branding configuration, multi-device sync, AI-driven adaptive questioning, real-time collaboration |
| Complexity Level | Medium - Multi-screen flow with form validation, conditional logic, dual persistence modes, and custom chat UI |
| Key Dependencies | Backend API for production mode (questionnaire config + response persistence), Local JSON structure for testing mode, Branding assets at compile time, Flutter form validation framework |

## 2. Screen Flow & Navigation

| Route | Screen | Purpose | Entry Conditions | Exit/Navigation |
|---|---|---|---|---|
| `/welcome` | WelcomeScreen | Introduction with time estimate and section preview | App launch or questionnaire start | → `/questionnaire` (start questionnaire) |
| `/questionnaire` | QuestionnaireScreen | Main conversational interface with 4 sections | From welcome or resume session | → `/review` (after all sections complete) |
| `/review` | ReviewScreen | Review all responses using same section components with edit options | All 4 sections completed | → `/questionnaire` (edit mode), → Complete (final submission) |
| `/completion` | CompletionScreen | Success message and next steps | After final submission | → App exit or home |

### Navigation Flow
| From Screen | To Screen | Trigger | Back Behavior | Deep Link Support |
|---|---|---|---|---|
| Welcome | Questionnaire | "Yes, let's do this!" button | Exit app (confirmation dialog) | No |
| Questionnaire | Questionnaire | Section progression (linear) | Previous question within section | No |
| Questionnaire | Review | All 4 sections completed | Last completed section | No |
| Review | Questionnaire | Edit button on any response | Specific question for editing | No |
| Review | Completion | Final submission | Cannot go back | No |

### Section Progression Logic
| Current Section | Next Section | Persistence Trigger | Navigation Rule |
|---|---|---|---|
| Personal Info (Section 1) | Goals (Section 2) | Save section 1 responses | Must complete all required questions |
| Goals (Section 2) | Health Background (Section 3) | Save section 2 responses | Must complete all required questions |
| Health Background (Section 3) | Lifestyle (Section 4) | Save section 3 responses | Must complete all required questions |
| Lifestyle (Section 4) | Review Screen | Save section 4 responses | Must complete all required questions |

## 3. State Management Architecture (Riverpod)

| Provider | Type | Purpose | Watchers | AutoDispose |
|---|---|---|---|---|
| `brandingConfigProvider` | `FutureProvider<BrandingConfig>` | Loads clinic branding configuration | All screens with BrandingHeader | No (shared across app) |
| `questionnaireConfigProvider` | `FutureProvider<QuestionnaireConfig>` | Loads questionnaire structure from JSON/API based on mode | Questionnaire & Review screens | No (shared across session) |
| `currentSectionProvider` | `StateNotifierProvider<CurrentSectionState>` | Manages active section, current question, input validation | QuestionnaireScreen components | Yes |
| `completedSectionsProvider` | `StateNotifierProvider<CompletedSectionsState>` | Manages completed Q&A pairs, section responses | ChatHistory, ReviewScreen | Yes |
| `editStateProvider` | `StateNotifierProvider<EditState>` | Manages which response is being edited | EditableResponse, ReviewScreen | Yes |
| `submissionStatusProvider` | `StateNotifierProvider<SubmissionStatus>` | Tracks final submission progress | ReviewScreen, CompletionScreen | Yes |

### Provider Dependencies
| Provider | Depends On | Invalidates | Lifespan |
|---|---|---|---|
| currentSectionProvider | questionnaireConfigProvider | editStateProvider when editing | Session (questionnaire start to completion) |
| completedSectionsProvider | questionnaireConfigProvider | None | Session (questionnaire start to completion) |
| editStateProvider | completedSectionsProvider | currentSectionProvider when editing current question | Per edit operation |
| submissionStatusProvider | completedSectionsProvider | None | Final submission only |

### State Transitions
| From State | To State | Trigger | Side Effects |
|---|---|---|---|
| CurrentSectionState.questionActive | CurrentSectionState.questionCompleted | Valid response submitted | Auto-advance to next question |
| CurrentSectionState.sectionActive | CurrentSectionState.sectionCompleted | All required questions answered | Save section via ResponsePersistenceService, update completedSectionsProvider |
| CompletedSectionsState.viewing | CompletedSectionsState.editing | Edit button clicked on any response | Activate editStateProvider for specific question |
| EditState.inactive | EditState.editing | Edit initiated from any screen | Load current response value, enable edit UI |
| EditState.editing | EditState.saving | Save button clicked | Persist change via ResponsePersistenceService |

### Provider State Structures
| Provider | State Fields | Key Methods | State Updates |
|---|---|---|---|
| currentSectionProvider | currentSectionIndex: int, currentQuestionIndex: int, currentResponse: Response?, isLoading: bool, validationErrors: Map<String,String> | answerCurrentQuestion(), moveToNextQuestion(), moveToNextSection() | Real-time validation, section progression |
| completedSectionsProvider | sectionResponses: List<SectionResponse>, lastCompletedSection: int | addCompletedSection(), updateResponse(), getAllResponses() | Section completion, response updates |
| editStateProvider | isEditing: bool, editingQuestionId: String?, originalValue: dynamic, editedValue: dynamic | startEdit(), saveEdit(), cancelEdit() | Edit operations across screens |
| submissionStatusProvider | isSubmitting: bool, isComplete: bool, error: String? | submitQuestionnaire(), retry() | Final submission tracking |

## 5. Widget Structure & UI Patterns

| Screen | Widget Tree | Key Props | Interactions |
|---|---|---|---|
| WelcomeScreen | Scaffold > Column > [Header, IntroContent, ActionButtons] | clinicLogo, nutritionistName, clientName | Start questionnaire, Ask questions |
| QuestionnaireScreen | Scaffold > Column > [Header, ProgressBar, ChatHistory, CurrentQuestionInput] | currentSection, completedSections, activeQuestion | Scroll chat history, Answer current question |
| ReviewScreen | Scaffold > Column > [Header, SectionedResponseList, SubmissionArea] | allResponses, editMode | Edit any response, Final submission |
| CompletionScreen | Scaffold > Column > [Header, SuccessMessage, NextSteps] | submissionStatus, nextActions | Navigate to next flow |

### Reusable Components
| Component | Purpose | Props | Usage Context |
|---|---|---|---|
| BrandingHeader | Display clinic logo and title | logoUrl, title, subtitle | All screens header |
| ProgressIndicator | Show section completion progress | currentSection, totalSections, sectionNames | Questionnaire screen |
| ChatBubble | Display bot questions and user responses | messageType, content, isEditable, onEdit | Chat history display |
| SectionContainer | Group completed Q&A by section | sectionTitle, questionAnswerPairs, onEdit | Chat history and review |
| QuestionInput | Dynamic input based on question type | questionType, options, validation, onSubmit | Active question area |
| EditableResponse | User response with edit capability | responseValue, questionType, onSave, onCancel | Inline editing |

### UI States
| Screen | Loading State | Error State | Empty State | Success State |
|---|---|---|---|---|
| WelcomeScreen | Loading branding config | Network error with retry | Default welcome content | Ready to start |
| QuestionnaireScreen | Loading question, Saving response | Validation errors, Save failures | No completed sections yet | Section completion animations |
| ReviewScreen | Loading responses | Edit save failures | No responses (shouldn't occur) | All responses loaded |
| CompletionScreen | Submitting final responses | Submission failures with retry | N/A | Submission success |

### Layout Patterns
| Component | Layout Strategy | Responsive Behavior | Animation |
|---|---|---|---|
| ChatHistory | ScrollView with auto-scroll to bottom | Expands to fill available space | Smooth scroll to new sections |
| CurrentQuestionInput | Fixed bottom position | Keyboard-aware resizing | Slide up/down transitions |
| SectionContainer | Grouped card layout | Stack vertically, wrap content | Expand/collapse on section completion |
| ProgressIndicator | Horizontal progress bar | Scale to screen width | Fill animation on progress |

### Input Validation Strategy
| Validation Type | Trigger | Display Method | User Feedback |
|---|---|---|---|
| Required Field | On blur, real-time typing | Inline error below input | Red border, error text |
| Format Validation | Real-time as user types | Inline validation icons | Green checkmark, red X |
| Range Validation | Real-time for numbers | Inline helper text | Dynamic range guidance |
| Conditional Logic | Question dependency changes | Show/hide dependent questions | Smooth transitions |

### Design System Integration
**Theme Usage**: All widgets must use the existing theme system defined in `lib/shared/theme/app_theme.dart`:
- **Color Scheme**: Use `Theme.of(context).colorScheme` for consistent colors across light/dark modes
- **Text Styles**: Apply `AppTextStyles` constants for typography (chatMessage, questionText, answerText, etc.)
- **Spacing**: Use `AppSizes` constants for consistent spacing and sizing (s, m, l, xl, radiusM, etc.)
- **Shadows**: Apply `AppShadows.chatBubble()` and `AppShadows.card()` for consistent elevation
- **Animations**: Use `AppDurations` constants (fast, normal, slow) for consistent motion design

## 4. Data Models & Validation

| Model | Fields | Validation | Serialization | Equality |
|---|---|---|---|---|
| `Question` | id: String, sectionId: String, questionText: String, inputType: QuestionType, required: bool, options: List<String>?, validation: ValidationRules?, placeholder: String? | questionText: required, non-empty; inputType: valid enum; validation rules consistency | fromJson/toJson for both local and API | ID-based equality |
| `QuestionSection` | id: String, title: String, description: String?, questions: List<Question>, completionMessage: String | title: required, non-empty; questions: non-empty list | fromJson/toJson for both local and API | ID-based equality |
| `QuestionnaireConfig` | id: String, title: String, sections: List<QuestionSection>, brandingConfig: BrandingConfig | title: required; sections: exactly 4 sections; valid branding | fromJson/toJson for both local and API | ID-based equality |
| `Response` | questionId: String, value: dynamic, timestamp: DateTime | questionId: must reference valid question; value: matches question type validation | fromJson/toJson for both local and API | questionId-based equality |
| `SectionResponse` | sectionId: String, responses: List<Response>, status: SectionStatus, completedAt: DateTime?, savedAt: DateTime | sectionId: must reference valid section; responses: match section questions; status: valid enum | fromJson/toJson for both local and API | sectionId-based equality |
| `SectionStatus` | enum: not_started, in_progress, completed | N/A | String mapping | Dart enum |
| `QuestionnaireSubmission` | questionnaireId: String, userId: String, sectionResponses: List<SectionResponse>, submittedAt: DateTime?, isComplete: bool | userId: required; questionnaireId: must reference valid questionnaire; all sections completed for final submission | fromJson/toJson for both local and API | ID-based equality |

### Model Relationships
| Model | Related To | Relationship Type | Cardinality |
|---|---|---|---|
| QuestionnaireConfig | QuestionSection | Contains | 1:n  |
| QuestionSection | Question | Contains | 1:N |
| QuestionnaireSubmission | SectionResponse | Contains | 1:N |
| SectionResponse | Response | Contains | 1:N |
| Response | Question | References via ID | N:1 |

### Validation Rules
| Field | Rule Type | Parameters | Error Message |
|---|---|---|---|
| Question.questionText | Required + Length | min_length: 1, max_length: 500 | "Question text is required and must be under 500 characters" |
| Response.value (text_input) | Type + Length | type: String, min_length varies by question | "Please enter valid text" |
| Response.value (number_input) | Type + Range | type: num, range varies by question (age: 18-100) | "Please enter a number between {min} and {max}" |
| Response.value (single_select) | Choice Validation | value must be in question.options | "Please select a valid option" |
| Response.value (multi_select) | Choice + Other Validation | values must be in options OR contain "other" with text | "Please select valid options" |

### Question Types & Input Patterns
| QuestionType | Expected Value Format | Validation Pattern | UI Component |
|---|---|---|---|
| text_input | String | Length constraints, pattern matching if specified | TextFormField |
| number_input | num (with optional unit) | Range validation, numeric format | NumberFormField + UnitSelector |
| single_select | String (selected option) | Must match one of question.options | RadioButtonGroup or DropdownButton |
| multi_select | List<String> (selected options) | Each must match question.options or be "other:text" | CheckboxGroup with OtherTextField |
| text_area | String | Length constraints, multiline | TextFormField(maxLines: null) |

## 6. API Requirements & Integration

| Endpoint | Method | Request | Response | Error Codes |
|---|---|---|---|---|
| `/api/questionnaires/{id}` | GET | - | `QuestionnaireConfig` | 404, 401, 500 |
| `/api/branding/config` | GET | - | `BrandingConfig` | 401, 500 |
| `/api/questionnaires/{questionnaireId}/sections/{sectionId}/responses` | POST | `SectionResponse` | `{success: bool, message: string}` | 400, 404, 401, 500 |
| `/api/questionnaires/{questionnaireId}/sections/{sectionId}/responses/{responseId}` | PUT | `Response` | `{success: bool, message: string}` | 400, 404, 401, 500 |
| `/api/questionnaires/{questionnaireId}/submit` | POST | `QuestionnaireSubmission` | `{success: bool, submissionId: string, message: string}` | 400, 404, 401, 500 |

### Dual Mode Operation
| Mode | Configuration Source | Response Persistence | Branding Source |
|---|---|---|---|
| Testing | `assets/questionnaire_config.json` | `local_storage/responses_{userId}.json` | `assets/branding_config.json` |
| Production | `GET /api/questionnaires/{id}` | API endpoints above | `GET /api/branding/config` |

### Request/Response Formats

#### Section Response Submission (POST)
```json
{
  "sectionId": "section_1_personal_info",
  "userId": "user123",
  "responses": [
    {
      "questionId": "Q1",
      "value": "Sarah Johnson",
      "timestamp": "2025-01-26T10:30:00Z"
    }
  ],
  "completedAt": "2025-01-26T10:35:00Z"
}
```

#### Individual Response Update (PUT)
```json
{
  "questionId": "Q1",
  "value": "Sarah M. Johnson",
  "timestamp": "2025-01-26T11:00:00Z"
}
```

#### Final Submission (POST)
```json
{
  "questionnaireId": "nutrition_onboarding_v1",
  "userId": "user123",
  "sectionResponses": [
    {
      "sectionId": "section_1_personal_info",
      "responses": [...],
      "isCompleted": true,
      "completedAt": "2025-01-26T10:35:00Z"
    }
  ],
  "submittedAt": "2025-01-26T11:15:00Z"
}
```

### Authentication & Authorization
| Aspect | Implementation | Requirements |
|---|---|---|
| Authentication Method | Bearer Token or API Key | Include in Authorization header |
| Session Management | Token-based with refresh | Handle token expiration gracefully |
| User Identification | userId in request payload | Must be consistent across requests |

### Error Response Format
| Error Code | Type | Response Format | User Action |
|---|---|---|---|
| 400 | Validation Error | `{error: "string", details: {...}}` | Show validation errors inline |
| 401 | Authentication Error | `{error: "Unauthorized"}` | Redirect to login/refresh token |
| 404 | Not Found | `{error: "Resource not found"}` | Show user-friendly error message |
| 500 | Server Error | `{error: "Internal server error"}` | Show retry option with support contact |

### Local JSON File Structure (Testing Mode)

#### questionnaire_config.json
```json
{
  "id": "nutrition_onboarding_v1",
  "title": "Nutrition Plan Questionnaire",
  "sections": [
    {
      "id": "section_1_personal_info",
      "title": "Personal Info",
      "questions": [...]
    }
  ],
  "brandingConfig": {...}
}
```

#### responses_{userId}.json
```json
{
  "questionnaireId": "nutrition_onboarding_v1",
  "userId": "user123",
  "sectionResponses": [...],
  "lastUpdated": "2025-01-26T11:00:00Z"
}
```

## 7. Services & Repository Layer

| Service | Methods | Return Type | Error Handling | Notes |
|---|---|---|---|---|
| QuestionnaireConfigService | loadQuestionnaire(questionnaireId), reloadQuestionnaire() | Future<QuestionnaireConfig> | Throws ConfigException | No caching - reloads each time, mode explicitly configured |
| ResponsePersistenceService | saveSection(sectionResponse), updateResponse(response), savePartialSection(sectionResponse), loadUserResponses(userId), deleteUserResponses(userId), submitQuestionnaire(submission) | Future<bool> | Throws PersistenceException | Handles both completed and partial section saves |
| BrandingService | loadBrandingConfig() | Future<BrandingConfig> | Throws ConfigException | Mode explicitly configured at service level |
| ResumeService | checkExistingResponses(userId), determineResumePoint(responses), clearExistingResponses(userId) | Future<ResumeState?> | Returns null if no resume data | Orchestrates resume logic and cleanup |

### Service Dependencies
| Service | Depends On | Provides To | Lifecycle |
|---|---|---|---|
| QuestionnaireConfigService | Mode Configuration (testing/production) | All Providers needing questionnaire data | App-level singleton |
| ResponsePersistenceService | Mode Configuration, File System (testing), HTTP Client (production) | currentSectionProvider, completedSectionsProvider | App-level singleton |
| BrandingService | Mode Configuration | brandingConfigProvider | App-level singleton |
| ResumeService | ResponsePersistenceService | Welcome page, currentSectionProvider initialization | Session-level |

### Service Mode Configuration
| Mode | Configuration Source | Service Behavior | Storage Location |
|---|---|---|---|
| Testing | Compile-time flag or environment variable | Load from assets, save to local files | `assets/` for config, `local_storage/` for responses |
| Production | Compile-time flag or environment variable | API calls with authentication | Remote API endpoints |

### Resume Functionality
| Resume Scenario | Detection Method | User Experience | Data Handling |
|---|---|---|---|
| No Previous Data | ResumeService.checkExistingResponses() returns null | Show normal welcome screen | Standard questionnaire flow |
| Partial Progress | ResumeService finds incomplete sections | Welcome screen shows "Resume" vs "Start Fresh" options | Load partial data, determine next question |
| All Sections Complete | ResumeService finds all sections completed but not submitted | Navigate directly to Review screen | Load all responses for review |
| Previously Submitted | ResumeService finds completed submission | Show completion screen or redirect | Read-only access to responses |

### Error Handling Strategy
| Error Type | Service Response | Provider Handling | User Experience |
|---|---|---|---|
| Network Error (Production) | Throw PersistenceException with retry info | Show retry dialog | "Connection failed. Tap to retry." |
| File Access Error (Testing) | Throw ConfigException with file details | Show technical error | "Unable to load questionnaire. Check app installation." |
| Validation Error | Throw ValidationException with field details | Show inline field errors | Highlight specific invalid fields |
| Authentication Error | Throw AuthException | Redirect to login/refresh | "Session expired. Please log in again." |

### Data Flow Patterns
| Operation | Service Chain | Data Transformation | Persistence Action |
|---|---|---|---|
| Load Questionnaire | QuestionnaireConfigService → Mode Check → JSON/API Load | Raw data → QuestionnaireConfig model | No persistence |
| Save Section | ResponsePersistenceService → Validation → Mode-based Save | SectionResponse → JSON/API format | File write or API POST |
| Update Response (Edit) | ResponsePersistenceService → Load → Update → Save | Single Response update within section | Partial file update or API PUT |
| Resume Detection | ResumeService → ResponsePersistenceService → Analysis | Raw responses → ResumeState | Read-only operation |
| Start Fresh | ResumeService → ResponsePersistenceService.deleteUserResponses() | Clear all user data | File deletion or API cleanup |

### Service Implementation Notes
| Service | Key Implementation Details | Testing Considerations | Performance Notes |
|---|---|---|---|
| QuestionnaireConfigService | Switch between asset loading and HTTP client based on mode | Mock different questionnaire configs | No caching - fresh load each time |
| ResponsePersistenceService | File I/O operations in testing mode, HTTP operations in production | Mock file system and API responses | Optimize JSON serialization for large responses |
| BrandingService | Asset loading vs API loading, handle missing assets gracefully | Test with different branding configs | Cache branding config at app level |
| ResumeService | Complex logic for determining resume point from partial data | Test all resume scenarios thoroughly | Efficient response analysis algorithms |

---

## Implementation Plan

### Phase 1: Foundation & Static UI (Week 1)
**Goal**: Create basic app structure with static questionnaire display

#### Deliverables:
- [ ] Flutter project setup with folder structure
- [ ] Data models implemented (Question, QuestionSection, QuestionnaireConfig, Response types)
- [ ] Static welcome screen with branding header
- [ ] Basic questionnaire screen showing hardcoded questions
- [ ] Static chat bubble components (bot questions, user responses)

#### Verifiable Outputs:
- **Demo**: App launches and shows welcome screen → navigate to questionnaire with sample questions
- **Code Review**: All data models with proper serialization (fromJson/toJson)
- **UI Test**: Chat interface displays correctly on different screen sizes

#### Success Criteria:
- App builds and runs without errors
- Welcome screen displays branding and questionnaire intro
- Questionnaire screen shows chat interface with sample Q&A pairs
- All data models pass unit tests for serialization

---

### Phase 2: Testing Mode & Local JSON (Week 2)
**Goal**: Implement complete testing mode functionality

#### Deliverables:
- [ ] QuestionnaireConfigService (testing mode only)
- [ ] Local JSON questionnaire configuration file
- [ ] ResponsePersistenceService (local file operations)
- [ ] Complete questionnaire flow (all 4 sections)
- [ ] Progress indicator and section transitions

#### Verifiable Outputs:
- **Demo**: Complete questionnaire from start to finish in testing mode
- **Data Persistence**: Responses saved to local file, survive app restart
- **JSON Config**: Questionnaire loaded from assets/questionnaire_config.json
- **Section Flow**: All 4 sections display with proper progression

#### Success Criteria:
- Questionnaire loads from local JSON file
- Users can complete all sections and see progress
- Responses persist between app sessions
- Section completion triggers save to local storage

---

### Phase 3: Interactive Input & Validation (Week 3)
**Goal**: Add real input handling and validation

#### Deliverables:
- [ ] QuestionInput component (all input types: text, number, single-select, multi-select)
- [ ] Real-time validation with error display
- [ ] Form state management with Riverpod providers
- [ ] Current question tracking and progression logic
- [ ] Input-specific UI components (dropdowns, checkboxes, etc.)

#### Verifiable Outputs:
- **Demo**: Users can actually input answers for all question types
- **Validation**: Real-time validation with error messages for invalid inputs
- **State Management**: Form state persists during navigation within sections
- **Input Types**: All question types (text, number, select, multi-select) working

#### Success Criteria:
- All input types render correctly and accept user input
- Validation shows immediate feedback for invalid entries
- Users cannot proceed without completing required fields
- Form state is properly managed across component updates

---

### Phase 4: Edit Functionality & Review Screen (Week 4)
**Goal**: Enable response editing and review workflow

#### Deliverables:
- [ ] EditableResponse component with inline editing
- [ ] Edit state management (editStateProvider)
- [ ] Review screen with sectioned response display
- [ ] Edit mode for individual responses
- [ ] Response update persistence

#### Verifiable Outputs:
- **Demo**: Users can edit any previous response from questionnaire or review screen
- **Review Screen**: All responses grouped by section with edit buttons
- **Edit Persistence**: Changes save immediately and reflect across screens
- **Edit Cancellation**: Users can cancel edits and revert to original values

#### Success Criteria:
- Any completed response can be edited inline
- Review screen displays all responses grouped by section
- Edits persist to local storage immediately
- Edit/cancel functionality works consistently

---

### Phase 5: Resume Functionality (Week 5)
**Goal**: Complete resume capability with partial saves

#### Deliverables:
- [ ] ResumeService implementation
- [ ] "Save and Resume Later" functionality
- [ ] Resume detection on welcome screen
- [ ] Partial section persistence
- [ ] Start Fresh option with data cleanup

#### Verifiable Outputs:
- **Demo**: Start questionnaire → save mid-section → restart app → resume from exact question
- **Welcome Screen**: Shows "Resume" vs "Start Fresh" options when data exists
- **Data Cleanup**: "Start Fresh" completely removes previous responses
- **Resume Points**: Correctly resumes from partial sections or review screen

#### Success Criteria:
- Users can save progress mid-section and resume later
- Welcome screen detects existing responses and offers resume
- Resume functionality works for all scenarios (partial, complete, submitted)
- Start Fresh option properly cleans up existing data

---

### Phase 6: Production Mode & API Integration (Week 6)
**Goal**: Add production mode with API connectivity

#### Deliverables:
- [ ] Mode configuration system (testing vs production)
- [ ] API client implementation
- [ ] BrandingService with API support
- [ ] ResponsePersistenceService API operations
- [ ] Error handling for network operations

#### Verifiable Outputs:
- **Demo**: Switch between testing and production modes
- **API Integration**: Load questionnaire from API, save responses to API
- **Error Handling**: Network errors display user-friendly messages with retry
- **Mode Switching**: Same app works in both modes without code changes

#### Success Criteria:
- App successfully loads questionnaire from API in production mode
- Section responses save to API with proper error handling
- Mode switching works through configuration change
- Network errors provide clear user feedback and recovery options

---

### Phase 7: Polish & Completion Flow (Week 7)
**Goal**: Complete user experience with final submission and animations

#### Deliverables:
- [ ] Final submission workflow
- [ ] Completion screen with success messaging
- [ ] Section transition animations
- [ ] Loading states and progress indicators
- [ ] Comprehensive error handling

#### Verifiable Outputs:
- **Demo**: Complete end-to-end user journey with smooth animations
- **Final Submission**: Review → Submit → Completion screen workflow
- **Loading States**: All async operations show appropriate loading indicators
- **Error Recovery**: All error scenarios have clear recovery paths

#### Success Criteria:
- Smooth animations between sections and screens
- Final submission creates complete QuestionnaireSubmission
- All loading states provide clear user feedback
- Error scenarios don't break the user flow

---

### Phase 8: Testing & Quality Assurance (Week 8)
**Goal**: Comprehensive testing and bug fixes

#### Deliverables:
- [ ] Unit tests for all services and providers
- [ ] Widget tests for all components
- [ ] Integration tests for complete user flows
- [ ] Performance optimization
- [ ] Accessibility improvements

#### Verifiable Outputs:
- **Test Coverage**: 90%+ code coverage for business logic
- **Performance**: Smooth 60fps on target devices
- **Accessibility**: Screen reader and keyboard navigation support
- **Cross-Device**: Consistent experience across phone/tablet sizes

#### Success Criteria:
- All critical user flows covered by automated tests
- App performs smoothly on minimum target device specifications
- Accessibility guidelines met for all interactive elements
- No critical bugs in end-to-end testing

---

## Phase Dependencies

```
Phase 1 (Foundation)
    ↓
Phase 2 (Testing Mode) ←── Must complete before Phase 6
    ↓
Phase 3 (Input & Validation)
    ↓
Phase 4 (Edit & Review)
    ↓
Phase 5 (Resume Functionality)
    ↓
Phase 6 (Production Mode) ←── Requires Phase 2 completion
    ↓
Phase 7 (Polish & Completion)
    ↓
Phase 8 (Testing & QA)
```

## Risk Mitigation

| Risk | Phase | Mitigation Strategy |
|---|---|---|
| Complex state management | Phase 3-4 | Start with simple state, incrementally add complexity |
| API integration challenges | Phase 6 | Ensure Phase 2 (testing mode) works perfectly first |
| Resume logic complexity | Phase 5 | Build on solid foundation from Phase 2-4 |
| Performance issues | Phase 7-8 | Regular performance testing throughout development |

---

## Project Folder Structure

### Feature Organization: `lib/features/client_questionnaire_flow/`

```
lib/features/client_questionnaire_flow/
├── data/
│   ├── models/
│   │   ├── question.dart                    # Question model with validation rules
│   │   ├── question.freezed.dart            # Generated freezed boilerplate
│   │   ├── question.g.dart                  # Generated JSON serialization
│   │   ├── question_section.dart            # QuestionSection model with completion logic
│   │   ├── question_section.freezed.dart    # Generated freezed boilerplate
│   │   ├── question_section.g.dart          # Generated JSON serialization
│   │   ├── questionnaire_config.dart        # Complete questionnaire configuration
│   │   ├── questionnaire_config.freezed.dart # Generated freezed boilerplate
│   │   ├── questionnaire_config.g.dart      # Generated JSON serialization
│   │   ├── response.dart                    # Individual response model
│   │   ├── response.freezed.dart            # Generated freezed boilerplate
│   │   ├── response.g.dart                  # Generated JSON serialization
│   │   ├── section_response.dart            # Section-level response with status
│   │   ├── section_response.freezed.dart    # Generated freezed boilerplate
│   │   ├── section_response.g.dart          # Generated JSON serialization
│   │   ├── questionnaire_submission.dart    # Final submission model
│   │   ├── questionnaire_submission.freezed.dart # Generated freezed boilerplate
│   │   ├── questionnaire_submission.g.dart  # Generated JSON serialization
│   │   ├── branding_config.dart             # Branding configuration model
│   │   ├── branding_config.freezed.dart     # Generated freezed boilerplate
│   │   ├── branding_config.g.dart           # Generated JSON serialization
│   │   └── enums.dart                       # QuestionType, SectionStatus enums
│   ├── services/
│   │   ├── questionnaire_config_service.dart # Load questionnaire from JSON/API
│   │   ├── response_persistence_service.dart # Save/load responses (dual mode)
│   │   ├── branding_service.dart            # Load branding configuration
│   │   └── resume_service.dart              # Handle resume functionality
│   └── repositories/
│       ├── local_questionnaire_repository.dart # Local JSON file operations
│       └── api_questionnaire_repository.dart   # API operations for production mode
├── domain/
│   ├── entities/                            # Clean domain entities (if using clean architecture)
│   └── usecases/                            # Business logic use cases (if using clean architecture)
├── presentation/
│   ├── providers/
│   │   ├── branding_config_provider.dart    # Riverpod provider for branding
│   │   ├── questionnaire_config_provider.dart # Riverpod provider for questionnaire config
│   │   ├── current_section_provider.dart    # Current section and question state
│   │   ├── completed_sections_provider.dart # Completed sections state
│   │   ├── edit_state_provider.dart         # Edit mode state management
│   │   └── submission_status_provider.dart  # Final submission tracking
│   ├── pages/
│   │   ├── welcome_page.dart                # Welcome screen with resume detection
│   │   ├── questionnaire_page.dart          # Main questionnaire interface
│   │   ├── review_page.dart                 # Review all responses screen
│   │   └── completion_page.dart             # Success/completion screen
│   └── widgets/
│       ├── branding_header.dart             # Clinic logo and title header
│       ├── progress_indicator.dart          # Section progress visualization
│       ├── chat_bubble.dart                 # Bot/user message bubbles
│       ├── section_container.dart           # Grouped section display
│       ├── question_input/
│       │   ├── question_input.dart          # Dynamic input widget factory
│       │   ├── text_question_input.dart     # Text input widget
│       │   ├── number_question_input.dart   # Number input with unit selector
│       │   ├── single_select_input.dart     # Radio buttons/dropdown
│       │   ├── multi_select_input.dart      # Checkboxes with other option
│       │   └── text_area_input.dart         # Multi-line text input
│       ├── editable_response.dart           # Response with inline edit capability
│       ├── chat_history.dart                # Scrollable completed responses
│       ├── current_question_area.dart       # Active question input area
│       └── save_resume_button.dart          # Save and resume later button
├── utils/
│   ├── constants.dart                       # App constants and configuration
│   ├── validation_rules.dart                # Input validation logic
│   └── question_type_helper.dart            # Question type utilities
└── assets/
    ├── questionnaire_config.json            # Sample questionnaire for testing mode
    └── branding_config.json                 # Sample branding for testing mode
```

### Configuration Files

```
assets/
├── questionnaire_config.json                # Testing mode questionnaire configuration
├── branding_config.json                     # Testing mode branding configuration
└── images/
    └── clinic_logo.png                       # Sample clinic logo for testing

pubspec.yaml                                 # Dependencies: riverpod, freezed, dio, etc.

lib/
├── main.dart                                # App entry point with mode configuration
└── core/
    ├── config/
    │   └── app_config.dart                   # Environment and mode configuration
    ├── network/
    │   └── api_client.dart                   # HTTP client for production mode
    └── storage/
        └── local_storage.dart                # Local file operations for testing mode
```

### Key Architectural Decisions

| Directory | Purpose | Notes |
|---|---|---|
| `data/models/` | Data transfer objects with serialization | Uses freezed for immutability and JSON generation |
| `data/services/` | Business logic and external integrations | Handles mode switching (testing vs production) |
| `presentation/providers/` | Riverpod state management | Separated by logical domains (current, completed, edit) |
| `presentation/pages/` | Full screen components | One file per route/screen |
| `presentation/widgets/` | Reusable UI components | Organized by functionality |
| `presentation/widgets/question_input/` | Input type-specific widgets | Modular approach for different question types |
| `utils/` | Helper functions and constants | Pure functions without external dependencies |
| `assets/` | Testing mode configuration | JSON files for local development |

### File Naming Conventions

| Type | Pattern | Example |
|---|---|---|
| Models | `snake_case.dart` | `question_section.dart` |
| Providers | `feature_provider.dart` | `current_section_provider.dart` |
| Pages | `feature_page.dart` | `questionnaire_page.dart` |
| Widgets | `descriptive_name.dart` | `chat_bubble.dart` |
| Services | `feature_service.dart` | `resume_service.dart` |
| Generated Files | `original.freezed.dart`, `original.g.dart` | Auto-generated, don't edit manually |

---