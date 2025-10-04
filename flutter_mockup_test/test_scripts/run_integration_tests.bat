@echo off
REM Script to run integration tests for Client Questionnaire Flow (Windows)
REM Runs the app in Chrome for web-based integration testing

echo 🧪 Starting Client Questionnaire Flow Integration Tests
echo 📱 Target: Chrome (Web)
echo.

REM Change to project directory
cd /d "%~dp0\.."

REM Check if Flutter is available
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter not found. Please ensure Flutter is installed and in PATH.
    pause
    exit /b 1
)

echo 🔧 Cleaning previous builds...
flutter clean
flutter pub get

echo.
echo 🏗️ Building for web...
flutter build web

echo.
echo 🚀 Starting ChromeDriver...
echo    Starting WebDriver on port 4444...

REM Start ChromeDriver in background
start /B "ChromeDriver" "C:\MOonShot\My Projects\NutriApp_Research\chromedriver\win64-140.0.7339.207\chromedriver-win64\chromedriver.exe" --port=4444

echo    Waiting for ChromeDriver to initialize...
timeout /t 3 /nobreak > nul

echo.
echo 🧪 Running integration tests in Chrome...
echo    This will:
echo    • Launch the app in Chrome via WebDriver
echo    • Test welcome page UI and navigation
echo    • Test questionnaire page components
echo    • Verify user interactions
echo.

REM Run integration tests on Chrome using flutter drive
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/client_questionnaire_flow_test.dart -d chrome

REM Kill ChromeDriver process
echo.
echo 🧹 Cleaning up ChromeDriver...
taskkill /F /IM chromedriver.exe > nul 2>&1

REM Check test results
if errorlevel 1 (
    echo.
    echo ❌ Integration tests failed
    echo 💡 Check the output above for specific test failures
    pause
    exit /b 1
) else (
    echo.
    echo ✅ Integration tests completed successfully!
    echo 📊 All Phase 1 UI components and navigation flows validated
    pause
)