import 'package:legal_assistant_app/core/utils/api_result.dart';
import 'package:legal_assistant_app/features/chat/data/models/file_query_response.dart';
import 'package:legal_assistant_app/features/chat/domain/repositories/chat_repository.dart';

class SendFileQueryUseCase {
  const SendFileQueryUseCase(this._repository);
  final ChatRepository _repository;
  Future<ApiResult<FileQueryResponse>> call(String filePath, String question) =>
      _repository.sendFileQuery(filePath, question);
}
