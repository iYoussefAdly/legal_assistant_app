import 'package:legal_assistant_app/core/utils/api_result.dart';
import 'package:legal_assistant_app/features/auth/domain/entities/user_entity.dart';
import 'package:legal_assistant_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<UserEntity>> call(String nationalId, String password) =>
      _repository.login(nationalId, password);
}
