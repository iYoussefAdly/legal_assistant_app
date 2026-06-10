import 'package:legal_assistant_app/features/chat/data/models/audio_query_response.dart';
import 'package:legal_assistant_app/features/chat/data/models/file_query_response.dart';
import 'package:legal_assistant_app/features/chat/data/models/init_chat_response.dart';
import 'package:legal_assistant_app/features/chat/data/models/text_query_response.dart';

sealed class ChatState {
  const ChatState();
}

final class ChatIdle extends ChatState {
  const ChatIdle();
}

// Text query
final class TextQueryLoading extends ChatState {
  const TextQueryLoading();
}

final class TextQuerySuccess extends ChatState {
  const TextQuerySuccess(this.response);
  final TextQueryResponse response;
}

final class TextQueryFailure extends ChatState {
  const TextQueryFailure(this.message);
  final String message;
}

// Audio query
final class AudioQueryLoading extends ChatState {
  const AudioQueryLoading();
}

final class AudioQuerySuccess extends ChatState {
  const AudioQuerySuccess(this.response);
  final AudioQueryResponse response;
}

final class AudioQueryFailure extends ChatState {
  const AudioQueryFailure(this.message);
  final String message;
}

// File query
final class FileQueryLoading extends ChatState {
  const FileQueryLoading();
}

final class FileQuerySuccess extends ChatState {
  const FileQuerySuccess(this.response);
  final FileQueryResponse response;
}

final class FileQueryFailure extends ChatState {
  const FileQueryFailure(this.message);
  final String message;
}

// Chat session init
final class ChatSessionResetting extends ChatState {
  const ChatSessionResetting();
}

final class ChatSessionReset extends ChatState {
  const ChatSessionReset(this.response);
  final InitChatResponse response;
}

final class ChatSessionResetFailure extends ChatState {
  const ChatSessionResetFailure(this.message);
  final String message;
}
