# Backend API Integration Specification
## Client Onboarding Questionnaire - Flutter Service Layer

**Document Version**: 1.0
**Generated**: 2025-01-26
**Purpose**: API service implementation specification for Flutter frontend
**Related Documents**:
- [Backend API Data Models Spec](Backend_API_Data_Models_Spec.md)
- [Backend API Requirements Spec](Backend_API_Requirements_Spec_Phase6.md)

---

## Table of Contents
1. [Overview](#1-overview)
2. [Service Architecture](#2-service-architecture)
3. [API Service Implementations](#3-api-service-implementations)
4. [Error Handling Strategy](#4-error-handling-strategy)
5. [Provider Integration](#5-provider-integration)
6. [Implementation Checklist](#6-implementation-checklist)

---

## 1. Overview

### 1.1 Integration Approach

**Direct API Service Pattern**:
- No repository abstraction layer
- Services directly called from Riverpod providers
- Simple, straightforward implementation
- Mode switching handled at provider level if needed

### 1.2 Technology Stack

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| **HTTP Client** | `dio` | ^5.0.0 | REST API communication |
| **State Management** | `riverpod` | ^2.0.0 | Provider-based state |
| **Serialization** | `freezed` + `json_serializable` | Latest | Model serialization |
| **Error Handling** | Custom exceptions | - | Typed error handling |

### 1.3 Key Principles

- **Simplicity**: Direct service-to-provider communication
- **Type Safety**: Strongly typed models and responses
- **Error Clarity**: Clear, actionable error messages
- **Testability**: Easy to mock and test services
- **No Auto-Save**: Manual save operations only

---

## 2. Service Architecture

### 2.1 Folder Structure

```
lib/features/client_questionnaire_flow/
├── data/
│   ├── models/                        # ✅ Already exists
│   │   ├── questionnaire_config.dart
│   │   ├── question_section.dart
│   │   ├── question.dart
│   │   ├── section_response.dart
│   │   ├── response.dart
│   │   ├── questionnaire_responses_submission.dart
│   │   ├── branding_config.dart
│   │   └── enums.dart
│   │
│   └── services/                      # 🆕 New
│       ├── api_client.dart                     # HTTP client wrapper
│       ├── questionnaire_api_service.dart      # Template loading
│       ├── response_api_service.dart           # Response persistence
│       ├── branding_api_service.dart           # Branding config
│       └── exceptions.dart                     # Custom exceptions
│
├── presentation/
│   └── providers/
│       ├── questionnaire_config_provider.dart  # Uses QuestionnaireApiService
│       ├── branding_provider.dart              # Uses BrandingApiService
│       ├── response_provider.dart              # Uses ResponseApiService
│       └── api_client_provider.dart            # 🆕 Provides ApiClient
```

### 2.2 Service Dependencies

```
ApiClient (base HTTP client)
    ↓
QuestionnaireApiService → uses ApiClient
BrandingApiService → uses ApiClient
ResponseApiService → uses ApiClient
    ↓
Riverpod Providers (consume services)
    ↓
UI Widgets
```

---

## 3. API Service Implementations

### 3.1 API Client (`api_client.dart`)

**Purpose**: Base HTTP client with authentication, error handling, and interceptors

**Key Features**:
- Dio-based HTTP client
- Configurable base URL and auth token
- Request/response logging
- Automatic error transformation
- Timeout handling

**Implementation**:

```dart
import 'package:dio/dio.dart';
import 'exceptions.dart';

class ApiClient {
  final Dio _dio;
  final String baseUrl;

  ApiClient({
    required this.baseUrl,
    String? authToken,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (authToken != null) 'Authorization': 'Bearer $authToken',
            },
          ),
        ) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('[API Request] ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('[API Response] ${response.statusCode} - ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('[API Error] ${error.response?.statusCode}: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  /// Generic GET request
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );

      return fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic POST request
  Future<Map<String, dynamic>> post(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Transform Dio errors into custom exceptions
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiTimeoutException('Request timeout - please check your connection');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final message = error.response?.data?['error'] ?? 'Unknown error';

        if (statusCode == 401) {
          return ApiUnauthorizedException('Authentication required');
        } else if (statusCode == 404) {
          return ApiNotFoundException('Resource not found');
        } else if (statusCode == 409) {
          return ApiConflictException(message);
        } else if (statusCode >= 400 && statusCode < 500) {
          return ApiValidationException(message);
        } else {
          return ApiServerException('Server error: $message');
        }

      case DioExceptionType.cancel:
        return ApiCancelledException('Request cancelled');

      default:
        return ApiNetworkException('Network error: ${error.message}');
    }
  }
}
```

**Configuration**:
```dart
// Example usage in provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: 'https://api.smartconnect.example.com',
    authToken: ref.watch(authTokenProvider), // Get from auth provider
  );
});
```

---

### 3.2 Custom Exceptions (`exceptions.dart`)

**Purpose**: Typed exceptions for clear error handling

**Implementation**:

```dart
/// Base API exception
abstract class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

/// Network connectivity issues
class ApiNetworkException extends ApiException {
  ApiNetworkException(super.message);
}

/// Request timeout
class ApiTimeoutException extends ApiException {
  ApiTimeoutException(super.message);
}

/// 401 Unauthorized
class ApiUnauthorizedException extends ApiException {
  ApiUnauthorizedException(super.message);
}

/// 404 Not Found
class ApiNotFoundException extends ApiException {
  ApiNotFoundException(super.message);
}

/// 400 Bad Request / Validation errors
class ApiValidationException extends ApiException {
  ApiValidationException(super.message);
}

/// 409 Conflict (concurrent edits, already submitted)
class ApiConflictException extends ApiException {
  ApiConflictException(super.message);
}

/// 500 Server errors
class ApiServerException extends ApiException {
  ApiServerException(super.message);
}

/// Request cancelled
class ApiCancelledException extends ApiException {
  ApiCancelledException(super.message);
}
```

---

### 3.3 Questionnaire API Service (`questionnaire_api_service.dart`)

**Purpose**: Load questionnaire template from backend

**Endpoint**: `GET /api/questionnaires/{id}`

**Implementation**:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/questionnaire_config.dart';
import 'api_client.dart';

part 'questionnaire_api_service.g.dart';

class QuestionnaireApiService {
  final ApiClient _apiClient;

  QuestionnaireApiService(this._apiClient);

  /// Load questionnaire template from backend
  ///
  /// Returns: QuestionnaireConfig with all sections and questions
  /// Throws: ApiException on failure
  Future<QuestionnaireConfig> loadQuestionnaire(String questionnaireId) async {
    return await _apiClient.get<QuestionnaireConfig>(
      '/api/questionnaires/$questionnaireId',
      fromJson: (json) => QuestionnaireConfig.fromJson(json),
    );
  }
}

/// Provider for QuestionnaireApiService
@riverpod
QuestionnaireApiService questionnaireApiService(QuestionnaireApiServiceRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return QuestionnaireApiService(apiClient);
}
```

**Usage Example**:
```dart
// In a provider
final questionnaireConfigProvider = FutureProvider<QuestionnaireConfig>((ref) async {
  final service = ref.watch(questionnaireApiServiceProvider);
  return await service.loadQuestionnaire('nutrition_onboarding_v1');
});
```

---

### 3.4 Branding API Service (`branding_api_service.dart`)

**Purpose**: Load clinic/nutritionist branding configuration

**Endpoint**: `GET /api/branding/config`

**Implementation**:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/branding_config.dart';
import 'api_client.dart';

part 'branding_api_service.g.dart';

class BrandingApiService {
  final ApiClient _apiClient;

  BrandingApiService(this._apiClient);

  /// Load branding configuration from backend
  ///
  /// Returns: BrandingConfig with logo, colors, and personalization
  /// Throws: ApiException on failure
  Future<BrandingConfig> loadBrandingConfig() async {
    return await _apiClient.get<BrandingConfig>(
      '/api/branding/config',
      fromJson: (json) => BrandingConfig.fromJson(json),
    );
  }
}

/// Provider for BrandingApiService
@riverpod
BrandingApiService brandingApiService(BrandingApiServiceRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BrandingApiService(apiClient);
}
```

**Usage Example**:
```dart
// In a provider
final brandingConfigProvider = FutureProvider<BrandingConfig>((ref) async {
  final service = ref.watch(brandingApiServiceProvider);
  return await service.loadBrandingConfig();
});
```

---

### 3.5 Response API Service (`response_api_service.dart`)

**Purpose**: Save section responses and submit final questionnaire

**Endpoints**:
- `POST /api/questionnaires/{qId}/sections/{sectionId}/responses`
- `GET /api/users/{userId}/responses?questionnaireId={qId}`
- `POST /api/questionnaires/{qId}/submit`

**Implementation**:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/section_response.dart';
import '../models/questionnaire_responses_submission.dart';
import '../models/enums.dart';
import 'api_client.dart';

part 'response_api_service.g.dart';

class ResponseApiService {
  final ApiClient _apiClient;

  ResponseApiService(this._apiClient);

  /// Save section responses to backend
  ///
  /// Called when:
  /// - User completes a section
  /// - User manually saves progress
  ///
  /// Parameters:
  /// - questionnaireId: ID of the questionnaire
  /// - sectionId: ID of the section being saved
  /// - userId: Current user's ID
  /// - sectionResponse: Complete section response data
  ///
  /// Throws: ApiException on failure
  Future<void> saveSectionResponse({
    required String questionnaireId,
    required String sectionId,
    required String userId,
    required SectionResponse sectionResponse,
  }) async {
    // Convert SectionResponse to API request format
    final requestData = {
      'userId': userId,
      'responses': sectionResponse.responses
          .map((response) => response.toJson())
          .toList(),
      'status': _sectionStatusToString(sectionResponse.status),
      'completedAt': sectionResponse.completedAt?.toIso8601String(),
      'savedAt': sectionResponse.savedAt.toIso8601String(),
    };

    await _apiClient.post(
      '/api/questionnaires/$questionnaireId/sections/$sectionId/responses',
      data: requestData,
    );
  }

  /// Load user's existing responses (for resume functionality)
  ///
  /// Returns: QuestionnaireResponsesSubmission with all saved section responses
  /// Returns empty submission if no responses exist
  ///
  /// Throws: ApiException on failure
  Future<QuestionnaireResponsesSubmission> loadUserResponses({
    required String userId,
    required String questionnaireId,
  }) async {
    return await _apiClient.get<QuestionnaireResponsesSubmission>(
      '/api/users/$userId/responses',
      queryParameters: {'questionnaireId': questionnaireId},
      fromJson: (json) => QuestionnaireResponsesSubmission.fromJson(json),
    );
  }

  /// Submit final questionnaire to backend
  ///
  /// Called when:
  /// - All sections completed
  /// - User confirms submission from review screen
  ///
  /// Returns: submissionId from backend
  ///
  /// Throws:
  /// - ApiValidationException if questionnaire incomplete
  /// - ApiConflictException if already submitted
  /// - ApiException for other failures
  Future<String> submitQuestionnaire({
    required QuestionnaireResponsesSubmission submission,
  }) async {
    final response = await _apiClient.post(
      '/api/questionnaires/${submission.questionnaireId}/submit',
      data: submission.toJson(),
    );

    return response['submissionId'] as String;
  }

  /// Helper: Convert SectionStatus enum to API string format
  String _sectionStatusToString(SectionStatus status) {
    switch (status) {
      case SectionStatus.notStarted:
        return 'not_started';
      case SectionStatus.inProgress:
        return 'in_progress';
      case SectionStatus.completed:
        return 'completed';
    }
  }
}

/// Provider for ResponseApiService
@riverpod
ResponseApiService responseApiService(ResponseApiServiceRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ResponseApiService(apiClient);
}
```

**Usage Example**:
```dart
// Save section when completed
Future<void> saveSection(SectionResponse response) async {
  final service = ref.read(responseApiServiceProvider);

  try {
    await service.saveSectionResponse(
      questionnaireId: 'nutrition_onboarding_v1',
      sectionId: response.sectionId,
      userId: currentUserId,
      sectionResponse: response,
    );
    // Show success message
  } on ApiValidationException catch (e) {
    // Show validation errors
  } on ApiException catch (e) {
    // Show error message with retry option
  }
}

// Load existing responses on app start
Future<void> checkForExistingResponses() async {
  final service = ref.read(responseApiServiceProvider);

  try {
    final existingResponses = await service.loadUserResponses(
      userId: currentUserId,
      questionnaireId: 'nutrition_onboarding_v1',
    );

    if (existingResponses.sectionResponses.isNotEmpty) {
      // Show "Resume" option
    }
  } on ApiNotFoundException {
    // No existing responses - start fresh
  }
}

// Submit final questionnaire
Future<void> submitFinalQuestionnaire() async {
  final service = ref.read(responseApiServiceProvider);

  try {
    final submissionId = await service.submitQuestionnaire(
      submission: currentSubmission,
    );
    // Navigate to completion screen with submissionId
  } on ApiConflictException {
    // Already submitted - navigate to completion
  } on ApiValidationException catch (e) {
    // Show incomplete sections error
  }
}
```

---

## 4. Error Handling Strategy

### 4.1 Error Types and User Messages

| Exception Type | User-Facing Message | Suggested Action |
|----------------|-------------------|------------------|
| `ApiNetworkException` | "No internet connection. Please check your network." | Show retry button |
| `ApiTimeoutException` | "Request timed out. Please try again." | Show retry button |
| `ApiUnauthorizedException` | "Your session has expired. Please log in again." | Navigate to login |
| `ApiNotFoundException` | "Questionnaire not found." | Contact support |
| `ApiValidationException` | Show specific validation errors from backend | Fix highlighted fields |
| `ApiConflictException` | "This has already been submitted." or "Another change was made." | Show current state or refresh |
| `ApiServerException` | "Something went wrong on our end. Please try again later." | Show retry button |
| `ApiCancelledException` | No message (silent) | - |

### 4.2 Error Handling Pattern

```dart
Future<void> performApiCall() async {
  try {
    // Make API call
    await service.someMethod();

  } on ApiValidationException catch (e) {
    // Show validation errors inline
    showValidationError(e.message);

  } on ApiUnauthorizedException catch (e) {
    // Redirect to login
    navigateToLogin();

  } on ApiConflictException catch (e) {
    // Show conflict resolution UI
    showConflictDialog(e.message);

  } on ApiTimeoutException catch (e) {
    // Show retry dialog
    showRetryDialog(e.message);

  } on ApiException catch (e) {
    // Generic error with retry
    showErrorDialog(
      message: e.message,
      action: 'Retry',
      onAction: () => performApiCall(),
    );
  }
}
```

### 4.3 Retry Logic

```dart
class RetryHelper {
  /// Retry a function up to maxAttempts with exponential backoff
  static Future<T> retry<T>({
    required Future<T> Function() function,
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
  }) async {
    int attempt = 0;

    while (true) {
      try {
        return await function();
      } catch (e) {
        attempt++;

        if (attempt >= maxAttempts) {
          rethrow; // Max attempts reached
        }

        // Don't retry on validation or auth errors
        if (e is ApiValidationException || e is ApiUnauthorizedException) {
          rethrow;
        }

        // Exponential backoff: 1s, 2s, 4s
        final delay = initialDelay * (1 << (attempt - 1));
        await Future.delayed(delay);
      }
    }
  }
}

// Usage
final result = await RetryHelper.retry(
  function: () => service.loadQuestionnaire(id),
  maxAttempts: 3,
);
```

---

## 5. Provider Integration

### 5.1 API Client Provider

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_client.dart';

/// Base URL provider (can be overridden for different environments)
final apiBaseUrlProvider = Provider<String>((ref) {
  // TODO: Load from environment config or build flavor
  return 'https://api.smartconnect.example.com';
});

/// Auth token provider (from authentication state)
final authTokenProvider = Provider<String?>((ref) {
  // TODO: Get from auth state provider
  return null; // Replace with actual auth token
});

/// API Client provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  final authToken = ref.watch(authTokenProvider);

  return ApiClient(
    baseUrl: baseUrl,
    authToken: authToken,
  );
});
```

### 5.2 Questionnaire Config Provider

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/questionnaire_config.dart';
import '../services/questionnaire_api_service.dart';

/// Current questionnaire ID (could be from route params or app state)
final currentQuestionnaireIdProvider = Provider<String>((ref) {
  return 'nutrition_onboarding_v1';
});

/// Questionnaire config loaded from API
final questionnaireConfigProvider = FutureProvider<QuestionnaireConfig>((ref) async {
  final service = ref.watch(questionnaireApiServiceProvider);
  final questionnaireId = ref.watch(currentQuestionnaireIdProvider);

  return await service.loadQuestionnaire(questionnaireId);
});
```

### 5.3 Branding Config Provider

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/branding_config.dart';
import '../services/branding_api_service.dart';

/// Branding config loaded from API
final brandingConfigProvider = FutureProvider<BrandingConfig>((ref) async {
  final service = ref.watch(brandingApiServiceProvider);

  return await service.loadBrandingConfig();
});
```

### 5.4 Response State Provider

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/questionnaire_responses_submission.dart';
import '../services/response_api_service.dart';

/// Current user ID provider
final currentUserIdProvider = Provider<String>((ref) {
  // TODO: Get from auth state
  return 'user_12345';
});

/// User's existing responses (for resume functionality)
final userResponsesProvider = FutureProvider<QuestionnaireResponsesSubmission>((ref) async {
  final service = ref.watch(responseApiServiceProvider);
  final userId = ref.watch(currentUserIdProvider);
  final questionnaireId = ref.watch(currentQuestionnaireIdProvider);

  try {
    return await service.loadUserResponses(
      userId: userId,
      questionnaireId: questionnaireId,
    );
  } on ApiNotFoundException {
    // No existing responses - return empty submission
    return QuestionnaireResponsesSubmission(
      questionnaireId: questionnaireId,
      userId: userId,
      sectionResponses: [],
    );
  }
});
```

---

## 6. Implementation Checklist

### 6.1 Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0

  # HTTP Client
  dio: ^5.4.0

  # Serialization (already exists)
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

dev_dependencies:
  # Code generation
  build_runner: ^2.4.0
  riverpod_generator: ^2.3.0
  freezed: ^2.4.6
  json_serializable: ^6.7.1

  # Testing
  mockito: ^5.4.0
  flutter_test:
    sdk: flutter
```

### 6.2 Implementation Steps

#### **Week 1: Core API Infrastructure**

- [ ] **Day 1-2: API Client Setup**
  - [ ] Create `api_client.dart` with Dio configuration
  - [ ] Implement error handling and interceptors
  - [ ] Create `exceptions.dart` with custom exception types
  - [ ] Set up `api_client_provider.dart`
  - [ ] Unit test ApiClient with mocked Dio

- [ ] **Day 3-4: Service Implementation**
  - [ ] Create `questionnaire_api_service.dart`
  - [ ] Create `branding_api_service.dart`
  - [ ] Create `response_api_service.dart`
  - [ ] Generate provider code with `build_runner`
  - [ ] Unit test each service with mocked ApiClient

- [ ] **Day 5: Provider Integration**
  - [ ] Set up all Riverpod providers
  - [ ] Configure base URL and auth token providers
  - [ ] Integration test with mock API responses

#### **Week 2: UI Integration & Testing**

- [ ] **Day 1-2: Provider Consumption**
  - [ ] Update existing providers to use API services
  - [ ] Replace local JSON loading with API calls
  - [ ] Handle loading states in UI
  - [ ] Handle error states in UI

- [ ] **Day 3-4: Error Handling**
  - [ ] Implement error dialog widgets
  - [ ] Add retry logic for failed requests
  - [ ] Add user-friendly error messages
  - [ ] Test all error scenarios

- [ ] **Day 5: End-to-End Testing**
  - [ ] Test complete flow from load to submission
  - [ ] Test resume functionality
  - [ ] Test error recovery
  - [ ] Performance testing

### 6.3 Code Generation Commands

```bash
# Generate provider code and freezed/json_serializable code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes during development
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 6.4 Testing Checklist

#### **Unit Tests**

- [ ] `api_client_test.dart`
  - [ ] Test successful GET requests
  - [ ] Test successful POST requests
  - [ ] Test timeout handling
  - [ ] Test 401/404/409/500 error transformations
  - [ ] Test network error handling

- [ ] `questionnaire_api_service_test.dart`
  - [ ] Test successful questionnaire loading
  - [ ] Test error handling

- [ ] `branding_api_service_test.dart`
  - [ ] Test successful branding loading
  - [ ] Test error handling

- [ ] `response_api_service_test.dart`
  - [ ] Test section save
  - [ ] Test user responses loading
  - [ ] Test final submission
  - [ ] Test all error scenarios

#### **Integration Tests**

- [ ] Test complete questionnaire flow with real API
- [ ] Test resume flow
- [ ] Test concurrent edit conflict handling
- [ ] Test network failure recovery

#### **Widget Tests**

- [ ] Test loading states display correctly
- [ ] Test error states display correctly
- [ ] Test retry buttons work
- [ ] Test navigation on errors

---

## 7. API Endpoints Reference

### 7.1 Endpoint Summary

| Operation | Endpoint | Method | Service Method | Provider |
|-----------|----------|--------|---------------|----------|
| **Load Questionnaire** | `/api/questionnaires/{id}` | GET | `QuestionnaireApiService.loadQuestionnaire()` | `questionnaireConfigProvider` |
| **Load Branding** | `/api/branding/config` | GET | `BrandingApiService.loadBrandingConfig()` | `brandingConfigProvider` |
| **Save Section** | `/api/questionnaires/{qId}/sections/{sectionId}/responses` | POST | `ResponseApiService.saveSectionResponse()` | Called from state notifiers |
| **Load User Responses** | `/api/users/{userId}/responses` | GET | `ResponseApiService.loadUserResponses()` | `userResponsesProvider` |
| **Submit Questionnaire** | `/api/questionnaires/{qId}/submit` | POST | `ResponseApiService.submitQuestionnaire()` | Called from submission logic |

### 7.2 Request/Response Examples

See [Backend API Data Models Spec - Section 6](Backend_API_Data_Models_Spec.md#6-complete-json-examples) for complete JSON examples.

---

## 8. Environment Configuration

### 8.1 Build Flavors (Future Enhancement)

```dart
// lib/config/env_config.dart

class EnvConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api-dev.smartconnect.example.com',
  );

  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );
}

// Usage in provider
final apiBaseUrlProvider = Provider<String>((ref) {
  return EnvConfig.apiBaseUrl;
});
```

### 8.2 Run Configurations

```bash
# Development
flutter run --dart-define=API_BASE_URL=https://api-dev.smartconnect.example.com

# Staging
flutter run --dart-define=API_BASE_URL=https://api-staging.smartconnect.example.com

# Production
flutter run --dart-define=API_BASE_URL=https://api.smartconnect.example.com --dart-define=ENABLE_LOGGING=false
```

---

## 9. Migration Path

### 9.1 From Local JSON to API

**Current State**: App loads from `assets/questionnaire_config.json`

**Migration Steps**:

1. **Phase 1**: Implement API services (no UI changes)
2. **Phase 2**: Add provider-level mode switching
3. **Phase 3**: Switch to API by default, keep local as fallback
4. **Phase 4**: Remove local JSON loading (after API stable)

**Provider with Fallback**:
```dart
final questionnaireConfigProvider = FutureProvider<QuestionnaireConfig>((ref) async {
  final service = ref.watch(questionnaireApiServiceProvider);
  final questionnaireId = ref.watch(currentQuestionnaireIdProvider);

  try {
    // Try API first
    return await service.loadQuestionnaire(questionnaireId);
  } catch (e) {
    // Fallback to local JSON
    print('API failed, using local fallback: $e');
    return await _loadLocalQuestionnaire();
  }
});
```

### 9.2 Testing During Migration

- Keep local JSON for UI development
- Use API in integration tests
- Feature flag to toggle between modes

---

## 10. Performance Considerations

### 10.1 Caching Strategy

```dart
// Cache questionnaire config (rarely changes)
final questionnaireConfigProvider = FutureProvider<QuestionnaireConfig>((ref) async {
  final service = ref.watch(questionnaireApiServiceProvider);
  final questionnaireId = ref.watch(currentQuestionnaireIdProvider);

  // Cache for 1 hour
  ref.cacheFor(const Duration(hours: 1));

  return await service.loadQuestionnaire(questionnaireId);
});
```

### 10.2 Request Optimization

- **Parallel Loading**: Load questionnaire + branding concurrently
- **Lazy Loading**: Only load user responses when needed
- **Debouncing**: Not needed (no auto-save)

---

## Document Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-01-26 | Initial specification - simplified API service pattern |

---

**End of Specification**
