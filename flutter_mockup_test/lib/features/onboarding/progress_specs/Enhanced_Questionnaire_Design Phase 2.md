# Enhanced Questionnaire Design Specification

## Overview
This document outlines the design for three focused enhancements to the existing questionnaire system:
1. **Branding Components** - Clinic logo, name, and nutritionist information
2. **Overall Progress Indicator** - Section-based progress tracking
3. **Completed Responses Widget** - Grouped response history with editing capability

## 🎨 **1. Branding Components Design**

### **A. Branding Data Model**

```dart
@freezed
class BrandingConfig with _$BrandingConfig {
  const factory BrandingConfig({
    @Default('NutriApp') String clinicName,
    @Default('Dr. Smith') String nutritionistName,
    String? clinicLogoUrl,
    String? nutritionistAvatarUrl,
    @Default('Welcome to your personalized nutrition journey!') String welcomeMessage,
    @Default('We\'re excited to help you achieve your health goals.') String welcomeSubtitle,
  }) = _BrandingConfig;

  factory BrandingConfig.fromJson(Map<String, dynamic> json) =>
      _$BrandingConfigFromJson(json);
}
```

### **B. Enhanced Welcome Page Layout**

```
┌─────────────────────────────────────────────┐
│                SAFE AREA                    │
├─────────────────────────────────────────────┤
│  ┌─────────────────────────────────────┐    │
│  │         BRANDING HEADER             │    │
│  │  ┌──────┐                          │    │
│  │  │ LOGO │  [Clinic Name]           │    │
│  │  │ 60x60│  Dr. [Nutritionist]      │    │
│  │  └──────┘                          │    │
│  └─────────────────────────────────────┘    │
│                                             │
│  ┌─────────────────────────────────────┐    │
│  │           MAIN CONTENT              │    │
│  │                                     │    │
│  │    🏥 [Health Icon - 80px]          │    │
│  │                                     │    │
│  │    Welcome to NutriApp              │    │
│  │    (Headline Medium, Bold)          │    │
│  │                                     │    │
│  │    [Personalized Welcome Message]   │    │
│  │    (Body Large, Center Aligned)     │    │
│  │                                     │    │
│  │    Quick assessment covers:         │    │
│  │    • Personal Info (2 mins)        │    │
│  │    • Health Goals (2 mins)         │    │
│  │    • Dietary Preferences (3 mins)   │    │
│  │    • Lifestyle (3 mins)            │    │
│  │                                     │    │
│  │  ┌─────────────────────────────┐    │    │
│  │  │     [Get Started]           │    │    │
│  │  │   (Primary Button)          │    │    │
│  │  └─────────────────────────────┘    │    │
│  └─────────────────────────────────────┘    │
└─────────────────────────────────────────────┘
```

### **C. BrandingHeader Widget Specification**

```dart
/// Displays clinic branding information at the top of screens
///
/// Features:
/// - Clinic logo (optional, with fallback to icon)
/// - Clinic name display
/// - Nutritionist name with title
/// - Consistent styling and spacing
/// - Theme-aware colors and typography
class BrandingHeader extends StatelessWidget {
  final BrandingConfig branding;
  final bool showNutritionist;
  final double? height;

  const BrandingHeader({
    super.key,
    required this.branding,
    this.showNutritionist = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height ?? 80,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.l,
        vertical: AppSizes.m,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Clinic Logo or Fallback Icon
          _buildLogo(context),

          const SizedBox(width: AppSizes.m),

          // Clinic and Nutritionist Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  branding.clinicName,
                  style: AppTextStyles.headerSubtitle.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (showNutritionist) ...[
                  const SizedBox(height: 2),
                  Text(
                    'with ${branding.nutritionistName}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    if (branding.clinicLogoUrl != null) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          child: Image.network(
            branding.clinicLogoUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(context),
          ),
        ),
      );
    }

    return _buildFallbackIcon(context);
  }

  Widget _buildFallbackIcon(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: Icon(
        Icons.local_hospital,
        size: 32,
        color: theme.colorScheme.onPrimaryContainer,
      ),
    );
  }
}
```

## 📊 **2. Overall Progress Indicator Design**

### **A. Section Progress Data Model**

```dart
@freezed
class SectionProgress with _$SectionProgress {
  const factory SectionProgress({
    required String sectionId,
    required String sectionTitle,
    required int totalQuestions,
    required int answeredQuestions,
    @Default(false) bool isCompleted,
  }) = _SectionProgress;

  const SectionProgress._();

  double get completionPercentage =>
    totalQuestions > 0 ? answeredQuestions / totalQuestions : 0.0;
}

@freezed
class OverallProgress with _$OverallProgress {
  const factory OverallProgress({
    required List<SectionProgress> sections,
    required int currentSectionIndex,
    required int currentQuestionIndex,
  }) = _OverallProgress;

  const OverallProgress._();

  double get overallPercentage {
    if (sections.isEmpty) return 0.0;

    final totalQuestions = sections.fold<int>(0, (sum, section) => sum + section.totalQuestions);
    final answeredQuestions = sections.fold<int>(0, (sum, section) => sum + section.answeredQuestions);

    return totalQuestions > 0 ? answeredQuestions / totalQuestions : 0.0;
  }

  String get progressText => '${currentSectionIndex + 1}/${sections.length}';
}
```

### **B. Enhanced Progress Indicator Layout**

```
┌─────────────────────────────────────────────┐
│           OVERALL PROGRESS BAR              │
├─────────────────────────────────────────────┤
│  Section Progress: 2/4                      │
│                                             │
│  ████████████░░░░░░░░░░░░░░░░░░░░░░░░  42%   │
│                                             │
│  ○──●──○──○  [Personal Info] [Goals]       │
│  │   │   │   │  [Health] [Lifestyle]        │
│  ✓   ●   ○   ○                             │
│                                             │
└─────────────────────────────────────────────┘
```

### **C. OverallProgressIndicator Widget Specification**

```dart
/// Enhanced progress indicator showing overall questionnaire completion
///
/// Features:
/// - Section-based progress tracking (e.g., "2/4")
/// - Visual progress bar with percentage
/// - Section completion indicators
/// - Current section highlighting
/// - Smooth animations for progress updates
class OverallProgressIndicator extends ConsumerWidget {
  final bool showSectionNames;
  final bool showPercentage;

  const OverallProgressIndicator({
    super.key,
    this.showSectionNames = false,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final overallProgress = ref.watch(overallProgressProvider);

    return Container(
      padding: const EdgeInsets.all(AppSizes.l),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Progress Label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Section Progress: ${overallProgress.progressText}',
                style: AppTextStyles.progressLabel.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (showPercentage)
                Text(
                  '${(overallProgress.overallPercentage * 100).round()}%',
                  style: AppTextStyles.progressPercent.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),

          const SizedBox(height: AppSizes.m),

          // Progress Bar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            child: LinearProgressIndicator(
              value: overallProgress.overallPercentage,
              backgroundColor: theme.colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
          ),

          if (showSectionNames) ...[
            const SizedBox(height: AppSizes.m),
            _buildSectionIndicators(context, overallProgress),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionIndicators(BuildContext context, OverallProgress progress) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: progress.sections.asMap().entries.map((entry) {
        final index = entry.key;
        final section = entry.value;
        final isCurrent = index == progress.currentSectionIndex;
        final isCompleted = section.isCompleted;

        return Expanded(
          child: Column(
            children: [
              // Section Indicator Dot
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? theme.colorScheme.primary
                      : isCurrent
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.outline,
                ),
                child: isCompleted
                    ? Icon(
                        Icons.check,
                        size: 8,
                        color: theme.colorScheme.onPrimary,
                      )
                    : null,
              ),

              const SizedBox(height: AppSizes.xs),

              // Section Name
              Text(
                section.sectionTitle,
                style: AppTextStyles.caption.copyWith(
                  color: isCurrent
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
```

## 📝 **3. Completed Responses Widget Design**

### **A. Response History Data Model**

```dart
@freezed
class CompletedResponse with _$CompletedResponse {
  const factory CompletedResponse({
    required String questionId,
    required String questionText,
    required dynamic answer,
    required String sectionId,
    required String sectionTitle,
    required DateTime answeredAt,
    @Default(false) bool isEditable,
  }) = _CompletedResponse;

  const CompletedResponse._();

  String get displayAnswer {
    if (answer is List<String>) {
      return (answer as List<String>).join(', ');
    }
    return answer?.toString() ?? '';
  }
}

@freezed
class ResponseGroup with _$ResponseGroup {
  const factory ResponseGroup({
    required String sectionId,
    required String sectionTitle,
    required List<CompletedResponse> responses,
    @Default(true) bool isExpanded,
  }) = _ResponseGroup;

  const ResponseGroup._();

  int get completedCount => responses.length;
}
```

### **B. Completed Responses Layout**

```
┌─────────────────────────────────────────────┐
│          COMPLETED RESPONSES                │
├─────────────────────────────────────────────┤
│  ▼ Personal Info (3/3 completed) ✅         │
│    ┌─────────────────────────────────────┐   │
│    │ Q: What's your name?            [✎] │   │
│    │ A: Sarah Johnson                    │   │
│    └─────────────────────────────────────┘   │
│    ┌─────────────────────────────────────┐   │
│    │ Q: How old are you?             [✎] │   │
│    │ A: 28 years                         │   │
│    └─────────────────────────────────────┘   │
│    ┌─────────────────────────────────────┐   │
│    │ Q: What's your gender?          [✎] │   │
│    │ A: Female                           │   │
│    └─────────────────────────────────────┘   │
│                                             │
│  ▼ Health Goals (2/2 completed) ✅          │
│    ┌─────────────────────────────────────┐   │
│    │ Q: Primary health goal?         [✎] │   │
│    │ A: Lose weight                      │   │
│    └─────────────────────────────────────┘   │
│    ┌─────────────────────────────────────┐   │
│    │ Q: Activity level?              [✎] │   │
│    │ A: Moderately active                │   │
│    └─────────────────────────────────────┘   │
│                                             │
│  ▶ Dietary Preferences (0/3)               │
│                                             │
│  ▶ Lifestyle (0/3)                         │
│                                             │
└─────────────────────────────────────────────┘
```

### **C. CompletedResponsesWidget Specification**

```dart
/// Widget displaying all completed responses grouped by sections
///
/// Features:
/// - Collapsible sections with completion indicators
/// - Individual response tiles with edit capability
/// - Section progress tracking
/// - Smooth expand/collapse animations
/// - Visual completion status indicators
class CompletedResponsesWidget extends ConsumerWidget {
  final bool allowEditing;
  final VoidCallback? onResponseEdit;

  const CompletedResponsesWidget({
    super.key,
    this.allowEditing = true,
    this.onResponseEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final responseGroups = ref.watch(responseGroupsProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          left: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSizes.l),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.assignment_turned_in,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppSizes.s),
                Text(
                  'Your Responses',
                  style: AppTextStyles.headerSubtitle.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Response Groups
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.m),
              itemCount: responseGroups.length,
              itemBuilder: (context, index) {
                final group = responseGroups[index];
                return _ResponseGroupWidget(
                  group: group,
                  allowEditing: allowEditing,
                  onEdit: onResponseEdit,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponseGroupWidget extends ConsumerWidget {
  final ResponseGroup group;
  final bool allowEditing;
  final VoidCallback? onEdit;

  const _ResponseGroupWidget({
    required this.group,
    required this.allowEditing,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final hasResponses = group.responses.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.m,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: Column(
        children: [
          // Section Header
          InkWell(
            onTap: hasResponses
                ? () => ref.read(responseGroupsProvider.notifier)
                    .toggleSection(group.sectionId)
                : null,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusM),
            ),
            child: Container(
              padding: const EdgeInsets.all(AppSizes.l),
              decoration: BoxDecoration(
                color: hasResponses
                    ? theme.colorScheme.primaryContainer.withOpacity(0.1)
                    : theme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSizes.radiusM),
                ),
              ),
              child: Row(
                children: [
                  // Expand/Collapse Icon
                  if (hasResponses)
                    AnimatedRotation(
                      turns: group.isExpanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.chevron_right,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    )
                  else
                    Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.outline,
                      size: 20,
                    ),

                  const SizedBox(width: AppSizes.s),

                  // Section Title
                  Expanded(
                    child: Text(
                      group.sectionTitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Completion Indicator
                  Text(
                    '(${group.completedCount} completed)',
                    style: AppTextStyles.caption.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(width: AppSizes.s),

                  if (hasResponses)
                    Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                      size: 16,
                    ),
                ],
              ),
            ),
          ),

          // Response Items
          if (hasResponses && group.isExpanded)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: group.responses.map((response) {
                  return _ResponseTile(
                    response: response,
                    allowEditing: allowEditing,
                    onEdit: onEdit,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _ResponseTile extends StatelessWidget {
  final CompletedResponse response;
  final bool allowEditing;
  final VoidCallback? onEdit;

  const _ResponseTile({
    required this.response,
    required this.allowEditing,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSizes.l),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question and Edit Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Q: ${response.questionText}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (allowEditing && response.isEditable)
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(
                    Icons.edit,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: const EdgeInsets.all(8),
                ),
            ],
          ),

          const SizedBox(height: AppSizes.xs),

          // Answer
          Text(
            'A: ${response.displayAnswer}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
```

## 🏗️ **4. Enhanced Questionnaire Page Layout (Mobile-First)**

### **A. Mobile-First Single Column Structure (Option 4: Collapsible Header)**

```
MOBILE LAYOUT (< 768px - Primary Target):
┌─────────────────────────────────────────────┐
│              BRANDING HEADER                │ ← 80px height
│  [LOGO] Clinic Name                        │
│         with Dr. Nutritionist               │
├─────────────────────────────────────────────┤
│           OVERALL PROGRESS                  │ ← 60px height
│  Section Progress: 2/4              75%     │
│  ████████████████████░░░░░░░░░░░░░░░░        │
├─────────────────────────────────────────────┤
│  ▶ Your Responses (2 sections done) 📝      │ ← 48px collapsed
├─────────────────────────────────────────────┤ ← OR 200px expanded
│                                             │
│              CURRENT QUESTION               │ ← Flexible height
│                                             │
│  What's your primary health goal?           │
│                                             │
│  ○ Lose weight                              │
│  ○ Gain weight                              │
│  ○ Build muscle                             │
│  ○ Improve energy                           │
│                                             │
├─────────────────────────────────────────────┤
│           [Back] [Next]                     │ ← 72px height
└─────────────────────────────────────────────┘

WHEN RESPONSES EXPANDED (Mobile):
┌─────────────────────────────────────────────┐
│              BRANDING HEADER                │
├─────────────────────────────────────────────┤
│           OVERALL PROGRESS                  │
├─────────────────────────────────────────────┤
│  ▼ Your Responses (2 sections done) 📝      │
│                                             │
│    ▼ Personal Info (3/3) ✅                │
│      • Name: Sarah Johnson                  │
│      • Age: 28 years                        │
│      • Gender: Female                       │
│                                             │
│    ▼ Health Goals (2/2) ✅                 │
│      • Goal: Lose weight                    │
│      • Activity: Moderately active          │
│                                             │
│    ▶ Dietary Preferences (0/3)              │
│    ▶ Lifestyle (0/3)                        │
│                                             │
├─────────────────────────────────────────────┤
│         CURRENT QUESTION (Compressed)       │
│                                             │
│  What's your primary health goal?           │
│  [Input area with reduced height]           │
│                                             │
├─────────────────────────────────────────────┤
│           [Back] [Next]                     │
└─────────────────────────────────────────────┘

DESKTOP LAYOUT (> 1200px - Secondary Target):
┌─────────────────────────────────────────────┐
│              BRANDING HEADER                │
├─────────────────────────────────────────────┤
│           OVERALL PROGRESS                  │
├─────────────────────────────────────────────┤
│  ┌─────────────────┬─────────────────────┐  │
│  │   MAIN CONTENT  │  COMPLETED RESPONSES│  │ ← Side-by-side
│  │                 │                     │  │   for desktop only
│  │  Current        │  ▼ Personal Info    │  │
│  │  Question       │  ▼ Health Goals     │  │
│  │                 │  ▶ Dietary Prefs    │  │
│  │  [Navigation]   │  ▶ Lifestyle        │  │
│  └─────────────────┴─────────────────────┘  │
└─────────────────────────────────────────────┘
```

### **B. Collapsible Responses Header Widget**

```dart
/// Mobile-first collapsible header for completed responses
///
/// Features:
/// - Always visible response count and status
/// - One-tap expand/collapse functionality
/// - Smooth height animations
/// - Compressed display optimized for mobile
/// - Progressive disclosure pattern
class CollapsibleResponsesHeader extends ConsumerStatefulWidget {
  final bool allowEditing;
  final VoidCallback? onResponseEdit;

  const CollapsibleResponsesHeader({
    super.key,
    this.allowEditing = true,
    this.onResponseEdit,
  });

  @override
  ConsumerState<CollapsibleResponsesHeader> createState() =>
    _CollapsibleResponsesHeaderState();
}

class _CollapsibleResponsesHeaderState
    extends ConsumerState<CollapsibleResponsesHeader>
    with SingleTickerProviderStateMixin {

  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightAnimation = Tween<double>(
      begin: 48.0, // Collapsed height
      end: 200.0,  // Expanded height
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responseGroups = ref.watch(responseGroupsProvider);
    final completedSections = responseGroups
        .where((group) => group.responses.isNotEmpty)
        .length;

    return AnimatedBuilder(
      animation: _heightAnimation,
      builder: (context, child) {
        return Container(
          height: _heightAnimation.value,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              // Always Visible Header (48px)
              InkWell(
                onTap: _toggleExpanded,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.l,
                    vertical: AppSizes.m,
                  ),
                  child: Row(
                    children: [
                      // Expand/Collapse Icon
                      AnimatedRotation(
                        turns: _isExpanded ? 0.25 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.chevron_right,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: AppSizes.m),

                      // Response Status
                      Expanded(
                        child: Text(
                          'Your Responses ($completedSections sections done)',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Status Icon
                      Icon(
                        Icons.assignment_turned_in,
                        color: completedSections > 0
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              // Expandable Content
              if (_isExpanded)
                Expanded(
                  child: _buildExpandedContent(context),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    final responseGroups = ref.watch(responseGroupsProvider);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.l),
      itemCount: responseGroups.length,
      itemBuilder: (context, index) {
        final group = responseGroups[index];
        return _CompactResponseGroup(
          group: group,
          allowEditing: widget.allowEditing,
          onEdit: widget.onResponseEdit,
        );
      },
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

/// Compact response group optimized for mobile display
class _CompactResponseGroup extends StatelessWidget {
  final ResponseGroup group;
  final bool allowEditing;
  final VoidCallback? onEdit;

  const _CompactResponseGroup({
    required this.group,
    required this.allowEditing,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasResponses = group.responses.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title with Status
          Row(
            children: [
              Icon(
                hasResponses ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 16,
                color: hasResponses
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
              ),
              const SizedBox(width: AppSizes.s),
              Expanded(
                child: Text(
                  '${group.sectionTitle} (${group.completedCount}/${group.responses.length})',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          // Compact Response List
          if (hasResponses) ...[
            const SizedBox(height: AppSizes.xs),
            ...group.responses.take(2).map((response) => // Show max 2 responses
              Padding(
                padding: const EdgeInsets.only(left: AppSizes.l, bottom: 2),
                child: Text(
                  '• ${response.questionText.length > 30
                      ? '${response.questionText.substring(0, 30)}...'
                      : response.questionText}: ${response.displayAnswer}',
                  style: AppTextStyles.caption.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (group.responses.length > 2)
              Padding(
                padding: const EdgeInsets.only(left: AppSizes.l),
                child: Text(
                  '  +${group.responses.length - 2} more responses',
                  style: AppTextStyles.caption.copyWith(
                    color: theme.colorScheme.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
```

### **C. Enhanced QuestionnairePage Integration (Mobile-First)**

```dart
class QuestionnairePage extends ConsumerWidget {
  const QuestionnairePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schemaAsync = ref.watch(questionnaireSchemaProvider);
    final navigationState = ref.watch(navigationStateProvider);
    final branding = ref.watch(brandingConfigProvider);

    return schemaAsync.when(
      loading: () => const QuestionnaireLoadingWidget(),
      error: (error, stack) => QuestionnaireErrorWidget(
        error: error,
        onRetry: () => ref.refresh(questionnaireSchemaProvider),
      ),
      data: (schema) {
        if (navigationState.isCompleted) {
          return const CompletionPage();
        }

        if (navigationState.showWelcome) {
          return Column(
            children: [
              // Branding Header on Welcome
              BrandingHeader(branding: branding),
              Expanded(
                child: WelcomePage(welcome: schema.welcome),
              ),
            ],
          );
        }

        // Responsive Questionnaire Layout
        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;

              if (screenWidth < 768) {
                // MOBILE: Single column with collapsible responses
                return _buildMobileLayout(context, ref, schema, branding);
              } else if (screenWidth < 1200) {
                // TABLET: Single column with larger spacing
                return _buildTabletLayout(context, ref, schema, branding);
              } else {
                // DESKTOP: Side-by-side layout
                return _buildDesktopLayout(context, ref, schema, branding);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
    QuestionnaireSchema schema,
    BrandingConfig branding,
  ) {
    return Column(
      children: [
        // Branding Header (80px)
        BrandingHeader(branding: branding),

        // Overall Progress (60px)
        OverallProgressIndicator(showSectionNames: false),

        // Collapsible Responses Header (48px collapsed / 200px expanded)
        CollapsibleResponsesHeader(
          onResponseEdit: () => _showEditDialog(context, ref),
        ),

        // Main Question Content (Flexible)
        Expanded(
          child: QuestionFlowWidget(schema: schema),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    WidgetRef ref,
    QuestionnaireSchema schema,
    BrandingConfig branding,
  ) {
    // Similar to mobile but with larger padding and spacing
    return Column(
      children: [
        BrandingHeader(branding: branding, height: 100),
        OverallProgressIndicator(showSectionNames: true),
        CollapsibleResponsesHeader(
          onResponseEdit: () => _showEditDialog(context, ref),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxl),
            child: QuestionFlowWidget(schema: schema),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    WidgetRef ref,
    QuestionnaireSchema schema,
    BrandingConfig branding,
  ) {
    // Side-by-side layout for desktop
    return Column(
      children: [
        BrandingHeader(branding: branding),
        OverallProgressIndicator(showSectionNames: true),
        Expanded(
          child: Row(
            children: [
              // Primary Content (2/3 width)
              Expanded(
                flex: 2,
                child: QuestionFlowWidget(schema: schema),
              ),
              // Completed Responses Sidebar (1/3 width)
              Expanded(
                flex: 1,
                child: CompletedResponsesWidget(
                  onResponseEdit: () => _showEditDialog(context, ref),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    // Implementation for response editing dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Response'),
        content: const Text('Response editing functionality will be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
```

### **D. Responsive Breakpoint Strategy**

```dart
/// Responsive breakpoint utilities for questionnaire layout
class QuestionnaireBreakpoints {
  static const double mobile = 768;
  static const double tablet = 1200;
  static const double desktop = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < tablet;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;

  /// Get appropriate collapsible header expanded height based on screen size
  static double getExpandedHeaderHeight(BuildContext context) {
    if (isMobile(context)) return 180;  // Compact mobile view
    if (isTablet(context)) return 220;  // Medium tablet view
    return 200;                         // Default desktop view
  }

  /// Get appropriate content padding based on screen size
  static EdgeInsets getContentPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(AppSizes.l);
    if (isTablet(context)) return const EdgeInsets.all(AppSizes.xxl);
    return const EdgeInsets.symmetric(horizontal: AppSizes.xxxl);
  }
}
```

## 🔄 **5. State Management Updates**

### **A. New Providers**

```dart
// Branding Configuration Provider
final brandingConfigProvider = Provider<BrandingConfig>((ref) {
  return const BrandingConfig(
    clinicName: 'Wellness Center',
    nutritionistName: 'Dr. Sarah Johnson',
    welcomeMessage: 'Welcome to your personalized nutrition journey!',
    welcomeSubtitle: 'Let\'s create a plan that works perfectly for your lifestyle.',
  );
});

// Overall Progress Provider
final overallProgressProvider = Provider<OverallProgress>((ref) {
  final schema = ref.watch(questionnaireSchemaProvider).value;
  final responses = ref.watch(responseStateProvider);
  final navigation = ref.watch(navigationStateProvider);

  if (schema == null) return const OverallProgress(sections: [], currentSectionIndex: 0, currentQuestionIndex: 0);

  final sections = schema.sections.map((section) {
    final answeredCount = section.questions
        .where((q) => responses.isQuestionAnswered(q.id))
        .length;

    return SectionProgress(
      sectionId: section.id,
      sectionTitle: section.title,
      totalQuestions: section.questions.length,
      answeredQuestions: answeredCount,
      isCompleted: answeredCount == section.questions.length,
    );
  }).toList();

  return OverallProgress(
    sections: sections,
    currentSectionIndex: navigation.currentSectionIndex,
    currentQuestionIndex: navigation.currentQuestionIndex,
  );
});

// Response Groups Provider
final responseGroupsProvider = StateNotifierProvider<ResponseGroupsNotifier, List<ResponseGroup>>((ref) {
  return ResponseGroupsNotifier(ref);
});
```

### **B. Implementation Priority**

```
Phase 1 (2-3 days):
├── BrandingConfig model and provider
├── BrandingHeader widget implementation
└── Enhanced WelcomePage with branding

Phase 2 (2-3 days):
├── OverallProgress model and calculations
├── OverallProgressIndicator widget
└── Integration with existing navigation

Phase 3 (3-4 days):
├── CompletedResponse models
├── CompletedResponsesWidget implementation
├── Response grouping and editing logic
└── Enhanced QuestionnairePage layout

Phase 4 (1-2 days):
├── Responsive layout adjustments
├── Animation polishing
├── Testing and bug fixes
└── Documentation updates
```

This design specification provides a complete blueprint for implementing the three focused enhancements while maintaining compatibility with the existing Clean Architecture foundation. Each component is designed to be modular, testable, and theme-aware, ensuring consistency with the current Material 3 implementation.