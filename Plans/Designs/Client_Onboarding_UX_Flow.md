# Client Onboarding Questionnaire - UX Flow Design

## Design Overview
Conversational chat interface with progressive disclosure, section grouping, and inline editing capabilities. One active question at a time with clean visual organization of completed responses.

Page flow:
1. Welcome Screen
2. Questionnaire FLow
3. Completion Flow

## Layout Structure

### Header Section
```
┌─────────────────────────────────────────────────────────┐
│                 [CLINIC LOGO]                          │
│          Nutrition Plan Questionnaire                   │
└─────────────────────────────────────────────────────────┘
```
- Clinic branding and customizable logo
- Clear questionnaire title
- Professional, trustworthy appearance

### Progress Indicator
```
┌─────────────────────────────────────────────────────────┐
│  PROGRESS BAR                                           │
│  ████████████░░░░░░░░░░░░░░░░ Personal Info (50%)      │
└─────────────────────────────────────────────────────────┘
```
- Visual progress bar showing completion percentage
- Current section name displayed
- Encourages completion and shows time investment

### Chat Interface with Grouping
```
┌─────────────────────────────────────────────────────────┐
│  CHAT INTERFACE (Scrollable)                           │
│                                                         │
│  🤖 Hi Sarah! I'm here to help Dr. Smith create        │
│     the perfect nutrition plan for you.                │
│                                                         │
│  🤖 This will take just 5-10 minutes and covers        │
│     4 areas: Personal Info, Goals, Health &            │
│     Lifestyle. Ready to get started?                   │
│                                                         │
│  👤 Yes, let's do this!          [📝 Edit]            │
│                                                         │
│ ┌─ PERSONAL INFO ────────────────────────────────────┐  │
│ │                                                    │  │
│ │ 🤖 What's your full name?                         │  │
│ │                                                    │  │
│ │ 👤 Sarah Johnson               [📝 Edit]          │  │
│ │                                                    │  │
│ │ 🤖 How old are you?                               │  │
│ │                                                    │  │
│ │ 👤 28 years old                [📝 Edit]          │  │
│ │                                                    │  │
│ │ 🤖 What's your current weight?                    │  │
│ │                                                    │  │
│ │ 👤 135 lbs                     [📝 Edit]          │  │
│ │                                                    │  │
│ └────────────────────────────────────────────────────┘  │
│                                                         │
│ ✅ Personal Info Complete! Now let's talk about your   │
│    goals 💪                                            │
│                                                         │
│ ┌─ YOUR GOALS ───────────────────────────────────────┐  │
│ │                                                    │  │
│ │ 🤖 What's your main health goal?                  │  │
│ │                                                    │  │
│ │ 👤 Lose weight                 [📝 Edit]          │  │
│ │                                                    │  │
│ │ 🤖 How much would you like to lose and in what    │  │
│ │    timeframe?                                      │  │
│ │                                                    │  │
│ └────────────────────────────────────────────────────┘  │
│                                                         │
│ 🤖 And your height?                                    │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ [5 ft] [7 in]                           [Submit] │ │
│ │                                         ▲ CURRENT │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## Key UX Principles

### 1. Progressive Disclosure
- **One Question at a Time**: Only current question is active for input
- **Contextual Flow**: Previous questions remain visible for context
- **Natural Progression**: Questions flow naturally like a conversation

### 2. Visual Grouping
- **Section Containers**: Boxed groups for each category (Personal Info, Goals, etc.)
- **Clear Headers**: Section names clearly labeled
- **Completion Celebrations**: Encouraging messages when sections finish

### 3. Inline Editing
- **Edit Buttons**: Every completed response has an edit option
- **Non-Disruptive**: Editing doesn't break the conversation flow
- **Immediate Feedback**: Changes reflect instantly in the interface

### 4. Current Question Highlighting
- **Visual Emphasis**: Active input field stands out from completed responses
- **Clear Indicator**: "CURRENT" label shows where user should focus
- **Input Validation**: Submit button only appears when input is valid

## Interaction Patterns

### Question Flow
1. **Bot asks question** → appears in chat
2. **User provides answer** → input field at bottom
3. **Answer submits** → moves to chat history with edit button
4. **Next question loads** → new active input appears
5. **Section completes** → celebration message + new section begins

### Section Transitions
```
🤖 Question from previous section...
👤 User's final answer for section     [📝 Edit]

✅ [SECTION NAME] Complete! [Encouraging message about next section]

┌─ NEXT SECTION NAME ────────────────────────────────────┐
│ 🤖 First question of new section...                   │
└────────────────────────────────────────────────────────┘
```

### Response States
- **Answered**: ✓ Check mark, edit button, slightly muted styling
- **Current**: Emphasized styling, active input field
- **Editable**: Inline editing without losing context

## Technical Considerations

### Responsive Design
- **Mobile First**: Touch-friendly inputs and buttons
- **Adaptive Layout**: Scales from mobile to desktop
- **Thumb-Friendly**: Input areas sized for mobile interaction

### Accessibility
- **Screen Reader Support**: Proper ARIA labels and structure
- **Keyboard Navigation**: Full keyboard accessibility
- **High Contrast**: Clear visual hierarchy and readable text
- **Focus Management**: Clear focus indicators

### Performance
- **Lazy Loading**: Only render visible chat history
- **State Management**: Efficient handling of form state
- **Auto-Save**: Preserve progress if user navigates away

## Visual Styling Notes

### Colors & Theming
- Clean, professional medical/health aesthetic
- Customizable to match clinic branding
- High contrast for accessibility
- Warm, approachable colors for conversation

### Typography
- Clear, readable fonts (Inter, Open Sans, or similar)
- Proper hierarchy for bot vs user messages
- Adequate spacing for mobile readability

### Animations
- Smooth transitions between questions
- Subtle hover effects on interactive elements
- Loading states for question transitions
- Celebration animations for section completion

This design balances the conversational UX with structured data collection, making the onboarding process feel natural while ensuring complete information capture.