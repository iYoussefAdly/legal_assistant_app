import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/core/di/service_locator.dart';
import 'package:legal_assistant_app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:legal_assistant_app/features/auth/presentation/widgets/sign_in_view_body.dart';
import 'package:legal_assistant_app/features/splash/presentation/widgets/custom_background.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: const Scaffold(
        body: CustomBackground(child: SignInViewBody()),
      ),
    );
  }
}
