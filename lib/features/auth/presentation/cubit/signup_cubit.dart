import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/core/utils/api_result.dart';
import 'package:legal_assistant_app/features/auth/domain/use_cases/signup_use_case.dart';
import 'package:legal_assistant_app/features/auth/presentation/cubit/signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this._signupUseCase) : super(const SignupInitial());

  final SignupUseCase _signupUseCase;

  Future<void> signup({
    required String nationalId,
    required String fullName,
    required String email,
    required String password,
    required String gender,
  }) async {
    emit(const SignupLoading());
    final result = await _signupUseCase(
      nationalId: nationalId,
      fullName: fullName,
      email: email,
      password: password,
      gender: gender,
    );
    switch (result) {
      case ApiSuccess():
        emit(const SignupSuccess());
      case ApiError(:final failure):
        emit(SignupFailure(message: failure.message));
    }
  }
}
