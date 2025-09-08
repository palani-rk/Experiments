# Client Onboarding Questionnaire Specification

## Overview
Conversational-style questionnaire interface that combines chat UX with structured data collection for nutritionist client onboarding.

## Design Approach
- **Hybrid Conversational + Wizard Interface**
- **Metadata-driven questions** (easily updatable)
- **Editable chat history** with category grouping
- **Progressive disclosure** with encouraging messages
- **Estimated completion time**: 5-10 minutes

## User Experience Flow

### Opening Sequence
```
BOT: Hi [CLIENT_NAME]! 👋 I'm here to help [NUTRITIONIST_NAME] create the perfect nutrition plan for you.

BOT: This will take just 5-10 minutes and covers 4 areas:
     • Personal Info (2 mins)
     • Your Goals (2 mins) 
     • Health Background (3 mins)
     • Lifestyle (3 mins)

BOT: Ready to get started? 
     [Yes, let's do this!] [I have questions first]
```

## Question Categories & Sample Questions

### SECTION 1: Personal Info (2 minutes)
**Category completion message**: "Great! Personal info complete ✅ Now let's talk about what you want to achieve."

| Question ID | Question Text | Input Type | Options/Validation |
|-------------|---------------|------------|-------------------|
| Q1 | What's your full name? | text_input | min_length: 2, required: true |
| Q2 | How old are you? | number_input | range: 18-100, required: true |
| Q3 | What's your current weight? | number_input + unit_selector | units: [kg, lbs], required: true |
| Q4 | And your height? | number_input + unit_selector | units: [cm, ft-in], required: true |

### SECTION 2: Goals (2 minutes)
**Category completion message**: "Love your motivation! 💪 Now let's understand your health background."

| Question ID | Question Text | Input Type | Options/Validation |
|-------------|---------------|------------|-------------------|
| Q5 | What's your main health goal? | single_select | [Lose weight, Gain weight, Build muscle, Improve energy, Manage medical condition, General wellness, Other] |
| Q6 | [Conditional: IF weight loss] How much would you like to lose? | number_input + timeframe_select | units: [kg, lbs] + timeframes: [weeks, months] |
| Q7 | What's your biggest motivation right now? | multi_select | [Feel more confident, Improve health numbers, Have more energy, Set good example for family, Doctor's recommendation, Other] |

### SECTION 3: Health Background (3 minutes)
**Category completion message**: "Thanks for sharing! Almost done - just your lifestyle habits left 🏃‍♀️"

| Question ID | Question Text | Input Type | Options/Validation |
|-------------|---------------|------------|-------------------|
| Q8 | Do you have any medical conditions? | multi_select + text_other | [None, Diabetes, High blood pressure, Heart disease, Thyroid issues, Food allergies, Other] |
| Q9 | [Conditional: IF conditions selected] Are you taking any medications? | text_area | placeholder: "List any medications or supplements..." |
| Q10 | Any foods you absolutely cannot or will not eat? | multi_select + text_other | [No restrictions, Vegetarian, Vegan, Gluten-free, Dairy-free, Nut allergies, Religious restrictions, Other] |

### SECTION 4: Lifestyle (3 minutes)
**Category completion message**: "Amazing work! 🎉 You're all done. [NUTRITIONIST_NAME] will review your responses and create your personalized plan. You'll hear back within 24-48 hours!"

| Question ID | Question Text | Input Type | Options/Validation |
|-------------|---------------|------------|-------------------|
| Q11 | How would you describe your activity level? | single_select | [Sedentary (desk job, little exercise), Lightly active (light exercise 1-3 days/week), Moderately active (moderate exercise 3-5 days/week), Very active (hard exercise 6-7 days/week)] |
| Q12 | How often do you cook at home? | single_select | [Daily, 4-6 times/week, 2-3 times/week, Once a week, Rarely/Never] |
| Q13 | What's your biggest challenge with eating healthy? | multi_select | [No time to cook, Don't know what to eat, Eating out too much, Late night snacking, Emotional eating, Budget constraints, Family preferences] |

## Completion Flow
```
BOT: Amazing work! 🎉 You're all done. [NUTRITIONIST_NAME] will review your responses 
     and create your personalized plan. You'll hear back within 24-48 hours!
     
     [View My Responses] [Send to Nutritionist]
```

## Technical Specifications

### Input Types
- **text_input**: Single line text field
- **text_area**: Multi-line text field with placeholder
- **number_input**: Numeric input with validation range
- **single_select**: Radio buttons or dropdown
- **multi_select**: Checkboxes with "Other" option
- **unit_selector**: Dropdown for measurement units
- **timeframe_select**: Duration selection

### Conditional Logic
- Questions can be conditional based on previous responses
- Example: Q6 only appears if Q5 = "Lose weight"
- Example: Q9 only appears if Q8 has any conditions selected

### Metadata Structure
```json
{
  "question_id": "Q1",
  "section": "personal_info",
  "question_text": "What's your full name?",
  "input_type": "text_input",
  "required": true,
  "options": null,
  "conditional_logic": null,
  "validation": {
    "min_length": 2
  },
  "placeholder": null
}
```

## User Experience Requirements

### Chat Interface Features
- **Scrollable History**: Users can scroll up to see previous responses
- **Editable Responses**: Click any previous response to edit inline
- **Category Grouping**: Visual separation of response categories
- **Progress Indication**: Show section completion and overall progress
- **Personalized Messages**: Use client and nutritionist names throughout

### Branding Options
- **Nutritionist/Clinic Logo**: Display at top of interface
- **Custom Colors**: Match clinic branding
- **Personalized Avatar**: Optional nutritionist photo in chat

### Response Validation
- **Real-time Validation**: Check input as user types
- **Required Field Enforcement**: Cannot proceed without required responses
- **Format Validation**: Email, phone, numeric ranges
- **Graceful Error Handling**: Clear error messages with correction guidance

## Future Enhancements
- **Adaptive Questioning**: AI-driven follow-up questions based on responses
- **Multi-language Support**: Questionnaire in multiple languages
- **Voice Input**: Speech-to-text for accessibility
- **Photo Uploads**: Current meal examples, body measurements
- **Integration**: Pre-fill from existing clinic management systems

## Success Metrics
- **Completion Rate**: Target 85%+ completion rate
- **Time to Complete**: Average 5-10 minutes
- **User Satisfaction**: Post-completion feedback
- **Data Quality**: Completeness and accuracy of responses