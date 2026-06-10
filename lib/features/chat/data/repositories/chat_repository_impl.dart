import 'package:legal_assistant_app/core/errors/exceptions.dart';
import 'package:legal_assistant_app/core/errors/failure.dart';
import 'package:legal_assistant_app/core/utils/api_result.dart';
import 'package:legal_assistant_app/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:legal_assistant_app/features/chat/data/models/audio_query_response.dart';
import 'package:legal_assistant_app/features/chat/data/models/file_query_response.dart';
import 'package:legal_assistant_app/features/chat/data/models/init_chat_response.dart';
import 'package:legal_assistant_app/features/chat/data/models/text_query_response.dart';
import 'package:legal_assistant_app/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._dataSource);

  final ChatRemoteDataSource _dataSource;

  @override
  Future<ApiResult<TextQueryResponse>> sendTextQuery(String question) =>
      _run(() => _dataSource.sendTextQuery(question));

  @override
  Future<ApiResult<AudioQueryResponse>> sendAudioQuery(String filePath) =>
      _run(() => _dataSource.sendAudioQuery(filePath));

  @override
  Future<ApiResult<FileQueryResponse>> sendFileQuery(
          String filePath, String question) =>
      _run(() => _dataSource.sendFileQuery(filePath, question));

  @override
  Future<ApiResult<InitChatResponse>> initializeChat(
          String name, String gender) =>
      _run(() => _dataSource.initializeChat(name, gender));

  Future<ApiResult<T>> _run<T>(Future<T> Function() call) async {
    try {
      return ApiSuccess(await call());
    } on QanounyApiException catch (e) {
      return ApiError(ServerFailure(e.message));
    } catch (_) {
      return const ApiError(UnknownFailure());
    }
  }
}
