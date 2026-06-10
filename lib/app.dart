import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/core/di/service_locator.dart';
import 'package:legal_assistant_app/core/router/app_router.dart';
import 'package:legal_assistant_app/features/auth/presentation/cubit/login_cubit.dart';

class QanounyApp extends StatelessWidget {
  const QanounyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginCubit>()..checkLoginStatus(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
