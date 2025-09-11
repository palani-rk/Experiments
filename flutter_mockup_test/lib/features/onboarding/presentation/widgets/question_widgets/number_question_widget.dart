import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/models/questionnaire_schema.dart';
import '../../../../../shared/theme/app_theme.dart';

class NumberQuestionWidget extends StatefulWidget {
  final Question question;
  final int? currentValue;
  final ValueChanged<int?> onChanged;

  const NumberQuestionWidget({
    super.key,
    required this.question,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  State<NumberQuestionWidget> createState() => _NumberQuestionWidgetState();
}

class _NumberQuestionWidgetState extends State<NumberQuestionWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.currentValue?.toString() ?? '',
    );
  }

  @override
  void didUpdateWidget(NumberQuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentValue != oldWidget.currentValue) {
      _controller.text = widget.currentValue?.toString() ?? '';
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
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            if (value.isEmpty) {
              widget.onChanged(null);
            } else {
              final number = int.tryParse(value);
              widget.onChanged(number);
            }
          },
          decoration: InputDecoration(
            hintText: 'Enter a number...',
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