import 'package:flutter/material.dart';
import 'package:legal_assistant_app/presentation/widgets/auth_widgets/sign_in_view_body.dart';
import 'package:legal_assistant_app/presentation/widgets/splash_widgets/custom_background.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CustomBackground(child: SignInViewBody()));
  }
}
