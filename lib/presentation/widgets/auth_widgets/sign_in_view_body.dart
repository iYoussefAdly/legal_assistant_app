import 'package:flutter/material.dart';
import 'package:legal_assistant_app/core/utils/app_styles.dart';
import 'package:legal_assistant_app/presentation/views/chat_view.dart';
import 'package:legal_assistant_app/presentation/views/sign_up_view.dart';
import 'package:legal_assistant_app/presentation/widgets/auth_widgets/custom_button.dart';
import 'package:legal_assistant_app/presentation/widgets/auth_widgets/custom_text_field.dart';
import 'package:legal_assistant_app/presentation/widgets/auth_widgets/auth_header.dart';

class SignInViewBody extends StatelessWidget {
  const SignInViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthHeader(text: 'Sign in to continue'),
              SizedBox(height: 64),
              CustomTextField(
                hintText: "enter your email",
                isItPassword: false,
              ),
              SizedBox(height: 16),
              CustomTextField(
                hintText: "enter your password",
                isItPassword: true,
              ),
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUpView();
                        },
                      ),
                    );
                  },
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
              ),
              SizedBox(height: 32),
              Align(
                alignment: Alignment.center,
                child: CustomButton(
                  buttonName: "Login",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatView()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
