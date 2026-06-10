import 'package:flutter/material.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Welcome to Qanouny', style: AppStyles.styleBold24),
        const SizedBox(height: 10),
        Text(text, style: AppStyles.styleRegular20),
      ],
    );
  }
}
