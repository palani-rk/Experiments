# API to Frontend Data Model Mapping

This document maps the SmartConnect Backend API response DTOs to the Flutter frontend data models for the questionnaire system.

## Overview

The mapping covers three main entity types:
1. **Template/Questionnaire Configuration** - Overall questionnaire structure
2. **Sections** - Groups of related questions
3. **Questions** - Individual question definitions

---

## 1. Template Mapping

### Backend: `TemplateResponseDto`
### Frontend: `QuestionnaireConfig`

| Backend Field (API) | Frontend Field (Flutter) | Type Match | Notes |
|---------------------|-------------------------|------------|-------|
| `id` | `id` | ✅ String → String | Direct mapping |
| `organizationId` | ❌ Not mapped | N/A | Backend-only metadata |
| `name` | ❌ Not mapped | N/A | Internal template identifier |
| `title` | `title` | ✅ String → String | Display title for questionnaire |
| `description` | ❌ Not mapped | ⚠️ Consider adding | Could be useful for UI context |
| `status` | ❌ Not mapped | N/A | Template lifecycle state (draft/active/archived) |
| `version` | ❌ Not mapped | N/A | Version tracking for template changes |
| `createdBy` | ❌ Not mapped | N/A | User ID who created template |
| `createdAt` | ❌ Not mapped | N/A | Template creation timestamp |
| `updatedAt` | ❌ Not mapped | N/A | Template last update timestamp |
| `sectionsCount` | Computed via `sectionCount` | ⚙️ Derived | Frontend computes from `sections.length` |
| `questionsCount` | Computed via `totalQuestionCount` | ⚙️ Derived | Frontend computes across all sections |
| `usageCount` | ❌ Not mapped | N/A | How many times template has been assigned |
| `sections` | `sections` | ⚠️ Type mismatch | API: `array<string>` (IDs), Frontend: `array<QuestionSection>` (full objects) |
| `creator` | ❌ Not mapped | N/A | Creator user object |

### ⚠️ **Key Issue**
The API returns `sections` as an array of section IDs (strings), but the frontend expects full `QuestionSection` objects. This requires:
1. Fetching template with section IDs
2. Making additional API calls to get full section details
3. Assembling the complete `QuestionnaireConfig` object

---

## 2. Section Mapping

### Backend: `SectionResponseDto`
### Frontend: `QuestionSection`

| Backend Field (API) | Frontend Field (Flutter) | Type Match | Notes |
|---------------------|-------------------------|------------|-------|
| `id` | `id` | ✅ String → String | Section unique identifier |
| `submissionId` | ❌ Not mapped | N/A | Links to user's submission (response context) |
| `sectionKey` | ❌ Not mapped | ⚠️ Consider adding | Business key for section (e.g., "personal_info") |
| `status` | ❌ Not mapped | N/A | Section completion status (not_started/in_progress/completed) |
| `startedAt` | ❌ Not mapped | N/A | When user started this section |
| `completedAt` | ❌ Not mapped | N/A | When user completed this section |
| `lastSavedAt` | ❌ Not mapped | N/A | Last save timestamp for section responses |
| `progress` | ❌ Not mapped | N/A | Progress tracking object |
| `completionMessage` | `completionMessage` | ✅ String → String | Message shown when section is completed |
| `questionResponses` | ❌ Not mapped | ⚠️ Response data | User's answers to questions in this section |
| ❌ API missing | `title` | ⚠️ Missing in API | **Frontend requires title** - may need to fetch from template definition |
| ❌ API missing | `description` | ⚠️ Missing in API | Optional description - may need separate endpoint |
| ❌ API missing | `questions` | ⚠️ Missing in API | **Frontend requires full Question objects** |

### ⚠️ **Key Issues**

1. **Different API Contexts**: `SectionResponseDto` appears to be a **response tracking DTO** (for user submissions), NOT a template definition DTO
2. **Missing Template Fields**: The API doesn't include `title`, `description`, or `questions` in `SectionResponseDto`
3. **Solution**: May need to check for a separate `SectionTemplateDto` or `CreateSectionDto` that includes:
   - `title` (required)
   - `description` (optional)
   - `questions` array (full Question objects)
   - `sectionKey` (business identifier)
   - `orderIndex` (section ordering)

Based on the API spec around line 4989-5025, there IS a `CreateSectionDto` with these fields:
- `sectionKey` ✅
- `title` ✅
- `description` ✅
- `orderIndex` ✅
- `completionMessage` ✅

But this doesn't include `questions` - those would need to be fetched separately.

---

## 3. Question Mapping

### Backend: `QuestionResponseDto`
### Frontend: `Question`

| Backend Field (API) | Frontend Field (Flutter) | Type Match | Notes |
|---------------------|-------------------------|------------|-------|
| `id` | `id` | ✅ String → String | Question unique identifier |
| `questionKey` | ❌ Not mapped | ⚠️ Consider adding | Business key for question (e.g., "Q1", "full_name") |
| `sectionKey` | `sectionId` | ⚠️ Semantic mismatch | API uses `sectionKey`, Frontend uses `sectionId` |
| `responseValue` | ❌ Not mapped | N/A | User's answer to this question |
| `responseMetadata` | ❌ Not mapped | N/A | Additional metadata about the response |
| `answeredAt` | ❌ Not mapped | N/A | When user first answered |
| `updatedAt` | ❌ Not mapped | N/A | Last update to answer |
| ❌ API missing | `questionText` | ⚠️ Missing in API | **Frontend requires the actual question text** |
| ❌ API missing | `inputType` | ⚠️ Missing in API | **Frontend requires input type (enum)** |
| ❌ API missing | `required` | ⚠️ Missing in API | **Frontend requires validation flag** |
| ❌ API missing | `options` | ⚠️ Missing in API | Options for select-type questions |
| ❌ API missing | `validation` | ⚠️ Missing in API | Validation rules object |
| ❌ API missing | `placeholder` | ⚠️ Missing in API | Placeholder text for inputs |

### ⚠️ **Key Issues**

1. **Wrong DTO Type**: `QuestionResponseDto` is for **user responses**, NOT question definitions
2. **Missing Question Definition Fields**: Need to reference `CreateQuestionDto` (lines 5148-5226) which includes:
   - `questionKey` ✅
   - `questionText` ✅
   - `inputType` ✅ (with enum: text_input, text_area, number_input, email_input, phone_input, date_input, single_select, multi_select, checkbox, radio, file_upload)
   - `required` ✅
   - `orderIndex` ✅
   - `options` ✅ (for select-type questions)
   - `validationRules` ✅ (object with minLength, maxLength, pattern, etc.)
   - `placeholder` ✅

### Frontend `QuestionType` Enum vs API `inputType`

The frontend uses a `QuestionType` enum (from `enums.dart`). The API supports these input types:
- `text_input` → `QuestionType.textInput`
- `text_area` → `QuestionType.textArea`
- `number_input` → `QuestionType.numberInput`
- `single_select` → `QuestionType.singleSelect`
- `multi_select` → `QuestionType.multiSelect`
- `email_input` → May need to add to frontend enum
- `phone_input` → May need to add to frontend enum
- `date_input` → May need to add to frontend enum
- `checkbox` → May need to add to frontend enum
- `radio` → May need to add to frontend enum
- `file_upload` → May need to add to frontend enum

---

## Summary & Recommendations

### 🔴 **Critical Mismatches**

1. **Response DTOs vs Definition DTOs**: The spec shows `SectionResponseDto` and `QuestionResponseDto` which track **user responses**, not template definitions. Need to use creation/template DTOs instead.

2. **Nested Data Structure**: Frontend expects fully nested objects:
   ```
   QuestionnaireConfig
   └── sections: List<QuestionSection>
       └── questions: List<Question>
   ```
   But API returns:
   - Template with section IDs (not full section objects)
   - Need additional API calls to build the full structure

### 🟡 **Recommended API Integration Strategy**

```dart
// Pseudo-code for loading questionnaire
Future<QuestionnaireConfig> loadQuestionnaire(String templateId) async {
  // 1. Get template with basic info and section IDs
  final template = await api.getTemplate(templateId);

  // 2. Fetch full section details for each section
  final sections = await Future.wait(
    template.sections.map((sectionId) async {
      final section = await api.getSection(templateId, sectionId);

      // 3. Fetch questions for each section
      final questions = await api.getQuestions(templateId, sectionId);

      return QuestionSection(
        id: section.id,
        title: section.title,
        description: section.description,
        completionMessage: section.completionMessage ?? 'Great! Moving on.',
        questions: questions.map((q) => Question(
          id: q.id,
          sectionId: section.id,
          questionText: q.questionText,
          inputType: mapInputType(q.inputType),
          required: q.required ?? true,
          options: q.options,
          validation: q.validationRules != null
              ? ValidationRules.fromJson(q.validationRules)
              : null,
          placeholder: q.placeholder,
        )).toList(),
      );
    })
  );

  return QuestionnaireConfig(
    id: template.id,
    title: template.title,
    sections: sections,
  );
}
```

### 🟢 **Additional Frontend Fields to Consider**

1. **QuestionnaireConfig**:
   - Add `description` field (from API)
   - Add `status` field (draft/active/archived)
   - Add `version` field (for template versioning)

2. **QuestionSection**:
   - Add `sectionKey` field (business identifier)
   - Add `orderIndex` field (section ordering)

3. **Question**:
   - Add `questionKey` field (business identifier, more stable than ID)
   - Add `orderIndex` field (question ordering within section)
   - Expand `QuestionType` enum to include all API input types

### 📋 **Complete Field Mapping Table**

#### For Template Definition APIs:
- Use `GET /api/questionnaire-templates/{templateId}` → `TemplateResponseDto`
- Use `GET /api/questionnaire-templates/{templateId}/sections` → `SectionListResponse`
- Use `GET /api/questionnaire-templates/{templateId}/sections/{sectionId}/questions` → `QuestionListResponse`

#### For Response/Submission Tracking:
- Use `SectionResponseDto` for tracking user progress
- Use `QuestionResponseDto` for storing user answers
- These are separate from the template definition models

---

## JSON Transformation Examples

### Example 1: Template API Response → QuestionnaireConfig

**API Response** (`TemplateResponseDto`):
```json
{
  "id": "template-123",
  "organizationId": "org-456",
  "name": "onboarding_v1",
  "title": "Client Onboarding Questionnaire",
  "description": "Gather initial client information",
  "status": "active",
  "version": 1,
  "sectionsCount": 3,
  "sections": ["section-1", "section-2", "section-3"],
  "createdAt": "2024-01-01T00:00:00Z"
}
```

**Frontend Model** (`QuestionnaireConfig`):
```dart
QuestionnaireConfig(
  id: "template-123",
  title: "Client Onboarding Questionnaire",
  sections: [
    // Must fetch separately using section IDs
  ],
)
```

### Example 2: Section Template → QuestionSection

**API Response** (from `CreateSectionDto` schema):
```json
{
  "id": "section-1",
  "sectionKey": "personal_info",
  "title": "Personal Information",
  "description": "Tell us about yourself",
  "orderIndex": 0,
  "completionMessage": "Personal info complete!"
}
```

**Frontend Model** (`QuestionSection`):
```dart
QuestionSection(
  id: "section-1",
  title: "Personal Information",
  description: "Tell us about yourself",
  completionMessage: "Personal info complete!",
  questions: [
    // Must fetch separately
  ],
)
```

### Example 3: Question Template → Question

**API Response** (from `CreateQuestionDto` schema):
```json
{
  "id": "question-1",
  "questionKey": "full_name",
  "questionText": "What is your full name?",
  "inputType": "text_input",
  "required": true,
  "orderIndex": 0,
  "placeholder": "Enter your full name",
  "validationRules": {
    "minLength": 2,
    "maxLength": 100,
    "pattern": "^[a-zA-Z ]+$"
  }
}
```

**Frontend Model** (`Question`):
```dart
Question(
  id: "question-1",
  sectionId: "section-1", // Must be provided by parent context
  questionText: "What is your full name?",
  inputType: QuestionType.textInput,
  required: true,
  placeholder: "Enter your full name",
  validation: ValidationRules(
    minLength: 2,
    maxLength: 100,
    pattern: r'^[a-zA-Z ]+$',
  ),
)
```

---

## API Endpoints Reference

Based on the OpenAPI spec:

### Template Operations
- `GET /api/questionnaire-templates` - List templates
- `GET /api/questionnaire-templates/{templateId}` - Get template details
- `POST /api/questionnaire-templates` - Create template
- `PUT /api/questionnaire-templates/{templateId}` - Update template
- `DELETE /api/questionnaire-templates/{templateId}` - Delete template

### Section Operations
- `GET /api/questionnaire-templates/{templateId}/sections` - List sections
- `GET /api/questionnaire-templates/{templateId}/sections/{sectionId}` - Get section details
- `POST /api/questionnaire-templates/{templateId}/sections` - Create section
- `PUT /api/questionnaire-templates/{templateId}/sections/{sectionId}` - Update section
- `DELETE /api/questionnaire-templates/{templateId}/sections/{sectionId}` - Delete section
- `POST /api/questionnaire-templates/{templateId}/sections/reorder` - Reorder sections

### Question Operations
- `GET /api/questionnaire-templates/{templateId}/sections/{sectionId}/questions` - List questions
- `GET /api/questionnaire-templates/{templateId}/sections/{sectionId}/questions/{questionId}` - Get question details
- `POST /api/questionnaire-templates/{templateId}/sections/{sectionId}/questions` - Create question
- `PUT /api/questionnaire-templates/{templateId}/sections/{sectionId}/questions/{questionId}` - Update question
- `DELETE /api/questionnaire-templates/{templateId}/sections/{sectionId}/questions/{questionId}` - Delete question
- `POST /api/questionnaire-templates/{templateId}/sections/{sectionId}/questions/reorder` - Reorder questions

### Response/Submission Operations (Different from template structure)
- `GET /api/channels/{channelId}/questionnaires/{assignmentId}/sections/{sectionKey}/status` - Get section progress
- `POST /api/channels/{channelId}/questionnaires/{assignmentId}/sections/{sectionKey}/responses` - Save section responses
- `POST /api/channels/{channelId}/questionnaires/{assignmentId}/questions/{sectionKey}/{questionKey}` - Save question response
- `POST /api/channels/{channelId}/questionnaires/{assignmentId}/submit` - Submit complete questionnaire

---

## Notes

- The API distinguishes between **template definitions** (what questions exist) and **response tracking** (user answers)
- Frontend models currently only handle template definitions
- Will need separate models for tracking user responses and submission state
- Consider caching the full questionnaire structure after initial load to avoid multiple API calls
