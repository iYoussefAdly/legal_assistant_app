import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/core/services/local_storage_service.dart';
import 'package:legal_assistant_app/core/utils/api_result.dart';
import 'package:legal_assistant_app/features/auth/domain/entities/user_entity.dart';
import 'package:legal_assistant_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:legal_assistant_app/features/auth/presentation/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._loginUseCase, this._storage) : super(const LoginInitial());

  final LoginUseCase _loginUseCase;
  final LocalStorageService _storage;

  Future<void> login(String nationalId, String password) async {
    emit(const LoginLoading());
    final result = await _loginUseCase(nationalId, password);
    switch (result) {
      case ApiSuccess(:final data):
        await _storage.saveSession(
          nationalId: data.nationalId,
          fullName: data.fullName,
          email: data.email,
          gender: data.gender,
        );
        emit(LoginSuccess(user: data));
      case ApiError(:final failure):
        emit(LoginFailure(message: failure.message));
    }
  }

  Future<void> checkLoginStatus() async {
    emit(const CheckingLoginState());
    if (_storage.isLoggedIn) {
      final user = UserEntity(
        nationalId: _storage.nationalId ?? '',
        fullName: _storage.fullName,
        email: _storage.email,
        gender: _storage.gender,
      );
      emit(LoginSuccess(user: user));
    } else {
      emit(const LoginInitial());
    }
  }

  Future<void> logout() async {
    await _storage.clearSession();
    emit(const LoginInitial());
  }
}
