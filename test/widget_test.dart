import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:legal_assistant_app/core/errors/failure.dart';
import 'package:legal_assistant_app/core/services/local_storage_service.dart';
import 'package:legal_assistant_app/core/utils/api_result.dart';
import 'package:legal_assistant_app/features/auth/domain/entities/user_entity.dart';
import 'package:legal_assistant_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:legal_assistant_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:legal_assistant_app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:legal_assistant_app/features/splash/presentation/views/splash_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _StubAuthRepository implements AuthRepository {
  @override
  Future<ApiResult<UserEntity>> login(String nationalId, String password) async =>
      const ApiError(ServerFailure('stub'));

  @override
  Future<ApiResult<void>> signup({
    required String nationalId,
    required String fullName,
    required String email,
    required String password,
    required String gender,
  }) async =>
      const ApiError(ServerFailure('stub'));
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('SplashView renders and completes its timer without crashing',
      (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    final loginCubit = LoginCubit(
      LoginUseCase(_StubAuthRepository()),
      LocalStorageService(prefs),
    );

    await tester.pumpWidget(
      BlocProvider.value(
        value: loginCubit,
        child: MaterialApp(
          routes: {
            '/sign-in': (_) => const Scaffold(body: Text('Sign In')),
            '/chat': (_) => const Scaffold(body: Text('Chat')),
          },
          home: const SplashView(),
        ),
      ),
    );

    // SplashView shows on first frame.
    expect(find.byType(SplashView), findsOneWidget);

    // Advance past the 4-second navigation timer so it fires and the test ends cleanly.
    await tester.pump(const Duration(seconds: 5));

    addTearDown(loginCubit.close);
  });
}
