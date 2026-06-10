import 'package:legal_assistant_app/core/utils/api_result.dart';
import 'package:legal_assistant_app/features/chat/data/models/audio_query_response.dart';
import 'package:legal_assistant_app/features/chat/data/models/file_query_response.dart';
import 'package:legal_assistant_app/features/chat/data/models/init_chat_response.dart';
import 'package:legal_assistant_app/features/chat/data/models/text_query_response.dart';

abstract interface class ChatRepository {
  Future<ApiResult<TextQueryResponse>> sendTextQuery(String question);
  Future<ApiResult<AudioQueryResponse>> sendAudioQuery(String filePath);
  Future<ApiResult<FileQueryResponse>> sendFileQuery(
      String filePath, String question);
  Future<ApiResult<InitChatResponse>> initializeChat(
      String name, String gender);
}
