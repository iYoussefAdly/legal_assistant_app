import 'package:flutter/material.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
import 'package:legal_assistant_app/presentation/widgets/custom_button.dart';
import 'package:legal_assistant_app/presentation/widgets/custom_text_field.dart';
import 'package:legal_assistant_app/presentation/widgets/sign_in_header.dart';

class SignInViewBody extends StatelessWidget {
  const SignInViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SignInHeader(),
          SizedBox(height: 64),
          CustomTextField(hintText: "enter your email", isItPassword: false),
          SizedBox(height: 16),
          CustomTextField(hintText: "enter your password", isItPassword: true),
          SizedBox(height: 32),
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: Text(
              "Forget Password?",
              style: AppStyles.styleRegular14.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: 32),
          Align(
            alignment: AlignmentGeometry.center,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Don't have an account? ",
                    style: AppStyles.styleRegular18.copyWith(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: "Sign Up",
                    style: AppStyles.styleRegular18.copyWith(
                      color: Color(0xffAF63E8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 32),
          Align(
            alignment: Alignment.center,
            child: CustomButton(buttonName: "Login", onTap: () {}),
          ),
        ],
      ),
    );
  }
}
