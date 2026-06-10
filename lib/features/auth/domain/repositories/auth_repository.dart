import 'package:legal_assistant_app/core/utils/api_result.dart';
import 'package:legal_assistant_app/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<ApiResult<UserEntity>> login(String nationalId, String password);
  Future<ApiResult<void>> signup({
    required String nationalId,
    required String fullName,
    required String email,
    required String password,
    required String gender,
  });
}
