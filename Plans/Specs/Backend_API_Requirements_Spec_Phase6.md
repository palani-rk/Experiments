# Backend API Requirements Specification
## Client Onboarding Questionnaire - Phase 6 Production Mode

**Document Version**: 1.0
**Generated**: 2025-01-26
**Target System**: NutriApp Client Onboarding Backend
**Related Frontend Spec**: [design_spec_client_onboarding_questionnaire.md](design_spec_client_onboarding_questionnaire.md)

---

## Table of Contents
1. [System Overview](#1-system-overview)
2. [Requirements & API Invocation Flows](#2-requirements--api-invocation-flows)
3. [API Endpoint Specifications](#3-api-endpoint-specifications)
4. [Database Data Models](#4-database-data-models)
5. [Security & Authentication](#5-security--authentication)
6. [Error Handling & Response Codes](#6-error-handling--response-codes)
7. [Performance Requirements](#7-performance-requirements)
8. [Appendix](#8-appendix)

---

## 1. System Overview

### 1.1 Purpose
Provide RESTful API backend for the Client Onboarding Questionnaire feature, supporting:
- Dynamic questionnaire configuration delivery
- Progressive response persistence (section-level saves)
- Resume functionality with partial response storage
- Final questionnaire submission and validation
- Multi-tenant clinic branding support

### 1.2 Architecture Context
```
┌─────────────────┐         HTTPS/REST          ┌──────────────────┐
│                 │◄──────────────────────────►│                  │
│  Flutter App    │    JSON Request/Response   │  Backend API     │
│  (Mobile)       │                            │  (Node.js/Python)│
└─────────────────┘                            └──────────────────┘
                                                        │
                                                        ▼
                                               ┌──────────────────┐
                                               │   PostgreSQL     │
                                               │   Database       │
                                               └──────────────────┘
```

### 1.3 Technology Stack
| Component | Technology | Version |
|-----------|-----------|---------|
| **API Framework** | Express.js / FastAPI | 4.x / 0.100+ |
| **Database** | PostgreSQL | 14+ |
| **Authentication** | JWT Bearer Tokens | - |
| **API Protocol** | RESTful JSON | - |
| **Documentation** | OpenAPI 3.0 | - |

### 1.4 Key Design Principles
- **Stateless API**: Each request contains all necessary context
- **Idempotent Operations**: Safe retry behavior for all mutations
- **Progressive Persistence**: Save section data incrementally, not just final submission
- **Multi-Tenancy**: Support multiple clinics/nutritionists with data isolation
- **Graceful Degradation**: Partial data saves allowed, final submission requires completeness

---

## 2. Requirements & API Invocation Flows

### 2.1 User Journey Flow Mapping

#### 2.1.1 Initial Questionnaire Load Flow
```
┌─────────┐                                      ┌─────────┐
│ Client  │                                      │  API    │
└────┬────┘                                      └────┬────┘
     │                                                │
     │  1. GET /api/branding/config                  │
     │  Authorization: Bearer <token>                │
     ├──────────────────────────────────────────────►│
     │                                                │
     │  2. Return BrandingConfig                     │
     │     {logoUrl, clinicName, colors...}          │
     │◄──────────────────────────────────────────────┤
     │                                                │
     │  3. GET /api/questionnaires/{id}              │
     │  Authorization: Bearer <token>                │
     ├──────────────────────────────────────────────►│
     │                                                │
     │  4. Return QuestionnaireConfig                │
     │     {sections[], questions[], validation...}  │
     │◄──────────────────────────────────────────────┤
     │                                                │
     │  5. GET /api/users/{userId}/responses         │
     │     ?questionnaireId={id}                     │
     ├──────────────────────────────────────────────►│
     │                                                │
     │  6. Return existing responses (if any)        │
     │     {sectionResponses[], resumePoint...}      │
     │◄──────────────────────────────────────────────┤
     │                                                │
```

**Key Requirements**:
- Branding config must load before questionnaire UI renders
- Questionnaire config defines all questions and validation rules
- Resume detection happens on initial load to determine entry point
- All three calls can be parallelized by client for performance

---

#### 2.1.2 Section Completion & Auto-Save Flow
```
┌─────────┐                                      ┌─────────┐
│ Client  │                                      │  API    │
└────┬────┘                                      └────┬────┘
     │                                                │
     │  User completes Section 1 (Personal Info)     │
     │                                                │
     │  1. POST /api/questionnaires/{qId}/           │
     │        sections/{sectionId}/responses         │
     │     Body: {                                   │
     │       userId, responses[], completedAt        │
     │     }                                         │
     ├──────────────────────────────────────────────►│
     │                                                │
     │                                  Validate ────┤
     │                                  - All required questions answered
     │                                  - Response formats valid
     │                                  - User authorized for questionnaire
     │                                                │
     │                                  Persist ─────┤
     │                                  - Upsert section_responses record
     │                                  - Update status to 'completed'
     │                                  - Store timestamp
     │                                                │
     │  2. Return success response                   │
     │     {success: true, sectionId, savedAt}       │
     │◄──────────────────────────────────────────────┤
     │                                                │
     │  3. Update local state                        │
     │     - Mark section complete                   │
     │     - Enable next section                     │
     │                                                │
```

**Key Requirements**:
- Section save must be **idempotent** (can replay same section data)
- Partial sections can be saved via separate endpoint for resume functionality
- Response validation must match frontend validation rules
- Each section save creates audit trail with timestamps

---

#### 2.1.3 Response Edit & Update Flow
```
┌─────────┐                                      ┌─────────┐
│ Client  │                                      │  API    │
└────┬────┘                                      └────┬────┘
     │                                                │
     │  User edits previously answered Q1            │
     │                                                │
     │  1. PUT /api/questionnaires/{qId}/            │
     │        sections/{sectionId}/                  │
     │        responses/{questionId}                 │
     │     Body: {                                   │
     │       value: "Updated Answer",                │
     │       timestamp: "2025-01-26T12:00:00Z"       │
     │     }                                         │
     ├──────────────────────────────────────────────►│
     │                                                │
     │                                  Validate ────┤
     │                                  - Question exists in section
     │                                  - Value matches question type
     │                                  - User owns this response
     │                                                │
     │                                  Update ──────┤
     │                                  - Update response value
     │                                  - Update timestamp
     │                                  - Maintain audit history
     │                                                │
     │  2. Return success response                   │
     │     {success: true, questionId, updatedAt}    │
     │◄──────────────────────────────────────────────┤
     │                                                │
```

**Key Requirements**:
- Individual response updates don't change section completion status
- Edit history maintained for audit purposes (optional)
- Updates are atomic - all or nothing
- Optimistic locking to prevent concurrent edit conflicts

---

#### 2.1.4 Partial Save & Resume Flow
```
┌─────────┐                                      ┌─────────┐
│ Client  │                                      │  API    │
└────┬────┘                                      └────┬────┘
     │                                                │
     │  User exits mid-section (e.g., Q3 of Section 2)
     │                                                │
     │  1. POST /api/questionnaires/{qId}/           │
     │        sections/{sectionId}/partial           │
     │     Body: {                                   │
     │       userId,                                 │
     │       responses: [Q1, Q2, Q3],               │
     │       lastQuestionId: "Q3",                  │
     │       status: "in_progress"                   │
     │     }                                         │
     ├──────────────────────────────────────────────►│
     │                                                │
     │                                  Persist ─────┤
     │                                  - Upsert section_responses
     │                                  - Set status = 'in_progress'
     │                                  - Store partial responses
     │                                  - Record lastQuestionId
     │                                                │
     │  2. Return success                            │
     │     {success: true, resumePoint: "Q4"}        │
     │◄──────────────────────────────────────────────┤
     │                                                │
     │  === User returns later ===                   │
     │                                                │
     │  3. GET /api/users/{userId}/responses         │
     │     ?questionnaireId={qId}                    │
     ├──────────────────────────────────────────────►│
     │                                                │
     │  4. Return partial responses with resume info │
     │     {                                         │
     │       sectionResponses: [...],                │
     │       resumeSection: "section_2_goals",       │
     │       resumeQuestion: "Q4"                    │
     │     }                                         │
     │◄──────────────────────────────────────────────┤
     │                                                │
```

**Key Requirements**:
- Partial saves don't require all section questions answered
- Resume point calculation based on last answered question
- Clear distinction between `in_progress` and `completed` sections
- Partial data survives app restarts and device changes

---

#### 2.1.5 Final Submission Flow
```
┌─────────┐                                      ┌─────────┐
│ Client  │                                      │  API    │
└────┬────┘                                      └────┬────┘
     │                                                │
     │  User reviews all responses & submits         │
     │                                                │
     │  1. POST /api/questionnaires/{qId}/submit     │
     │     Body: {                                   │
     │       userId,                                 │
     │       sectionResponses: [                     │
     │         {sectionId, responses[], status},     │
     │         ...all 4 sections                     │
     │       ],                                      │
     │       submittedAt: "2025-01-26T12:30:00Z"     │
     │     }                                         │
     ├──────────────────────────────────────────────►│
     │                                                │
     │                                  Validate ────┤
     │                                  - All 4 sections completed
     │                                  - All required questions answered
     │                                  - All responses valid
     │                                  - Not already submitted
     │                                                │
     │                                  Process ─────┤
     │                                  - Create questionnaire_submissions record
     │                                  - Update all section_responses to 'submitted'
     │                                  - Generate submissionId
     │                                  - Trigger notification to nutritionist
     │                                                │
     │  2. Return success with submission ID         │
     │     {                                         │
     │       success: true,                          │
     │       submissionId: "sub_abc123",            │
     │       message: "Submitted successfully"       │
     │     }                                         │
     │◄──────────────────────────────────────────────┤
     │                                                │
     │  3. Navigate to completion screen             │
     │     Show confirmation & next steps            │
     │                                                │
```

**Key Requirements**:
- Final submission is **terminal** - no edits allowed after
- All 4 sections must be `completed` before submission accepted
- Submission creates immutable snapshot of responses
- Backend triggers downstream workflows (nutritionist notification, etc.)
- Submission is idempotent with same `submissionId` returned if replayed

---

### 2.2 Error & Edge Case Flows

#### 2.2.1 Network Failure & Retry Flow
```
┌─────────┐                                      ┌─────────┐
│ Client  │                                      │  API    │
└────┬────┘                                      └────┬────┘
     │                                                │
     │  1. POST /api/.../responses                   │
     ├──────────────────────────────────────────────►│
     │                                                X  Network Error
     │  2. Request timeout                           │
     │◄───────────────────────────────────────────────
     │
     │  3. Store request in retry queue
     │     Show user: "Saving... will retry"
     │
     │  4. Retry POST /api/.../responses
     │     (Same request payload)
     ├──────────────────────────────────────────────►│
     │                                                │
     │                                  Idempotent ──┤
     │                                  - Detect duplicate by userId + sectionId
     │                                  - Return success (already saved)
     │                                                │
     │  5. Success response                          │
     │◄──────────────────────────────────────────────┤
     │                                                │
```

**Requirements**:
- All mutation endpoints must be idempotent
- Use request IDs or natural keys to detect duplicates
- Retry with exponential backoff (1s, 2s, 4s, 8s)
- Max 5 retry attempts before showing permanent error

---

#### 2.2.2 Concurrent Edit Conflict Flow
```
┌──────────┐        ┌──────────┐              ┌─────────┐
│ Client A │        │ Client B │              │  API    │
└────┬─────┘        └────┬─────┘              └────┬────┘
     │                   │                          │
     │  1. GET response (version: 1)                │
     ├─────────────────────────────────────────────►│
     │◄──────────────────────────────────────────────┤
     │                   │                          │
     │                   │  2. GET response (v: 1)  │
     │                   ├─────────────────────────►│
     │                   │◄─────────────────────────┤
     │                   │                          │
     │  3. PUT update (if-match: v1)                │
     ├─────────────────────────────────────────────►│
     │                                  Update ─────┤
     │                                  - version = 2
     │  4. Success (new version: 2)                 │
     │◄──────────────────────────────────────────────┤
     │                   │                          │
     │                   │  5. PUT update (if-match: v1)
     │                   ├─────────────────────────►│
     │                                  Conflict ───┤
     │                                  - Current version = 2
     │                                  - Request expects v1
     │                   │  6. 409 Conflict         │
     │                   │     {error, currentValue}│
     │                   │◄─────────────────────────┤
     │                   │                          │
     │                   │  7. Show conflict UI     │
     │                   │     - Show current value
     │                   │     - Ask user to refresh
     │                   │                          │
```

**Requirements**:
- Implement optimistic locking with version numbers or ETags
- Return current value on conflict for client resolution
- Rare edge case - acceptable to show manual resolution UI

---

## 3. API Endpoint Specifications

### 3.1 Branding Configuration

#### `GET /api/branding/config`
**Purpose**: Retrieve clinic branding configuration for UI customization

**Authentication**: Required (Bearer Token)

**Request Headers**:
```http
Authorization: Bearer <jwt_token>
```

**Query Parameters**: None

**Response 200 - Success**:
```json
{
  "clinicId": "clinic_001",
  "clinicName": "HealthFirst Nutrition",
  "logoUrl": "https://cdn.example.com/logos/healthfirst.png",
  "primaryColor": "#2E7D32",
  "secondaryColor": "#81C784",
  "nutritionistName": "Dr. Sarah Johnson",
  "nutritionistPhoto": "https://cdn.example.com/photos/sarah.jpg",
  "supportEmail": "support@healthfirst.com",
  "supportPhone": "+1-555-0123"
}
```

**Response Fields**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| clinicId | string | Yes | Unique clinic identifier |
| clinicName | string | Yes | Display name for clinic |
| logoUrl | string(url) | No | Clinic logo image URL |
| primaryColor | string(hex) | Yes | Primary brand color |
| secondaryColor | string(hex) | Yes | Secondary brand color |
| nutritionistName | string | Yes | Nutritionist's display name |
| nutritionistPhoto | string(url) | No | Nutritionist photo URL |
| supportEmail | string(email) | Yes | Support contact email |
| supportPhone | string | No | Support phone number |

**Error Responses**:
- `401 Unauthorized`: Invalid or missing token
- `404 Not Found`: Clinic not found for user
- `500 Internal Server Error`: Server error

**Caching**: Client should cache for session duration

---

### 3.2 Questionnaire Configuration

#### `GET /api/questionnaires/{questionnaireId}`
**Purpose**: Retrieve complete questionnaire structure with all sections and questions

**Authentication**: Required

**Path Parameters**:
- `questionnaireId` (string): Questionnaire identifier (e.g., `nutrition_onboarding_v1`)

**Request Headers**:
```http
Authorization: Bearer <jwt_token>
```

**Response 200 - Success**:
```json
{
  "id": "nutrition_onboarding_v1",
  "title": "Nutrition Plan Questionnaire",
  "version": "1.0",
  "estimatedMinutes": 10,
  "sections": [
    {
      "id": "section_1_personal_info",
      "title": "Personal Info",
      "description": "Basic information to personalize your plan",
      "estimatedMinutes": 2,
      "order": 1,
      "completionMessage": "Great! Personal info complete ✅",
      "questions": [
        {
          "id": "Q1",
          "questionText": "What's your full name?",
          "inputType": "text_input",
          "required": true,
          "order": 1,
          "validation": {
            "minLength": 2,
            "maxLength": 100,
            "pattern": null
          },
          "placeholder": "Enter your full name",
          "options": null,
          "conditionalLogic": null
        },
        {
          "id": "Q2",
          "questionText": "How old are you?",
          "inputType": "number_input",
          "required": true,
          "order": 2,
          "validation": {
            "min": 18,
            "max": 100,
            "integer": true
          },
          "placeholder": "Age",
          "options": null,
          "conditionalLogic": null
        },
        {
          "id": "Q3",
          "questionText": "What's your current weight?",
          "inputType": "number_input",
          "required": true,
          "order": 3,
          "validation": {
            "min": 30,
            "max": 300
          },
          "placeholder": "Weight",
          "options": ["kg", "lbs"],
          "conditionalLogic": null
        }
      ]
    },
    {
      "id": "section_2_goals",
      "title": "Your Goals",
      "description": "What you want to achieve",
      "estimatedMinutes": 2,
      "order": 2,
      "completionMessage": "Love your motivation! 💪",
      "questions": [
        {
          "id": "Q5",
          "questionText": "What's your main health goal?",
          "inputType": "single_select",
          "required": true,
          "order": 1,
          "validation": null,
          "placeholder": null,
          "options": [
            "Lose weight",
            "Gain weight",
            "Build muscle",
            "Improve energy",
            "Manage medical condition",
            "General wellness",
            "Other"
          ],
          "conditionalLogic": null
        },
        {
          "id": "Q6",
          "questionText": "How much would you like to lose?",
          "inputType": "number_input",
          "required": false,
          "order": 2,
          "validation": {
            "min": 1,
            "max": 100
          },
          "placeholder": "Target weight loss",
          "options": ["kg", "lbs"],
          "conditionalLogic": {
            "showIf": {
              "questionId": "Q5",
              "operator": "equals",
              "value": "Lose weight"
            }
          }
        }
      ]
    }
  ]
}
```

**Response Fields** (nested):

**QuestionnaireConfig**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | string | Yes | Unique questionnaire ID |
| title | string | Yes | Display title |
| version | string | Yes | Version number |
| estimatedMinutes | integer | Yes | Total estimated completion time |
| sections | Section[] | Yes | Array of sections (min 1) |

**Section**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | string | Yes | Unique section ID |
| title | string | Yes | Section display title |
| description | string | No | Section description |
| estimatedMinutes | integer | Yes | Section time estimate |
| order | integer | Yes | Display order (1-based) |
| completionMessage | string | Yes | Message shown on completion |
| questions | Question[] | Yes | Array of questions (min 1) |

**Question**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | string | Yes | Unique question ID within questionnaire |
| questionText | string | Yes | Question prompt text |
| inputType | enum | Yes | `text_input`, `text_area`, `number_input`, `single_select`, `multi_select` |
| required | boolean | Yes | Whether answer is required |
| order | integer | Yes | Display order within section |
| validation | object | No | Type-specific validation rules |
| placeholder | string | No | Input placeholder text |
| options | string[] | No | Options for select/multi-select types |
| conditionalLogic | object | No | Conditional display logic |

**Validation Object** (varies by inputType):
```typescript
// For text_input / text_area
{
  minLength?: number,
  maxLength?: number,
  pattern?: string  // regex pattern
}

// For number_input
{
  min?: number,
  max?: number,
  integer?: boolean,
  step?: number
}

// For single_select / multi_select
// Options array serves as validation
```

**ConditionalLogic Object**:
```json
{
  "showIf": {
    "questionId": "Q5",
    "operator": "equals",  // or "not_equals", "contains", "greater_than"
    "value": "Lose weight"
  }
}
```

**Error Responses**:
- `401 Unauthorized`: Invalid authentication
- `404 Not Found`: Questionnaire not found
- `500 Internal Server Error`: Server error

**Performance**: Response size typically 10-50KB, cache aggressively

---

### 3.3 Section Response Persistence

#### `POST /api/questionnaires/{questionnaireId}/sections/{sectionId}/responses`
**Purpose**: Save completed or partial section responses

**Authentication**: Required

**Path Parameters**:
- `questionnaireId` (string): Questionnaire ID
- `sectionId` (string): Section ID (e.g., `section_1_personal_info`)

**Request Headers**:
```http
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

**Request Body**:
```json
{
  "userId": "user_12345",
  "responses": [
    {
      "questionId": "Q1",
      "value": "Sarah Johnson",
      "timestamp": "2025-01-26T10:30:00Z"
    },
    {
      "questionId": "Q2",
      "value": 32,
      "timestamp": "2025-01-26T10:30:15Z"
    },
    {
      "questionId": "Q3",
      "value": {
        "amount": 68,
        "unit": "kg"
      },
      "timestamp": "2025-01-26T10:30:30Z"
    }
  ],
  "status": "completed",
  "completedAt": "2025-01-26T10:35:00Z"
}
```

**Request Body Fields**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| userId | string | Yes | User identifier (validated against auth token) |
| responses | Response[] | Yes | Array of question responses |
| status | enum | Yes | `in_progress` or `completed` |
| completedAt | string(ISO8601) | Conditional | Required if status=completed |

**Response Object Fields**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| questionId | string | Yes | Question being answered |
| value | any | Yes | Answer value (type varies by question) |
| timestamp | string(ISO8601) | Yes | When answer was provided |

**Response Value Types by Question Type**:
```typescript
// text_input, text_area
value: string

// number_input (no unit)
value: number

// number_input (with unit)
value: {
  amount: number,
  unit: string  // must be in question.options
}

// single_select
value: string  // must be in question.options

// multi_select
value: string[]  // each must be in question.options OR "other:text"
```

**Response 200 - Success**:
```json
{
  "success": true,
  "sectionId": "section_1_personal_info",
  "status": "completed",
  "savedAt": "2025-01-26T10:35:01Z",
  "responseCount": 3
}
```

**Response 400 - Validation Error**:
```json
{
  "success": false,
  "error": "Validation failed",
  "details": {
    "Q2": "Value must be between 18 and 100",
    "Q3": "Unit 'pounds' is not a valid option"
  }
}
```

**Validation Rules**:
1. All `questionId` values must exist in the specified section
2. `value` must match question's `inputType` and validation rules
3. If `status=completed`, all required questions in section must be answered
4. If `status=in_progress`, partial responses allowed
5. `userId` must match authenticated user
6. Request is **idempotent** - replaying same data returns success

**Error Responses**:
- `400 Bad Request`: Validation errors (see details in response)
- `401 Unauthorized`: Invalid authentication
- `403 Forbidden`: User not authorized for this questionnaire
- `404 Not Found`: Questionnaire or section not found
- `409 Conflict`: Section already submitted (cannot modify)
- `500 Internal Server Error`: Server error

---

### 3.4 Individual Response Update

#### `PUT /api/questionnaires/{questionnaireId}/sections/{sectionId}/responses/{questionId}`
**Purpose**: Update a single response value (for edit functionality)

**Authentication**: Required

**Path Parameters**:
- `questionnaireId` (string): Questionnaire ID
- `sectionId` (string): Section ID
- `questionId` (string): Question ID to update

**Request Headers**:
```http
Authorization: Bearer <jwt_token>
Content-Type: application/json
If-Match: "version_hash"  // Optional: for optimistic locking
```

**Request Body**:
```json
{
  "value": "Sarah M. Johnson",
  "timestamp": "2025-01-26T11:00:00Z"
}
```

**Response 200 - Success**:
```json
{
  "success": true,
  "questionId": "Q1",
  "updatedAt": "2025-01-26T11:00:01Z",
  "version": "v2"
}
```

**Response 409 - Conflict** (if using optimistic locking):
```json
{
  "success": false,
  "error": "Conflict: response was modified by another request",
  "currentValue": "Sarah Johnson",
  "currentVersion": "v3",
  "timestamp": "2025-01-26T10:59:00Z"
}
```

**Validation Rules**:
1. Question must exist in section
2. Value must match question type and validation
3. Section must not be in `submitted` state
4. User must own the response

**Error Responses**:
- `400 Bad Request`: Invalid value for question type
- `401 Unauthorized`: Invalid authentication
- `403 Forbidden`: Cannot edit submitted questionnaire
- `404 Not Found`: Question/section/questionnaire not found
- `409 Conflict`: Concurrent modification (if using locking)
- `500 Internal Server Error`: Server error

---

### 3.5 Partial Section Save

#### `POST /api/questionnaires/{questionnaireId}/sections/{sectionId}/partial`
**Purpose**: Save incomplete section for resume functionality

**Authentication**: Required

**Path Parameters**:
- `questionnaireId` (string): Questionnaire ID
- `sectionId` (string): Section ID

**Request Body**:
```json
{
  "userId": "user_12345",
  "responses": [
    {
      "questionId": "Q5",
      "value": "Lose weight",
      "timestamp": "2025-01-26T11:00:00Z"
    },
    {
      "questionId": "Q6",
      "value": {
        "amount": 10,
        "unit": "kg"
      },
      "timestamp": "2025-01-26T11:01:00Z"
    }
  ],
  "lastQuestionId": "Q6",
  "status": "in_progress",
  "savedAt": "2025-01-26T11:01:30Z"
}
```

**Response 200 - Success**:
```json
{
  "success": true,
  "sectionId": "section_2_goals",
  "status": "in_progress",
  "savedAt": "2025-01-26T11:01:31Z",
  "resumePoint": {
    "nextQuestionId": "Q7",
    "sectionProgress": "66%"
  }
}
```

**Key Differences from Section Save**:
- Does NOT require all required questions answered
- Stores `lastQuestionId` for resume point calculation
- Always sets `status=in_progress`
- Calculates and returns `resumePoint`

**Error Responses**: Same as section save endpoint

---

### 3.6 User Responses Retrieval

#### `GET /api/users/{userId}/responses`
**Purpose**: Retrieve all existing responses for resume detection

**Authentication**: Required

**Path Parameters**:
- `userId` (string): User identifier

**Query Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| questionnaireId | string | Yes | Filter by questionnaire |

**Request Headers**:
```http
Authorization: Bearer <jwt_token>
```

**Response 200 - Success** (with partial progress):
```json
{
  "userId": "user_12345",
  "questionnaireId": "nutrition_onboarding_v1",
  "sectionResponses": [
    {
      "sectionId": "section_1_personal_info",
      "status": "completed",
      "completedAt": "2025-01-26T10:35:00Z",
      "responses": [
        {
          "questionId": "Q1",
          "value": "Sarah Johnson",
          "timestamp": "2025-01-26T10:30:00Z"
        }
      ]
    },
    {
      "sectionId": "section_2_goals",
      "status": "in_progress",
      "completedAt": null,
      "responses": [
        {
          "questionId": "Q5",
          "value": "Lose weight",
          "timestamp": "2025-01-26T11:00:00Z"
        }
      ],
      "lastQuestionId": "Q6"
    }
  ],
  "resumePoint": {
    "sectionId": "section_2_goals",
    "questionId": "Q7",
    "overallProgress": "40%"
  },
  "isSubmitted": false,
  "lastUpdated": "2025-01-26T11:01:30Z"
}
```

**Response 200 - Success** (no data):
```json
{
  "userId": "user_12345",
  "questionnaireId": "nutrition_onboarding_v1",
  "sectionResponses": [],
  "resumePoint": null,
  "isSubmitted": false,
  "lastUpdated": null
}
```

**Response Fields**:
| Field | Type | Description |
|-------|------|-------------|
| userId | string | User identifier |
| questionnaireId | string | Questionnaire identifier |
| sectionResponses | SectionResponse[] | All saved section data |
| resumePoint | object \| null | Where to resume (null if not started) |
| isSubmitted | boolean | Whether final submission completed |
| lastUpdated | string(ISO8601) | Last modification timestamp |

**Resume Point Calculation**:
- If no sections started: `null`
- If sections in progress: next unanswered question in current section
- If all sections completed but not submitted: review screen
- If submitted: completion screen

**Error Responses**:
- `401 Unauthorized`: Invalid authentication
- `403 Forbidden`: User cannot access this data
- `404 Not Found`: User or questionnaire not found
- `500 Internal Server Error`: Server error

---

### 3.7 Final Questionnaire Submission

#### `POST /api/questionnaires/{questionnaireId}/submit`
**Purpose**: Submit completed questionnaire for nutritionist review

**Authentication**: Required

**Path Parameters**:
- `questionnaireId` (string): Questionnaire ID

**Request Headers**:
```http
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

**Request Body**:
```json
{
  "userId": "user_12345",
  "sectionResponses": [
    {
      "sectionId": "section_1_personal_info",
      "responses": [
        {"questionId": "Q1", "value": "Sarah Johnson", "timestamp": "..."},
        {"questionId": "Q2", "value": 32, "timestamp": "..."}
      ],
      "status": "completed",
      "completedAt": "2025-01-26T10:35:00Z"
    },
    {
      "sectionId": "section_2_goals",
      "responses": [...],
      "status": "completed",
      "completedAt": "2025-01-26T10:40:00Z"
    },
    {
      "sectionId": "section_3_health",
      "responses": [...],
      "status": "completed",
      "completedAt": "2025-01-26T10:50:00Z"
    },
    {
      "sectionId": "section_4_lifestyle",
      "responses": [...],
      "status": "completed",
      "completedAt": "2025-01-26T11:00:00Z"
    }
  ],
  "submittedAt": "2025-01-26T11:15:00Z"
}
```

**Validation Requirements**:
1. All sections (4) must be present
2. All sections must have `status=completed`
3. All required questions in all sections must be answered
4. All response values must pass validation
5. User must not have already submitted this questionnaire

**Response 200 - Success**:
```json
{
  "success": true,
  "submissionId": "sub_abc123def456",
  "submittedAt": "2025-01-26T11:15:01Z",
  "message": "Questionnaire submitted successfully",
  "nextSteps": {
    "nutritionistName": "Dr. Sarah Johnson",
    "expectedResponseTime": "24-48 hours",
    "confirmationEmail": "sarah@example.com"
  }
}
```

**Response 400 - Validation Error**:
```json
{
  "success": false,
  "error": "Incomplete questionnaire",
  "details": {
    "missingSections": [],
    "incompleteSections": ["section_3_health"],
    "validationErrors": {
      "section_2_goals": {
        "Q6": "Required question not answered"
      }
    }
  }
}
```

**Response 409 - Already Submitted**:
```json
{
  "success": false,
  "error": "Questionnaire already submitted",
  "existingSubmissionId": "sub_xyz789",
  "submittedAt": "2025-01-25T14:30:00Z"
}
```

**Side Effects**:
1. Creates `questionnaire_submissions` record
2. Updates all `section_responses` to `status=submitted`
3. Generates unique `submissionId`
4. Triggers notification to nutritionist (email/SMS/dashboard)
5. May trigger downstream workflows (analytics, CRM integration, etc.)

**Idempotency**:
- If exact same request replayed: returns same `submissionId` with 200
- If different data for already-submitted questionnaire: returns 409 Conflict

**Error Responses**:
- `400 Bad Request`: Incomplete or invalid data
- `401 Unauthorized`: Invalid authentication
- `403 Forbidden`: User not authorized
- `404 Not Found`: Questionnaire not found
- `409 Conflict`: Already submitted
- `500 Internal Server Error`: Server error

---

### 3.8 Delete User Responses (Start Fresh)

#### `DELETE /api/users/{userId}/responses`
**Purpose**: Clear all responses for fresh start

**Authentication**: Required

**Path Parameters**:
- `userId` (string): User identifier

**Query Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| questionnaireId | string | Yes | Which questionnaire to clear |

**Request Headers**:
```http
Authorization: Bearer <jwt_token>
```

**Response 200 - Success**:
```json
{
  "success": true,
  "message": "All responses deleted",
  "deletedSections": 3,
  "deletedResponses": 15
}
```

**Response 403 - Cannot Delete Submitted**:
```json
{
  "success": false,
  "error": "Cannot delete submitted questionnaire",
  "submissionId": "sub_abc123"
}
```

**Behavior**:
- Deletes all `section_responses` for user + questionnaire
- Does NOT delete final submission if already submitted
- Idempotent - returns success even if no data exists

**Error Responses**:
- `401 Unauthorized`: Invalid authentication
- `403 Forbidden`: Cannot delete submitted data or unauthorized
- `500 Internal Server Error`: Server error

---

## 4. Database Data Models

### 4.1 Entity Relationship Diagram

```
┌─────────────────────────────────┐
│         clinics                 │
├─────────────────────────────────┤
│ id (PK)                         │
│ name                            │
│ logo_url                        │
│ primary_color                   │
│ secondary_color                 │
│ created_at                      │
│ updated_at                      │
└──────────┬──────────────────────┘
           │
           │ 1:N
           │
┌──────────▼──────────────────────┐
│      nutritionists              │
├─────────────────────────────────┤
│ id (PK)                         │
│ clinic_id (FK)                  │
│ name                            │
│ email                           │
│ photo_url                       │
│ created_at                      │
│ updated_at                      │
└──────────┬──────────────────────┘
           │
           │ 1:N
           │
┌──────────▼──────────────────────┐       ┌─────────────────────────────┐
│         users                   │       │     questionnaires          │
├─────────────────────────────────┤       ├─────────────────────────────┤
│ id (PK)                         │       │ id (PK)                     │
│ email                           │       │ title                       │
│ full_name                       │       │ version                     │
│ nutritionist_id (FK)            │       │ estimated_minutes           │
│ created_at                      │       │ is_active                   │
│ updated_at                      │       │ created_at                  │
└──────────┬──────────────────────┘       │ updated_at                  │
           │                              └──────────┬──────────────────┘
           │                                         │
           │                                         │ 1:N
           │                                         │
           │                              ┌──────────▼──────────────────┐
           │                              │    questionnaire_sections   │
           │                              ├─────────────────────────────┤
           │                              │ id (PK)                     │
           │                              │ questionnaire_id (FK)       │
           │                              │ section_id                  │
           │                              │ title                       │
           │                              │ description                 │
           │                              │ order_index                 │
           │                              │ estimated_minutes           │
           │                              │ completion_message          │
           │                              └──────────┬──────────────────┘
           │                                         │
           │                                         │ 1:N
           │                                         │
           │                              ┌──────────▼──────────────────┐
           │                              │   questionnaire_questions   │
           │                              ├─────────────────────────────┤
           │                              │ id (PK)                     │
           │                              │ section_id (FK)             │
           │                              │ question_id                 │
           │                              │ question_text               │
           │                              │ input_type                  │
           │                              │ required                    │
           │                              │ order_index                 │
           │                              │ validation_rules (JSON)     │
           │                              │ options (JSON)              │
           │                              │ conditional_logic (JSON)    │
           │                              │ placeholder                 │
           │                              └─────────────────────────────┘
           │
           │ N:M (via section_responses)
           │
           │                              ┌─────────────────────────────┐
           └─────────────────────────────►│    section_responses        │
                                          ├─────────────────────────────┤
                                          │ id (PK)                     │
                                          │ user_id (FK)                │
                                          │ questionnaire_id (FK)       │
                                          │ section_id                  │
                                          │ status                      │
                                          │ responses (JSONB)           │
                                          │ last_question_id            │
                                          │ completed_at                │
                                          │ created_at                  │
                                          │ updated_at                  │
                                          │ version                     │
                                          └──────────┬──────────────────┘
                                                     │
                                                     │ N:1 (rollup)
                                                     │
                                          ┌──────────▼──────────────────┐
                                          │ questionnaire_submissions   │
                                          ├─────────────────────────────┤
                                          │ id (PK)                     │
                                          │ user_id (FK)                │
                                          │ questionnaire_id (FK)       │
                                          │ submission_id (UNIQUE)      │
                                          │ section_responses_snapshot  │
                                          │   (JSONB)                   │
                                          │ submitted_at                │
                                          │ created_at                  │
                                          └─────────────────────────────┘
```

---

### 4.2 Table Specifications

#### 4.2.1 `clinics`
**Purpose**: Multi-tenant clinic/organization data

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Unique clinic identifier |
| name | VARCHAR(255) | NOT NULL | Clinic display name |
| logo_url | TEXT | NULL | Logo image URL |
| primary_color | VARCHAR(7) | NOT NULL | Primary brand color (hex) |
| secondary_color | VARCHAR(7) | NOT NULL | Secondary brand color (hex) |
| support_email | VARCHAR(255) | NOT NULL | Support contact email |
| support_phone | VARCHAR(50) | NULL | Support phone number |
| created_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | Record creation timestamp |
| updated_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | Last update timestamp |

**Indexes**:
- Primary key on `id`
- Index on `name` for search

**Sample Data**:
```sql
INSERT INTO clinics (id, name, logo_url, primary_color, secondary_color, support_email)
VALUES (
  'clinic_001',
  'HealthFirst Nutrition',
  'https://cdn.example.com/logos/healthfirst.png',
  '#2E7D32',
  '#81C784',
  'support@healthfirst.com'
);
```

---

#### 4.2.2 `nutritionists`
**Purpose**: Nutritionist profiles for personalization

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Unique nutritionist ID |
| clinic_id | UUID | NOT NULL, FOREIGN KEY | Reference to clinic |
| name | VARCHAR(255) | NOT NULL | Nutritionist display name |
| email | VARCHAR(255) | NOT NULL, UNIQUE | Contact email |
| photo_url | TEXT | NULL | Profile photo URL |
| is_active | BOOLEAN | NOT NULL, DEFAULT TRUE | Account active status |
| created_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | Record creation |
| updated_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | Last update |

**Indexes**:
- Primary key on `id`
- Foreign key index on `clinic_id`
- Unique index on `email`

**Relationships**:
- `clinic_id` → `clinics.id` (ON DELETE CASCADE)

---

#### 4.2.3 `users`
**Purpose**: Client/patient records

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Unique user identifier |
| email | VARCHAR(255) | NOT NULL, UNIQUE | User email (auth) |
| full_name | VARCHAR(255) | NULL | Full name from questionnaire |
| nutritionist_id | UUID | NOT NULL, FOREIGN KEY | Assigned nutritionist |
| is_active | BOOLEAN | NOT NULL, DEFAULT TRUE | Account status |
| created_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | Account creation |
| updated_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | Last update |

**Indexes**:
- Primary key on `id`
- Unique index on `email`
- Foreign key index on `nutritionist_id`

**Relationships**:
- `nutritionist_id` → `nutritionists.id` (ON DELETE RESTRICT)

---

#### 4.2.4 `questionnaires`
**Purpose**: Questionnaire templates/versions

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | VARCHAR(100) | PRIMARY KEY | Questionnaire identifier |
| title | VARCHAR(255) | NOT NULL | Display title |
| version | VARCHAR(20) | NOT NULL | Version string (e.g., "1.0") |
| estimated_minutes | INTEGER | NOT NULL | Total time estimate |
| is_active | BOOLEAN | NOT NULL, DEFAULT TRUE | Active for new users |
| created_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | Created timestamp |
| updated_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | Last update |

**Indexes**:
- Primary key on `id`
- Index on `is_active` for filtering

**Sample Data**:
```sql
INSERT INTO questionnaires (id, title, version, estimated_minutes, is_active)
VALUES (
  'nutrition_onboarding_v1',
  'Nutrition Plan Questionnaire',
  '1.0',
  10,
  TRUE
);
```

---

#### 4.2.5 `questionnaire_sections`
**Purpose**: Questionnaire sections (categories)

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Unique section record ID |
| questionnaire_id | VARCHAR(100) | NOT NULL, FOREIGN KEY | Parent questionnaire |
| section_id | VARCHAR(100) | NOT NULL | Section identifier (e.g., section_1_personal_info) |
| title | VARCHAR(255) | NOT NULL | Section display title |
| description | TEXT | NULL | Section description |
| order_index | INTEGER | NOT NULL | Display order (1-based) |
| estimated_minutes | INTEGER | NOT NULL | Section time estimate |
| completion_message | TEXT | NOT NULL | Message on completion |
| created_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | Created timestamp |
| updated_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | Last update |

**Indexes**:
- Primary key on `id`
- Foreign key index on `questionnaire_id`
- Unique composite index on `(questionnaire_id, section_id)`
- Index on `(questionnaire_id, order_index)` for sorting

**Relationships**:
- `questionnaire_id` → `questionnaires.id` (ON DELETE CASCADE)

**Sample Data**:
```sql
INSERT INTO questionnaire_sections
  (questionnaire_id, section_id, title, description, order_index, estimated_minutes, completion_message)
VALUES
  ('nutrition_onboarding_v1', 'section_1_personal_info', 'Personal Info',
   'Basic information to personalize your plan', 1, 2,
   'Great! Personal info complete ✅'),
  ('nutrition_onboarding_v1', 'section_2_goals', 'Your Goals',
   'What you want to achieve', 2, 2,
   'Love your motivation! 💪');
```

---

#### 4.2.6 `questionnaire_questions`
**Purpose**: Individual questions within sections

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Unique question record ID |
| section_id | UUID | NOT NULL, FOREIGN KEY | Parent section |
| question_id | VARCHAR(50) | NOT NULL | Question identifier (e.g., Q1, Q2) |
| question_text | TEXT | NOT NULL | Question prompt |
| input_type | VARCHAR(50) | NOT NULL | Input type enum |
| required | BOOLEAN | NOT NULL, DEFAULT FALSE | Answer required |
| order_index | INTEGER | NOT NULL | Display order in section |
| validation_rules | JSONB | NULL | Validation configuration |
| options | JSONB | NULL | Options for select types |
| conditional_logic | JSONB | NULL | Conditional display rules |
| placeholder | TEXT | NULL | Input placeholder text |
| created_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | Created timestamp |
| updated_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | Last update |

**Indexes**:
- Primary key on `id`
- Foreign key index on `section_id`
- Unique composite index on `(section_id, question_id)`
- Index on `(section_id, order_index)` for sorting

**Relationships**:
- `section_id` → `questionnaire_sections.id` (ON DELETE CASCADE)

**JSONB Field Schemas**:

**validation_rules** (varies by input_type):
```json
// text_input / text_area
{
  "minLength": 2,
  "maxLength": 100,
  "pattern": "^[A-Za-z\\s]+$"  // optional regex
}

// number_input
{
  "min": 18,
  "max": 100,
  "integer": true,
  "step": 1
}
```

**options** (for select types or units):
```json
["Lose weight", "Gain weight", "Build muscle", "Other"]
// or for units
["kg", "lbs"]
```

**conditional_logic**:
```json
{
  "showIf": {
    "questionId": "Q5",
    "operator": "equals",
    "value": "Lose weight"
  }
}
```

**Sample Data**:
```sql
INSERT INTO questionnaire_questions
  (section_id, question_id, question_text, input_type, required, order_index, validation_rules, placeholder)
VALUES
  ('<section_1_uuid>', 'Q1', 'What''s your full name?', 'text_input', TRUE, 1,
   '{"minLength": 2, "maxLength": 100}', 'Enter your full name'),
  ('<section_1_uuid>', 'Q2', 'How old are you?', 'number_input', TRUE, 2,
   '{"min": 18, "max": 100, "integer": true}', 'Age');
```

---

#### 4.2.7 `section_responses`
**Purpose**: Store user responses per section (working data)

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Unique response record ID |
| user_id | UUID | NOT NULL, FOREIGN KEY | User who answered |
| questionnaire_id | VARCHAR(100) | NOT NULL, FOREIGN KEY | Which questionnaire |
| section_id | VARCHAR(100) | NOT NULL | Which section |
| status | VARCHAR(20) | NOT NULL | not_started, in_progress, completed, submitted |
| responses | JSONB | NOT NULL | Array of question responses |
| last_question_id | VARCHAR(50) | NULL | Last answered question (for resume) |
| completed_at | TIMESTAMP | NULL | When section completed |
| created_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | First save timestamp |
| updated_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | Last update timestamp |
| version | INTEGER | NOT NULL, DEFAULT 1 | Optimistic locking version |

**Indexes**:
- Primary key on `id`
- **Unique composite** index on `(user_id, questionnaire_id, section_id)` for idempotency
- Foreign key index on `user_id`
- Foreign key index on `questionnaire_id`
- Index on `status` for filtering
- Index on `(user_id, questionnaire_id, updated_at DESC)` for resume queries

**Relationships**:
- `user_id` → `users.id` (ON DELETE CASCADE)
- `questionnaire_id` → `questionnaires.id` (ON DELETE CASCADE)

**JSONB Schema for `responses`**:
```json
[
  {
    "questionId": "Q1",
    "value": "Sarah Johnson",
    "timestamp": "2025-01-26T10:30:00Z"
  },
  {
    "questionId": "Q2",
    "value": 32,
    "timestamp": "2025-01-26T10:30:15Z"
  },
  {
    "questionId": "Q3",
    "value": {
      "amount": 68,
      "unit": "kg"
    },
    "timestamp": "2025-01-26T10:30:30Z"
  }
]
```

**Status Enum Values**:
- `not_started`: Section exists but no responses yet
- `in_progress`: Partial responses saved
- `completed`: All required questions answered
- `submitted`: Part of final submission (immutable)

**Sample Query** (get all responses for resume):
```sql
SELECT
  section_id,
  status,
  responses,
  last_question_id,
  completed_at
FROM section_responses
WHERE user_id = $1
  AND questionnaire_id = $2
ORDER BY created_at ASC;
```

---

#### 4.2.8 `questionnaire_submissions`
**Purpose**: Immutable record of final submissions

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Unique submission record ID |
| user_id | UUID | NOT NULL, FOREIGN KEY | User who submitted |
| questionnaire_id | VARCHAR(100) | NOT NULL, FOREIGN KEY | Which questionnaire |
| submission_id | VARCHAR(100) | NOT NULL, UNIQUE | Public submission identifier |
| section_responses_snapshot | JSONB | NOT NULL | Complete snapshot of all responses |
| submitted_at | TIMESTAMP | NOT NULL | Submission timestamp |
| created_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | Record creation |

**Indexes**:
- Primary key on `id`
- **Unique** index on `submission_id` for lookups
- **Unique composite** index on `(user_id, questionnaire_id)` to prevent duplicate submissions
- Foreign key index on `user_id`
- Foreign key index on `questionnaire_id`
- Index on `submitted_at DESC` for recent submissions

**Relationships**:
- `user_id` → `users.id` (ON DELETE RESTRICT - don't delete submitted data)
- `questionnaire_id` → `questionnaires.id` (ON DELETE RESTRICT)

**JSONB Schema for `section_responses_snapshot`**:
```json
{
  "sections": [
    {
      "sectionId": "section_1_personal_info",
      "status": "completed",
      "completedAt": "2025-01-26T10:35:00Z",
      "responses": [
        {"questionId": "Q1", "value": "Sarah Johnson", "timestamp": "..."},
        {"questionId": "Q2", "value": 32, "timestamp": "..."}
      ]
    },
    {
      "sectionId": "section_2_goals",
      "status": "completed",
      "completedAt": "2025-01-26T10:40:00Z",
      "responses": [...]
    }
  ],
  "metadata": {
    "appVersion": "1.0.0",
    "deviceType": "mobile",
    "completionTime": "15 minutes"
  }
}
```

**Sample Query** (check if user already submitted):
```sql
SELECT submission_id, submitted_at
FROM questionnaire_submissions
WHERE user_id = $1
  AND questionnaire_id = $2
LIMIT 1;
```

---

### 4.3 Database Constraints & Business Rules

#### 4.3.1 Unique Constraints
| Table | Constraint | Purpose |
|-------|-----------|----------|
| section_responses | (user_id, questionnaire_id, section_id) | One response set per user per section |
| questionnaire_submissions | (user_id, questionnaire_id) | One submission per user per questionnaire |
| questionnaire_submissions | submission_id | Unique public submission ID |
| questionnaire_sections | (questionnaire_id, section_id) | Section IDs unique within questionnaire |
| questionnaire_questions | (section_id, question_id) | Question IDs unique within section |

#### 4.3.2 Foreign Key Cascade Rules
| Parent → Child | ON DELETE | Rationale |
|----------------|-----------|-----------|
| clinics → nutritionists | CASCADE | Delete all nutritionists when clinic closes |
| nutritionists → users | RESTRICT | Don't delete nutritionist with active clients |
| questionnaires → sections | CASCADE | Delete sections when questionnaire removed |
| sections → questions | CASCADE | Delete questions when section removed |
| users → section_responses | CASCADE | Delete user's working responses with account |
| users → submissions | RESTRICT | **Never delete submitted data** |
| questionnaires → submissions | RESTRICT | **Never delete submitted data** |

#### 4.3.3 Check Constraints
```sql
-- Status must be valid enum value
ALTER TABLE section_responses
ADD CONSTRAINT valid_status
CHECK (status IN ('not_started', 'in_progress', 'completed', 'submitted'));

-- Order index must be positive
ALTER TABLE questionnaire_sections
ADD CONSTRAINT positive_order
CHECK (order_index > 0);

-- Estimated minutes must be reasonable
ALTER TABLE questionnaires
ADD CONSTRAINT reasonable_time
CHECK (estimated_minutes BETWEEN 1 AND 120);

-- Completed sections must have completion timestamp
ALTER TABLE section_responses
ADD CONSTRAINT completed_has_timestamp
CHECK (
  (status IN ('not_started', 'in_progress')) OR
  (status IN ('completed', 'submitted') AND completed_at IS NOT NULL)
);
```

---

### 4.4 Indexes for Performance

#### 4.4.1 Query Pattern Analysis
| Query Pattern | Frequency | Indexes Needed |
|---------------|-----------|----------------|
| Get user's responses for questionnaire | High (every app launch) | (user_id, questionnaire_id) |
| Load questionnaire config | Medium (once per session) | questionnaire_id |
| Get sections in order | Medium | (questionnaire_id, order_index) |
| Get questions in order | Medium | (section_id, order_index) |
| Check existing submission | High (before final submit) | (user_id, questionnaire_id) on submissions |
| Get recent submissions for nutritionist | Medium | (questionnaire_id, submitted_at DESC) |

#### 4.4.2 Recommended Indexes
```sql
-- section_responses (most critical for resume)
CREATE INDEX idx_section_responses_user_questionnaire
ON section_responses(user_id, questionnaire_id, updated_at DESC);

CREATE INDEX idx_section_responses_status
ON section_responses(status)
WHERE status != 'submitted';  -- Partial index for active responses

-- questionnaire_submissions (prevent duplicates, lookup)
CREATE UNIQUE INDEX idx_submissions_user_questionnaire
ON questionnaire_submissions(user_id, questionnaire_id);

CREATE INDEX idx_submissions_recent
ON questionnaire_submissions(submitted_at DESC);

-- questionnaire_sections (ordered retrieval)
CREATE INDEX idx_sections_questionnaire_order
ON questionnaire_sections(questionnaire_id, order_index);

-- questionnaire_questions (ordered retrieval)
CREATE INDEX idx_questions_section_order
ON questionnaire_questions(section_id, order_index);

-- JSONB indexing for response queries (optional, for advanced analytics)
CREATE INDEX idx_section_responses_data
ON section_responses USING GIN (responses);
```

---

### 4.5 Data Retention & Archival

#### 4.5.1 Retention Policies
| Data Type | Retention Period | Archive Strategy |
|-----------|------------------|------------------|
| Active section_responses | Until submitted or 90 days inactive | Delete or archive after 90 days |
| Questionnaire submissions | Indefinite (legal/medical record) | Never delete, archive to cold storage after 2 years |
| User accounts | While active + 7 years post-deletion | Soft delete, hard delete after 7 years |
| Questionnaire configs | Version history indefinite | Keep all versions for audit trail |

#### 4.5.2 Archival SQL
```sql
-- Archive old incomplete responses (cleanup job)
DELETE FROM section_responses
WHERE status IN ('not_started', 'in_progress')
  AND updated_at < NOW() - INTERVAL '90 days'
  AND user_id NOT IN (
    SELECT DISTINCT user_id
    FROM questionnaire_submissions
    WHERE submitted_at > NOW() - INTERVAL '90 days'
  );

-- Archive old submissions to cold storage table
INSERT INTO questionnaire_submissions_archive
SELECT * FROM questionnaire_submissions
WHERE submitted_at < NOW() - INTERVAL '2 years';

-- Then optionally delete from hot table (if cold storage verified)
DELETE FROM questionnaire_submissions
WHERE submitted_at < NOW() - INTERVAL '2 years';
```

---

## 5. Security & Authentication

### 5.1 Authentication Strategy

#### 5.1.1 JWT Token-Based Authentication
**Token Format**:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Token Payload**:
```json
{
  "sub": "user_12345",           // Subject (user ID)
  "email": "sarah@example.com",  // User email
  "nutritionistId": "nutr_789",  // Assigned nutritionist
  "clinicId": "clinic_001",      // Clinic context
  "role": "client",              // User role
  "iat": 1706270400,             // Issued at
  "exp": 1706356800              // Expires (24 hours)
}
```

**Token Validation**:
1. Verify signature with secret key
2. Check expiration (`exp` claim)
3. Validate `sub` (user ID) exists in database
4. Ensure user `is_active = true`

#### 5.1.2 Token Refresh Flow
```
Client stores:
- Access Token (short-lived, 1 hour)
- Refresh Token (long-lived, 7 days)

On 401 Unauthorized:
1. POST /api/auth/refresh with refresh_token
2. Receive new access_token + refresh_token
3. Retry original request with new token
4. If refresh fails → redirect to login
```

---

### 5.2 Authorization Rules

#### 5.2.1 Resource Access Control
| Endpoint | Authorization Check |
|----------|---------------------|
| GET /api/branding/config | User must belong to clinic |
| GET /api/questionnaires/{id} | Questionnaire must be active |
| POST /api/.../responses | `userId` in request must match token `sub` |
| PUT /api/.../responses/{qId} | User must own the response |
| GET /api/users/{userId}/responses | `userId` must match token `sub` OR nutritionist owns user |
| POST /api/.../submit | User must own all section responses |
| DELETE /api/users/{userId}/responses | `userId` must match token `sub` |

#### 5.2.2 Multi-Tenancy Isolation
**Data Isolation Strategy**:
- All queries filtered by `clinic_id` (derived from user's nutritionist)
- Row-Level Security (RLS) policies in PostgreSQL
- Prevent cross-clinic data leakage

**Example RLS Policy**:
```sql
-- Ensure users can only access their own clinic's data
CREATE POLICY user_clinic_isolation ON users
FOR ALL
USING (
  nutritionist_id IN (
    SELECT id FROM nutritionists
    WHERE clinic_id = current_setting('app.current_clinic_id')::UUID
  )
);

-- Set clinic context per request
SET app.current_clinic_id = '<clinic_id_from_token>';
```

---

### 5.3 Data Protection

#### 5.3.1 Sensitive Data Handling
| Data Type | Protection Method |
|-----------|-------------------|
| User emails | Indexed but not exposed in logs |
| Health conditions (responses) | Encrypted at rest (database-level) |
| Authentication tokens | HTTPS only, httpOnly cookies for refresh tokens |
| API keys | Hashed in database, never logged |

#### 5.3.2 HTTPS/TLS Requirements
- **All API communication**: TLS 1.2+ required
- **Certificate pinning**: Recommended for mobile app
- **HSTS header**: `Strict-Transport-Security: max-age=31536000; includeSubDomains`

#### 5.3.3 Input Validation & Sanitization
**Server-Side Validation** (never trust client):
1. **Type validation**: Ensure data types match schema
2. **Range validation**: Numbers within expected ranges
3. **Length validation**: Strings within max lengths
4. **Format validation**: Regex for emails, phone numbers
5. **SQL injection prevention**: Parameterized queries only
6. **XSS prevention**: Sanitize any user-generated content returned in errors

**Example Validation Middleware**:
```javascript
// Express.js example
const { body, validationResult } = require('express-validator');

router.post('/api/questionnaires/:qId/sections/:sectionId/responses', [
  body('userId').isUUID(),
  body('responses').isArray({ min: 1 }),
  body('responses.*.questionId').isString().trim().notEmpty(),
  body('responses.*.value').exists(),
  body('responses.*.timestamp').isISO8601(),
  body('status').isIn(['in_progress', 'completed']),
], (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  // Process request...
});
```

---

### 5.4 Rate Limiting & Abuse Prevention

#### 5.4.1 Rate Limit Rules
| Endpoint Pattern | Limit | Window | Throttle Response |
|------------------|-------|--------|-------------------|
| GET /api/branding/config | 10 req/min | Per user | 429 Too Many Requests |
| GET /api/questionnaires/* | 20 req/min | Per user | 429 + Retry-After header |
| POST /api/.../responses | 60 req/hour | Per user | 429 |
| POST /api/.../submit | 5 req/hour | Per user | 429 (prevent spam) |
| DELETE /api/users/*/responses | 5 req/hour | Per user | 429 |

#### 5.4.2 DDoS Protection
- **API Gateway**: Use AWS API Gateway, Cloudflare, or similar
- **Request Throttling**: Exponential backoff on client side
- **IP Blacklisting**: Block malicious IPs at network edge

---

## 6. Error Handling & Response Codes

### 6.1 HTTP Status Code Usage

| Status Code | Meaning | When to Use |
|-------------|---------|-------------|
| **200 OK** | Success | Successful GET, PUT, DELETE operations |
| **201 Created** | Resource created | Successful POST creating new resource (optional, can use 200) |
| **400 Bad Request** | Client error | Validation failures, malformed JSON, missing required fields |
| **401 Unauthorized** | Authentication failed | Invalid/missing token, expired token |
| **403 Forbidden** | Authorization failed | Valid token but user lacks permission for resource |
| **404 Not Found** | Resource not found | Questionnaire, section, user, etc. doesn't exist |
| **409 Conflict** | State conflict | Already submitted, concurrent edit conflict |
| **422 Unprocessable Entity** | Business logic error | Valid format but violates business rules |
| **429 Too Many Requests** | Rate limit exceeded | User exceeded rate limits |
| **500 Internal Server Error** | Server error | Unexpected server failures |
| **503 Service Unavailable** | Temporary outage | Database down, maintenance mode |

---

### 6.2 Error Response Format

#### 6.2.1 Standard Error Structure
**All error responses** follow this format:
```json
{
  "success": false,
  "error": "Human-readable error message",
  "errorCode": "VALIDATION_ERROR",  // Machine-readable code
  "details": {  // Optional, context-specific
    "field": "error detail"
  },
  "timestamp": "2025-01-26T12:00:00Z",
  "path": "/api/questionnaires/xyz/submit",
  "requestId": "req_abc123"  // For support debugging
}
```

#### 6.2.2 Error Code Taxonomy
| Error Code | HTTP Status | Description |
|------------|-------------|-------------|
| VALIDATION_ERROR | 400 | Input validation failed |
| MISSING_REQUIRED_FIELD | 400 | Required field not provided |
| INVALID_FORMAT | 400 | Data format incorrect |
| UNAUTHORIZED | 401 | Authentication required or failed |
| FORBIDDEN | 403 | User lacks permission |
| RESOURCE_NOT_FOUND | 404 | Requested resource doesn't exist |
| ALREADY_SUBMITTED | 409 | Questionnaire already submitted |
| CONCURRENT_MODIFICATION | 409 | Optimistic lock conflict |
| INCOMPLETE_QUESTIONNAIRE | 422 | Business rule: questionnaire not complete |
| RATE_LIMIT_EXCEEDED | 429 | Too many requests |
| INTERNAL_ERROR | 500 | Unexpected server error |
| SERVICE_UNAVAILABLE | 503 | Temporary service outage |

#### 6.2.3 Validation Error Details
For `400 Bad Request` validation errors, include field-level details:
```json
{
  "success": false,
  "error": "Validation failed",
  "errorCode": "VALIDATION_ERROR",
  "details": {
    "Q2": "Value must be between 18 and 100",
    "Q3": "Unit 'pounds' is not a valid option (expected: kg, lbs)",
    "responses": "Array must contain at least 1 element"
  },
  "timestamp": "2025-01-26T12:00:00Z",
  "path": "/api/questionnaires/nutrition_onboarding_v1/sections/section_1/responses",
  "requestId": "req_abc123"
}
```

---

### 6.3 Client Error Handling Guidelines

#### 6.3.1 Recommended Client Behavior
| Error Type | Client Action |
|------------|---------------|
| 400 Validation Error | Show inline field errors, allow correction |
| 401 Unauthorized | Attempt token refresh, then redirect to login |
| 403 Forbidden | Show "Access Denied" message, contact support |
| 404 Not Found | Show "Not Found" message, navigate back |
| 409 Conflict (concurrent edit) | Show current value, ask user to refresh |
| 409 Conflict (already submitted) | Navigate to completion screen |
| 422 Incomplete Questionnaire | Highlight missing sections, block submission |
| 429 Rate Limit | Show "Please slow down" message, auto-retry after delay |
| 500/503 Server Error | Show "Something went wrong", offer retry button |

#### 6.3.2 Retry Strategy
**Exponential Backoff for Network Errors**:
```javascript
async function fetchWithRetry(url, options, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const response = await fetch(url, options);
      if (response.ok || response.status < 500) {
        return response;  // Success or client error (don't retry)
      }
      // Server error (5xx) - retry
    } catch (networkError) {
      // Network failure - retry
    }

    // Wait before retry: 2^i seconds (1s, 2s, 4s...)
    if (i < maxRetries - 1) {
      await new Promise(resolve => setTimeout(resolve, Math.pow(2, i) * 1000));
    }
  }
  throw new Error('Max retries exceeded');
}
```

**Don't Retry**:
- 400 Bad Request (fix input first)
- 401 Unauthorized (get new token first)
- 403 Forbidden (permission issue, not transient)
- 404 Not Found (won't exist on retry)
- 409 Conflict (user must resolve)
- 422 Unprocessable Entity (business logic, not transient)

**Do Retry**:
- Network failures (timeout, DNS errors)
- 500 Internal Server Error
- 503 Service Unavailable
- 429 Too Many Requests (with backoff)

---

## 7. Performance Requirements

### 7.1 Response Time Targets

| Endpoint | P50 | P95 | P99 | Notes |
|----------|-----|-----|-----|-------|
| GET /api/branding/config | <100ms | <200ms | <300ms | Cacheable, should be fast |
| GET /api/questionnaires/{id} | <150ms | <300ms | <500ms | Larger payload, cache aggressively |
| POST /api/.../responses | <200ms | <400ms | <600ms | Database write, validation |
| PUT /api/.../responses/{qId} | <150ms | <300ms | <500ms | Single row update |
| GET /api/users/{userId}/responses | <200ms | <400ms | <600ms | Complex query, joins |
| POST /api/.../submit | <300ms | <600ms | <1s | Final submission, may trigger workflows |

**Monitoring**: Track P50, P95, P99 response times, alert if P95 > target

---

### 7.2 Throughput Requirements

| Metric | Target | Justification |
|--------|--------|---------------|
| Concurrent Users | 1,000 | Initial scale, 100 clinics × 10 concurrent users |
| Requests per Second (RPS) | 500 RPS | Average 0.5 req/sec per user |
| Peak RPS | 2,000 RPS | 4x peak for lunch/evening hours |
| Database Connections | 50-100 | Connection pooling, 1-2 per API server instance |

**Scaling Strategy**:
- **Horizontal**: Add API server instances behind load balancer
- **Database**: Read replicas for GET requests, write to primary
- **Caching**: Redis/Memcached for questionnaire configs, branding

---

### 7.3 Caching Strategy

#### 7.3.1 Cache Layers
| Data Type | Cache Layer | TTL | Invalidation |
|-----------|-------------|-----|--------------|
| Branding config | CDN + App cache | 1 hour | On branding update |
| Questionnaire config | CDN + App cache | 1 hour | On questionnaire version change |
| Section responses | No cache | - | Real-time data |
| Submissions | No cache | - | Immutable after creation |

#### 7.3.2 HTTP Caching Headers
**Cacheable Resources**:
```http
GET /api/branding/config
Cache-Control: public, max-age=3600  # 1 hour
ETag: "v1-abc123"
Vary: Authorization
```

**Dynamic Resources**:
```http
GET /api/users/{userId}/responses
Cache-Control: no-store, must-revalidate
Pragma: no-cache
```

#### 7.3.3 Application-Level Caching
**Redis Cache Example**:
```javascript
// Cache questionnaire config
const cacheKey = `questionnaire:${questionnaireId}`;
let config = await redis.get(cacheKey);

if (!config) {
  config = await db.getQuestionnaireConfig(questionnaireId);
  await redis.setex(cacheKey, 3600, JSON.stringify(config));  // 1 hour TTL
}

return JSON.parse(config);
```

---

### 7.4 Database Optimization

#### 7.4.1 Query Optimization Checklist
- [ ] All foreign key columns indexed
- [ ] Composite indexes for common query patterns
- [ ] `EXPLAIN ANALYZE` on slow queries (>100ms)
- [ ] Use pagination for large result sets
- [ ] Avoid N+1 queries (use JOINs or batch fetches)
- [ ] JSONB GIN indexes for frequent JSON queries

#### 7.4.2 Connection Pooling
**Recommended Pool Settings** (PostgreSQL):
```javascript
const pool = new Pool({
  max: 20,              // Maximum connections
  min: 5,               // Minimum idle connections
  idleTimeoutMillis: 30000,  // Close idle after 30s
  connectionTimeoutMillis: 5000,  // Fail fast if no connection available
});
```

#### 7.4.3 Read Replicas
**For High Read Volume**:
- **Writes**: Primary database (POST, PUT, DELETE)
- **Reads**: Replica database (GET requests)
- **Replication Lag**: Monitor lag, fallback to primary if >5s

**Query Routing**:
```javascript
// Route reads to replica, writes to primary
const db = req.method === 'GET' ? replicaPool : primaryPool;
const result = await db.query(sql, params);
```

---

## 8. Appendix

### 8.1 Sample API Flows (cURL Examples)

#### 8.1.1 Complete Onboarding Flow
```bash
# 1. Get branding config
curl -X GET https://api.example.com/api/branding/config \
  -H "Authorization: Bearer <token>"

# 2. Get questionnaire structure
curl -X GET https://api.example.com/api/questionnaires/nutrition_onboarding_v1 \
  -H "Authorization: Bearer <token>"

# 3. Check for existing responses (resume detection)
curl -X GET "https://api.example.com/api/users/user_12345/responses?questionnaireId=nutrition_onboarding_v1" \
  -H "Authorization: Bearer <token>"

# 4. Save section 1 responses
curl -X POST https://api.example.com/api/questionnaires/nutrition_onboarding_v1/sections/section_1_personal_info/responses \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "user_12345",
    "responses": [
      {"questionId": "Q1", "value": "Sarah Johnson", "timestamp": "2025-01-26T10:30:00Z"},
      {"questionId": "Q2", "value": 32, "timestamp": "2025-01-26T10:30:15Z"}
    ],
    "status": "completed",
    "completedAt": "2025-01-26T10:35:00Z"
  }'

# 5. Edit a response
curl -X PUT https://api.example.com/api/questionnaires/nutrition_onboarding_v1/sections/section_1_personal_info/responses/Q1 \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "value": "Sarah M. Johnson",
    "timestamp": "2025-01-26T11:00:00Z"
  }'

# 6. Final submission
curl -X POST https://api.example.com/api/questionnaires/nutrition_onboarding_v1/submit \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "user_12345",
    "sectionResponses": [
      {"sectionId": "section_1_personal_info", "responses": [...], "status": "completed"},
      {"sectionId": "section_2_goals", "responses": [...], "status": "completed"},
      {"sectionId": "section_3_health", "responses": [...], "status": "completed"},
      {"sectionId": "section_4_lifestyle", "responses": [...], "status": "completed"}
    ],
    "submittedAt": "2025-01-26T11:15:00Z"
  }'
```

---

### 8.2 OpenAPI 3.0 Specification Excerpt

```yaml
openapi: 3.0.3
info:
  title: NutriApp Client Onboarding API
  version: 1.0.0
  description: Backend API for client questionnaire onboarding

servers:
  - url: https://api.nutriapp.example.com
    description: Production server
  - url: https://staging-api.nutriapp.example.com
    description: Staging server

paths:
  /api/branding/config:
    get:
      summary: Get clinic branding configuration
      tags:
        - Branding
      security:
        - bearerAuth: []
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/BrandingConfig'
        '401':
          $ref: '#/components/responses/Unauthorized'

  /api/questionnaires/{questionnaireId}:
    get:
      summary: Get questionnaire configuration
      tags:
        - Questionnaires
      security:
        - bearerAuth: []
      parameters:
        - name: questionnaireId
          in: path
          required: true
          schema:
            type: string
          example: nutrition_onboarding_v1
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/QuestionnaireConfig'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '404':
          $ref: '#/components/responses/NotFound'

components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

  schemas:
    BrandingConfig:
      type: object
      required:
        - clinicId
        - clinicName
        - primaryColor
        - secondaryColor
        - nutritionistName
        - supportEmail
      properties:
        clinicId:
          type: string
          example: clinic_001
        clinicName:
          type: string
          example: HealthFirst Nutrition
        logoUrl:
          type: string
          format: uri
          example: https://cdn.example.com/logos/healthfirst.png
        primaryColor:
          type: string
          pattern: '^#[0-9A-Fa-f]{6}$'
          example: "#2E7D32"
        # ... additional fields

    QuestionnaireConfig:
      type: object
      required:
        - id
        - title
        - version
        - estimatedMinutes
        - sections
      properties:
        id:
          type: string
          example: nutrition_onboarding_v1
        title:
          type: string
          example: Nutrition Plan Questionnaire
        version:
          type: string
          example: "1.0"
        estimatedMinutes:
          type: integer
          example: 10
        sections:
          type: array
          items:
            $ref: '#/components/schemas/QuestionSection'

    # ... additional schemas

  responses:
    Unauthorized:
      description: Authentication required or invalid token
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'

    NotFound:
      description: Resource not found
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
```

---

### 8.3 Database Migration Scripts

#### 8.3.1 Initial Schema Setup
```sql
-- File: V001__initial_schema.sql

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Clinics table
CREATE TABLE clinics (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  logo_url TEXT,
  primary_color VARCHAR(7) NOT NULL DEFAULT '#2E7D32',
  secondary_color VARCHAR(7) NOT NULL DEFAULT '#81C784',
  support_email VARCHAR(255) NOT NULL,
  support_phone VARCHAR(50),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_clinics_name ON clinics(name);

-- Nutritionists table
CREATE TABLE nutritionists (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  photo_url TEXT,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_nutritionists_clinic ON nutritionists(clinic_id);
CREATE UNIQUE INDEX idx_nutritionists_email ON nutritionists(email);

-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) NOT NULL UNIQUE,
  full_name VARCHAR(255),
  nutritionist_id UUID NOT NULL REFERENCES nutritionists(id) ON DELETE RESTRICT,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_nutritionist ON users(nutritionist_id);

-- Questionnaires table
CREATE TABLE questionnaires (
  id VARCHAR(100) PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  version VARCHAR(20) NOT NULL,
  estimated_minutes INTEGER NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),

  CONSTRAINT reasonable_time CHECK (estimated_minutes BETWEEN 1 AND 120)
);

CREATE INDEX idx_questionnaires_active ON questionnaires(is_active);

-- Questionnaire sections table
CREATE TABLE questionnaire_sections (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  questionnaire_id VARCHAR(100) NOT NULL REFERENCES questionnaires(id) ON DELETE CASCADE,
  section_id VARCHAR(100) NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  order_index INTEGER NOT NULL,
  estimated_minutes INTEGER NOT NULL,
  completion_message TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),

  CONSTRAINT positive_order CHECK (order_index > 0)
);

CREATE INDEX idx_sections_questionnaire ON questionnaire_sections(questionnaire_id);
CREATE UNIQUE INDEX idx_sections_questionnaire_section
  ON questionnaire_sections(questionnaire_id, section_id);
CREATE INDEX idx_sections_order ON questionnaire_sections(questionnaire_id, order_index);

-- Questionnaire questions table
CREATE TABLE questionnaire_questions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  section_id UUID NOT NULL REFERENCES questionnaire_sections(id) ON DELETE CASCADE,
  question_id VARCHAR(50) NOT NULL,
  question_text TEXT NOT NULL,
  input_type VARCHAR(50) NOT NULL,
  required BOOLEAN NOT NULL DEFAULT FALSE,
  order_index INTEGER NOT NULL,
  validation_rules JSONB,
  options JSONB,
  conditional_logic JSONB,
  placeholder TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),

  CONSTRAINT positive_order CHECK (order_index > 0)
);

CREATE INDEX idx_questions_section ON questionnaire_questions(section_id);
CREATE UNIQUE INDEX idx_questions_section_question
  ON questionnaire_questions(section_id, question_id);
CREATE INDEX idx_questions_order ON questionnaire_questions(section_id, order_index);

-- Section responses table
CREATE TABLE section_responses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  questionnaire_id VARCHAR(100) NOT NULL REFERENCES questionnaires(id) ON DELETE CASCADE,
  section_id VARCHAR(100) NOT NULL,
  status VARCHAR(20) NOT NULL,
  responses JSONB NOT NULL,
  last_question_id VARCHAR(50),
  completed_at TIMESTAMP,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  version INTEGER NOT NULL DEFAULT 1,

  CONSTRAINT valid_status CHECK (status IN ('not_started', 'in_progress', 'completed', 'submitted')),
  CONSTRAINT completed_has_timestamp CHECK (
    (status IN ('not_started', 'in_progress')) OR
    (status IN ('completed', 'submitted') AND completed_at IS NOT NULL)
  )
);

CREATE UNIQUE INDEX idx_section_responses_unique
  ON section_responses(user_id, questionnaire_id, section_id);
CREATE INDEX idx_section_responses_user ON section_responses(user_id);
CREATE INDEX idx_section_responses_questionnaire ON section_responses(questionnaire_id);
CREATE INDEX idx_section_responses_status ON section_responses(status)
  WHERE status != 'submitted';
CREATE INDEX idx_section_responses_resume
  ON section_responses(user_id, questionnaire_id, updated_at DESC);
CREATE INDEX idx_section_responses_data ON section_responses USING GIN (responses);

-- Questionnaire submissions table
CREATE TABLE questionnaire_submissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  questionnaire_id VARCHAR(100) NOT NULL REFERENCES questionnaires(id) ON DELETE RESTRICT,
  submission_id VARCHAR(100) NOT NULL UNIQUE,
  section_responses_snapshot JSONB NOT NULL,
  submitted_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_submissions_submission_id ON questionnaire_submissions(submission_id);
CREATE UNIQUE INDEX idx_submissions_user_questionnaire
  ON questionnaire_submissions(user_id, questionnaire_id);
CREATE INDEX idx_submissions_user ON questionnaire_submissions(user_id);
CREATE INDEX idx_submissions_questionnaire ON questionnaire_submissions(questionnaire_id);
CREATE INDEX idx_submissions_recent ON questionnaire_submissions(submitted_at DESC);
```

#### 8.3.2 Seed Data Script
```sql
-- File: V002__seed_data.sql

-- Insert sample clinic
INSERT INTO clinics (id, name, logo_url, primary_color, secondary_color, support_email)
VALUES (
  'clinic_001',
  'HealthFirst Nutrition',
  'https://cdn.example.com/logos/healthfirst.png',
  '#2E7D32',
  '#81C784',
  'support@healthfirst.com'
);

-- Insert sample nutritionist
INSERT INTO nutritionists (id, clinic_id, name, email, photo_url)
VALUES (
  'nutr_001',
  'clinic_001',
  'Dr. Sarah Johnson',
  'sarah@healthfirst.com',
  'https://cdn.example.com/photos/sarah.jpg'
);

-- Insert questionnaire
INSERT INTO questionnaires (id, title, version, estimated_minutes, is_active)
VALUES (
  'nutrition_onboarding_v1',
  'Nutrition Plan Questionnaire',
  '1.0',
  10,
  TRUE
);

-- Insert sections
INSERT INTO questionnaire_sections
  (questionnaire_id, section_id, title, description, order_index, estimated_minutes, completion_message)
VALUES
  ('nutrition_onboarding_v1', 'section_1_personal_info', 'Personal Info',
   'Basic information to personalize your plan', 1, 2,
   'Great! Personal info complete ✅'),
  ('nutrition_onboarding_v1', 'section_2_goals', 'Your Goals',
   'What you want to achieve', 2, 2,
   'Love your motivation! 💪'),
  ('nutrition_onboarding_v1', 'section_3_health', 'Health Background',
   'Your medical history', 3, 3,
   'Thanks for sharing! Almost done 🏃‍♀️'),
  ('nutrition_onboarding_v1', 'section_4_lifestyle', 'Lifestyle',
   'Your daily habits', 4, 3,
   'Amazing work! 🎉 You''re all done!');

-- Insert sample questions for Section 1
INSERT INTO questionnaire_questions
  (section_id, question_id, question_text, input_type, required, order_index, validation_rules, placeholder)
SELECT
  id as section_id,
  'Q1',
  'What''s your full name?',
  'text_input',
  TRUE,
  1,
  '{"minLength": 2, "maxLength": 100}'::JSONB,
  'Enter your full name'
FROM questionnaire_sections
WHERE section_id = 'section_1_personal_info';

-- ... (additional question inserts)
```

---

### 8.4 Testing Checklist

#### 8.4.1 Unit Tests
- [ ] Questionnaire config validation
- [ ] Response validation for each question type
- [ ] Conditional logic evaluation
- [ ] Token generation and validation
- [ ] Business rule enforcement (all sections required for submission)

#### 8.4.2 Integration Tests
- [ ] Complete onboarding flow (load → answer → save → submit)
- [ ] Resume functionality (partial save → restart → resume)
- [ ] Edit workflow (complete → edit → save)
- [ ] Concurrent edit conflict resolution
- [ ] Idempotent request handling
- [ ] Rate limiting enforcement

#### 8.4.3 Load Tests
- [ ] 500 RPS sustained for 5 minutes
- [ ] 2,000 RPS peak for 1 minute
- [ ] Response times under P95 targets
- [ ] Database connection pool stability
- [ ] Memory leak detection

#### 8.4.4 Security Tests
- [ ] Authentication bypass attempts
- [ ] Cross-user data access attempts (IDOR)
- [ ] SQL injection testing
- [ ] XSS payload testing
- [ ] Rate limit bypass attempts
- [ ] Token manipulation testing

---

### 8.5 Deployment Checklist

#### 8.5.1 Pre-Deployment
- [ ] Database migrations tested in staging
- [ ] API backward compatibility verified
- [ ] Environment variables configured
- [ ] SSL/TLS certificates valid
- [ ] Load balancer health checks configured
- [ ] Monitoring and alerting set up
- [ ] Log aggregation configured
- [ ] Backup and restore procedures tested

#### 8.5.2 Post-Deployment
- [ ] Smoke tests passed
- [ ] Performance metrics baseline established
- [ ] Error rates within acceptable limits (<0.1%)
- [ ] Database replication lag acceptable (<5s)
- [ ] Cache hit rates acceptable (>80% for configs)
- [ ] User acceptance testing completed

---

### 8.6 Monitoring & Observability

#### 8.6.1 Key Metrics to Track
| Metric | Tool | Alert Threshold |
|--------|------|-----------------|
| API response time (P95) | Datadog/New Relic | >500ms |
| Error rate | Sentry/Datadog | >1% |
| Request throughput (RPS) | Prometheus | Baseline ±50% |
| Database connection pool usage | PostgreSQL stats | >80% |
| Cache hit rate | Redis metrics | <70% |
| JWT token validation failures | Auth logs | >5% |

#### 8.6.2 Logging Strategy
**Log Levels**:
- **ERROR**: Failed requests, exceptions, database errors
- **WARN**: Rate limit hits, deprecated endpoint usage, slow queries
- **INFO**: Request start/end, authentication events, submission events
- **DEBUG**: Detailed request/response bodies (staging only)

**Structured Logging Format**:
```json
{
  "timestamp": "2025-01-26T12:00:00Z",
  "level": "INFO",
  "service": "questionnaire-api",
  "requestId": "req_abc123",
  "userId": "user_12345",
  "endpoint": "/api/questionnaires/xyz/submit",
  "method": "POST",
  "statusCode": 200,
  "duration": 245,
  "message": "Questionnaire submitted successfully"
}
```

---

## Document Change Log

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-01-26 | System | Initial specification for Phase 6 backend API |

---

**End of Specification**
