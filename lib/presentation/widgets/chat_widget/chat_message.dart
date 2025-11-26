import 'package:equatable/equatable.dart';

enum MessageRole { user, assistant }

enum MessageKind { text, audio, file }

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.role,
    required this.content,
    this.kind = MessageKind.text,
    this.riskLevel,
    this.sources = const [],
    this.fullText,
  });

  final MessageRole role;
  final MessageKind kind;
  final String content;
  final String? riskLevel;
  final List<String> sources;
  final String? fullText;

  bool get hasMetadata =>
      (riskLevel?.isNotEmpty ?? false) ||
      sources.isNotEmpty ||
      (fullText?.isNotEmpty ?? false);

  @override
  List<Object?> get props =>
      [role, kind, content, riskLevel, sources, fullText];
}

