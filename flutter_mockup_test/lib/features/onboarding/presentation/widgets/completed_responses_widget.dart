import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/completed_response.dart';
import '../providers/completed_responses_provider.dart';
import '../../../../shared/theme/app_theme.dart';

/// Chat-style widget displaying completed responses as scrollable section cards
///
/// Features:
/// - Scrollable chat-like interface with section cards
/// - Section cards with completion status indicators
/// - Question-answer pairs within each section with edit capability
/// - Clean card-based design similar to messaging apps
/// - Error handling and loading states
/// - Accessibility support
class CompletedResponsesWidget extends ConsumerWidget {
  /// Whether editing responses is allowed
  final bool allowEditing;

  /// Callback when a response edit is requested
  final VoidCallback? onResponseEdit;

  /// Scroll controller for the chat area
  final ScrollController? scrollController;

  /// Whether to add padding at bottom for overlay input
  final bool addBottomPadding;

  const CompletedResponsesWidget({
    super.key,
    this.allowEditing = true,
    this.onResponseEdit,
    this.scrollController,
    this.addBottomPadding = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final responseGroups = ref.watch(responseGroupsProvider);

    return Container(
      color: theme.colorScheme.surfaceContainerLow,
      child: _buildScrollableContent(context, ref, responseGroups),
    );
  }

  /// Builds the scrollable content area with section cards
  Widget _buildScrollableContent(
    BuildContext context,
    WidgetRef ref,
    List<ResponseGroup> responseGroups,
  ) {
    // Filter groups that have responses
    final completedGroups = responseGroups
        .where((group) => group.responses.isNotEmpty)
        .toList();

    if (completedGroups.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.only(
        left: AppSizes.l,
        right: AppSizes.l,
        top: AppSizes.l,
        bottom: addBottomPadding ? 200 : AppSizes.l, // Space for overlay input
      ),
      itemCount: completedGroups.length,
      itemBuilder: (context, index) {
        final group = completedGroups[index];
        return _buildSectionCard(context, ref, group);
      },
    );
  }

  /// Builds a section card similar to the mockup design
  Widget _buildSectionCard(
    BuildContext context,
    WidgetRef ref,
    ResponseGroup group,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.l),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: AppShadows.card(context),
      ),
      child: Column(
        children: [
          // Section Header
          _buildSectionHeader(context, theme, group),

          // Question-Answer Pairs
          _buildQuestionAnswerList(context, group),
        ],
      ),
    );
  }

  /// Builds the section header with completion status
  Widget _buildSectionHeader(
    BuildContext context,
    ThemeData theme,
    ResponseGroup group,
  ) {
    final IconData sectionIcon = _getSectionIcon(group.sectionTitle);

    return Container(
      padding: const EdgeInsets.all(AppSizes.l),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusM),
          topRight: Radius.circular(AppSizes.radiusM),
        ),
      ),
      child: Row(
        children: [
          Icon(
            sectionIcon,
            color: theme.colorScheme.onPrimaryContainer,
            size: 20,
          ),
          const SizedBox(width: AppSizes.s),
          Expanded(
            child: Text(
              group.sectionTitle.toUpperCase(),
              style: AppTextStyles.sectionTitle.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                letterSpacing: 0.5,
              ),
            ),
          ),
          // Completion status icon
          Icon(
            group.isCompleted ? Icons.check_circle : Icons.access_time,
            color: group.isCompleted
                ? Colors.green[500]
                : theme.colorScheme.secondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  /// Builds the list of question-answer pairs
  Widget _buildQuestionAnswerList(
    BuildContext context,
    ResponseGroup group,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.l),
      child: Column(
        children: group.responses.map((response) {
          return _buildQuestionAnswerPair(context, response);
        }).toList(),
      ),
    );
  }

  /// Builds a single question-answer pair similar to mockup
  Widget _buildQuestionAnswerPair(
    BuildContext context,
    CompletedResponse response,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Row (Bot Avatar + Question)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 8,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.smart_toy,
                  size: 10,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSizes.s),
              Expanded(
                child: Text(
                  response.questionText,
                  style: AppTextStyles.questionText.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.xs),

          // Answer Row (User Avatar + Answer + Edit Button)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 8,
                backgroundColor: Colors.blue[100],
                child: Icon(
                  Icons.person,
                  size: 10,
                  color: Colors.blue[600],
                ),
              ),
              const SizedBox(width: AppSizes.s),
              Expanded(
                child: Text(
                  response.displayAnswer,
                  style: AppTextStyles.answerText.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              // Edit Button
              if (allowEditing && response.isEditable) ...[
                _buildEditButton(context, theme),
              ],
            ],
          ),

          // Validation Error (if any)
          if (response.validationError != null) ...[
            const SizedBox(height: AppSizes.xs),
            _buildValidationError(context, theme, response.validationError!),
          ],
        ],
      ),
    );
  }

  /// Builds the edit button similar to mockup style
  Widget _buildEditButton(BuildContext context, ThemeData theme) {
    return InkWell(
      onTap: onResponseEdit,
      borderRadius: BorderRadius.circular(AppSizes.m),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s,
          vertical: AppSizes.xs,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSizes.m),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit,
              size: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 2),
            Text(
              'Edit',
              style: AppTextStyles.editButtonText.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds validation error display
  Widget _buildValidationError(
    BuildContext context,
    ThemeData theme,
    String error,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 24), // Align with answer text
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
        border: Border.all(
          color: theme.colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning,
            size: 12,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: AppSizes.xs),
          Flexible(
            child: Text(
              error,
              style: AppTextStyles.editButtonText.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the empty state when no responses exist
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xxl * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: AppSizes.l),
            Text(
              'No responses yet',
              style: AppTextStyles.headerSubtitle.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: AppSizes.s),
            Text(
              'Start answering questions to see your responses here',
              style: AppTextStyles.progressPercent.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Gets appropriate icon for different sections
  IconData _getSectionIcon(String sectionTitle) {
    final title = sectionTitle.toLowerCase();

    if (title.contains('personal') || title.contains('info')) {
      return Icons.person_outline;
    } else if (title.contains('goal') || title.contains('objective')) {
      return Icons.flag_outlined;
    } else if (title.contains('health') || title.contains('medical')) {
      return Icons.favorite_outline;
    } else if (title.contains('diet') || title.contains('food') || title.contains('nutrition')) {
      return Icons.restaurant_outlined;
    } else if (title.contains('lifestyle') || title.contains('activity')) {
      return Icons.directions_run_outlined;
    } else {
      return Icons.quiz_outlined;
    }
  }
}

/// Widget for the current question input overlay (similar to mockup)
///
/// This widget overlays at the bottom of the screen and displays
/// the current question with input controls
class CurrentQuestionOverlay extends ConsumerWidget {
  /// The current question being asked
  final String questionText;

  /// Widget for the input controls
  final Widget inputWidget;

  /// Whether to show the "CURRENT" indicator
  final bool showCurrentIndicator;

  /// Callback when input is submitted
  final VoidCallback? onSubmit;

  const CurrentQuestionOverlay({
    super.key,
    required this.questionText,
    required this.inputWidget,
    this.showCurrentIndicator = true,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSizes.l),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: AppShadows.elevated(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.xl),
          topRight: Radius.circular(AppSizes.xl),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Question Header with Bot Avatar
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.smart_toy,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSizes.m),
              Expanded(
                child: Text(
                  questionText,
                  style: AppTextStyles.currentQuestionText.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.l),

          // Input Area
          Container(
            padding: const EdgeInsets.all(AppSizes.l),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(AppSizes.l),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                // Input Widget
                inputWidget,

                const SizedBox(height: AppSizes.l),

                // Submit Button
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: AppSizes.l),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.m),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Submit',
                          style: AppTextStyles.buttonText.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Current Indicator
                if (showCurrentIndicator) ...[
                  const SizedBox(height: AppSizes.s),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.keyboard_arrow_up,
                        color: theme.colorScheme.primary,
                        size: 16,
                      ),
                      Text(
                        'CURRENT',
                        style: AppTextStyles.statusLabel.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}