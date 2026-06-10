import 'package:legal_assistant_app/core/utils/api_result.dart';

abstract interface class DocumentRepository {
  Future<ApiResult<Map<String, dynamic>>> uploadDocument({
    required String nationalId,
    required String filePath,
    String? title,
  });
}
