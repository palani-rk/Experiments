# Design-Driven Flutter Development Workflow

A comprehensive workflow for building Flutter apps using a user-centered, design-first approach with Claude Code and the SuperClaude framework.

## 🎯 **Workflow Overview**

This workflow follows a 4-phase approach:
1. **Discovery & Wireframing** - Define user flows and create ASCII wireframes
2. **Component Selection** - Generate and compare Material 3 components
3. **State Management & Testing** - Implement Riverpod architecture with integration tests
4. **API Integration** - Design and integrate REST APIs

## 📋 **Phase-by-Phase Implementation**

### **Phase 1: Discovery & ASCII Wireframing**

#### Step 1: Requirements Discovery
**Command:**
```bash
/sc:brainstorm --strategy systematic --depth normal
```

**Sample Prompt:**
```
"Design a nutrition app onboarding flow where users answer questions about their health goals, dietary preferences, and lifestyle. The flow should feel conversational and take 5-10 minutes to complete."
```

**Auto-Triggered Agents:** `requirements-analyst`, `socratic-mentor`

**Deliverables:**
- User personas and journey maps
- Detailed requirements specification
- User story breakdown

**Output File:** `Plans/Requirements_Discovery.md`

**Expected Markdown Structure:**
```markdown
# [App Name] Requirements Discovery

## Project Overview
- **App Concept:** [Brief description]
- **Target Audience:** [Primary user groups]
- **Core Value Proposition:** [What problem does this solve]

## User Personas
### Primary Persona: [Name]
- **Demographics:** [Age, occupation, tech comfort]
- **Goals:** [What they want to achieve]
- **Pain Points:** [Current challenges]
- **Usage Context:** [When/where they'll use the app]

## User Journey Map
### Phase 1: [Discovery/Onboarding]
- **User Actions:** [What they do]
- **Touchpoints:** [Where they interact]
- **Emotions:** [How they feel]
- **Opportunities:** [Improvement areas]

## User Stories
### Epic: [Main Feature Area]
#### Story 1: [Feature Name]
- **As a** [user type]
- **I want** [functionality]
- **So that** [benefit/outcome]
- **Acceptance Criteria:**
  - [ ] [Testable condition 1]
  - [ ] [Testable condition 2]

## Technical Requirements
- **Platform:** [iOS/Android/Web]
- **Performance:** [Response time, load requirements]
- **Accessibility:** [WCAG compliance level]
- **Integration:** [External services needed]
```

---

#### Step 2: ASCII Wireframe Creation
**Command:**
```bash
/sc:improve --type architecture --think-hard --scope project
```

**Sample Prompt:**
```
"Create ASCII wireframes for the nutrition app onboarding flow. Show the main chat interface, progress tracking, and question input areas. Focus on mobile-first design with clear information hierarchy."
```

**Auto-Triggered Agents:** `system-architect`, `frontend-architect`

**Deliverables:**
- ASCII wireframes for all key screens
- Information architecture diagrams
- Navigation flow documentation

**Output File:** `Plans/Wireframes_Architecture.md`

**Expected Markdown Structure:**
```markdown
# [App Name] Wireframes & Architecture

## Information Architecture
```
[App Name]
├── Authentication
│   ├── Login
│   └── Registration
├── Onboarding
│   ├── Welcome
│   ├── Profile Setup
│   └── Preferences
└── Main App
    ├── Dashboard
    ├── Features
    └── Settings
```

## Screen Wireframes

### Screen 1: [Screen Name]
**Purpose:** [What this screen accomplishes]
**User Flow:** [How users arrive here and where they go next]

```
┌─────────────────────────────────────┐
│ ◀ Back    [Screen Title]      ☰    │
├─────────────────────────────────────┤
│                                     │
│  [Main Content Area]                │
│  ┌─────────────────────────────┐    │
│  │         Component 1         │    │
│  │  ○ User Avatar              │    │
│  │  "Welcome Message"          │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │         Component 2         │    │
│  │  [ Input Field        ]     │    │
│  │  [ Input Field        ]     │    │
│  │  [     Button      ]        │    │
│  └─────────────────────────────┘    │
│                                     │
├─────────────────────────────────────┤
│  [Tab 1]  [Tab 2]  [Tab 3]         │
└─────────────────────────────────────┘
```

**Key Components:**
- **Header:** Navigation and title
- **Main Content:** Primary user interaction area
- **Input Section:** Form fields and validation
- **Action Buttons:** Primary and secondary actions
- **Bottom Navigation:** Tab bar for main sections

**Interactions:**
- **Tap [Button]:** Navigate to [Next Screen]
- **Swipe:** [Gesture behavior]
- **Long Press:** [Context menu/actions]

## Navigation Flow
```
[Welcome] → [Profile Setup] → [Preferences] → [Dashboard]
    ↑              ↓               ↓             ↓
[Login] ←→ [Registration]    [Skip Option] → [Main App]
```

## Component Hierarchy
### Screen: [Screen Name]
```
Screen Container
├── Header
│   ├── Back Button
│   ├── Title Text
│   └── Menu Icon
├── Content Area
│   ├── Progress Indicator
│   ├── Chat Messages List
│   │   ├── Bot Message Bubble
│   │   └── User Message Bubble
│   └── Input Section
│       ├── Text Input
│       └── Send Button
└── Footer
    └── Progress Text
```

## Design Decisions
### Layout Principles
- **Mobile-First:** Optimized for small screens, scales up
- **Single Column:** Avoid complex multi-column layouts
- **Thumb-Friendly:** Action buttons within easy reach
- **Consistent Spacing:** 8dp grid system throughout

### Information Density
- **Progressive Disclosure:** Show essential info first
- **Scannable Content:** Use white space and hierarchy
- **Clear Actions:** Obvious next steps for users

## Responsive Considerations
- **Portrait Primary:** Main use case is portrait orientation
- **Landscape Support:** Horizontal layout for input screens
- **Tablet Adaptation:** Two-column layout for larger screens
```

---

### **Phase 2: Material 3 Component Selection**

#### Step 1: Component Exploration
**Command:**
```bash
/sc:improve --type quality --magic --c7 --loop --iterations 3
```

**Sample Prompt:**
```
"Generate 3 different Material 3 component approaches for displaying chat bubbles in a nutrition onboarding flow. Compare: 1) Standard chat bubbles, 2) Card-based Q&A display, 3) List-based form layout. Show pros/cons for each."
```

**Auto-Triggered Agents:** `superdesign`, `frontend-architect`, Context7 MCP

**Deliverables:**
- Multiple component implementation options
- Comparative analysis with pros/cons
- Design system recommendations

**Output File:** `Plans/Component_Analysis.md`

**Expected Markdown Structure:**
```markdown
# [App Name] Component Analysis

## Design System Foundation
- **Framework:** Flutter with Material 3
- **Theme:** Custom theme extending MaterialTheme
- **Color Palette:** [Primary, Secondary, Tertiary colors]
- **Typography:** Material 3 type scale with custom extensions
- **Spacing System:** 8dp grid with AppSizes constants

## Component Options Analysis

### Component: [Component Name] (e.g., Chat Bubble)
**Purpose:** [What this component does]
**Context:** [Where it's used in the app]

#### Option 1: [Approach Name] (e.g., Standard Chat Bubbles)
```dart
// Code snippet showing component structure
class ChatBubbleStandard extends StatelessWidget {
  // Implementation overview
}
```

**Pros:**
- ✅ [Advantage 1]
- ✅ [Advantage 2]
- ✅ [Advantage 3]

**Cons:**
- ❌ [Limitation 1]
- ❌ [Limitation 2]

**Material 3 Compliance:** [Assessment]
**Accessibility Score:** [WCAG AA/AAA rating]
**Performance Impact:** [Low/Medium/High]

#### Option 2: [Approach Name] (e.g., Card-based Q&A Display)
```dart
// Code snippet showing component structure
class QuestionAnswerCard extends StatelessWidget {
  // Implementation overview
}
```

**Pros:**
- ✅ [Advantage 1]
- ✅ [Advantage 2]

**Cons:**
- ❌ [Limitation 1]
- ❌ [Limitation 2]

**Material 3 Compliance:** [Assessment]
**Accessibility Score:** [WCAG AA/AAA rating]
**Performance Impact:** [Low/Medium/High]

#### Option 3: [Approach Name] (e.g., List-based Form Layout)
```dart
// Code snippet showing component structure
class FormListTile extends StatelessWidget {
  // Implementation overview
}
```

**Pros:**
- ✅ [Advantage 1]
- ✅ [Advantage 2]

**Cons:**
- ❌ [Limitation 1]
- ❌ [Limitation 2]

**Material 3 Compliance:** [Assessment]
**Accessibility Score:** [WCAG AA/AAA rating]
**Performance Impact:** [Low/Medium/High]

#### Recommendation: [Selected Option]
**Rationale:** [Why this option was chosen based on requirements]

**Implementation Plan:**
1. [Step 1: Base component creation]
2. [Step 2: Theme integration]
3. [Step 3: Accessibility features]
4. [Step 4: Responsive behavior]

## Selected Components Summary

### Primary Components
| Component | Selected Option | Rationale | Priority |
|-----------|----------------|-----------|----------|
| Chat Bubble | [Option Name] | [Brief reason] | High |
| Progress Bar | [Option Name] | [Brief reason] | High |
| Input Field | [Option Name] | [Brief reason] | Medium |
| Navigation | [Option Name] | [Brief reason] | Low |

### Component Dependencies
```
ChatScreen
├── ChatHeader (Primary)
├── ProgressIndicator (Primary)  
├── MessagesList
│   ├── ChatBubble (Selected: [Option])
│   └── QuestionAnswerCard (Selected: [Option])
└── InputSection (Selected: [Option])
```

## Design Tokens Integration

### Color Mapping
- **Primary Actions:** `theme.colorScheme.primary`
- **Surface Elements:** `theme.colorScheme.surface`
- **Text Content:** `theme.colorScheme.onSurface`
- **Status Indicators:** `theme.colorScheme.tertiary`

### Spacing Constants
- **Component Padding:** `AppSizes.l` (16dp)
- **Element Spacing:** `AppSizes.m` (12dp)
- **Tight Spacing:** `AppSizes.s` (8dp)
- **Loose Spacing:** `AppSizes.xl` (20dp)

### Animation Durations
- **Quick Interactions:** `AppDurations.fast` (150ms)
- **Standard Transitions:** `AppDurations.normal` (300ms)
- **Complex Animations:** `AppDurations.slow` (500ms)

## Accessibility Implementation
- **Screen Reader Support:** Semantic labels for all interactive elements
- **Focus Management:** Logical tab order and focus indicators
- **Color Contrast:** WCAG AA compliance (4.5:1 ratio minimum)
- **Touch Targets:** Minimum 44x44dp for all interactive elements
- **Text Scaling:** Support for system font size preferences

## Responsive Design Strategy
### Mobile (320-768dp)
- **Single column layout**
- **Stack components vertically**
- **Full-width interactive elements**
- **Bottom sheet for secondary actions**

### Tablet (768-1024dp)
- **Two-column layout where appropriate**
- **Side navigation for main sections**
- **Modal dialogs for detailed interactions**
- **Adaptive spacing based on screen size**

### Desktop/Web (1024dp+)
- **Multi-column layouts**
- **Persistent navigation panels**
- **Hover states and keyboard shortcuts**
- **Optimal content width with centered layout**
```

---

#### Step 2: Component Implementation
**Command:**
```bash
/sc:implement --magic --c7 --validate
```

**Sample Prompt:**
```
"Implement the selected chat bubble component using Material 3 design tokens. Include proper theming, accessibility features, and responsive behavior for different screen sizes."
```

**Auto-Triggered Agents:** `superdesign`, `quality-engineer`, Context7 MCP

**Deliverables:**
- Production-ready Flutter widget components
- Material 3 design system integration
- Accessibility compliance validation
- Responsive design implementation

**Output File:** `Plans/Component_Implementation.md`

**Expected Markdown Structure:**
```markdown
# [App Name] Component Implementation

## Implementation Summary
- **Total Components:** [Number] components implemented
- **Theme Integration:** Complete Material 3 integration with custom design tokens
- **Accessibility:** WCAG AA compliance achieved
- **Test Coverage:** [Percentage]% widget test coverage
- **Performance:** Optimized for smooth animations and efficient rebuilds

## Files Created

### New Component Files
- `lib/widgets/chat_bubble.dart` - Individual chat message display
- `lib/widgets/progress_bar.dart` - Onboarding progress indicator  
- `lib/widgets/question_input.dart` - Current question input section
- `lib/widgets/question_answer_tile.dart` - Q&A pair display
- `lib/widgets/section_card.dart` - Completed section container
- `lib/widgets/chat_header.dart` - Chat screen header

### New Utility Files
- `lib/constants.dart` - App-wide design tokens and constants
- `test/widget/component_test.dart` - Widget test suite
- `test/golden/golden_tests.dart` - Golden file tests

## Files Modified

### Updated Existing Files
- `lib/theme.dart` - Extended with AppSizes, AppTextStyles, AppShadows
- `lib/main.dart` - Updated to showcase new components
- `pubspec.yaml` - Added test dependencies and assets
- `analysis_options.yaml` - Updated linting rules for new structure

## Component Library

### Core Components Built
| Component | File | Purpose | Usage |
|-----------|------|---------|-------|
| **ChatBubble** | `chat_bubble.dart` | Display chat messages | `ChatBubble(text: "Hi!", isBot: true)` |
| **ProgressBar** | `progress_bar.dart` | Show completion progress | `ProgressBar(progress: 0.6, section: "Info")` |
| **InputSection** | `question_input.dart` | Handle user input | `InputSection(question: "Name?", onSubmit: callback)` |
| **QATile** | `question_answer_tile.dart` | Display Q&A pairs | `QATile(question: "Age?", answer: "25")` |
| **SectionCard** | `section_card.dart` | Group completed items | `SectionCard(title: "Personal Info", children: [...])` |
| **ChatHeader** | `chat_header.dart` | Screen header with status | `ChatHeader(title: "Assistant", isOnline: true)` |

## Key Implementation Decisions

### Design System Integration
- **Material 3 Compliance:** All components follow Material 3 design guidelines
- **Custom Theme Extension:** Added AppSizes, AppTextStyles, and AppShadows to existing MaterialTheme
- **Consistent Spacing:** 8dp grid system with semantic naming (xs, s, m, l, xl)
- **Responsive Design:** Components adapt to mobile, tablet, and desktop breakpoints

### Accessibility Standards
- **WCAG AA Compliance:** All color combinations meet 4.5:1 contrast ratio minimum
- **Screen Reader Support:** Proper semantic labels and descriptions
- **Focus Management:** Logical tab order and visible focus indicators  
- **Touch Targets:** Minimum 44x44dp for all interactive elements

### Performance Optimizations
- **const Constructors:** Reduced unnecessary widget rebuilds
- **Efficient List Rendering:** ListView.builder for dynamic content
- **Memory Management:** Proper disposal of controllers and animations
- **Widget Composition:** Logical component breakdown for optimal updates

## Testing Implementation

### Test Coverage Achieved
- **Widget Tests:** 92% coverage across all components
- **Integration Tests:** Complete user flow validation
- **Golden Tests:** Visual regression testing for UI consistency
- **Accessibility Tests:** Semantic testing with screen reader simulation

### Test Files Structure
```
test/
├── widget/
│   ├── chat_bubble_test.dart (95% coverage)
│   ├── progress_bar_test.dart (90% coverage)
│   └── input_section_test.dart (88% coverage)
├── integration/
│   └── chat_flow_test.dart (E2E user flows)
└── golden/
    └── component_golden_test.dart (Visual consistency)
```

## Integration Notes

### State Management Ready
- **Riverpod Integration:** Components designed to work with provider pattern
- **Data Binding:** Ready for JSON data integration
- **Form Validation:** Built-in validation support with error states

### API Integration Prepared
- **Loading States:** All input components support disabled/loading states
- **Error Handling:** Components display validation errors appropriately
- **Data Flow:** Clear props interface for easy API data binding

## Next Phase Preparation
- **Components ready for Riverpod state management integration**
- **JSON data structure interfaces defined**
- **Component APIs designed for REST API data binding**
- **Test framework established for continued development**
```

---

### **Phase 3: Riverpod State Management & Integration Testing**

#### Step 1: State Architecture Setup
**Command:**
```bash
/sc:implement --task-manage --seq --delegate auto --focus architecture
```

**Sample Prompt:**
```
"Setup Riverpod state management architecture for the nutrition app onboarding flow. Include providers for: user responses, current question state, progress tracking, and form validation. Use JSON metadata structure."
```

**Auto-Triggered Agents:** `backend-architect`, `refactoring-expert`, Sequential MCP

**Deliverables:**
- Riverpod provider architecture
- JSON metadata structure design
- State management patterns implementation
- Provider dependency mapping

**Output File:** `Plans/State_Management_Architecture.md`

**Expected Markdown Structure:**
```markdown
# [App Name] State Management Architecture

## Feature-Based Architecture Overview
- **Organization:** Feature-based folder structure with clear separation of concerns
- **State Management:** Riverpod providers organized per feature
- **Data Models:** JSON-serializable models with business logic separation
- **Services:** API integration and business logic per feature

## Files Created

### Feature Structure: Onboarding
```
lib/features/onboarding/
├── models/
│   ├── onboarding_data.dart - Main data model with JSON serialization
│   ├── user_response.dart - Individual response model
│   └── question.dart - Question definition model
├── services/
│   ├── onboarding_api_service.dart - REST API integration
│   └── onboarding_business_logic.dart - Business rules and validation
├── providers/
│   ├── onboarding_provider.dart - Main feature state management
│   ├── progress_provider.dart - Progress tracking state
│   └── validation_provider.dart - Form validation state
├── widgets/
│   ├── chat_bubble.dart - Feature-specific chat components
│   ├── progress_bar.dart - Progress tracking components
│   └── input_section.dart - Input handling components
└── pages/
    ├── onboarding_chat_page.dart - Main chat interface
    └── onboarding_summary_page.dart - Completion summary
```

### Shared Infrastructure
```
lib/shared/
├── theme.dart - App-wide design system (existing, extended)
├── constants.dart - Global constants and configuration
└── utils/
    ├── json_helpers.dart - JSON serialization utilities
    └── validation_helpers.dart - Common validation functions
```

## Data Models Architecture

### Core Data Models
| Model | File | Purpose | JSON Support |
|-------|------|---------|--------------|
| **OnboardingData** | `models/onboarding_data.dart` | Complete session data | ✅ Full serialization |
| **UserResponse** | `models/user_response.dart` | Individual Q&A response | ✅ Serializable |
| **Question** | `models/question.dart` | Question metadata | ✅ Configuration data |

### JSON Data Structure
```json
{
  "sessionId": "uuid-string",
  "currentStep": 3,
  "totalSteps": 8,
  "progress": 0.375,
  "responses": [
    {
      "questionId": "personal_info_name",
      "answer": "Sarah Johnson",
      "timestamp": "2024-01-15T10:30:00Z",
      "isValid": true
    }
  ],
  "metadata": {
    "featureVersion": "1.0",
    "startedAt": "2024-01-15T10:25:00Z",
    "lastUpdated": "2024-01-15T10:30:00Z"
  }
}
```

## Services Architecture

### API Service Layer
- **Feature-Specific Services:** Each feature has its own API service
- **Business Logic Services:** Separate business rules from API calls
- **Error Handling:** Consistent error handling across all services
- **Mock Implementation:** Services support mock data for development

### Service Implementation
```
OnboardingApiService
├── startSession() → POST /api/onboarding/start
├── submitResponse() → PUT /api/onboarding/response
├── getProgress() → GET /api/onboarding/progress
└── completeSession() → POST /api/onboarding/complete
```

## Provider Architecture

### Feature-Based State Management
- **Provider Scoping:** Each feature manages its own state
- **Cross-Feature Communication:** Minimal coupling between feature providers
- **State Persistence:** JSON-based persistence per feature
- **Performance:** Selective rebuilds and optimized dependencies

### Provider Dependencies
```
OnboardingProvider (Feature Root)
├── ProgressProvider (tracks completion)
├── ValidationProvider (handles validation)
└── UserResponseProvider (manages user input)
```

## Integration Notes

### Component-Provider Integration
- **Feature Isolation:** Components only access providers within their feature
- **Shared Components:** Common widgets in shared/ folder when reused
- **State Flow:** Clear data flow from user input to state to UI updates
- **Performance:** Components subscribe only to needed state slices

## Next Phase Preparation
- **Feature Structure:** Ready for additional features following same pattern
- **API Integration:** Service layer prepared for REST API connection
- **JSON Mock Data:** Complete test data structure for E2E testing
- **State Persistence:** Local storage implementation ready for production
```

---

#### Step 2: Integration Testing
**Command:**
```bash
/sc:test --play --validate --focus testing --loop --iterations 2
```

**Sample Prompt:**
```
"Create integration tests for the complete onboarding user flow using JSON mock data. Test scenarios: happy path completion, form validation errors, progress saving, and data persistence. Use Playwright for E2E testing."
```

**Auto-Triggered Agents:** `quality-engineer`, `performance-engineer`, Playwright MCP

**Deliverables:**
- Comprehensive integration test suite
- E2E user flow validation
- JSON mock data scenarios
- Performance benchmarking
- Error handling validation

**Output File:** `Plans/Integration_Testing_Implementation.md`

**Expected Markdown Structure:**
```markdown
# [App Name] Integration Testing Implementation

## E2E Testing Strategy
- **Feature-Level Testing:** Complete user journey testing per feature
- **Integration Test Package:** Using Flutter's `integration_test` package
- **Real App Testing:** Tests run against actual running application
- **JSON Mock Data:** Realistic data scenarios for comprehensive testing

## Files Created

### Test Structure
```
integration_test/
├── features/
│   ├── onboarding_flow_test.dart - Complete onboarding user journey
│   └── nutrition_plan_flow_test.dart - Nutrition planning flow (future)
└── test_helpers/
    ├── mock_data.dart - JSON test data and scenarios
    ├── test_utils.dart - Common testing utilities
    └── app_wrapper.dart - Test app initialization
```

### Mock Data Files
```
integration_test/mock_data/
├── onboarding_happy_path.json - Successful completion scenario
├── onboarding_validation_errors.json - Form validation testing
├── onboarding_partial_completion.json - Progress saving scenarios
└── api_error_responses.json - Error handling test data
```

## Test Coverage Implementation

### Onboarding Flow Tests
| Test Scenario | File | Coverage | JSON Data |
|---------------|------|----------|-----------|
| **Happy Path** | `onboarding_flow_test.dart` | Complete user journey | `onboarding_happy_path.json` |
| **Validation Errors** | `onboarding_flow_test.dart` | Form validation flows | `onboarding_validation_errors.json` |
| **Progress Saving** | `onboarding_flow_test.dart` | Session persistence | `onboarding_partial_completion.json` |
| **Error Recovery** | `onboarding_flow_test.dart` | API error handling | `api_error_responses.json` |

### Test Implementation Example
```dart
// integration_test/features/onboarding_flow_test.dart
testWidgets('Complete onboarding happy path', (tester) async {
  // Load mock data
  final mockData = await loadMockData('onboarding_happy_path.json');
  
  // Initialize app with mock data
  await tester.pumpWidget(TestAppWrapper(mockData: mockData));
  
  // Test complete user flow
  await tester.tap(find.byKey(Key('start_onboarding')));
  await tester.pumpAndSettle();
  
  // Validate each step of the flow
  // ... complete E2E test implementation
});
```

## JSON Mock Data Structure

### Test Data Organization
- **Feature-Based:** Mock data organized per feature
- **Scenario-Based:** Separate files for different test scenarios
- **Realistic Data:** Production-like data for accurate testing
- **Edge Cases:** Comprehensive edge case coverage

### Sample Mock Data
```json
{
  "testScenario": "onboarding_happy_path",
  "sessionData": {
    "sessionId": "test-uuid-123",
    "currentStep": 1,
    "totalSteps": 8,
    "responses": []
  },
  "expectedFlow": [
    {
      "stepId": "personal_info_name",
      "expectedQuestion": "What's your full name?",
      "userInput": "Test User",
      "expectedValidation": true
    }
  ],
  "apiResponses": {
    "POST /api/onboarding/start": {
      "status": 200,
      "data": { "sessionId": "test-uuid-123" }
    }
  }
}
```

## Test Execution Strategy

### Feature-Level Test Flows
- **Complete User Journeys:** End-to-end feature testing
- **Cross-Screen Navigation:** Multi-screen flow validation
- **State Persistence:** Data saving and restoration
- **Error Scenarios:** Comprehensive error handling

### Performance Testing
- **Flow Timing:** Measure complete feature flow performance
- **Memory Usage:** Track memory consumption during flows
- **UI Responsiveness:** Validate smooth animations and transitions
- **Data Loading:** Test with various data sizes and network conditions

## Test Infrastructure

### Test Utilities
- **App Wrapper:** Consistent app initialization for tests
- **Mock Data Loader:** JSON data loading utilities
- **Helper Functions:** Common testing operations and assertions
- **Screen Object Pattern:** Reusable page interaction helpers

### CI/CD Integration
- **Automated Testing:** Integration tests run on every PR
- **Device Testing:** Tests run on multiple device configurations
- **Performance Monitoring:** Track test performance over time
- **Test Reporting:** Comprehensive test result reporting

## Validation Scenarios

### User Flow Validation
- **Happy Path:** Complete successful feature usage
- **Error Paths:** Various error conditions and recovery
- **Edge Cases:** Boundary conditions and unusual inputs
- **Accessibility:** Screen reader and keyboard navigation testing

### Data Validation
- **JSON Serialization:** Data model serialization/deserialization
- **State Persistence:** Local storage and session management
- **API Integration:** Mock API response handling
- **Validation Logic:** Form validation and business rules

## Test Maintenance

### Test Organization
- **Feature-Aligned:** Tests mirror feature structure
- **Shared Utilities:** Common testing code in helpers
- **Mock Data Management:** Centralized test data management
- **Documentation:** Clear test scenario documentation

## Next Phase Preparation
- **API Integration Testing:** Ready for real API testing
- **Production Testing:** Test infrastructure ready for production data
- **Performance Baselines:** Established performance benchmarks
- **Error Monitoring:** Comprehensive error tracking setup
```

---

### **Phase 4: REST API Design & Integration**

#### Step 1: API Design
**Command:**
```bash
/sc:implement --orchestrate --seq --c7 --focus architecture
```

**Sample Prompt:**
```
"Design REST API endpoints for the nutrition onboarding flow based on the frontend UX requirements. Include: POST /onboarding/start, PUT /onboarding/response, GET /onboarding/progress, POST /onboarding/complete. Align with RESTJS patterns."
```

**Auto-Triggered Agents:** `backend-architect`, `security-engineer`, Context7 MCP, Sequential MCP

**Deliverables:**
- REST API specification
- Endpoint documentation
- Request/response schemas
- RESTJS integration patterns

---

#### Step 2: API Integration
**Command:**
```bash
/sc:implement --validate --safe-mode --focus security
```

**Sample Prompt:**
```
"Integrate the nutrition app frontend with the REST API, transitioning from JSON mock data to live API calls. Include proper error handling, loading states, data validation, and secure authentication patterns."
```

**Auto-Triggered Agents:** `security-engineer`, `backend-architect`, `quality-engineer`

**Deliverables:**
- Live API integration
- Error handling implementation
- Loading state management
- Security validation
- Authentication flow integration

---

## 🔄 **Cross-Phase Transition Commands**

### **Wireframes → Components**
**Command:** `/sc:implement --magic --c7 --scope module`  
**Purpose:** Convert ASCII wireframes into Material 3 Flutter widgets

### **Components → State Management**
**Command:** `/sc:implement --task-manage --seq --delegate files --focus architecture`  
**Purpose:** Integrate components with Riverpod state management

### **State → Testing**
**Command:** `/sc:test --play --validate --focus testing`  
**Purpose:** Create comprehensive integration tests for stateful components

### **Testing → API Integration**
**Command:** `/sc:implement --orchestrate --validate --safe-mode --focus security`  
**Purpose:** Replace mock data with secure REST API integration

---

## 📋 **Quick Reference Command Matrix**

| Phase | Primary Command | Key Flags | Auto-Agents | Deliverable |
|-------|----------------|-----------|-------------|-------------|
| **Discovery** | `/sc:brainstorm` | `--strategy systematic --depth normal` | requirements-analyst, socratic-mentor | Requirements & User Stories |
| **Wireframing** | `/sc:improve` | `--type architecture --think-hard --scope project` | system-architect, frontend-architect | ASCII Wireframes |
| **Components** | `/sc:improve` | `--type quality --magic --c7 --loop` | superdesign, frontend-architect | Component Options |
| **Implementation** | `/sc:implement` | `--magic --c7 --validate` | superdesign, quality-engineer | Flutter Widgets |
| **State Mgmt** | `/sc:implement` | `--task-manage --seq --delegate auto` | backend-architect, refactoring-expert | Riverpod Architecture |
| **Testing** | `/sc:test` | `--play --validate --focus testing` | quality-engineer, performance-engineer | Integration Tests |
| **API Design** | `/sc:implement` | `--orchestrate --seq --c7` | backend-architect, security-engineer | REST API Spec |
| **Integration** | `/sc:implement` | `--validate --safe-mode --focus security` | security-engineer, quality-engineer | Production App |

---

## 🛠️ **Technology Stack Integration**

### **Frontend Stack**
- **Framework:** Flutter with Material 3 design system
- **State Management:** Riverpod with JSON metadata
- **Testing:** integration_test + Playwright for E2E validation
- **Architecture:** Component-based with design system tokens

### **Backend Stack**
- **API:** REST API powered by RESTJS
- **Design Philosophy:** API designed to match UX flows
- **Integration:** Secure authentication and error handling
- **Data Format:** JSON with structured metadata

### **Development Tools**
- **Wireframing:** ASCII wireframes via Claude Code
- **Component Design:** Claude Code component generation and comparison
- **Testing:** Automated integration testing with running application
- **API Testing:** JSON mock data for development and validation

---

## 🎯 **Best Practices**

### **Discovery Phase**
- Start with user workflow before technical implementation
- Use systematic brainstorming for comprehensive requirements
- Validate wireframes before moving to component selection
- Document all decisions for future reference

### **Component Phase**
- Always compare multiple Material 3 component approaches
- Validate accessibility compliance from the start
- Implement responsive design patterns consistently
- Use design system tokens for consistency

### **State Management Phase**
- Structure Riverpod providers for optimal performance
- Design JSON metadata for easy API transition
- Implement comprehensive error handling
- Test all user flow scenarios with mock data

### **API Integration Phase**
- Design APIs based on frontend UX needs
- Implement secure authentication patterns
- Add proper loading states and error handling
- Validate performance under real-world conditions

---

## 🚀 **Getting Started**

1. **Initialize Project:** Create Flutter project with Material 3 and Riverpod dependencies
2. **Start Discovery:** Run `/sc:brainstorm` with your app concept
3. **Create Wireframes:** Use `/sc:improve --type architecture` for ASCII wireframes
4. **Build Components:** Use `/sc:improve --magic --c7` for Material 3 components
5. **Add State Management:** Use `/sc:implement --task-manage` for Riverpod setup
6. **Test Flows:** Use `/sc:test --play` for comprehensive testing
7. **Integrate APIs:** Use `/sc:implement --orchestrate` for REST API integration

This workflow ensures a systematic, user-centered approach to Flutter development while leveraging the full power of Claude Code's agent orchestration and MCP server capabilities.