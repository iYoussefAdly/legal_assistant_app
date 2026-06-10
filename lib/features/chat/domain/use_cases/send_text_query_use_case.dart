import 'package:legal_assistant_app/core/utils/api_result.dart';
import 'package:legal_assistant_app/features/chat/data/models/text_query_response.dart';
import 'package:legal_assistant_app/features/chat/domain/repositories/chat_repository.dart';

class SendTextQueryUseCase {
  const SendTextQueryUseCase(this._repository);
  final ChatRepository _repository;
  Future<ApiResult<TextQueryResponse>> call(String question) =>
      _repository.sendTextQuery(question);
}
