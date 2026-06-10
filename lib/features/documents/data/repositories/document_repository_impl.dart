import 'package:legal_assistant_app/core/errors/exceptions.dart';
import 'package:legal_assistant_app/core/errors/failure.dart';
import 'package:legal_assistant_app/core/utils/api_result.dart';
import 'package:legal_assistant_app/features/documents/data/data_sources/document_remote_data_source.dart';
import 'package:legal_assistant_app/features/documents/domain/repositories/document_repository.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  const DocumentRepositoryImpl(this._dataSource);

  final DocumentRemoteDataSource _dataSource;

  @override
  Future<ApiResult<Map<String, dynamic>>> uploadDocument({
    required String nationalId,
    required String filePath,
    String? title,
  }) async {
    try {
      final result = await _dataSource.uploadDocument(
        nationalId: nationalId,
        filePath: filePath,
        title: title,
      );
      return ApiSuccess(result);
    } on QanounyApiException catch (e) {
      return ApiError(ServerFailure(e.message));
    } catch (_) {
      return const ApiError(UnknownFailure());
    }
  }
}
