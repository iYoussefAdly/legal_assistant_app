import 'package:equatable/equatable.dart';
import 'package:legal_assistant_app/data/models/legal_source.dart';

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

  factory AudioQueryResponse.fromJson(Map<String, dynamic> json) {
    return AudioQueryResponse(
      success: json['success'] as bool? ?? false,
      query: json['query']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      riskLevel: json['risk_level']?.toString() ?? '',
      sources: SourceReference.listFromJson(json['sources']),
      citedSources: CitedSource.listFromJson(json['cited_sources']),
      termSummary: _parseTermSummary(json),
      transcript: _parseTranscript(json),
    );
  }

  static String? _parseTermSummary(Map<String, dynamic> json) {
    String? parseValue(dynamic value) {
      if (value is String) {
        final trimmed = value.trim();
        return trimmed.isEmpty ? null : trimmed;
      }
      if (value is List) {
        final entries = value
            .map((item) => item.toString().trim())
            .where((item) => item.isNotEmpty)
            .toList();
        if (entries.isNotEmpty) {
          return entries.join('\n\n');
        }
      }
      return null;
    }

    return parseValue(json['term_summary']) ??
        parseValue(json['terms_summary']);
  }

  static String? _parseTranscript(Map<String, dynamic> json) {
    const transcriptKeys = [
      'transcript',
      'transcription',
      'transcribed_text',
      'audio_transcript',
    ];
    for (final key in transcriptKeys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [
        success,
        query,
        answer,
        riskLevel,
        sources,
        citedSources,
        termSummary,
        transcript,
      ];
}

