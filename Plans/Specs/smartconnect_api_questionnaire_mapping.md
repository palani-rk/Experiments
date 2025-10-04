# SmartConnect API to Flutter QuestionnaireConfig Mapping

## Overview
This document maps the SmartConnect backend API structure for questionnaire templates and assignments to the Flutter `QuestionnaireConfig` model.

## API Endpoints

### Primary Endpoints for Questionnaire Loading

1. **Get Assignment Details**
   ```
   GET /api/channels/{channelId}/questionnaire-assignments/{assignmentId}
   ```
   - Returns: `AssignmentResponseDto`
   - Contains: Assignment metadata + template reference
   - Use case: Get assignment with basic template info

2. **Get Template Details with Sections and Questions**
   ```
   GET /api/questionnaire-templates/{templateId}
   ```
   - Returns: `TemplateResponseDto`
   - Contains: Full template structure with sections and questions
   - Use case: Load complete questionnaire configuration

### Response Endpoints

3. **Save Section Responses (Bulk)**
   ```
   POST /api/channels/{channelId}/questionnaires/{assignmentId}/sections/{sectionKey}/responses
   ```
   - Request: `SaveSectionResponseDto`
   - Response: `SaveSectionResponseResultDto`
   - Use case: Save all responses for a section at once

4. **Get Section Status**
   ```
   GET /api/channels/{channelId}/questionnaires/{assignmentId}/sections/{sectionKey}/status
   ```
   - Response: `SectionResponseDto`
   - Use case: Get current section completion status and responses

5. **Submit Questionnaire**
   ```
   POST /api/channels/{channelId}/questionnaires/{assignmentId}/submit
   ```
   - Response: `SubmissionResponseDto`
   - Use case: Final submission of completed questionnaire

6. **Get My Submission Status**
   ```
   GET /api/channels/{channelId}/questionnaires/{assignmentId}/my-submission
   ```
   - Response: `SubmissionResponseDto`
   - Use case: Check overall submission status and progress

---

## Data Model Mapping

### 1. Assignment to QuestionnaireConfig

**SmartConnect API Structure:**
```json
{
  "id": "assignment-uuid",
  "templateId": "template-uuid",
  "channelId": "channel-uuid",
  "status": "active",
  "dueDate": "2025-10-10T23:59:59.000Z",
  "customTitle": "New Client Onboarding",
  "customInstructions": "Please complete by end of week",
  "allowPartialSubmissions": true,
  "allowResponseEditing": true,
  "template": {
    "id": "template-uuid",
    "name": "client_onboarding",
    "title": "Client Onboarding Questionnaire",
    "description": "Comprehensive client intake",
    "status": "active",
    "version": 1,
    "sections": ["section-id-1", "section-id-2"]  // Array of section IDs
  }
}
```

**Flutter Model:**
```dart
@freezed
class QuestionnaireConfig with _$QuestionnaireConfig {
  const factory QuestionnaireConfig({
    required String id,
    required String title,
    required List<QuestionSection> sections,
  }) = _QuestionnaireConfig;
}
```

**Mapping Logic:**
```dart
QuestionnaireConfig fromAssignmentResponse(AssignmentResponseDto assignment) {
  // Use assignment ID as questionnaire ID (represents the instance)
  final id = assignment.id;

  // Use custom title if provided, otherwise use template title
  final title = assignment.customTitle ?? assignment.template.title;

  // Note: Assignment only has section IDs, need separate API call to get full sections
  // Need to call GET /api/questionnaire-templates/{templateId} for full details

  return QuestionnaireConfig(
    id: id,
    title: title,
    sections: [], // Will be populated from template endpoint
  );
}
```

### 2. Template to QuestionnaireConfig with Sections

**SmartConnect Template Structure (Full):**

When calling `/api/questionnaire-templates/{templateId}`, the response includes embedded sections and questions.

Based on the schema definitions:

**TemplateResponseDto:**
```json
{
  "id": "template-uuid",
  "organizationId": "org-uuid",
  "name": "client_onboarding",
  "title": "Client Onboarding Questionnaire",
  "description": "Comprehensive client intake form",
  "status": "active",
  "version": 1,
  "sectionsCount": 4,
  "questionsCount": 15,
  "sections": [
    // Array of section objects (need to infer structure from endpoints)
  ]
}
```

**Section Structure (from SectionResponseDto as template):**
```json
{
  "id": "section-uuid",
  "sectionKey": "personal_info",
  "title": "Personal Information",
  "description": "Tell us about yourself",
  "orderIndex": 1,
  "completionMessage": "Personal information completed!",
  "questions": [
    {
      "id": "question-uuid",
      "questionKey": "Q1",
      "questionText": "What is your full name?",
      "inputType": "text_input",
      "required": true,
      "orderIndex": 1,
      "placeholder": "Enter your full name",
      "options": null,
      "validationRules": {
        "minLength": 2,
        "maxLength": 100
      }
    }
  ]
}
```

**Flutter QuestionSection Model:**
```dart
@freezed
class QuestionSection with _$QuestionSection {
  const factory QuestionSection({
    required String id,
    required String title,
    String? description,
    required List<Question> questions,
    required String completionMessage,
  }) = _QuestionSection;
}
```

**Mapping Logic:**
```dart
QuestionSection fromApiSection(dynamic sectionData) {
  return QuestionSection(
    id: sectionData['sectionKey'],  // Use sectionKey as ID
    title: sectionData['title'],
    description: sectionData['description'],
    questions: (sectionData['questions'] as List)
        .map((q) => Question.fromJson(q))
        .toList(),
    completionMessage: sectionData['completionMessage'] ?? 'Section completed!',
  );
}
```

### 3. Question Mapping

**SmartConnect Question (from CreateQuestionDto/schema):**
```json
{
  "id": "question-uuid",
  "questionKey": "Q1",
  "questionText": "What is your full name?",
  "inputType": "text_input",
  "required": true,
  "orderIndex": 1,
  "options": ["Option 1", "Option 2"],
  "validationRules": {
    "minLength": 2,
    "maxLength": 100,
    "pattern": "^[a-zA-Z ]+$"
  },
  "placeholder": "Enter your full name"
}
```

**Flutter Question Model:**
```dart
@freezed
class Question with _$Question {
  const factory Question({
    required String id,
    required String sectionId,
    required String questionText,
    required QuestionType inputType,
    @Default(true) bool required,
    List<String>? options,
    ValidationRules? validation,
    String? placeholder,
  }) = _Question;
}
```

**QuestionType Enum Mapping:**

| SmartConnect `inputType` | Flutter `QuestionType` |
|-------------------------|------------------------|
| `text_input`            | `QuestionType.textInput` |
| `text_area`             | `QuestionType.textArea` |
| `number_input`          | `QuestionType.numberInput` |
| `single_select`         | `QuestionType.singleSelect` |
| `multi_select`          | `QuestionType.multiSelect` |

**Mapping Logic:**
```dart
Question fromApiQuestion(dynamic questionData, String sectionId) {
  return Question(
    id: questionData['questionKey'],  // Use questionKey as ID
    sectionId: sectionId,
    questionText: questionData['questionText'],
    inputType: _mapInputType(questionData['inputType']),
    required: questionData['required'] ?? true,
    options: questionData['options'] != null
        ? List<String>.from(questionData['options'])
        : null,
    validation: questionData['validationRules'] != null
        ? ValidationRules.fromJson(questionData['validationRules'])
        : null,
    placeholder: questionData['placeholder'],
  );
}

QuestionType _mapInputType(String apiType) {
  switch (apiType) {
    case 'text_input':
      return QuestionType.textInput;
    case 'text_area':
      return QuestionType.textArea;
    case 'number_input':
      return QuestionType.numberInput;
    case 'single_select':
      return QuestionType.singleSelect;
    case 'multi_select':
      return QuestionType.multiSelect;
    default:
      return QuestionType.textInput;
  }
}
```

### 4. ValidationRules Mapping

**SmartConnect validationRules (JSON object):**
```json
{
  "minLength": 2,
  "maxLength": 100,
  "minValue": 0,
  "maxValue": 999,
  "pattern": "^[a-zA-Z ]+$"
}
```

**Flutter ValidationRules:**
```dart
@freezed
class ValidationRules with _$ValidationRules {
  const factory ValidationRules({
    int? minLength,
    int? maxLength,
    num? minValue,
    num? maxValue,
    String? pattern,
    bool? required,
  }) = _ValidationRules;
}
```

**Mapping Logic:**
```dart
ValidationRules fromApiValidation(Map<String, dynamic> rules) {
  return ValidationRules(
    minLength: rules['minLength'] as int?,
    maxLength: rules['maxLength'] as int?,
    minValue: rules['minValue'] as num?,
    maxValue: rules['maxValue'] as num?,
    pattern: rules['pattern'] as String?,
    required: rules['required'] as bool?,
  );
}
```

---

## Response Data Mapping

### 5. Section Responses

**SmartConnect SaveSectionResponseDto (Request):**
```json
{
  "questionResponses": [
    {
      "questionKey": "Q1",
      "value": "John Doe",
      "metadata": {}
    },
    {
      "questionKey": "Q2",
      "value": 25,
      "metadata": {}
    }
  ],
  "sectionStatus": "completed",
  "autoSave": false
}
```

**Flutter SectionResponse:**
```dart
@freezed
class SectionResponse with _$SectionResponse {
  const factory SectionResponse({
    required String sectionId,
    required List<Response> responses,
    required SectionStatus status,
    DateTime? completedAt,
    required DateTime savedAt,
  }) = _SectionResponse;
}
```

**Mapping to API Request:**
```dart
SaveSectionResponseDto toApiRequest(SectionResponse sectionResponse) {
  return SaveSectionResponseDto(
    questionResponses: sectionResponse.responses.map((r) =>
      QuestionResponseInputDto(
        questionKey: r.questionId,
        value: r.value,
        metadata: {},
      )
    ).toList(),
    sectionStatus: _mapStatus(sectionResponse.status),
    autoSave: false,
  );
}

String _mapStatus(SectionStatus status) {
  switch (status) {
    case SectionStatus.notStarted:
      return 'not_started';
    case SectionStatus.inProgress:
      return 'in_progress';
    case SectionStatus.completed:
      return 'completed';
  }
}
```

**Mapping from API Response:**
```dart
SectionResponse fromApiResponse(SectionResponseDto apiResponse) {
  return SectionResponse(
    sectionId: apiResponse.sectionKey,
    responses: apiResponse.questionResponses
        .map((qr) => Response(
          questionId: qr.questionKey,
          value: qr.value,
          timestamp: DateTime.parse(apiResponse.lastSavedAt),
        ))
        .toList(),
    status: _parseStatus(apiResponse.status),
    completedAt: apiResponse.completedAt != null
        ? DateTime.parse(apiResponse.completedAt)
        : null,
    savedAt: DateTime.parse(apiResponse.lastSavedAt),
  );
}

SectionStatus _parseStatus(String apiStatus) {
  switch (apiStatus) {
    case 'not_started':
      return SectionStatus.notStarted;
    case 'in_progress':
      return SectionStatus.inProgress;
    case 'completed':
      return SectionStatus.completed;
    default:
      return SectionStatus.notStarted;
  }
}
```

### 6. Individual Response Mapping

**Flutter Response:**
```dart
@freezed
class Response with _$Response {
  const factory Response({
    required String questionId,
    required dynamic value,
    required DateTime timestamp,
  }) = _Response;
}
```

**SmartConnect QuestionResponseInputDto:**
```json
{
  "questionKey": "Q1",
  "value": "Any type - string, number, array for multi-select",
  "metadata": {}
}
```

**Mapping Logic:**
```dart
QuestionResponseInputDto toApiResponse(Response response) {
  return QuestionResponseInputDto(
    questionKey: response.questionId,
    value: response.value,
    metadata: {},
  );
}

Response fromApiResponse(QuestionResponseDto apiResponse) {
  return Response(
    questionId: apiResponse.questionKey,
    value: apiResponse.responseValue,
    timestamp: DateTime.parse(apiResponse.answeredAt),
  );
}
```

---

## Complete API Integration Flow

### Loading Questionnaire

```dart
Future<QuestionnaireConfig> loadQuestionnaire({
  required String channelId,
  required String assignmentId,
}) async {
  // Step 1: Get assignment details
  final assignment = await apiClient.get<AssignmentResponseDto>(
    '/api/channels/$channelId/questionnaire-assignments/$assignmentId',
    fromJson: AssignmentResponseDto.fromJson,
  );

  // Step 2: Get full template with sections and questions
  final template = await apiClient.get<TemplateResponseDto>(
    '/api/questionnaire-templates/${assignment.templateId}',
    fromJson: TemplateResponseDto.fromJson,
  );

  // Step 3: Map to QuestionnaireConfig
  return QuestionnaireConfig(
    id: assignment.id,  // Use assignment ID as questionnaire instance ID
    title: assignment.customTitle ?? template.title,
    sections: template.sections.map((section) =>
      QuestionSection(
        id: section.sectionKey,
        title: section.title,
        description: section.description,
        questions: section.questions.map((q) =>
          Question(
            id: q.questionKey,
            sectionId: section.sectionKey,
            questionText: q.questionText,
            inputType: _mapInputType(q.inputType),
            required: q.required,
            options: q.options,
            validation: q.validationRules != null
                ? ValidationRules.fromJson(q.validationRules)
                : null,
            placeholder: q.placeholder,
          )
        ).toList(),
        completionMessage: section.completionMessage ?? 'Section completed!',
      )
    ).toList(),
  );
}
```

### Saving Section Responses

```dart
Future<void> saveSectionResponses({
  required String channelId,
  required String assignmentId,
  required String sectionKey,
  required List<Response> responses,
  required SectionStatus status,
}) async {
  final requestBody = SaveSectionResponseDto(
    questionResponses: responses.map((r) =>
      QuestionResponseInputDto(
        questionKey: r.questionId,
        value: r.value,
        metadata: {},
      )
    ).toList(),
    sectionStatus: _mapStatusToApi(status),
    autoSave: false,
  );

  await apiClient.post(
    '/api/channels/$channelId/questionnaires/$assignmentId/sections/$sectionKey/responses',
    body: requestBody.toJson(),
    fromJson: SaveSectionResponseResultDto.fromJson,
  );
}
```

### Submitting Questionnaire

```dart
Future<SubmissionResponseDto> submitQuestionnaire({
  required String channelId,
  required String assignmentId,
}) async {
  return await apiClient.post<SubmissionResponseDto>(
    '/api/channels/$channelId/questionnaires/$assignmentId/submit',
    fromJson: SubmissionResponseDto.fromJson,
  );
}
```

---

## Key Differences and Considerations

### 1. ID Strategy
- **SmartConnect**: Uses both UUID (`id`) and business keys (`sectionKey`, `questionKey`)
- **Flutter**: Uses business keys as IDs for simpler reference
- **Mapping**: Always use `sectionKey` and `questionKey` as the Flutter model IDs

### 2. Status Enums
Both use similar three-state status for sections:
- `not_started` / `NotStarted`
- `in_progress` / `InProgress`
- `completed` / `Completed`

### 3. Validation Rules
- **SmartConnect**: Free-form JSON object with any properties
- **Flutter**: Strongly-typed `ValidationRules` class
- **Mapping**: Map known fields, ignore unknown properties

### 4. Multi-value Support
- For `multi_select` questions, SmartConnect uses array values
- Flutter Response model uses `dynamic` type to support both single values and arrays
- Use `Response.valueAsList` extension method for multi-select responses

### 5. Assignment vs Template
- **Assignment**: Instance of a questionnaire assigned to a channel
- **Template**: Reusable questionnaire definition
- **Flutter**: Uses assignment ID as the questionnaire instance ID
- **Loading**: Always fetch assignment first, then template for full structure

---

## Error Handling

### Common API Errors

| Status Code | Error | Handling Strategy |
|-------------|-------|-------------------|
| 400 | Invalid response data | Validate data before submission |
| 403 | Assignment not active or due date passed | Show appropriate message, disable submission |
| 404 | Assignment/template not found | Handle gracefully, maybe refresh or return to list |
| 409 | Validation failed | Show validation errors to user |

### Error Response Example

```json
{
  "statusCode": 400,
  "message": "Submission incomplete - missing required questions",
  "error": "Bad Request",
  "details": {
    "missingQuestions": [
      {
        "sectionKey": "personal_info",
        "questionKey": "Q1"
      }
    ]
  }
}
```

---

## Summary

### Loading Questionnaire
1. Call GET `/api/channels/{channelId}/questionnaire-assignments/{assignmentId}`
2. Extract `templateId` from assignment
3. Call GET `/api/questionnaire-templates/{templateId}`
4. Map template structure to `QuestionnaireConfig`

### Saving Responses
1. Collect all responses for a section
2. POST to `/api/channels/{channelId}/questionnaires/{assignmentId}/sections/{sectionKey}/responses`
3. Include section status (`in_progress` or `completed`)

### Final Submission
1. Ensure all required sections are completed
2. POST to `/api/channels/{channelId}/questionnaires/{assignmentId}/submit`
3. Handle validation errors if any required questions are missing

### Key Mapping Rules
- Use `sectionKey` as Flutter `QuestionSection.id`
- Use `questionKey` as Flutter `Question.id`
- Use assignment `id` as `QuestionnaireConfig.id`
- Map enum values from snake_case to camelCase
- Convert ISO timestamps to DateTime objects
