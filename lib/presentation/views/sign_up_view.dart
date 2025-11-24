import 'package:flutter/material.dart';
import 'package:legal_assistant_app/presentation/widgets/auth_widgets/sign_up_view_body.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xffD1A2F5),
            Color(0xffE6DDF0),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SignUpViewBody(),
      ),
    );
  }
}