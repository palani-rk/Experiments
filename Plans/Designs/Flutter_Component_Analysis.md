# Flutter Component Breakdown for Client Onboarding Questionnaire

## Design Overview
Based on the UX flow design and specification, this is a conversational questionnaire interface with:
- Chat-style message bubbles
- Progressive disclosure (one question at a time)
- Inline editing capabilities
- Progress tracking
- Section grouping with visual containers
- Mobile-first responsive design

## Identified Components:

### 1. **App Header with Logo & Title**
- **Option A**: `AppBar` - Standard Material 3 app bar with leading logo and title
- **Option B**: `SliverAppBar` - Collapsible header that can shrink on scroll
- **Option C**: `Container` with custom styling - Full control over branding and layout

### 2. **Progress Indicator**
- **Option A**: `LinearProgressIndicator` - Clean horizontal progress bar with percentage
- **Option B**: `StepperProgressIndicator` (custom) - Shows current section name with progress
- **Option C**: `CircularProgressIndicator` with text - Compact circular indicator

### 3. **Chat Messages Container**
- **Option A**: `ListView.builder` - Scrollable list of message widgets
- **Option B**: `SingleChildScrollView` with `Column` - Simple scrollable column layout
- **Option C**: `CustomScrollView` with `SliverList` - Advanced scrolling with sliver effects

### 4. **Bot Message Bubble**
- **Option A**: `Card` with custom styling - Material 3 elevated surface with shadow
- **Option B**: `Container` with `BoxDecoration` - Full custom styling control
- **Option C**: `ChatBubble` (custom widget) - Purpose-built chat bubble component

### 5. **User Response Bubble**
- **Option A**: `ListTile` - Simple tile with text and trailing edit button
- **Option B**: `Card` with `Row` layout - Custom card with text and action button
- **Option C**: `InkWell` wrapped `Container` - Custom interactive response bubble

### 6. **Section Grouping Container**
- **Option A**: `Card` with custom border - Material 3 card with section styling
- **Option B**: `Container` with `BoxDecoration` - Custom border and background styling
- **Option C**: `ExpansionTile` - Collapsible section that can be expanded/collapsed

### 7. **Current Question Input Field**
- **Option A**: `TextFormField` - Material 3 input with validation and styling
- **Option B**: `TextField` with `InputDecoration` - Basic text input with custom decoration
- **Option C**: `CupertinoTextField` - iOS-style input for consistent look

### 8. **Input Type Variants**
- **Single Select**: `RadioListTile` or `SegmentedButton` or `DropdownButtonFormField`
- **Multi Select**: `CheckboxListTile` or `FilterChip` or `ChoiceChip`
- **Number Input**: `TextFormField` with `keyboardType: TextInputType.number`
- **Unit Selector**: `DropdownButton` or `PopupMenuButton` or `SegmentedButton`

### 9. **Edit Button for Responses**
- **Option A**: `IconButton` - Simple edit icon button
- **Option B**: `TextButton` - Text-based edit button
- **Option C**: `OutlinedButton` - Outlined button for better visibility

### 10. **Submit/Continue Button**
- **Option A**: `ElevatedButton` - Primary Material 3 elevated button
- **Option B**: `FilledButton` - Material 3 filled button variant
- **Option C**: `FloatingActionButton` - Floating action for next question

### 11. **Section Completion Celebration**
- **Option A**: `Card` with celebration styling - Elevated card with success styling
- **Option B**: `Banner` - Material 3 banner component for notifications
- **Option C**: `SnackBar` - Temporary celebration message overlay

### 12. **Loading States**
- **Option A**: `CircularProgressIndicator` - Standard Material loading spinner
- **Option B**: `LinearProgressIndicator` - Horizontal loading bar
- **Option C**: `Shimmer` effect (custom) - Skeleton loading animation

## Layout Architecture Options:

### **Option A**: Card-Based Layout
- Each message is a `Card` widget
- Clean Material 3 elevation and shadows
- Good for visual separation

### **Option B**: Chat Bubble Layout  
- Custom chat bubble widgets
- More authentic messaging app feel
- Better for conversational UX

### **Option C**: List-Based Layout
- Uses `ListTile` for messages
- More compact and efficient
- Better for data-heavy forms

## Responsive Design Considerations:
- `MediaQuery` for screen size detection
- `LayoutBuilder` for responsive widget sizing  
- `Flexible` and `Expanded` for dynamic layouts
- `SafeArea` for proper screen edge handling