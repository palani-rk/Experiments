import 'package:flutter/material.dart';
import '../../../data/models/questionnaire_schema.dart';
import '../../../../../shared/theme/app_theme.dart';

class TextQuestionWidget extends StatefulWidget {
  final Question question;
  final String? currentValue;
  final ValueChanged<String> onChanged;

  const TextQuestionWidget({
    super.key,
    required this.question,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  State<TextQuestionWidget> createState() => _TextQuestionWidgetState();
}

class _TextQuestionWidgetState extends State<TextQuestionWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue ?? '');
  }

  @override
  void didUpdateWidget(TextQuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentValue != oldWidget.currentValue) {
      _controller.text = widget.currentValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.question.hint != null) ...[
          Text(
            widget.question.hint!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSizes.m),
        ],
        TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Enter your answer...',
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              borderSide: BorderSide(
                color: theme.colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: AppSizes.inputBorderWidth,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.5),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.l,
              vertical: AppSizes.m,
            ),
            filled: true,
            fillColor: theme.colorScheme.surface,
          ),
          style: AppTextStyles.answerText.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}