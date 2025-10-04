# Flutter Interactive Design Spec

## Command: `/flutter-design-spec`

Save this file as `.claude/commands/flutter-design-spec.md` in your project directory.

---
allowed-tools: Read, Glob, Grep, TodoWrite
argument-hint: [mode] [target-file]
description: Interactive Flutter design specification creation through iterative discussion and alignment
model: Claude Sonnet
---

# Flutter Interactive Design Spec Generator

Create comprehensive Flutter design specifications through interactive discussion and iterative refinement, ensuring user alignment at each stage.

## Usage
- **Start New**: `/flutter-design-spec new` or `/flutter-design-spec start`
- **Continue**: `/flutter-design-spec continue @design-spec.md`
- **Review Section**: `/flutter-design-spec review [section-name] @design-spec.md`

## Process Overview

This command follows a structured, interactive approach:
1. **Requirements Discovery** - Interactive Q&A to understand needs
2. **Pattern Analysis** - Review existing codebase patterns
3. **Section-by-Section Design** - Iterative discussion and spec building
4. **User Alignment** - Confirm each section before proceeding

## Mode Selection

Analyze $ARGUMENTS to determine mode:
- If first argument is "new" or "start" → New specification mode
- If first argument is "continue" → Continue existing spec at $2
- If first argument is "review" → Review specific section at $3
- If no arguments → Ask which mode to use

---

## NEW SPECIFICATION MODE

### Stage 1: Requirements Discovery & Context Analysis

**Step 1.1: Workspace Analysis**
First, scan the workspace for existing patterns:

1. Check for @pubspec.yaml to understand dependencies and versions
2. Look for existing patterns in:
   - `lib/providers/` - Riverpod patterns
   - `lib/models/` - Model structures
   - `lib/services/` - Service patterns
   - `lib/screens/` or `lib/features/` - Widget patterns
3. Check for CLAUDE.md or README.md for project conventions
4. Look for existing design specs: `design_spec_*.md` files

**Step 1.2: Requirements Gathering**

Read requirements from (in order of priority):
1. @requirements.md if exists
2. User-provided requirements in conversation
3. README.md for project overview if no requirements found

**Step 1.3: Interactive Requirements Discussion**

Ask ONLY the most critical questions (max 3-5) to clarify:

**Always ask**:
- "What are the main user actions and their expected outcomes?"
- "What happens when operations fail or go wrong?"

**Conditional questions based on context**:
- If forms detected: "What validation rules and error handling do you need?"
- If lists detected: "Do you need pagination, search, or filtering?"
- If multi-step flows: "Can users navigate freely between steps or is it linear?"
- If external data: "What's your offline/caching strategy?"
- If authentication patterns found: "What user roles and permissions apply?"

**Step 1.4: Complexity Assessment & Approach Discussion**

Present complexity assessment and get user confirmation:
- **Simple**: Single screen CRUD, basic forms, no offline/realtime
- **Medium**: Multi-screen flows, complex validation, API integration
- **Complex**: Offline sync, real-time updates, complex state dependencies

Ask: "Does this complexity assessment match your expectations? Any concerns about scope?"

### Stage 2: Core Specification Creation

Create initial `design_spec_[feature_name].md` with basic structure:

```markdown
# Flutter Design Specification: [Feature Name]

**Generated**: [Date]
**Status**: In Progress - Interactive Design Phase
**Complexity**: [Simple/Medium/Complex]
**Requirements Source**: [requirements.md or inline]
**Flutter Version**: [from pubspec.yaml]
**Riverpod Version**: [from pubspec.yaml]

---

## Specification Sections

### ✅ Completed Sections
- [ ] Overview
- [ ] Screen Flow
- [ ] State Management
- [ ] Data Models
- [ ] Widget Structure
- [ ] API Requirements
- [ ] Services/Repositories

### 🔄 Extended Sections (Medium/Complex)
- [ ] Navigation & Routing
- [ ] Error Handling Strategy
- [ ] Form Controllers

### 🔄 Advanced Sections (Complex Only)
- [ ] Business Logic Controllers
- [ ] Caching Strategy
- [ ] Performance Optimizations
- [ ] Testing Strategy
- [ ] Accessibility Checklist
- [ ] Localization Support

---

[Sections will be added iteratively through discussion]
```

### Stage 3: Section-by-Section Interactive Design

For each section, follow this pattern:

**Step 3.1: Section Introduction**
"Let's design the [SECTION NAME]. This covers [brief description]. Based on your requirements, I'm thinking about [initial approach]. What are your thoughts?"

**Step 3.2: Interactive Discussion**
- Present initial ideas and ask for feedback
- Discuss alternatives and trade-offs
- Ask specific clarifying questions for that section
- Ensure user understands implications

**Step 3.3: Section Confirmation**
"Here's what I understand for [SECTION NAME]: [summary]. Does this align with your vision? Should we adjust anything before I add it to the spec?"

**Step 3.4: Spec Update**
Once confirmed, update the specification file with the completed section.

**Step 3.5: Progress Check**
"✅ [SECTION NAME] completed and added to spec. Ready to move to [NEXT SECTION]?"

## SECTION-SPECIFIC DISCUSSION GUIDES

### 1. Overview Section Discussion
**Topics to cover**:
- Feature scope boundaries (what's in/out)
- Success metrics and user goals
- Key dependencies and constraints
- Integration points with existing systems

**Questions to ask**:
- "What defines success for this feature?"
- "Are there any existing features this needs to integrate with?"
- "What's absolutely essential vs nice-to-have?"

### 2. Screen Flow Discussion
**Topics to cover**:
- Navigation patterns and entry points
- User journey through screens
- Back navigation and exit strategies
- Deep linking requirements

**Questions to ask**:
- "How do users typically discover and access this feature?"
- "What happens if users navigate away mid-process?"
- "Do you need bookmarkable URLs for any screens?"

### 3. State Management Discussion
**Topics to cover**:
- Data lifecycle and persistence
- Loading and error states
- Real-time updates if applicable
- State sharing between screens

**Questions to ask**:
- "How long should this data stay fresh?"
- "What happens when network is unavailable?"
- "Do multiple screens need to react to the same data changes?"

### 4. Data Models Discussion
**Topics to cover**:
- Core entities and relationships
- Validation rules and constraints
- Serialization requirements
- Data transformations needed

**Questions to ask**:
- "What business rules govern this data?"
- "How does this data relate to your existing models?"
- "Are there any data validation rules users expect?"

### 5. Widget Structure Discussion
**Topics to cover**:
- UI patterns and design system compliance
- Responsive behavior across devices
- Accessibility requirements
- User interaction patterns

**Questions to ask**:
- "Do you have existing design patterns we should follow?"
- "What devices/screen sizes need to be supported?"
- "Are there accessibility requirements we need to meet?"

### 6. API Requirements Discussion
**Topics to cover**:
- Endpoint design and data contracts
- Authentication and authorization
- Error handling and status codes
- Rate limiting and performance

**Questions to ask**:
- "Is the API already defined or do we need to design it?"
- "What authentication method are you using?"
- "How should we handle network failures?"

### 7. Services/Repositories Discussion
**Topics to cover**:
- Data access patterns
- Caching strategy
- Error handling approach
- Testing and mocking strategy

**Questions to ask**:
- "How should we handle offline scenarios?"
- "What caching makes sense for your use case?"
- "How important is real-time data vs cached performance?"

---

## CONTINUE MODE

### Resume Existing Specification

**Step 1: Load Current State**
- Read the existing specification file
- Identify completed vs pending sections
- Understand current progress and context

**Step 2: Status Summary**
Present current state: "I see we've completed [X] sections: [list]. The next pending section is [Y]. Ready to continue with [Y], or would you like to review/modify any completed sections first?"

**Step 3: Continue Process**
Follow the same interactive discussion pattern for remaining sections.

---

## REVIEW MODE

### Review Specific Section

**Step 1: Section Analysis**
- Read the specified section from the spec file
- Analyze for completeness and clarity
- Check alignment with overall specification

**Step 2: Discussion Points**
Present: "Reviewing [SECTION NAME]. Here's what's currently defined: [summary]. Areas we could explore further: [list]. What would you like to focus on?"

**Step 3: Refinement**
Based on discussion, offer to update the section with improvements.

---

## Output Guidelines

### Communication Style
- **Interactive**: Always present ideas for discussion, not final decisions
- **Incremental**: Build understanding progressively through conversation
- **Confirmatory**: Seek explicit approval before writing to spec files
- **Educational**: Explain trade-offs and implications of choices

### Specification Format
- **NO CODE SAMPLES**: Specifications describe what, not how
- **Clear Structure**: Use consistent formatting and organization
- **Decision Context**: Document why choices were made
- **Future-Friendly**: Design for maintainability and extension

### Progress Tracking
- Update TodoWrite with section completion status
- Mark completed sections in specification file
- Provide clear progress indicators to user

## Error Handling

**If requirements are unclear**:
- State specifically what information is missing
- Ask targeted questions to fill gaps
- Provide examples of the type of information needed

**If user seems uncertain**:
- Offer to explore options together
- Provide pros/cons of different approaches
- Suggest starting simple and evolving

**If scope seems too large**:
- Suggest breaking into phases
- Identify MVP vs future enhancements
- Recommend starting with core user flows

## Best Practices

1. **Listen First**: Understand user intent before proposing solutions
2. **Explain Trade-offs**: Help users make informed decisions
3. **Stay Focused**: Keep discussions on current section, note future topics
4. **Validate Understanding**: Summarize and confirm before proceeding
5. **Document Decisions**: Capture the "why" behind choices made
6. **Progressive Disclosure**: Introduce complexity gradually as needed

Remember: The goal is collaborative design through conversation, not automated specification generation. Every section should feel jointly created through dialogue.