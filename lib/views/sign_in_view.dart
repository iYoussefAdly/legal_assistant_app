import 'package:flutter/material.dart';
import 'package:legal_assistant_app/constants.dart';
import 'package:legal_assistant_app/views/widgets/sign_in_view_body.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackGroundColor,
      body:SignInViewBody(),
    );
  }
}