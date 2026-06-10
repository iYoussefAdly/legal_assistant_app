import 'package:legal_assistant_app/core/errors/exceptions.dart';
import 'package:legal_assistant_app/core/errors/failure.dart';
import 'package:legal_assistant_app/core/utils/api_result.dart';
import 'package:legal_assistant_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:legal_assistant_app/features/auth/data/models/user_data_model.dart';
import 'package:legal_assistant_app/features/auth/domain/entities/user_entity.dart';
import 'package:legal_assistant_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final AuthRemoteDataSource _dataSource;

  @override
  Future<ApiResult<UserEntity>> login(
    String nationalId,
    String password,
  ) async {
    try {
      final model = await _dataSource.login(nationalId, password);
      return ApiSuccess(model.toEntity());
    } on QanounyApiException catch (e) {
      return ApiError(ServerFailure(e.message));
    } catch (_) {
      return const ApiError(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<void>> signup({
    required String nationalId,
    required String fullName,
    required String email,
    required String password,
    required String gender,
  }) async {
    try {
      final model = UserDataModel(
        nationalId: nationalId,
        fullName: fullName,
        email: email,
        passwordHash: password,
        gender: gender,
      );
      await _dataSource.signup(model);
      return const ApiSuccess(null);
    } on QanounyApiException catch (e) {
      return ApiError(ServerFailure(e.message));
    } catch (_) {
      return const ApiError(UnknownFailure());
    }
  }
}
