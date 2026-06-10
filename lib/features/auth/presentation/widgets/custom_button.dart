import 'package:flutter/material.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonName,
    required this.onTap,
  });

  final String buttonName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 204,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            buttonName,
            style: AppStyles.styleSemitBold16.copyWith(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
