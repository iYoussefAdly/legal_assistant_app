import 'package:legal_assistant_app/core/utils/api_result.dart';
import 'package:legal_assistant_app/features/documents/domain/repositories/document_repository.dart';

class UploadDocumentUseCase {
  const UploadDocumentUseCase(this._repository);

  final DocumentRepository _repository;

  Future<ApiResult<Map<String, dynamic>>> call({
    required String nationalId,
    required String filePath,
    String? title,
  }) =>
      _repository.uploadDocument(
        nationalId: nationalId,
        filePath: filePath,
        title: title,
      );
}
