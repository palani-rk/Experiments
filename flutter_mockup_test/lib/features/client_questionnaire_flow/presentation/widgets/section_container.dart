import 'package:flutter/material.dart';
import 'chat_bubble.dart';
import '../../data/models/question.dart';
import '../../data/models/response.dart';
import '../../data/models/section_response.dart';
import '../../../../shared/theme/app_theme.dart';

/// Container that groups completed Q&A pairs by section - Phase 3: Dynamic implementation
/// Connected to dynamic section data and edit functionality
class SectionContainer extends StatelessWidget {
  final String sectionTitle;
  final List<Question> questions;
  final SectionResponse sectionResponse;
  final Function(String questionId)? onEdit;
  final bool isCollapsed;

  const SectionContainer({
    super.key,
    required this.sectionTitle,
    required this.questions,
    required this.sectionResponse,
    this.onEdit,
    this.isCollapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.l,
        vertical: AppSizes.s,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        boxShadow: AppShadows.card(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section header
          _buildSectionHeader(context),

          // Q&A pairs (collapsible)
          if (!isCollapsed) _buildQuestionAnswerList(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.l),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusM),
          topRight: Radius.circular(AppSizes.radiusM),
        ),
      ),
      child: Row(
        children: [
          // Completion indicator
          Container(
            width: AppSizes.iconM,
            height: AppSizes.iconM,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              size: AppSizes.iconS,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),

          const SizedBox(width: AppSizes.m),

          // Section title
          Expanded(
            child: Text(
              sectionTitle,
              style: AppTextStyles.sectionTitle.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),

          // Status label
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s,
              vertical: AppSizes.xs,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            child: Text(
              'COMPLETED',
              style: AppTextStyles.statusLabel.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionAnswerList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.s),
      child: Column(
        children: _buildQuestionAnswerPairs(context),
      ),
    );
  }

  List<Widget> _buildQuestionAnswerPairs(BuildContext context) {
    final pairs = <Widget>[];

    for (final question in questions) {
      // Find the corresponding response from sectionResponse
      final response = sectionResponse.getResponseByQuestionId(question.id);

      if (response != null) {
        pairs.add(
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.s),
            child: Column(
              children: [
                // Bot question
                ChatBubble(
                  content: question.questionText,
                  type: ChatBubbleType.bot,
                ),
                // User answer with edit capability
                ChatBubble(
                  content: response.valueAsString,
                  type: ChatBubbleType.user,
                  isEditable: true,
                  onEdit: onEdit != null ? () => onEdit!(question.id) : null,
                ),
              ],
            ),
          ),
        );
      }
    }

    return pairs;
  }
}