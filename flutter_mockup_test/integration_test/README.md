# Integration Tests - Client Questionnaire Flow

This directory contains integration tests for the Phase 1 implementation of the Client Questionnaire Flow feature.

## Overview

The integration tests validate:
- ✅ Welcome page UI components and branding
- ✅ Navigation flow from mockup selection to questionnaire
- ✅ Questionnaire page UI elements and interactions
- ✅ Progress indicator and section display
- ✅ Sample data rendering and chat interface
- ✅ Question input components and user interactions
- ✅ Edit functionality dialogs (Phase 1 placeholders)
- ✅ Back navigation and flow continuity

## Test Structure

```
integration_test/
├── client_questionnaire_flow_test.dart    # Main test suite
├── test_driver/
│   └── integration_test.dart              # Test driver configuration
└── README.md                              # This documentation
```

## Running Tests

### Prerequisites
- Flutter SDK installed and in PATH
- Chrome browser available
- Project dependencies installed (`flutter pub get`)

### Quick Start

**Windows:**
```bash
test_scripts\run_integration_tests.bat
```

**Mac/Linux:**
```bash
./test_scripts/run_integration_tests.sh
```

### Manual Execution

1. **Clean and prepare:**
   ```bash
   flutter clean
   flutter pub get
   flutter build web
   ```

2. **Start ChromeDriver (in separate terminal):**
   ```bash
   chromedriver --port=4444
   ```

3. **Run integration tests (in project terminal):**
   ```bash
   flutter drive --driver=test_driver/integration_test.dart --target=integration_test/client_questionnaire_flow_test.dart -d chrome
   ```

## Test Scenarios

### 1. Welcome Page Validation
- **Test**: `Welcome page UI elements and navigation`
- **Validates**: Branding, content, section preview, start button
- **Flow**: Mockup selection → Welcome page → Questionnaire page

### 2. Branding and Content
- **Test**: `Welcome page branding and content validation`
- **Validates**: Header elements, time estimates, section icons
- **Coverage**: All static content matches design spec

### 3. Questionnaire UI Components
- **Test**: `Questionnaire page UI components and interactions`
- **Validates**: Progress indicator, completed sections, current question
- **Coverage**: Chat interface, sample data display

### 4. User Interactions
- **Test**: `Question input interaction and response handling`
- **Validates**: Single select questions, submit functionality
- **Coverage**: Phase 1 placeholder responses

### 5. Edit Functionality
- **Test**: `Edit functionality dialog`
- **Validates**: Edit button interaction, placeholder dialog
- **Coverage**: Phase 4 preparation (currently shows placeholder)

### 6. Navigation Flow
- **Test**: `Navigation flow and back button functionality`
- **Validates**: Forward/backward navigation, route management
- **Coverage**: Complete user journey integrity

## Phase 1 Implementation Notes

### Current Test Coverage
- ✅ **Static UI Components**: All widgets render correctly
- ✅ **Navigation Flow**: App routing works as designed
- ✅ **Sample Data**: Hardcoded data displays properly
- ✅ **User Interactions**: Basic input handling (placeholder responses)
- ✅ **Design System**: Material 3 theme and styling consistency

### Phase 1 Limitations (Expected)
- **Dynamic Data Loading**: Tests use hardcoded sample data
- **State Management**: No actual response persistence
- **Form Validation**: Basic input capture only
- **Edit Functionality**: Placeholder dialogs only

### Test Environment
- **Platform**: Web (Chrome)
- **Renderer**: HTML (for compatibility)
- **Test Framework**: `integration_test` package
- **Target**: Phase 1 static implementation

## Continuous Integration

These tests validate that the Phase 1 foundation is solid and ready for Phase 2 dynamic implementation. All tests should pass with the current static implementation.

### Success Criteria
- All UI components render without errors
- Navigation flows work correctly
- Sample data displays as expected
- User interactions trigger appropriate responses
- No runtime exceptions or widget errors

## Troubleshooting

### Common Issues

1. **Chrome not found**
   - Ensure Chrome is installed and accessible
   - Alternative: Use `flutter run -d web-server` for local testing

2. **Flutter web build errors**
   - Run `flutter clean && flutter pub get`
   - Check that web support is enabled: `flutter config --enable-web`

3. **Test timeouts**
   - Increase timeout in test configuration if needed
   - Check network connectivity for web asset loading

4. **Widget not found errors**
   - Verify that UI changes haven't modified widget keys/text
   - Update test expectations to match current implementation

### Debug Mode

For development and debugging, run tests with verbose output:
```bash
# Terminal 1: Start ChromeDriver
chromedriver --port=4444

# Terminal 2: Run tests with verbose output
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/client_questionnaire_flow_test.dart -d chrome --verbose
```

## Next Steps (Phase 2)

When implementing Phase 2 dynamic features, update tests to validate:
- [ ] JSON configuration loading
- [ ] Dynamic question progression
- [ ] Response state management
- [ ] Local persistence
- [ ] Progress saving/resuming
- [ ] Form validation and error handling