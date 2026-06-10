import 'package:flutter/material.dart';
import 'package:legal_assistant_app/features/auth/presentation/views/sign_in_view.dart';
import 'package:legal_assistant_app/features/auth/presentation/views/sign_up_view.dart';
import 'package:legal_assistant_app/features/auth/presentation/views/forget_password_view.dart';
import 'package:legal_assistant_app/features/chat/presentation/views/chat_view.dart';
import 'package:legal_assistant_app/features/splash/presentation/views/splash_view.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const forgotPassword = '/forgot-password';
  static const chat = '/chat';
}

abstract class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case AppRoutes.signIn:
        return MaterialPageRoute(builder: (_) => const SignInView());
      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpView());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgetPasswordView());
      case AppRoutes.chat:
        return MaterialPageRoute(builder: (_) => const ChatView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
