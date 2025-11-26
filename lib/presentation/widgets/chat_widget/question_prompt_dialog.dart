import 'package:flutter/material.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';

Future<String?> showQuestionPromptDialog(
  BuildContext context, {
  String initialValue = '',
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => QuestionPromptDialog(initialValue: initialValue),
  );
}

class QuestionPromptDialog extends StatefulWidget {
  const QuestionPromptDialog({super.key, required this.initialValue});

  final String initialValue;

  @override
  State<QuestionPromptDialog> createState() => _QuestionPromptDialogState();
}

class _QuestionPromptDialogState extends State<QuestionPromptDialog> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Document Question',
        style: AppStyles.styleSemitBold16.copyWith(color: Colors.black87),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Type your legal question',
              errorText: _error,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _handleSubmit,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  void _handleSubmit() {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      setState(() {
        _error = 'Question is required to analyze the document.';
      });
      return;
    }
    Navigator.of(context).pop(value);
  }
}

