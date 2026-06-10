import 'package:flutter/material.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';

/// A reusable dialog that prompts the user for a question about a document.
/// [skipLabel] defaults to 'Skip'; set to 'Cancel' when skip is not appropriate.
Future<String?> showQuestionDialog(
  BuildContext context, {
  String skipLabel = 'Skip',
}) {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text(
        'Document Question',
        style: AppStyles.styleSemitBold16.copyWith(color: Colors.white),
      ),
      content: TextField(
        controller: controller,
        style: AppStyles.styleRegular16.copyWith(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'What would you like to know about this document?',
          hintStyle:
              AppStyles.styleRegular16.copyWith(color: Colors.grey[500]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[700]!),
          ),
        ),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(
            skipLabel,
            style:
                AppStyles.styleRegular16.copyWith(color: Colors.grey[400]),
          ),
        ),
        TextButton(
          onPressed: () =>
              Navigator.pop(ctx, controller.text.trim()),
          child: Text(
            'Ask',
            style:
                AppStyles.styleRegular16.copyWith(color: Colors.blue[300]),
          ),
        ),
      ],
    ),
  );
}
