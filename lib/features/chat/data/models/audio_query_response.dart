import 'package:equatable/equatable.dart';
import 'package:legal_assistant_app/features/chat/data/models/legal_source_model.dart';

class AudioQueryResponse extends Equatable {
  const AudioQueryResponse({
    required this.success,
    required this.query,
    required this.answer,
    required this.riskLevel,
    required this.sources,
    required this.citedSources,
    this.termSummary,
    this.transcript,
  });

  final bool success;
  final String query;
  final String answer;
  final String riskLevel;
  final List<SourceReference> sources;
  final List<CitedSource> citedSources;
  final String? termSummary;
  final String? transcript;

  factory AudioQueryResponse.fromJson(Map<String, dynamic> json) =>
      AudioQueryResponse(
        success: json['success'] as bool? ?? false,
        query: json['query']?.toString() ?? '',
        answer: json['answer']?.toString() ?? '',
        riskLevel: json['risk_level']?.toString() ?? '',
        sources: SourceReference.listFromJson(json['sources']),
        citedSources: CitedSource.listFromJson(json['cited_sources']),
        termSummary: _parseTermSummary(json),
        transcript: _parseTranscript(json),
      );

  static String? _parseTermSummary(Map<String, dynamic> json) {
    String? parse(dynamic v) {
      if (v is String) {
        final s = v.trim();
        return s.isEmpty ? null : s;
      }
      if (v is List) {
        final entries =
            v.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList();
        return entries.isEmpty ? null : entries.join('\n\n');
      }
      return null;
    }
    return parse(json['term_summary']) ?? parse(json['terms_summary']);
  }

  static String? _parseTranscript(Map<String, dynamic> json) {
    const keys = ['transcript', 'transcription', 'transcribed_text', 'audio_transcript'];
    for (final key in keys) {
      final v = json[key];
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return null;
  }

  @override
  List<Object?> get props => [
        success, query, answer, riskLevel, sources,
        citedSources, termSummary, transcript,
      ];
}
