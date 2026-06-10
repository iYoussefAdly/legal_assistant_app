import 'package:legal_assistant_app/core/utils/api_result.dart';
import 'package:legal_assistant_app/features/auth/domain/repositories/auth_repository.dart';

class SignupUseCase {
  const SignupUseCase(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<void>> call({
    required String nationalId,
    required String fullName,
    required String email,
    required String password,
    required String gender,
  }) =>
      _repository.signup(
        nationalId: nationalId,
        fullName: fullName,
        email: email,
        password: password,
        gender: gender,
      );
}
