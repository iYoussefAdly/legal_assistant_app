import 'package:legal_assistant_app/core/utils/api_result.dart';
import 'package:legal_assistant_app/features/chat/data/models/audio_query_response.dart';
import 'package:legal_assistant_app/features/chat/domain/repositories/chat_repository.dart';

class SendAudioQueryUseCase {
  const SendAudioQueryUseCase(this._repository);
  final ChatRepository _repository;
  Future<ApiResult<AudioQueryResponse>> call(String filePath) =>
      _repository.sendAudioQuery(filePath);
}
