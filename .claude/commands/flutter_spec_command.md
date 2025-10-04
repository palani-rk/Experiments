# Flutter Design Spec Generator

## Command: `/flutter-spec`

Save this file as `.claude/commands/flutter-spec.md` in your project directory.

---
allowed-tools: Read, Glob, Grep, Bash(flutter analyze:*), Bash(dart format:*)
argument-hint: [mode] [target-file]
description: Generate or review comprehensive Flutter design specifications with Riverpod state management
model: Claude Sonnet
---

# Flutter Design Spec Generator

Generate or review comprehensive Flutter design specifications from requirements, including widgets, Riverpod state management, data models, and services.

## Usage
- **Generate**: `/flutter-spec generate` or `/flutter-spec gen`
- **Review**: `/flutter-spec review @design-spec.md`

## Current Context
- Requirements: Check @requirements.md if exists
- Existing specs: Look for design_spec_*.md files
- Codebase patterns: Scan lib/ for established patterns

## Mode Selection

Analyze $ARGUMENTS to determine mode:
- If first argument is "generate" or "gen" → Generate mode
- If first argument is "review" → Review mode with file at $2
- If no arguments → Ask which mode to use

## GENERATE MODE

### Step 1: Context Analysis
First, scan the workspace for existing patterns:

1. Check for @pubspec.yaml to understand dependencies and versions
2. Look for existing patterns in:
   - `lib/providers/` - Riverpod patterns
   - `lib/models/` - Model structures  
   - `lib/services/` - Service patterns
   - `lib/screens/` or `lib/features/` - Widget patterns
3. Check for CLAUDE.md or README.md for project conventions

### Step 2: Documentation Research
Based on requirements, search official documentation:

**Flutter Documentation**:
- Search https://api.flutter.dev for appropriate widgets
- Check Material 3 guidelines for design patterns
- Verify widget properties and best practices
- Look up performance recommendations for lists/animations

**Riverpod Documentation**:
- Search https://riverpod.dev for current syntax (v2.x)
- Verify provider patterns (AsyncNotifier vs StateNotifier)
- Check code generation syntax if using riverpod_generator
- Look up proper disposal and family patterns

**Package Documentation**:
- For any third-party packages mentioned in requirements
- Verify latest versions and breaking changes
- Check compatibility with Flutter/Dart versions

### Step 3: Requirements Gathering

Read requirements from (in order of priority):
1. @requirements.md if exists
2. User-provided requirements in conversation
3. README.md for project overview if no requirements found

### Step 4: Complexity Assessment

Classify the requirements as:
- **Simple**: Single screen CRUD, basic forms, no offline/realtime
- **Medium**: Multi-screen flows, complex validation, API integration
- **Complex**: Offline sync, real-time updates, complex state dependencies

### Step 5: Clarifying Questions

Ask ONLY relevant questions (max 3-5) based on gaps:

**Always consider**:
- "What are the main user actions and their expected outcomes?"
- "What happens when operations fail?"

**Conditional questions**:
- If forms: "What validation rules apply?"
- If lists: "Do you need pagination or infinite scroll?"  
- If multi-step: "Can users navigate freely between steps?"
- If external data: "What's the caching strategy?"

Wait for answers before proceeding.

### Step 6: Generate Specification with Documentation-Based Code

Create `design_spec_[feature_name].md` with:

```markdown
# Flutter Design Specification: [Feature Name]

**Generated**: [Date]
**Complexity**: [Simple/Medium/Complex]
**Requirements Source**: [requirements.md or inline]
**Flutter Version**: [from pubspec.yaml]
**Riverpod Version**: [from pubspec.yaml]

---

# CORE SPECIFICATIONS (Always Included)

## 1. Overview

| Field | Details |
|---|---|
| Feature Name | [Name from requirements] |
| User Goal | [Primary objective in user's words] |
| Success Metrics | [Measurable outcomes] |
| In Scope | [Features to include] |
| Out of Scope | [Explicitly excluded items] |
| Complexity Level | [Simple/Medium/Complex with justification] |
| Key Dependencies | [Required APIs, services, packages] |

## 2. Screen Flow

| Route | Screen | Purpose | Entry Conditions | Exit/Navigation |
|---|---|---|---|---|
| `/home` | HomeScreen | Display item list | App launch or deep link | → `/details/:id`, → `/create` |
| `/details/:id` | DetailsScreen | Show item details | From list tap or deep link | ← Back to list, → `/edit/:id` |
| `/create` | CreateItemScreen | Add new item | From home FAB | ← Cancel, → Success to home |

## 3. State Management (Riverpod)

| Provider | Type | Purpose | Watchers | AutoDispose |
|---|---|---|---|---|
| `itemListProvider` | `AsyncNotifierProvider<ItemList, List<Item>>` | Manages item collection | ItemListScreen | Yes |
| `selectedItemProvider` | `Provider<Item?>` | Current selected item | DetailsScreen | Yes |
| `itemFormProvider` | `StateNotifierProvider<ItemFormState>` | Form state management | CreateItemScreen | Yes |

### Provider Implementation

\```dart
// Based on Riverpod v2.x documentation
@riverpod
class ItemList extends _$ItemList {
  @override
  Future<List<Item>> build() async {
    // Watch repository for updates
    final repository = ref.watch(itemRepositoryProvider);
    return repository.fetchAll();
  }
  
  Future<void> refresh() async {
    // Proper refresh pattern from Riverpod docs
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => 
      ref.read(itemRepositoryProvider).fetchAll()
    );
  }
  
  Future<void> addItem(Item item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(itemRepositoryProvider);
      await repository.create(item);
      return repository.fetchAll();
    });
  }
  
  Future<void> deleteItem(String id) async {
    // Optimistic update
    state = AsyncValue.data(
      state.value?.where((item) => item.id != id).toList() ?? [],
    );
    
    try {
      await ref.read(itemRepositoryProvider).delete(id);
    } catch (error, stack) {
      // Revert on error
      state = AsyncError(error, stack);
    }
  }
}
\```

## 4. Data Models

| Model | Fields | Validation | Serialization | Equality |
|---|---|---|---|---|
| `Item` | id: String, title: String, description: String?, createdAt: DateTime, status: ItemStatus | title: required, non-empty, max 100 chars | fromJson/toJson via freezed | freezed equality |
| `ItemForm` | title: String, description: String? | Same as Item | N/A | freezed equality |
| `ItemStatus` | enum: draft, published, archived | N/A | String mapping | Dart enum |

### Model Implementation

\```dart
// Using freezed as per Flutter best practices
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';
part 'item.g.dart';

@freezed
class Item with _$Item {
  const factory Item({
    required String id,
    required String title,
    String? description,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(ItemStatus.draft) ItemStatus status,
  }) = _Item;
  
  factory Item.fromJson(Map<String, dynamic> json) => 
      _$ItemFromJson(json);
}

enum ItemStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('published')  
  published,
  @JsonValue('archived')
  archived,
}
\```

## 5. Widget Structure

| Screen | Widget Tree | Key Props | Interactions |
|---|---|---|---|
| ItemListScreen | Scaffold > RefreshIndicator > ListView.builder | onRefresh, itemBuilder, itemCount | Pull refresh, tap item, FAB tap |
| DetailsScreen | Scaffold > CustomScrollView > SliverAppBar + SliverList | expandedHeight, flexibleSpace | Back navigation, edit action |
| CreateItemScreen | Scaffold > Form > Column > TextFormFields + ElevatedButton | formKey, validators, onSaved | Input text, validate, submit |

### Widget Implementation

\```dart
// Following Flutter Material 3 guidelines
class ItemListScreen extends ConsumerWidget {
  const ItemListScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemListProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
            tooltip: 'Filter items',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(itemListProvider.future),
        child: itemsAsync.when(
          data: (items) => items.isEmpty 
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No items yet',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      onPressed: () => context.push('/create'),
                      child: const Text('Create your first item'),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(item.title[0].toUpperCase()),
                      ),
                      title: Text(item.title),
                      subtitle: Text(
                        item.description ?? 'No description',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Chip(
                        label: Text(item.status.name),
                        visualDensity: VisualDensity.compact,
                      ),
                      onTap: () => context.push('/details/${item.id}'),
                    ),
                  );
                },
              ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: ErrorDisplay(
              error: error,
              onRetry: () => ref.invalidate(itemListProvider),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create'),
        label: const Text('Add Item'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
\```

## 6. API Requirements

| Endpoint | Method | Request | Response | Error Codes |
|---|---|---|---|---|
| `/api/items` | GET | Query params: page, limit, sort | `{items: List<Item>, total: int}` | 401, 500 |
| `/api/items/:id` | GET | - | `Item` | 404, 401, 500 |
| `/api/items` | POST | `ItemForm` | `Item` | 400, 401, 500 |
| `/api/items/:id` | PUT | `ItemForm` | `Item` | 400, 404, 401, 500 |
| `/api/items/:id` | DELETE | - | `{success: bool}` | 404, 401, 500 |

## 7. Services/Repositories

| Service | Methods | Return Type | Error Handling | Notes |
|---|---|---|---|---|
| ItemRepository | fetchAll(), fetchById(id), create(form), update(id, form), delete(id) | Future<T> | Throws custom exceptions | Handles API calls |
| CacheService | get(key), set(key, value), clear() | T? | Returns null on error | Memory + disk cache |
| AuthService | getCurrentUser(), refreshToken() | User? | Throws AuthException | Singleton pattern |

### Repository Implementation

\```dart
@riverpod
ItemRepository itemRepository(ItemRepositoryRef ref) {
  final dio = ref.watch(dioProvider);
  return ItemRepository(dio);
}

class ItemRepository {
  final Dio _dio;
  
  ItemRepository(this._dio);
  
  Future<List<Item>> fetchAll({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/api/items',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      
      final items = (response.data['items'] as List)
          .map((json) => Item.fromJson(json))
          .toList();
          
      return items;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Exception _handleError(DioException error) {
    if (error.response?.statusCode == 401) {
      return UnauthorizedException();
    }
    return NetworkException(error.message ?? 'Network error');
  }
}
\```

---

# EXTENDED SPECIFICATIONS (Based on Complexity)

[Include for Medium and Complex projects]

## 8. Navigation & Routing

| Route Pattern | Deep Link | Guards | Transition | Back Behavior |
|---|---|---|---|---|
| `/item/:id` | `app://items/{id}` | Auth required | Material slide | Pop to list |
| `/item/:id/edit` | `app://items/{id}/edit` | Auth + owner check | Modal sheet | Save prompt |
| `/search?q=:query` | `app://search?q={query}` | None | Fade | Preserve query |

### Router Configuration

\```dart
// Using go_router as per Flutter navigation best practices
@riverpod
GoRouter router(RouterRef ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/home',
    refreshListenable: authState,
    redirect: (context, state) {
      final isAuthenticated = authState.value != null;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      
      if (!isAuthenticated && !isAuthRoute) {
        return '/auth/login?from=${state.matchedLocation}';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => const ItemListScreen(),
        routes: [
          GoRoute(
            path: 'details/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return DetailsScreen(itemId: id);
            },
          ),
        ],
      ),
    ],
  );
}
\```

## 9. Error Handling Strategy

| Error Type | User Feedback | Recovery Action | Logging | Retry Policy |
|---|---|---|---|---|
| Network Error | SnackBar with retry | Retry button | Error + stack | Exponential backoff |
| Validation Error | Inline field error | Fix and resubmit | Warning | Immediate |
| Auth Error | Dialog + redirect | Re-login | Info | After refresh |
| Server Error | Full screen error | Contact support | Critical | Manual only |

## 10. Form Controllers

| Controller | Fields | Validation Rules | Submission Flow |
|---|---|---|---|
| ItemFormController | title, description | title: required, 3-100 chars; description: optional, max 500 | Validate → Show loading → API call → Handle response |

### Form Controller Implementation

\```dart
@riverpod
class ItemFormController extends _$ItemFormController {
  @override
  FutureOr<void> build() => null;
  
  Future<void> submit(ItemForm form) async {
    // Validate
    if (!_validate(form)) {
      state = AsyncError(
        ValidationException('Please check your input'),
        StackTrace.current,
      );
      return;
    }
    
    // Submit with loading state
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(itemRepositoryProvider);
      final item = await repository.create(form);
      
      // Invalidate list to refresh
      ref.invalidate(itemListProvider);
      
      // Navigate on success
      if (context.mounted) {
        context.go('/details/${item.id}');
      }
    });
  }
  
  bool _validate(ItemForm form) {
    return form.title.isNotEmpty && 
           form.title.length >= 3 &&
           form.title.length <= 100;
  }
}
\```

[Include for Complex projects only]

## 11. Business Logic Controllers

| Controller | State Type | Methods | Side Effects | Concurrency |
|---|---|---|---|---|
| SyncController | AsyncValue<SyncStatus> | syncAll(), syncItem(id) | Updates cache, notifications | Queue-based |
| FilterController | FilterState | applyFilter(), clearFilter() | Updates item list | Debounced |

## 12. Caching Strategy

| Data Type | Cache Duration | Refresh Trigger | Offline Behavior | Storage |
|---|---|---|---|---|
| Item List | 5 minutes | Pull-to-refresh, focus, CRUD | Show cached with indicator | Memory + Hive |
| Item Details | 10 minutes | Manual refresh | Show cached | Memory only |
| User Profile | Session | Login/logout | Required for offline | Secure storage |

## 13. Performance Optimizations

| Area | Technique | Implementation | Measurement |
|---|---|---|---|
| List Rendering | Virtualization | ListView.builder with keys | Frame rendering time |
| Images | Lazy loading | CachedNetworkImage with placeholder | Memory usage |
| State Updates | Selective rebuilds | Consumer for specific providers | Rebuild count |
| Navigation | Preloading | Prefetch next likely screen | Route transition time |

## 14. Testing Strategy

| Test Type | Coverage Target | Key Scenarios | Tools |
|---|---|---|---|
| Unit Tests | 90% business logic | Models, controllers, services | mockito, faker |
| Widget Tests | 80% UI components | User flows, interactions | flutter_test, golden |
| Integration | Critical paths | Auth, CRUD, sync | integration_test |
| E2E | Happy paths | Full user journeys | patrol |

### Test Examples

\```dart
// Widget test example
testWidgets('ItemListScreen shows items', (tester) async {
  final items = [
    Item(id: '1', title: 'Test Item', createdAt: DateTime.now()),
  ];
  
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        itemListProvider.overrideWith(() => 
          AsyncValue.data(items),
        ),
      ],
      child: const MaterialApp(
        home: ItemListScreen(),
      ),
    ),
  );
  
  expect(find.text('Test Item'), findsOneWidget);
});
\```

## 15. Accessibility Checklist

| Feature | Implementation | Testing Method | WCAG Level |
|---|---|---|---|
| Screen readers | Semantics widgets, labels | TalkBack/VoiceOver | AA |
| Keyboard nav | Focus management, tab order | Tab traversal test | AA |
| Color contrast | 4.5:1 for normal text | Contrast analyzer | AA |
| Touch targets | Min 48x48 dp | Layout inspector | AA |
| Animations | Respect reduce motion | Settings testing | AA |

## 16. Localization Support

| Area | Implementation | Languages | Fallback |
|---|---|---|---|
| UI Text | Flutter intl package | en, es, fr | English |
| Date/Time | intl DateFormat | User locale | ISO format |
| Numbers | NumberFormat | User locale | Invariant |
| Validation Messages | Localized strings | All supported | English |

---

# Package Recommendations

Based on the requirements and Flutter best practices:

## Required Packages
- **State Management**: `flutter_riverpod: ^2.5.0` + `riverpod_generator`
- **Routing**: `go_router: ^14.0.0` - Official Flutter navigation solution
- **Models**: `freezed: ^2.5.0` + `json_annotation` - Immutable models
- **HTTP**: `dio: ^5.4.0` - Advanced HTTP client with interceptors

## Recommended Packages
- **Forms**: `flutter_form_builder: ^9.3.0` - Comprehensive form solution
- **Storage**: `hive_flutter: ^1.1.0` - Fast key-value database
- **Images**: `cached_network_image: ^3.3.0` - Image caching
- **Validation**: `form_builder_validators: ^9.1.0` - Pre-built validators

## Development Packages
- **Testing**: `mockito: ^5.4.0`, `golden_test: ^0.15.0`
- **Linting**: `very_good_analysis: ^5.1.0`
- **Generation**: `build_runner: ^2.4.0`

---

# Consistency Notes

[Auto-generated based on codebase scan]

## Existing Patterns Detected
- File structure: features/[feature_name]/[presentation, domain, data]
- Naming: camelCase for variables, PascalCase for classes
- State: AsyncNotifierProvider for async operations
- Models: Freezed with json_serialization

## Deviations from Project Standards
- [List any inconsistencies with existing code]

## Migration Considerations
- [Note any breaking changes or refactoring needed]

---

# Implementation Checklist

- [ ] Create required models with freezed
- [ ] Set up Riverpod providers
- [ ] Implement repository layer
- [ ] Build UI screens
- [ ] Add navigation routing
- [ ] Implement error handling
- [ ] Add loading states
- [ ] Create empty states
- [ ] Add pull-to-refresh
- [ ] Implement forms with validation
- [ ] Add accessibility labels
- [ ] Write unit tests
- [ ] Write widget tests
- [ ] Test error scenarios
- [ ] Verify deep linking
- [ ] Check offline behavior
- [ ] Performance testing
- [ ] Accessibility audit
```

For **Medium complexity**, include sections 8-10.
For **Complex**, include all sections 8-16.

### Step 7: Package Recommendations

Search pub.dev and documentation for appropriate packages:
- **Forms**: Research `flutter_form_builder` vs `reactive_forms`
- **Navigation**: Check `go_router` latest patterns for deep linking
- **Storage**: Compare `hive`, `drift`, `isar` for offline needs
- **Images**: Verify `cached_network_image` vs `extended_image`
- **State**: Confirm Riverpod version and generation setup

Include links to documentation for each recommended package.

### Step 8: Consistency Check

Note any deviations from existing patterns:
- File structure differences
- Naming convention conflicts
- State management pattern variations

## REVIEW MODE

### Step 1: Load Existing Spec

Read the specified design spec file from $2 or prompt for file path.

### Step 2: Codebase Analysis

Scan actual implementation to compare:
1. Check implemented screens vs specified
2. Compare providers with spec
3. Verify models match specification
4. Check API integration

### Step 3: Quality Checks

Evaluate against criteria:

**Completeness**:
- [ ] All user flows have screens
- [ ] State covers all UI states  
- [ ] Error scenarios handled
- [ ] Models include all fields

**Code Quality**:
- [ ] No circular dependencies
- [ ] Proper provider disposal
- [ ] Consistent patterns
- [ ] Performance considered

**Accuracy**:
- [ ] Imports are correct
- [ ] Riverpod syntax matches version
- [ ] Types match correctly

### Step 4: Generate Review Report

Append to existing spec:

```markdown
## Review Notes
**Reviewed**: [Date]

### ✅ Implemented Correctly
- [List what matches spec]

### ⚠️ Deviations Found
- [List differences]

### 🐛 Issues Identified
- [List problems]

### 💡 Suggested Improvements
- [List recommendations]

### 📋 Action Items
1. [Prioritized fixes]
```

## Output Guidelines

1. **Always include code snippets** that compile
2. **Use actual Flutter/Riverpod syntax** for the version in pubspec
3. **Reference existing patterns** from the codebase
4. **Keep tables concise** but complete
5. **Include only relevant sections** based on complexity
6. **Provide actionable feedback** in review mode

## Error Handling

If requirements are unclear:
- State what's missing
- Ask for specific clarification
- Provide example of what's needed

If no requirements found:
- Check README.md
- Look for user stories in docs/
- Ask user to provide requirements

## Best Practices

1. **Always search documentation**: 
   - Flutter docs for widget properties and best practices
   - Riverpod docs for current patterns and syntax
   - Package docs for latest API changes
2. **Verify code accuracy**: Test snippets against current package versions
3. **Start simple**: Core tables first, extend as needed
4. **Show, don't tell**: Include working code snippets from docs
5. **Be consistent**: Follow project conventions
6. **Stay practical**: Focus on implementation details
7. **Think ahead**: Consider testing and maintenance

## Documentation Resources

When generating specs, reference these resources:
- **Flutter Widgets**: https://api.flutter.dev/flutter/widgets/widgets-library.html
- **Material Design**: https://m3.material.io/develop/flutter
- **Riverpod**: https://riverpod.dev/docs/getting_started
- **Flutter Cookbook**: https://docs.flutter.dev/cookbook
- **Effective Dart**: https://dart.dev/effective-dart
- **Flutter Performance**: https://docs.flutter.dev/perf/best-practices

Remember: The goal is to create a specification with accurate, documentation-based code that a developer (or AI) can implement directly without ambiguity.