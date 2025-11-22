import 'package:flutter/material.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.buttonName, required this.onTap,});
  final String buttonName;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Container(
        width: 204,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xffD28DF1), Color(0xffB165E9)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: Text(buttonName,style: AppStyles.styleSemitBold16.copyWith(color: Colors.white),)),
      ),
    );
  }
}
