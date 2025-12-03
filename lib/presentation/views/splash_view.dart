import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/logic/cubit/login_cubit.dart';
import 'package:legal_assistant_app/logic/states/login_state.dart';
import 'package:legal_assistant_app/presentation/views/sign_in_view.dart';
import 'package:legal_assistant_app/presentation/views/chat_view.dart';
import 'package:legal_assistant_app/presentation/widgets/auth_widgets/custom_button.dart';
import 'package:legal_assistant_app/presentation/widgets/splash_widgets/custom_background.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء فحص تسجيل الدخول عند بناء الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginCubit>().checkLoginStatus();
    });

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ChatView()),
          );
        }
      },
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          bool isChecking = state is CheckingLoginState;
          return Scaffold(
            body: CustomBackground(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/Frame 3.png'),
                    SizedBox(height: 32),

                    // Loading أثناء فحص تسجيل الدخول
                    if (isChecking)
                      CircularProgressIndicator()
                    else
                      CustomButton(
                        buttonName: 'Continue',
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => SignInView()),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
