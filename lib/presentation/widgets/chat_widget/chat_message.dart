import 'package:equatable/equatable.dart';
import 'package:legal_assistant_app/data/models/legal_source.dart';

enum MessageRole { user, assistant }

enum MessageKind { text, audio, file }

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.role,
    required this.content,
    this.kind = MessageKind.text,
    this.riskLevel,
    this.citedSources = const [],
    this.termsSummary = const [],
    this.fullText,
  });

  final MessageRole role;
  final MessageKind kind;
  final String content;
  final String? riskLevel;
  final List<CitedSource> citedSources;
  final List<String> termsSummary;
  final String? fullText;

  bool get hasMetadata =>
      (riskLevel?.isNotEmpty ?? false) ||
      citedSources.isNotEmpty ||
      termsSummary.isNotEmpty ||
      (fullText?.isNotEmpty ?? false);

  @override
  List<Object?> get props => [
        role,
        kind,
        content,
        riskLevel,
        citedSources,
        termsSummary,
        fullText,
      ];
}

