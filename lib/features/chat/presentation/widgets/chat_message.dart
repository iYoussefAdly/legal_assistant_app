import 'package:equatable/equatable.dart';
import 'package:legal_assistant_app/features/chat/data/models/legal_source_model.dart';

enum MessageRole { user, assistant }

enum MessageKind { text, audio, file }

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.role,
    required this.content,
    this.kind = MessageKind.text,
    this.riskLevel,
    this.citedSources = const [],
    this.termSummary,
    this.fullText,
  });

  final MessageRole role;
  final MessageKind kind;
  final String content;
  final String? riskLevel;
  final List<CitedSource> citedSources;
  final String? termSummary;
  final String? fullText;

  bool get hasMetadata =>
      (riskLevel?.isNotEmpty ?? false) ||
      citedSources.isNotEmpty ||
      (termSummary?.isNotEmpty ?? false) ||
      (fullText?.isNotEmpty ?? false);

  @override
  List<Object?> get props =>
      [role, kind, content, riskLevel, citedSources, termSummary, fullText];
}
