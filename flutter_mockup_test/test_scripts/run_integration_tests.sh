#!/bin/bash

# Script to run integration tests for Client Questionnaire Flow
# Runs the app in Chrome for web-based integration testing

echo "🧪 Starting Client Questionnaire Flow Integration Tests"
echo "📱 Target: Chrome (Web)"
echo ""

# Ensure we're in the correct directory
cd "$(dirname "$0")/.."

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please ensure Flutter is installed and in PATH."
    exit 1
fi

# Check if Chrome is available
if ! command -v google-chrome &> /dev/null && ! command -v chromium &> /dev/null; then
    echo "⚠️  Chrome not found in PATH. Attempting to use system default browser."
fi

echo "🔧 Cleaning previous builds..."
flutter clean
flutter pub get

echo ""
echo "🏗️  Building for web..."
flutter build web

echo ""
echo "🚀 Starting ChromeDriver..."
echo "   Starting WebDriver on port 4444..."

# Start ChromeDriver in background
"C:/MOonShot/My Projects/NutriApp_Research/chromedriver/win64-140.0.7339.207/chromedriver-win64/chromedriver.exe" --port=4444 &
CHROMEDRIVER_PID=$!

echo "   Waiting for ChromeDriver to initialize..."
sleep 3

echo ""
echo "🧪 Running integration tests in Chrome..."
echo "   This will:"
echo "   • Launch the app in Chrome via WebDriver"
echo "   • Test welcome page UI and navigation"
echo "   • Test questionnaire page components"
echo "   • Verify user interactions"
echo ""

# Run integration tests on Chrome using flutter drive
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/client_questionnaire_flow_test.dart -d chrome

# Store test result
TEST_RESULT=$?

# Kill ChromeDriver process
echo ""
echo "🧹 Cleaning up ChromeDriver..."
kill $CHROMEDRIVER_PID 2>/dev/null

# Check test results
if [ $TEST_RESULT -eq 0 ]; then
    echo ""
    echo "✅ Integration tests completed successfully!"
    echo "📊 All Phase 1 UI components and navigation flows validated"
else
    echo ""
    echo "❌ Integration tests failed"
    echo "💡 Check the output above for specific test failures"
    exit 1
fi