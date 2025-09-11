# Questionnaire Design Specification

## Overview

This document defines the complete specification for NutriApp's metadata-driven questionnaire system. The system enables dynamic questionnaire generation, complex conditional flows, comprehensive response tracking, and extensible input types.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Root Questionnaire Schema](#root-questionnaire-schema)
3. [Welcome Section](#welcome-section)
4. [Sections Structure](#sections-structure)
5. [Question Types & Input Specifications](#question-types--input-specifications)
6. [Response Tracking](#response-tracking)
7. [Conditional Flows](#conditional-flows)
8. [Settings & Configuration](#settings--configuration)
9. [Implementation Guidelines](#implementation-guidelines)

## Architecture Overview

### Core Components

```
┌─────────────────────────────────────────────────────────────┐
│                    Questionnaire System                     │
├─────────────────────────────────────────────────────────────┤
│ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ │
│ │   JSON Schema   │ │ Widget Container│ │ Flow Engine     │ │
│ │   Parser        │ │ Renderer        │ │ Processor       │ │
│ └─────────────────┘ └─────────────────┘ └─────────────────┘ │
│ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ │
│ │ Input Types     │ │ Response        │ │ Analytics       │ │
│ │ Registry        │ │ Tracker         │ │ Engine          │ │
│ └─────────────────┘ └─────────────────┘ └─────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### File Structure

```
features/onboarding/
├── models/
│   ├── questionnaire_schema.dart          # Core schema models
│   ├── question_models.dart               # Question and input type models  
│   ├── response_models.dart               # Response and analytics models
│   ├── conditional_flow_models.dart       # Flow control models
│   └── models.dart                        # Barrel export
├── widgets/
│   ├── inputs/                            # Input type implementations
│   │   ├── question_input_type.dart       # Base abstract class
│   │   ├── text_question_input.dart       # Text input implementation
│   │   ├── multifield_question_input.dart # Multi-field form implementation
│   │   ├── radio_question_input.dart      # Radio button implementation
│   │   ├── multiselect_question_input.dart# Multi-select implementation
│   │   ├── dropdown_question_input.dart   # Dropdown implementation
│   │   ├── slider_question_input.dart     # Slider/range implementation
│   │   └── inputs.dart                    # Barrel export
│   ├── current_question_input_widget_container.dart # Main container
│   └── widgets.dart                       # Main barrel export
├── services/
│   ├── questionnaire_service.dart         # JSON parsing and state management
│   ├── conditional_flow_engine.dart       # Flow control logic
│   ├── response_tracker.dart              # Analytics and progress tracking
│   └── services.dart                      # Barrel export
└── progress_specs/
    ├── questionnaire_design_spec.md       # This document
    └── progress_tracker.md                # Implementation progress
```

## Root Questionnaire Schema

```json
{
  "questionnaireId": "nutri_app_onboarding_v1",
  "version": "1.0.0",
  "title": "NutriApp Health Assessment",
  "welcome": {
    // Welcome section configuration
  },
  "sections": [
    // Array of question sections
  ],
  "responses": {
    // User responses with metadata
  },
  "conditionalFlows": {
    // Flow control rules
  },
  "settings": {
    // Global questionnaire settings
  },
  "metadata": {
    // Questionnaire metadata
  }
}
```

## Welcome Section

### Schema Structure

```json
{
  "welcome": {
    "title": "Welcome to Your Health Journey",
    "subtitle": "Personalized nutrition starts with understanding you",
    "description": "This assessment will help us create a personalized nutrition plan tailored to your goals, preferences, and lifestyle.",
    "estimatedTime": 8,
    "timeUnit": "minutes",
    "features": [
      {
        "icon": "psychology",
        "title": "Personalized Insights",
        "description": "AI-powered recommendations based on your unique profile"
      },
      {
        "icon": "track_changes", 
        "title": "Progress Tracking",
        "description": "Monitor your journey with detailed analytics"
      },
      {
        "icon": "restaurant_menu",
        "title": "Custom Meal Plans", 
        "description": "Recipes and meals designed for your goals"
      }
    ],
    "privacyNote": "Your data is encrypted and never shared without permission",
    "ui": {
      "showProgressBar": true,
      "allowSkip": false,
      "buttonText": "Start Assessment",
      "showFeatureIcons": true,
      "theme": {
        "backgroundGradient": ["#667eea", "#764ba2"],
        "textColor": "#ffffff"
      }
    }
  }
}
```

### Features Array Properties

| Property | Type | Description |
|----------|------|-------------|
| `icon` | String | Material Design icon name |
| `title` | String | Feature headline |
| `description` | String | Feature explanation |

## Sections Structure

### Section Schema

```json
{
  "sectionId": "personal_info",
  "title": "Personal Information", 
  "description": "Basic details about you",
  "icon": "person",
  "estimatedTime": 2,
  "order": 1,
  "isRequired": true,
  "questions": [
    // Array of questions
  ],
  "completion": {
    "isCompleted": false,
    "completedAt": null,
    "requiredQuestions": ["name", "age", "gender"],
    "optionalQuestions": ["height", "weight"]
  },
  "conditionalDisplay": {
    "showIf": {
      "sectionId": "previous_section",
      "condition": "isCompleted === true"
    }
  },
  "ui": {
    "showSectionProgress": true,
    "allowNavigateBack": true,
    "sectionTheme": {
      "primaryColor": "#007AFF",
      "headerColor": "#F2F2F7"
    }
  }
}
```

## Question Types & Input Specifications

### Base Question Schema

```json
{
  "questionId": "unique_question_id",
  "question": "Question text displayed to user",
  "description": "Optional additional context",
  "inputType": "text|multifield|radio|multiselect|dropdown|slider",
  "required": true,
  "order": 1,
  "metadata": {
    // Input-type specific configuration
  },
  "validation": {
    // Validation rules
  },
  "ui": {
    // UI customization
  },
  "conditionalLogic": {
    // Show/hide conditions
  }
}
```

### 1. Text Input Type

```json
{
  "questionId": "name_input",
  "question": "What's your full name?",
  "inputType": "text",
  "required": true,
  "metadata": {
    "placeholder": "Enter your full name",
    "keyboardType": "text", // text, email, phone, number, url
    "maxLength": 50,
    "minLength": 2,
    "multiline": false,
    "maxLines": 1,
    "defaultValue": "",
    "autocorrect": true,
    "capitalization": "words" // none, characters, words, sentences
  },
  "validation": {
    "required": {
      "enabled": true,
      "message": "Name is required"
    },
    "minLength": {
      "value": 2,
      "message": "Name must be at least 2 characters"
    },
    "pattern": {
      "regex": "^[a-zA-Z\\s]+$",
      "message": "Name can only contain letters and spaces"
    }
  },
  "ui": {
    "style": "outlined", // outlined, filled, underlined
    "labelPosition": "floating", // floating, fixed, none
    "showCharacterCount": true
  }
}
```

### 2. Multi-Field Input Type

```json
{
  "questionId": "height_input", 
  "question": "What's your height?",
  "inputType": "multifield",
  "required": true,
  "metadata": {
    "layout": "horizontal", // horizontal, vertical, grid
    "spacing": 16,
    "fields": [
      {
        "key": "feet",
        "label": "Feet",
        "type": "number",
        "placeholder": "5",
        "width": "flex", // flex, fixed, percentage
        "defaultValue": "",
        "min": 1,
        "max": 8,
        "step": 1
      },
      {
        "key": "inches", 
        "label": "Inches",
        "type": "number", 
        "placeholder": "8",
        "width": "flex",
        "defaultValue": "",
        "min": 0,
        "max": 11,
        "step": 1
      }
    ]
  },
  "validation": {
    "required": {
      "enabled": true,
      "message": "Please enter both feet and inches"
    },
    "custom": {
      "rules": [
        {
          "condition": "feet >= 1 && feet <= 8",
          "message": "Height must be between 1-8 feet"
        },
        {
          "condition": "inches >= 0 && inches <= 11", 
          "message": "Inches must be between 0-11"
        }
      ]
    }
  },
  "ui": {
    "fieldSpacing": 12,
    "showLabels": true,
    "labelPosition": "top"
  }
}
```

### 3. Radio Button Input Type

```json
{
  "questionId": "activity_level",
  "question": "What's your activity level?",
  "inputType": "radio",
  "required": true,
  "metadata": {
    "options": [
      {
        "value": "sedentary",
        "label": "Sedentary",
        "description": "Little to no exercise",
        "icon": "chair",
        "disabled": false,
        "triggers": ["low_activity_flow"]
      },
      {
        "value": "light",
        "label": "Lightly Active", 
        "description": "Light exercise 1-3 days/week",
        "icon": "walk"
      },
      {
        "value": "moderate",
        "label": "Moderately Active",
        "description": "Moderate exercise 3-5 days/week", 
        "icon": "run"
      },
      {
        "value": "active",
        "label": "Very Active",
        "description": "Hard exercise 6-7 days/week",
        "icon": "fitness_center",
        "triggers": ["high_activity_flow"]
      }
    ],
    "defaultValue": null,
    "allowDeselect": false
  },
  "validation": {
    "required": {
      "enabled": true,
      "message": "Please select your activity level"
    }
  },
  "ui": {
    "displayStyle": "list", // list, grid, chips, cards
    "columnsInGrid": 2,
    "showIcons": true,
    "showDescriptions": true,
    "cardElevation": 2
  }
}
```

### 4. Multi-Select Input Type

```json
{
  "questionId": "dietary_preferences",
  "question": "What are your dietary preferences?",
  "inputType": "multiselect", 
  "required": false,
  "metadata": {
    "options": [
      {
        "value": "vegetarian",
        "label": "Vegetarian",
        "description": "No meat or fish",
        "icon": "eco",
        "category": "diet_type"
      },
      {
        "value": "vegan", 
        "label": "Vegan",
        "description": "No animal products",
        "icon": "local_florist",
        "category": "diet_type"
      },
      {
        "value": "gluten_free",
        "label": "Gluten-Free", 
        "description": "No wheat, barley, or rye",
        "icon": "no_food",
        "category": "restrictions"
      }
    ],
    "minSelections": 0,
    "maxSelections": null,
    "defaultValues": [],
    "groupByCategory": true
  },
  "validation": {
    "minSelections": {
      "value": 1,
      "message": "Please select at least one preference"
    },
    "maxSelections": {
      "value": 3,
      "message": "Please select no more than 3 preferences"
    }
  },
  "ui": {
    "displayStyle": "chips", // chips, checkboxes, cards, list
    "allowSearch": true,
    "searchPlaceholder": "Search preferences...",
    "showCategoryHeaders": true,
    "chipStyle": "outlined" // filled, outlined
  }
}
```

### 5. Dropdown Input Type

```json
{
  "questionId": "country_selection",
  "question": "What country are you from?",
  "inputType": "dropdown",
  "required": true,
  "metadata": {
    "options": [
      {
        "value": "us",
        "label": "United States",
        "group": "North America"
      },
      {
        "value": "ca", 
        "label": "Canada",
        "group": "North America"
      },
      {
        "value": "uk",
        "label": "United Kingdom", 
        "group": "Europe"
      }
    ],
    "placeholder": "Select your country",
    "searchable": true,
    "groupOptions": true,
    "defaultValue": null
  },
  "validation": {
    "required": {
      "enabled": true,
      "message": "Please select your country"
    }
  },
  "ui": {
    "maxDropdownHeight": 200,
    "showSearchBar": true,
    "searchPlaceholder": "Search countries...",
    "groupDividers": true
  }
}
```

### 6. Slider Input Type

```json
{
  "questionId": "weight_goal",
  "question": "What's your target weight loss per week?",
  "inputType": "slider",
  "required": true,
  "metadata": {
    "min": 0.5,
    "max": 2.0,
    "step": 0.25,
    "defaultValue": 1.0,
    "unit": "lbs",
    "showValue": true,
    "divisions": 6
  },
  "validation": {
    "range": {
      "min": 0.5,
      "max": 2.0,
      "message": "Please select between 0.5 and 2.0 lbs per week"
    }
  },
  "ui": {
    "showLabels": true,
    "showTicks": true,
    "valuePosition": "above", // above, below, inline
    "formatValue": "{value} {unit}/week"
  }
}
```

## Response Tracking

### Response Structure

```json
{
  "responses": {
    "sessionId": "user_123_session_456",
    "startedAt": "2025-01-15T10:30:00Z",
    "lastUpdatedAt": "2025-01-15T10:45:00Z",
    "completedAt": null,
    "currentSection": "health_goals",
    "currentQuestion": "primary_goal",
    "overallProgress": 0.35,
    
    "sectionResponses": {
      "personal_info": {
        "sectionId": "personal_info",
        "isCompleted": true,
        "completedAt": "2025-01-15T10:38:00Z",
        "progress": 1.0,
        "timeSpent": 480, // seconds
        "questionResponses": {
          "name": {
            "questionId": "name",
            "value": "John Smith",
            "isAnswered": true,
            "answeredAt": "2025-01-15T10:31:00Z",
            "isValid": true,
            "validationErrors": [],
            "editCount": 0,
            "timeSpent": 45
          },
          "height": {
            "questionId": "height",
            "value": {
              "feet": 6,
              "inches": 2
            },
            "isAnswered": true,
            "answeredAt": "2025-01-15T10:35:00Z",
            "isValid": true,
            "validationErrors": [],
            "editCount": 2,
            "timeSpent": 120
          }
        }
      }
    },
    
    "analytics": {
      "totalTimeSpent": 660,
      "averageTimePerQuestion": 55,
      "mostEditedQuestion": "height",
      "questionsSkipped": [],
      "questionsWithErrors": [],
      "deviceInfo": {
        "platform": "iOS",
        "screenSize": "375x812",
        "appVersion": "1.2.0"
      }
    }
  }
}
```

### Response Properties

| Property | Type | Description |
|----------|------|-------------|
| `sessionId` | String | Unique session identifier |
| `currentSection` | String | Currently active section |
| `currentQuestion` | String | Currently active question |
| `overallProgress` | Double | Completion percentage (0.0-1.0) |
| `timeSpent` | Integer | Time in seconds |
| `editCount` | Integer | Number of times answer was modified |
| `validationErrors` | Array | Current validation errors |

## Conditional Flows

### Flow Structure

```json
{
  "conditionalFlows": {
    "flows": {
      "weight_loss_flow": {
        "flowId": "weight_loss_flow",
        "name": "Weight Loss Journey",
        "description": "Additional questions for weight loss goals",
        "triggeredBy": {
          "questionId": "primary_goal",
          "value": "weight_loss"
        },
        "actions": [
          {
            "type": "showQuestion",
            "questionId": "target_weight_loss",
            "sectionId": "health_goals"
          },
          {
            "type": "showSection",
            "sectionId": "dietary_restrictions"
          },
          {
            "type": "hideQuestion",
            "questionId": "bulking_calories",
            "sectionId": "nutrition_preferences"
          }
        ]
      },
      
      "high_activity_flow": {
        "flowId": "high_activity_flow", 
        "name": "High Activity Nutrition",
        "triggeredBy": {
          "questionId": "activity_level",
          "operator": "in",
          "values": ["very_active", "extremely_active"]
        },
        "conditions": [
          {
            "type": "and",
            "rules": [
              {
                "questionId": "primary_goal",
                "operator": "in", 
                "values": ["muscle_gain", "weight_loss"]
              },
              {
                "questionId": "exercise_frequency",
                "operator": "greater_than",
                "value": 4
              }
            ]
          }
        ],
        "actions": [
          {
            "type": "showQuestion",
            "questionId": "pre_workout_nutrition",
            "insertAfter": "activity_level"
          },
          {
            "type": "updateValidation",
            "questionId": "daily_calories",
            "validation": {
              "range": {
                "min": 2200,
                "max": 4000,
                "message": "High activity requires 2200-4000 calories"
              }
            }
          }
        ]
      }
    }
  }
}
```

### Flow Actions

| Action Type | Description | Parameters |
|-------------|-------------|------------|
| `showQuestion` | Display a question | `questionId`, `sectionId`, `insertAfter` |
| `hideQuestion` | Hide a question | `questionId`, `sectionId` |
| `showSection` | Display a section | `sectionId` |
| `hideSection` | Hide a section | `sectionId` |
| `updateValidation` | Modify validation rules | `questionId`, `validation` |
| `skipQuestions` | Skip multiple questions | `questionIds` |
| `addValidation` | Add validation rules | `questionId`, `validation` |

### Conditional Operators

| Category | Operators |
|----------|-----------|
| **Comparison** | `equals`, `not_equals`, `greater_than`, `less_than`, `greater_than_or_equal`, `less_than_or_equal` |
| **Inclusion** | `in`, `not_in`, `contains`, `not_contains` |
| **Existence** | `is_answered`, `is_not_answered`, `is_valid`, `is_not_valid` |
| **Logical** | `and`, `or`, `not` |
| **Temporal** | `answered_before`, `answered_after`, `answered_within_seconds` |

## Settings & Configuration

### Global Settings

```json
{
  "settings": {
    "allowBackNavigation": true,
    "allowSkipOptionalQuestions": true,
    "autoSave": true,
    "autoSaveInterval": 30, // seconds
    "sessionTimeout": 3600, // seconds
    "maxEditCount": 5,
    "showProgressBar": true,
    "enableAnalytics": true,
    "offlineMode": false
  },
  
  "metadata": {
    "createdBy": "nutri_team",
    "createdAt": "2025-01-10T00:00:00Z",
    "lastModified": "2025-01-14T15:30:00Z",
    "version": "1.0.0",
    "targetAudience": "health_conscious_adults",
    "estimatedCompletionTime": 8,
    "languages": ["en", "es", "fr"],
    "tags": ["health", "nutrition", "onboarding", "assessment"]
  }
}
```

### UI Theme Configuration

```json
{
  "ui": {
    "theme": {
      "primaryColor": "#007AFF",
      "errorColor": "#FF3B30", 
      "surfaceColor": "#F2F2F7",
      "textColor": "#000000"
    },
    "typography": {
      "questionTextStyle": "headline6",
      "labelTextStyle": "subtitle2",
      "inputTextStyle": "body1"
    },
    "spacing": {
      "fieldPadding": 16,
      "fieldSpacing": 12,
      "sectionSpacing": 24
    },
    "animations": {
      "enableTransitions": true,
      "transitionDuration": 300
    }
  }
}
```

## Implementation Guidelines

### 1. Component Architecture

- **Base Abstract Class**: `QuestionInputType<T>` with generic typing
- **Container Widget**: `CurrentQuestionInputWidgetContainer` manages overall UI
- **Input Types**: Concrete implementations for each input type
- **State Management**: Centralized response tracking and validation

### 2. Validation Strategy

- **Real-time Validation**: Validate on value change
- **Submission Validation**: Final validation before section completion
- **Custom Rules**: Support for complex validation logic
- **Error Display**: Clear, contextual error messages

### 3. Performance Considerations

- **Lazy Loading**: Load sections on demand
- **State Preservation**: Maintain responses across navigation
- **Efficient Rendering**: Only re-render changed components
- **Memory Management**: Clean up completed sections

### 4. Testing Requirements

- **Unit Tests**: Individual input type components
- **Integration Tests**: Full questionnaire flow
- **Validation Tests**: All validation rules and edge cases
- **Performance Tests**: Large questionnaire handling
- **Accessibility Tests**: Screen reader and keyboard navigation

### 5. Error Handling

- **Graceful Degradation**: Fallback for unsupported input types
- **Network Resilience**: Offline capability with sync
- **Validation Recovery**: Clear path to resolve errors
- **Progress Preservation**: Save state on unexpected exits

### 6. Accessibility Guidelines

- **Screen Reader Support**: Proper semantic labeling
- **Keyboard Navigation**: Full keyboard accessibility
- **High Contrast**: Support for accessibility themes
- **Text Scaling**: Responsive to system text size
- **Voice Input**: Compatible with voice control

---

**Document Version**: 1.0.0  
**Last Updated**: January 15, 2025  
**Next Review**: February 1, 2025