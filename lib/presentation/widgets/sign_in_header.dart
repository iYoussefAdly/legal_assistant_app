import 'package:flutter/material.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';

class SignInHeader extends StatelessWidget {
  const SignInHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Welcome to QANOUNY AI",style: AppStyles.styleBold24,),
          SizedBox(
            height: 10,
          ),
          Text("Sign in to continue",style: AppStyles.styleRegular20,)
      ],
    );
  }
}