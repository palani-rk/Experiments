# Backend API Data Models Specification
## Client Onboarding Questionnaire - Frontend-to-Backend Mapping

**Document Version**: 1.0
**Generated**: 2025-01-26
**Purpose**: Accurate API data models derived from Flutter frontend implementation
**Frontend Source**: `lib/features/client_questionnaire_flow/data/models/`

---

## Table of Contents
1. [Overview](#1-overview)
2. [Questionnaire Template API Models](#2-questionnaire-template-api-models)
3. [Questionnaire Responses API Models](#3-questionnaire-responses-api-models)
4. [Branding Configuration API Model](#4-branding-configuration-api-model)
5. [Frontend-to-Backend Field Mapping](#5-frontend-to-backend-field-mapping)
6. [Complete JSON Examples](#6-complete-json-examples)
7. [Validation Rules Reference](#7-validation-rules-reference)

---

## 1. Overview

### 1.1 Design Principles
- **Exact Frontend Mapping**: All API models derived directly from Flutter `@freezed` classes
- **JSON Compatibility**: All models support `fromJson`/`toJson` serialization
- **Type Safety**: Strict type definitions matching Dart implementation
- **Null Safety**: Explicit nullable vs required fields matching frontend

### 1.2 Technology Stack Alignment
| Component | Frontend (Flutter) | Backend |
|-----------|-------------------|---------|
| **Serialization** | `freezed` + `json_serializable` | JSON Schema / Pydantic / TypeScript |
| **Date/Time** | `DateTime` (ISO 8601) | ISO 8601 strings |
| **Enums** | Dart enums with `@JsonValue` | String enums (snake_case) |
| **Nullable Types** | `Type?` (null-safe Dart) | `nullable: true` in schema |

---

## 2. Questionnaire Template API Models

### 2.1 QuestionnaireConfig (Root Template Model)

**Purpose**: Complete questionnaire configuration delivered to frontend

**Flutter Source**: `questionnaire_config.dart`

**API Model Schema**:
```typescript
interface QuestionnaireConfig {
  id: string;              // Unique questionnaire identifier
  title: string;           // Display title
  sections: QuestionSection[];  // Array of sections (min 1)
}
```

**JSON Schema**:
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["id", "title", "sections"],
  "properties": {
    "id": {
      "type": "string",
      "description": "Unique questionnaire identifier",
      "example": "nutrition_onboarding_v1",
      "minLength": 1
    },
    "title": {
      "type": "string",
      "description": "Questionnaire display title",
      "example": "Nutrition Plan Questionnaire",
      "minLength": 1,
      "maxLength": 255
    },
    "sections": {
      "type": "array",
      "description": "Ordered array of questionnaire sections",
      "items": { "$ref": "#/definitions/QuestionSection" },
      "minItems": 1
    }
  }
}
```

**Database Table**: `questionnaires`
```sql
CREATE TABLE questionnaires (
  id VARCHAR(100) PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
```

---

### 2.2 QuestionSection

**Purpose**: Grouped set of related questions

**Flutter Source**: `question_section.dart`

**API Model Schema**:
```typescript
interface QuestionSection {
  id: string;                   // Unique section identifier
  title: string;                // Section display title
  description: string | null;   // Optional description
  questions: Question[];        // Array of questions (min 1)
  completionMessage: string;    // Message shown on section completion
}
```

**JSON Schema**:
```json
{
  "type": "object",
  "required": ["id", "title", "questions", "completionMessage"],
  "properties": {
    "id": {
      "type": "string",
      "description": "Unique section identifier within questionnaire",
      "example": "section_1_personal_info",
      "pattern": "^section_[0-9]+_[a-z_]+$"
    },
    "title": {
      "type": "string",
      "description": "Section display title",
      "example": "Personal Info",
      "minLength": 1,
      "maxLength": 255
    },
    "description": {
      "type": ["string", "null"],
      "description": "Optional section description or instructions",
      "example": "Basic information to personalize your plan",
      "maxLength": 500
    },
    "questions": {
      "type": "array",
      "description": "Ordered array of questions in this section",
      "items": { "$ref": "#/definitions/Question" },
      "minItems": 1
    },
    "completionMessage": {
      "type": "string",
      "description": "Encouraging message displayed when section is completed",
      "example": "Great! Personal info complete ✅",
      "default": "Great! Moving on to the next section.",
      "minLength": 1,
      "maxLength": 255
    }
  }
}
```

**Database Table**: `questionnaire_sections`
```sql
CREATE TABLE questionnaire_sections (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  questionnaire_id VARCHAR(100) NOT NULL REFERENCES questionnaires(id) ON DELETE CASCADE,
  section_id VARCHAR(100) NOT NULL,  -- The 'id' field in JSON
  title VARCHAR(255) NOT NULL,
  description TEXT NULL,
  completion_message VARCHAR(255) NOT NULL DEFAULT 'Great! Moving on to the next section.',
  order_index INTEGER NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),

  CONSTRAINT unique_section_per_questionnaire UNIQUE (questionnaire_id, section_id)
);
```

---

### 2.3 Question

**Purpose**: Individual question with validation rules

**Flutter Source**: `question.dart`

**API Model Schema**:
```typescript
interface Question {
  id: string;                      // Unique question identifier
  sectionId: string;               // Parent section reference
  questionText: string;            // Question prompt
  inputType: QuestionType;         // Input type enum
  required: boolean;               // Whether answer is required (default: true)
  options: string[] | null;        // Options for select types or units
  validation: ValidationRules | null;  // Validation configuration
  placeholder: string | null;      // Input placeholder text
}

enum QuestionType {
  TEXT_INPUT = "text_input",
  NUMBER_INPUT = "number_input",
  SINGLE_SELECT = "single_select",
  MULTI_SELECT = "multi_select",
  TEXT_AREA = "text_area"
}
```

**JSON Schema**:
```json
{
  "type": "object",
  "required": ["id", "sectionId", "questionText", "inputType"],
  "properties": {
    "id": {
      "type": "string",
      "description": "Unique question identifier",
      "example": "Q1",
      "pattern": "^Q[0-9]+$"
    },
    "sectionId": {
      "type": "string",
      "description": "Reference to parent section ID",
      "example": "section_1_personal_info"
    },
    "questionText": {
      "type": "string",
      "description": "Question prompt displayed to user",
      "example": "What's your full name?",
      "minLength": 1,
      "maxLength": 500
    },
    "inputType": {
      "type": "string",
      "enum": ["text_input", "number_input", "single_select", "multi_select", "text_area"],
      "description": "Type of input control to render"
    },
    "required": {
      "type": "boolean",
      "description": "Whether this question must be answered",
      "default": true
    },
    "options": {
      "type": ["array", "null"],
      "description": "Options for select types, or units for number inputs (e.g., ['kg', 'lbs'])",
      "items": { "type": "string" },
      "example": ["Lose weight", "Gain weight", "Build muscle"]
    },
    "validation": {
      "oneOf": [
        { "$ref": "#/definitions/ValidationRules" },
        { "type": "null" }
      ],
      "description": "Optional validation rules specific to input type"
    },
    "placeholder": {
      "type": ["string", "null"],
      "description": "Placeholder text for input field",
      "example": "Enter your full name",
      "maxLength": 100
    }
  }
}
```

**Database Table**: `questionnaire_questions`
```sql
CREATE TABLE questionnaire_questions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  section_id UUID NOT NULL REFERENCES questionnaire_sections(id) ON DELETE CASCADE,
  question_id VARCHAR(50) NOT NULL,  -- The 'id' field in JSON (Q1, Q2, etc.)
  section_id_ref VARCHAR(100) NOT NULL,  -- The 'sectionId' field for reference
  question_text TEXT NOT NULL,
  input_type VARCHAR(50) NOT NULL,
  required BOOLEAN NOT NULL DEFAULT TRUE,
  options JSONB NULL,  -- Array of strings
  validation_rules JSONB NULL,  -- ValidationRules object
  placeholder TEXT NULL,
  order_index INTEGER NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),

  CONSTRAINT unique_question_per_section UNIQUE (section_id, question_id),
  CONSTRAINT valid_input_type CHECK (input_type IN ('text_input', 'number_input', 'single_select', 'multi_select', 'text_area'))
);
```

---

### 2.4 ValidationRules

**Purpose**: Type-specific validation configuration

**Flutter Source**: `question.dart` (nested class)

**API Model Schema**:
```typescript
interface ValidationRules {
  // For text_input and text_area
  minLength?: number | null;
  maxLength?: number | null;
  pattern?: string | null;      // Regex pattern

  // For number_input
  minValue?: number | null;
  maxValue?: number | null;

  // General
  required?: boolean | null;
}
```

**JSON Schema**:
```json
{
  "type": "object",
  "properties": {
    "minLength": {
      "type": ["integer", "null"],
      "description": "Minimum string length (for text inputs)",
      "minimum": 0,
      "example": 2
    },
    "maxLength": {
      "type": ["integer", "null"],
      "description": "Maximum string length (for text inputs)",
      "minimum": 1,
      "example": 100
    },
    "pattern": {
      "type": ["string", "null"],
      "description": "Regex pattern for validation",
      "example": "^[A-Za-z\\s]+$"
    },
    "minValue": {
      "type": ["number", "null"],
      "description": "Minimum numeric value (for number inputs)",
      "example": 18
    },
    "maxValue": {
      "type": ["number", "null"],
      "description": "Maximum numeric value (for number inputs)",
      "example": 100
    },
    "required": {
      "type": ["boolean", "null"],
      "description": "Whether field is required (redundant with Question.required)",
      "example": true
    }
  },
  "additionalProperties": false
}
```

**Storage**: Stored as JSONB in `questionnaire_questions.validation_rules`

**Example Values**:
```json
// Text validation
{
  "minLength": 2,
  "maxLength": 100,
  "pattern": "^[A-Za-z\\s]+$"
}

// Number validation
{
  "minValue": 18,
  "maxValue": 100
}

// No validation
null
```

---

## 3. Questionnaire Responses API Models

### 3.1 QuestionnaireResponsesSubmission (Root Response Model)

**Purpose**: Complete set of user responses for submission

**Flutter Source**: `questionnaire_responses_submission.dart`

**API Model Schema**:
```typescript
interface QuestionnaireResponsesSubmission {
  questionnaireId: string;       // Reference to questionnaire
  userId: string;                // User identifier
  sectionResponses: SectionResponse[];  // Array of section responses
  submittedAt: string | null;    // ISO 8601 timestamp
  isComplete: boolean;           // Completion status (default: false)
}
```

**JSON Schema**:
```json
{
  "type": "object",
  "required": ["questionnaireId", "userId", "sectionResponses"],
  "properties": {
    "questionnaireId": {
      "type": "string",
      "description": "Reference to questionnaire template ID",
      "example": "nutrition_onboarding_v1"
    },
    "userId": {
      "type": "string",
      "description": "Unique user/client identifier",
      "example": "user_12345"
    },
    "sectionResponses": {
      "type": "array",
      "description": "Array of responses grouped by section",
      "items": { "$ref": "#/definitions/SectionResponse" },
      "minItems": 0
    },
    "submittedAt": {
      "type": ["string", "null"],
      "format": "date-time",
      "description": "ISO 8601 timestamp of final submission (null if not submitted)",
      "example": "2025-01-26T12:00:00.000Z"
    },
    "isComplete": {
      "type": "boolean",
      "description": "Whether all required sections are completed",
      "default": false
    }
  }
}
```

**Database Table**: `questionnaire_submissions`
```sql
CREATE TABLE questionnaire_submissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  questionnaire_id VARCHAR(100) NOT NULL REFERENCES questionnaires(id),
  user_id UUID NOT NULL REFERENCES users(id),
  submission_id VARCHAR(100) NOT NULL UNIQUE,  -- Public-facing ID
  section_responses_snapshot JSONB NOT NULL,   -- Complete sectionResponses array
  submitted_at TIMESTAMP NULL,
  is_complete BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),

  CONSTRAINT unique_user_questionnaire UNIQUE (user_id, questionnaire_id)
);
```

---

### 3.2 SectionResponse

**Purpose**: All responses for a specific section

**Flutter Source**: `section_response.dart`

**API Model Schema**:
```typescript
interface SectionResponse {
  sectionId: string;             // Reference to section ID
  responses: Response[];         // Array of individual responses
  status: SectionStatus;         // Section completion status
  completedAt: string | null;    // ISO 8601 timestamp (null if not completed)
  savedAt: string;               // ISO 8601 timestamp of last save
}

enum SectionStatus {
  NOT_STARTED = "not_started",
  IN_PROGRESS = "in_progress",
  COMPLETED = "completed"
}
```

**JSON Schema**:
```json
{
  "type": "object",
  "required": ["sectionId", "responses", "status", "savedAt"],
  "properties": {
    "sectionId": {
      "type": "string",
      "description": "Reference to section ID from questionnaire template",
      "example": "section_1_personal_info"
    },
    "responses": {
      "type": "array",
      "description": "Array of individual question responses",
      "items": { "$ref": "#/definitions/Response" },
      "minItems": 0
    },
    "status": {
      "type": "string",
      "enum": ["not_started", "in_progress", "completed"],
      "description": "Current completion status of this section"
    },
    "completedAt": {
      "type": ["string", "null"],
      "format": "date-time",
      "description": "ISO 8601 timestamp when section was completed (null if not completed)",
      "example": "2025-01-26T11:30:00.000Z"
    },
    "savedAt": {
      "type": "string",
      "format": "date-time",
      "description": "ISO 8601 timestamp of last save (required)",
      "example": "2025-01-26T11:30:05.000Z"
    }
  }
}
```

**Database Table**: `section_responses`
```sql
CREATE TABLE section_responses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  questionnaire_id VARCHAR(100) NOT NULL REFERENCES questionnaires(id),
  section_id VARCHAR(100) NOT NULL,  -- Reference to section_id
  responses JSONB NOT NULL,  -- Array of Response objects
  status VARCHAR(20) NOT NULL,
  completed_at TIMESTAMP NULL,
  saved_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  version INTEGER NOT NULL DEFAULT 1,  -- For optimistic locking

  CONSTRAINT unique_user_section UNIQUE (user_id, questionnaire_id, section_id),
  CONSTRAINT valid_status CHECK (status IN ('not_started', 'in_progress', 'completed')),
  CONSTRAINT completed_has_timestamp CHECK (
    (status != 'completed') OR (status = 'completed' AND completed_at IS NOT NULL)
  )
);
```

---

### 3.3 Response

**Purpose**: Individual question answer

**Flutter Source**: `response.dart`

**API Model Schema**:
```typescript
interface Response {
  questionId: string;      // Reference to question ID
  value: any;              // Answer value (type varies by question type)
  timestamp: string;       // ISO 8601 timestamp when answered
}
```

**JSON Schema**:
```json
{
  "type": "object",
  "required": ["questionId", "value", "timestamp"],
  "properties": {
    "questionId": {
      "type": "string",
      "description": "Reference to question ID from template",
      "example": "Q1"
    },
    "value": {
      "description": "Answer value - type varies by question inputType",
      "oneOf": [
        { "type": "string" },
        { "type": "number" },
        { "type": "array", "items": { "type": "string" } },
        { "type": "object" },
        { "type": "null" }
      ],
      "examples": [
        "Sarah Johnson",
        32,
        ["Lose weight", "Build muscle"],
        { "amount": 68, "unit": "kg" }
      ]
    },
    "timestamp": {
      "type": "string",
      "format": "date-time",
      "description": "ISO 8601 timestamp when this answer was provided",
      "example": "2025-01-26T11:25:30.000Z"
    }
  }
}
```

**Value Type Mapping by Question Type**:
| Question Type | Value Type | Example |
|---------------|------------|---------|
| `text_input` | `string` | `"Sarah Johnson"` |
| `text_area` | `string` | `"I want to improve my energy levels..."` |
| `number_input` (no unit) | `number` | `32` |
| `number_input` (with unit) | `object` | `{"amount": 68, "unit": "kg"}` |
| `single_select` | `string` | `"Lose weight"` |
| `multi_select` | `string[]` | `["Lose weight", "Build muscle"]` |

**Storage**: Stored as JSONB array in `section_responses.responses`

---

## 4. Branding Configuration API Model

### 4.1 BrandingConfig

**Purpose**: Clinic/nutritionist branding customization

**Flutter Source**: `branding_config.dart`

**API Model Schema**:
```typescript
interface BrandingConfig {
  logoUrl: string;              // Clinic logo image URL
  title: string;                // Main title
  subtitle: string;             // Subtitle
  nutritionistName: string | null;  // Nutritionist's name
  clientName: string | null;        // Client's name (for personalization)
  primaryColor: string;         // Primary brand color (hex)
  secondaryColor: string;       // Secondary brand color (hex)
}
```

**JSON Schema**:
```json
{
  "type": "object",
  "required": ["logoUrl", "title", "subtitle"],
  "properties": {
    "logoUrl": {
      "type": "string",
      "format": "uri",
      "description": "Clinic logo image URL",
      "example": "https://cdn.example.com/logos/healthfirst.png"
    },
    "title": {
      "type": "string",
      "description": "Main title displayed in header",
      "example": "Your Nutrition Journey",
      "minLength": 1,
      "maxLength": 255
    },
    "subtitle": {
      "type": "string",
      "description": "Subtitle displayed below title",
      "example": "Let's get started!",
      "minLength": 1,
      "maxLength": 255
    },
    "nutritionistName": {
      "type": ["string", "null"],
      "description": "Nutritionist's name for personalization",
      "example": "Dr. Sarah Johnson",
      "maxLength": 100
    },
    "clientName": {
      "type": ["string", "null"],
      "description": "Client's name for personalization",
      "example": "Sarah",
      "maxLength": 100
    },
    "primaryColor": {
      "type": "string",
      "pattern": "^#[0-9A-Fa-f]{6}$",
      "description": "Primary brand color in hex format",
      "default": "#6d5e0f",
      "example": "#2E7D32"
    },
    "secondaryColor": {
      "type": "string",
      "pattern": "^#[0-9A-Fa-f]{6}$",
      "description": "Secondary brand color in hex format",
      "default": "#43664e",
      "example": "#81C784"
    }
  }
}
```

**Database Table**: Can be stored per clinic or per user session
```sql
-- Option 1: Per clinic (shared)
CREATE TABLE clinic_branding (
  clinic_id UUID PRIMARY KEY REFERENCES clinics(id),
  logo_url TEXT NOT NULL,
  title VARCHAR(255) NOT NULL,
  subtitle VARCHAR(255) NOT NULL,
  primary_color VARCHAR(7) NOT NULL DEFAULT '#6d5e0f',
  secondary_color VARCHAR(7) NOT NULL DEFAULT '#43664e',
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Option 2: Per user session (personalized)
-- Dynamically generate BrandingConfig in API response combining:
-- - Clinic branding (logo, colors)
-- - User data (clientName from users.full_name)
-- - Nutritionist data (nutritionistName from nutritionists.name)
```

---

## 5. Frontend-to-Backend Field Mapping

### 5.1 QuestionnaireConfig Mapping

| Flutter Field | Dart Type | Backend Field | SQL Type | API JSON Type | Notes |
|---------------|-----------|---------------|----------|---------------|-------|
| `id` | `String` | `id` | `VARCHAR(100)` | `string` | Primary key |
| `title` | `String` | `title` | `VARCHAR(255)` | `string` | Required |
| `sections` | `List<QuestionSection>` | *Separate table* | *Join query* | `array` | 1:N relationship |

### 5.2 QuestionSection Mapping

| Flutter Field | Dart Type | Backend Field | SQL Type | API JSON Type | Notes |
|---------------|-----------|---------------|----------|---------------|-------|
| `id` | `String` | `section_id` | `VARCHAR(100)` | `string` | Business key |
| `title` | `String` | `title` | `VARCHAR(255)` | `string` | Required |
| `description` | `String?` | `description` | `TEXT NULL` | `string \| null` | Optional |
| `questions` | `List<Question>` | *Separate table* | *Join query* | `array` | 1:N relationship |
| `completionMessage` | `String` | `completion_message` | `VARCHAR(255)` | `string` | Default provided |

### 5.3 Question Mapping

| Flutter Field | Dart Type | Backend Field | SQL Type | API JSON Type | Notes |
|---------------|-----------|---------------|----------|---------------|-------|
| `id` | `String` | `question_id` | `VARCHAR(50)` | `string` | Business key (Q1, Q2) |
| `sectionId` | `String` | `section_id_ref` | `VARCHAR(100)` | `string` | Foreign key reference |
| `questionText` | `String` | `question_text` | `TEXT` | `string` | Required |
| `inputType` | `QuestionType` | `input_type` | `VARCHAR(50)` | `enum string` | Enum values |
| `required` | `bool` | `required` | `BOOLEAN` | `boolean` | Default: true |
| `options` | `List<String>?` | `options` | `JSONB NULL` | `array \| null` | For select types |
| `validation` | `ValidationRules?` | `validation_rules` | `JSONB NULL` | `object \| null` | Nested object |
| `placeholder` | `String?` | `placeholder` | `TEXT NULL` | `string \| null` | Optional |

### 5.4 ValidationRules Mapping

| Flutter Field | Dart Type | Backend Field | JSON Type | Notes |
|---------------|-----------|---------------|-----------|-------|
| `minLength` | `int?` | `minLength` | `integer \| null` | For text inputs |
| `maxLength` | `int?` | `maxLength` | `integer \| null` | For text inputs |
| `pattern` | `String?` | `pattern` | `string \| null` | Regex pattern |
| `minValue` | `num?` | `minValue` | `number \| null` | For number inputs |
| `maxValue` | `num?` | `maxValue` | `number \| null` | For number inputs |
| `required` | `bool?` | `required` | `boolean \| null` | Redundant field |

### 5.5 QuestionnaireResponsesSubmission Mapping

| Flutter Field | Dart Type | Backend Field | SQL Type | API JSON Type | Notes |
|---------------|-----------|---------------|----------|---------------|-------|
| `questionnaireId` | `String` | `questionnaire_id` | `VARCHAR(100)` | `string` | Foreign key |
| `userId` | `String` | `user_id` | `UUID` | `string` | Foreign key |
| `sectionResponses` | `List<SectionResponse>` | `section_responses_snapshot` | `JSONB` | `array` | Stored as JSON |
| `submittedAt` | `DateTime?` | `submitted_at` | `TIMESTAMP NULL` | `string \| null` | ISO 8601 |
| `isComplete` | `bool` | `is_complete` | `BOOLEAN` | `boolean` | Default: false |

### 5.6 SectionResponse Mapping

| Flutter Field | Dart Type | Backend Field | SQL Type | API JSON Type | Notes |
|---------------|-----------|---------------|----------|---------------|-------|
| `sectionId` | `String` | `section_id` | `VARCHAR(100)` | `string` | Foreign key reference |
| `responses` | `List<Response>` | `responses` | `JSONB` | `array` | Array of Response objects |
| `status` | `SectionStatus` | `status` | `VARCHAR(20)` | `enum string` | Enum values |
| `completedAt` | `DateTime?` | `completed_at` | `TIMESTAMP NULL` | `string \| null` | ISO 8601 |
| `savedAt` | `DateTime` | `saved_at` | `TIMESTAMP` | `string` | ISO 8601, required |

### 5.7 Response Mapping

| Flutter Field | Dart Type | Backend Field | JSON Type | Notes |
|---------------|-----------|---------------|-----------|-------|
| `questionId` | `String` | `questionId` | `string` | Reference to question |
| `value` | `dynamic` | `value` | `any` | Type varies by question |
| `timestamp` | `DateTime` | `timestamp` | `string` | ISO 8601 format |

### 5.8 Enum Value Mappings

**QuestionType Enum**:
| Flutter Enum | Dart Value | JSON/API Value | SQL Storage |
|--------------|------------|----------------|-------------|
| `QuestionType.textInput` | `textInput` | `"text_input"` | `'text_input'` |
| `QuestionType.numberInput` | `numberInput` | `"number_input"` | `'number_input'` |
| `QuestionType.singleSelect` | `singleSelect` | `"single_select"` | `'single_select'` |
| `QuestionType.multiSelect` | `multiSelect` | `"multi_select"` | `'multi_select'` |
| `QuestionType.textArea` | `textArea` | `"text_area"` | `'text_area'` |

**SectionStatus Enum**:
| Flutter Enum | Dart Value | JSON/API Value | SQL Storage |
|--------------|------------|----------------|-------------|
| `SectionStatus.notStarted` | `notStarted` | `"not_started"` | `'not_started'` |
| `SectionStatus.inProgress` | `inProgress` | `"in_progress"` | `'in_progress'` |
| `SectionStatus.completed` | `completed` | `"completed"` | `'completed'` |

---

## 6. Complete JSON Examples

### 6.1 Complete QuestionnaireConfig (Template)

```json
{
  "id": "nutrition_onboarding_v1",
  "title": "Nutrition Plan Questionnaire",
  "sections": [
    {
      "id": "section_1_personal_info",
      "title": "Personal Info",
      "description": "Basic information to personalize your plan",
      "completionMessage": "Great! Personal info complete ✅",
      "questions": [
        {
          "id": "Q1",
          "sectionId": "section_1_personal_info",
          "questionText": "What's your full name?",
          "inputType": "text_input",
          "required": true,
          "options": null,
          "validation": {
            "minLength": 2,
            "maxLength": 100,
            "pattern": null,
            "minValue": null,
            "maxValue": null,
            "required": null
          },
          "placeholder": "Enter your full name"
        },
        {
          "id": "Q2",
          "sectionId": "section_1_personal_info",
          "questionText": "How old are you?",
          "inputType": "number_input",
          "required": true,
          "options": null,
          "validation": {
            "minLength": null,
            "maxLength": null,
            "pattern": null,
            "minValue": 18,
            "maxValue": 100,
            "required": null
          },
          "placeholder": "Age"
        },
        {
          "id": "Q3",
          "sectionId": "section_1_personal_info",
          "questionText": "What's your current weight?",
          "inputType": "number_input",
          "required": true,
          "options": ["kg", "lbs"],
          "validation": {
            "minLength": null,
            "maxLength": null,
            "pattern": null,
            "minValue": 30,
            "maxValue": 300,
            "required": null
          },
          "placeholder": "Weight"
        }
      ]
    },
    {
      "id": "section_2_goals",
      "title": "Your Goals",
      "description": "What you want to achieve",
      "completionMessage": "Love your motivation! 💪",
      "questions": [
        {
          "id": "Q5",
          "sectionId": "section_2_goals",
          "questionText": "What's your main health goal?",
          "inputType": "single_select",
          "required": true,
          "options": [
            "Lose weight",
            "Gain weight",
            "Build muscle",
            "Improve energy",
            "Manage medical condition",
            "General wellness",
            "Other"
          ],
          "validation": null,
          "placeholder": null
        },
        {
          "id": "Q6",
          "sectionId": "section_2_goals",
          "questionText": "What's your biggest motivation?",
          "inputType": "multi_select",
          "required": true,
          "options": [
            "Feel more confident",
            "Improve health numbers",
            "Have more energy",
            "Set good example for family"
          ],
          "validation": null,
          "placeholder": null
        }
      ]
    }
  ]
}
```

---

### 6.2 Complete QuestionnaireResponsesSubmission

```json
{
  "questionnaireId": "nutrition_onboarding_v1",
  "userId": "user_12345",
  "sectionResponses": [
    {
      "sectionId": "section_1_personal_info",
      "responses": [
        {
          "questionId": "Q1",
          "value": "Sarah Johnson",
          "timestamp": "2025-01-26T11:20:00.000Z"
        },
        {
          "questionId": "Q2",
          "value": 32,
          "timestamp": "2025-01-26T11:20:30.000Z"
        },
        {
          "questionId": "Q3",
          "value": {
            "amount": 68,
            "unit": "kg"
          },
          "timestamp": "2025-01-26T11:21:00.000Z"
        }
      ],
      "status": "completed",
      "completedAt": "2025-01-26T11:21:00.000Z",
      "savedAt": "2025-01-26T11:21:05.000Z"
    },
    {
      "sectionId": "section_2_goals",
      "responses": [
        {
          "questionId": "Q5",
          "value": "Lose weight",
          "timestamp": "2025-01-26T11:22:00.000Z"
        },
        {
          "questionId": "Q6",
          "value": [
            "Feel more confident",
            "Improve health numbers"
          ],
          "timestamp": "2025-01-26T11:22:30.000Z"
        }
      ],
      "status": "completed",
      "completedAt": "2025-01-26T11:22:30.000Z",
      "savedAt": "2025-01-26T11:22:35.000Z"
    }
  ],
  "submittedAt": "2025-01-26T11:25:00.000Z",
  "isComplete": true
}
```

---

### 6.3 Partial SectionResponse (In Progress)

```json
{
  "sectionId": "section_2_goals",
  "responses": [
    {
      "questionId": "Q5",
      "value": "Lose weight",
      "timestamp": "2025-01-26T11:22:00.000Z"
    }
  ],
  "status": "in_progress",
  "completedAt": null,
  "savedAt": "2025-01-26T11:22:10.000Z"
}
```

---

### 6.4 BrandingConfig Example

```json
{
  "logoUrl": "https://cdn.example.com/logos/healthfirst.png",
  "title": "Your Nutrition Journey",
  "subtitle": "Let's create your personalized plan",
  "nutritionistName": "Dr. Sarah Johnson",
  "clientName": "Sarah",
  "primaryColor": "#2E7D32",
  "secondaryColor": "#81C784"
}
```

---

## 7. Validation Rules Reference

### 7.1 Server-Side Validation Requirements

**All validations from Flutter must be replicated on backend**:

#### Text Input Validation
```typescript
// Example: Full name (Q1)
if (question.inputType === 'text_input') {
  const value = response.value as string;

  // Required check
  if (question.required && (!value || value.trim() === '')) {
    throw ValidationError('This field is required');
  }

  // Length validation
  if (question.validation?.minLength && value.length < question.validation.minLength) {
    throw ValidationError(`Minimum length is ${question.validation.minLength}`);
  }

  if (question.validation?.maxLength && value.length > question.validation.maxLength) {
    throw ValidationError(`Maximum length is ${question.validation.maxLength}`);
  }

  // Pattern validation
  if (question.validation?.pattern) {
    const regex = new RegExp(question.validation.pattern);
    if (!regex.test(value)) {
      throw ValidationError('Invalid format');
    }
  }
}
```

#### Number Input Validation
```typescript
// Example: Age (Q2)
if (question.inputType === 'number_input') {
  const value = response.value as number;

  // Type check
  if (typeof value !== 'number' || isNaN(value)) {
    throw ValidationError('Must be a valid number');
  }

  // Range validation
  if (question.validation?.minValue && value < question.validation.minValue) {
    throw ValidationError(`Minimum value is ${question.validation.minValue}`);
  }

  if (question.validation?.maxValue && value > question.validation.maxValue) {
    throw ValidationError(`Maximum value is ${question.validation.maxValue}`);
  }
}
```

#### Number Input with Unit Validation
```typescript
// Example: Weight (Q3)
if (question.inputType === 'number_input' && question.options) {
  const value = response.value as { amount: number; unit: string };

  // Structure validation
  if (!value.amount || !value.unit) {
    throw ValidationError('Must include amount and unit');
  }

  // Unit validation
  if (!question.options.includes(value.unit)) {
    throw ValidationError(`Unit must be one of: ${question.options.join(', ')}`);
  }

  // Amount validation (same as number_input)
  // ... apply minValue/maxValue to value.amount
}
```

#### Single Select Validation
```typescript
// Example: Main goal (Q5)
if (question.inputType === 'single_select') {
  const value = response.value as string;

  // Required check
  if (question.required && !value) {
    throw ValidationError('Please select an option');
  }

  // Options validation
  if (!question.options || !question.options.includes(value)) {
    throw ValidationError('Invalid selection');
  }
}
```

#### Multi Select Validation
```typescript
// Example: Motivations (Q6)
if (question.inputType === 'multi_select') {
  const value = response.value as string[];

  // Type check
  if (!Array.isArray(value)) {
    throw ValidationError('Must be an array of selections');
  }

  // Required check (at least one selection)
  if (question.required && value.length === 0) {
    throw ValidationError('Please select at least one option');
  }

  // Options validation
  for (const item of value) {
    if (!question.options || !question.options.includes(item)) {
      throw ValidationError(`Invalid selection: ${item}`);
    }
  }
}
```

---

### 7.2 Response Value Type Validation Matrix

| Input Type | Expected Value Type | Validation Checks | Example Valid Value |
|------------|-------------------|-------------------|---------------------|
| `text_input` | `string` | `minLength`, `maxLength`, `pattern`, `required` | `"Sarah Johnson"` |
| `text_area` | `string` | `minLength`, `maxLength`, `required` | `"I want to improve..."` |
| `number_input` (no unit) | `number` | `minValue`, `maxValue`, `required` | `32` |
| `number_input` (with unit) | `object { amount, unit }` | `minValue`, `maxValue`, `required`, `unit in options` | `{"amount": 68, "unit": "kg"}` |
| `single_select` | `string` | `value in options`, `required` | `"Lose weight"` |
| `multi_select` | `string[]` | `all values in options`, `required` (min 1) | `["Option1", "Option2"]` |

---

### 7.3 Section Completion Validation

**Backend must validate section completion before accepting `status: "completed"`**:

```typescript
function validateSectionCompletion(
  section: QuestionSection,
  sectionResponse: SectionResponse
): boolean {

  // Get all required questions in this section
  const requiredQuestions = section.questions.filter(q => q.required);

  // Check each required question has a valid response
  for (const question of requiredQuestions) {
    const response = sectionResponse.responses.find(r => r.questionId === question.id);

    if (!response || !isValidResponseValue(response.value, question.inputType)) {
      return false;  // Missing or invalid response
    }
  }

  return true;  // All required questions answered
}

function isValidResponseValue(value: any, inputType: QuestionType): boolean {
  if (value === null || value === undefined) return false;

  switch (inputType) {
    case 'text_input':
    case 'text_area':
    case 'single_select':
      return typeof value === 'string' && value.trim() !== '';

    case 'number_input':
      return typeof value === 'number' ||
             (typeof value === 'object' && value.amount !== undefined);

    case 'multi_select':
      return Array.isArray(value) && value.length > 0;

    default:
      return false;
  }
}
```

---

### 7.4 Final Submission Validation

**Backend must validate complete questionnaire before accepting final submission**:

```typescript
function validateFinalSubmission(
  questionnaire: QuestionnaireConfig,
  submission: QuestionnaireResponsesSubmission
): ValidationResult {

  const errors: string[] = [];

  // 1. Check all sections present
  for (const section of questionnaire.sections) {
    const sectionResponse = submission.sectionResponses.find(
      sr => sr.sectionId === section.id
    );

    if (!sectionResponse) {
      errors.push(`Missing section: ${section.id}`);
      continue;
    }

    // 2. Check section status is 'completed'
    if (sectionResponse.status !== 'completed') {
      errors.push(`Section ${section.id} is not completed`);
    }

    // 3. Check all required questions answered
    if (!validateSectionCompletion(section, sectionResponse)) {
      errors.push(`Section ${section.id} has missing required answers`);
    }
  }

  return {
    isValid: errors.length === 0,
    errors: errors
  };
}
```

---

## 8. API Endpoint Design Based on Models

### 8.1 GET /api/questionnaires/{id} - Load Template

**Response**: `QuestionnaireConfig`

```typescript
// Response matches QuestionnaireConfig model exactly
GET /api/questionnaires/nutrition_onboarding_v1

Response 200:
{
  "id": "nutrition_onboarding_v1",
  "title": "Nutrition Plan Questionnaire",
  "sections": [ /* QuestionSection[] */ ]
}
```

---

### 8.2 GET /api/branding/config - Load Branding

**Response**: `BrandingConfig`

```typescript
GET /api/branding/config

Response 200:
{
  "logoUrl": "https://...",
  "title": "Your Nutrition Journey",
  "subtitle": "Let's get started",
  "nutritionistName": "Dr. Sarah Johnson",
  "clientName": "Sarah",
  "primaryColor": "#2E7D32",
  "secondaryColor": "#81C784"
}
```

---

### 8.3 POST /api/questionnaires/{qId}/sections/{sectionId}/responses - Save Section

**Request**: Subset of `SectionResponse`

```typescript
POST /api/questionnaires/nutrition_onboarding_v1/sections/section_1_personal_info/responses

Request Body:
{
  "userId": "user_12345",
  "responses": [
    {
      "questionId": "Q1",
      "value": "Sarah Johnson",
      "timestamp": "2025-01-26T11:20:00.000Z"
    }
  ],
  "status": "completed",
  "completedAt": "2025-01-26T11:21:00.000Z",
  "savedAt": "2025-01-26T11:21:05.000Z"
}

Response 200:
{
  "success": true,
  "sectionId": "section_1_personal_info",
  "savedAt": "2025-01-26T11:21:05.123Z"
}
```

---

### 8.4 GET /api/users/{userId}/responses?questionnaireId={qId} - Load Responses

**Response**: `QuestionnaireResponsesSubmission`

```typescript
GET /api/users/user_12345/responses?questionnaireId=nutrition_onboarding_v1

Response 200:
{
  "questionnaireId": "nutrition_onboarding_v1",
  "userId": "user_12345",
  "sectionResponses": [ /* SectionResponse[] */ ],
  "submittedAt": null,
  "isComplete": false
}
```

---

### 8.5 POST /api/questionnaires/{qId}/submit - Final Submission

**Request**: `QuestionnaireResponsesSubmission`

```typescript
POST /api/questionnaires/nutrition_onboarding_v1/submit

Request Body:
{
  "questionnaireId": "nutrition_onboarding_v1",
  "userId": "user_12345",
  "sectionResponses": [ /* Complete SectionResponse[] */ ],
  "submittedAt": "2025-01-26T11:25:00.000Z",
  "isComplete": true
}

Response 200:
{
  "success": true,
  "submissionId": "sub_abc123",
  "submittedAt": "2025-01-26T11:25:00.123Z"
}
```

---

## Document Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-01-26 | Initial specification from Flutter models |

---

**End of Specification**
