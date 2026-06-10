import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/core/services/local_storage_service.dart';
import 'package:legal_assistant_app/core/utils/api_result.dart';
import 'package:legal_assistant_app/features/chat/domain/use_cases/init_chat_use_case.dart';
import 'package:legal_assistant_app/features/chat/domain/use_cases/send_audio_query_use_case.dart';
import 'package:legal_assistant_app/features/chat/domain/use_cases/send_file_query_use_case.dart';
import 'package:legal_assistant_app/features/chat/domain/use_cases/send_text_query_use_case.dart';
import 'package:legal_assistant_app/features/chat/presentation/cubit/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required SendTextQueryUseCase sendTextQuery,
    required SendAudioQueryUseCase sendAudioQuery,
    required SendFileQueryUseCase sendFileQuery,
    required InitChatUseCase initChat,
    required LocalStorageService storage,
  })  : _sendTextQuery = sendTextQuery,
        _sendAudioQuery = sendAudioQuery,
        _sendFileQuery = sendFileQuery,
        _initChat = initChat,
        _storage = storage,
        super(const ChatIdle());

  final SendTextQueryUseCase _sendTextQuery;
  final SendAudioQueryUseCase _sendAudioQuery;
  final SendFileQueryUseCase _sendFileQuery;
  final InitChatUseCase _initChat;
  final LocalStorageService _storage;

  String? get currentNationalId => _storage.nationalId;
  String get userName => _storage.fullName ?? 'User';
  String get userGender => _storage.gender ?? 'Unknown';

  Future<void> sendTextQuery(String question) async {
    emit(const TextQueryLoading());
    final result = await _sendTextQuery(question);
    switch (result) {
      case ApiSuccess(:final data):
        emit(TextQuerySuccess(data));
      case ApiError(:final failure):
        emit(TextQueryFailure(failure.message));
    }
  }

  Future<void> sendAudioQuery(String filePath) async {
    emit(const AudioQueryLoading());
    final result = await _sendAudioQuery(filePath);
    switch (result) {
      case ApiSuccess(:final data):
        emit(AudioQuerySuccess(data));
      case ApiError(:final failure):
        emit(AudioQueryFailure(failure.message));
    }
  }

  Future<void> sendFileQuery(String filePath, String question) async {
    emit(const FileQueryLoading());
    final result = await _sendFileQuery(filePath, question);
    switch (result) {
      case ApiSuccess(:final data):
        emit(FileQuerySuccess(data));
      case ApiError(:final failure):
        emit(FileQueryFailure(failure.message));
    }
  }

  Future<void> resetChatSession() async {
    emit(const ChatSessionResetting());
    final result = await _initChat(userName, userGender);
    switch (result) {
      case ApiSuccess(:final data):
        emit(ChatSessionReset(data));
      case ApiError(:final failure):
        emit(ChatSessionResetFailure(failure.message));
    }
  }
}
