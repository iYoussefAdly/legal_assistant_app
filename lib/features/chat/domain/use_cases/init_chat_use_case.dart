import 'package:legal_assistant_app/core/utils/api_result.dart';
import 'package:legal_assistant_app/features/chat/data/models/init_chat_response.dart';
import 'package:legal_assistant_app/features/chat/domain/repositories/chat_repository.dart';

class InitChatUseCase {
  const InitChatUseCase(this._repository);
  final ChatRepository _repository;
  Future<ApiResult<InitChatResponse>> call(String name, String gender) =>
      _repository.initializeChat(name, gender);
}
