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
    required this.termsSummary,
    this.transcript,
  });

  final bool success;
  final String query;
  final String answer;
  final String riskLevel;
  final List<SourceReference> sources;
  final List<CitedSource> citedSources;
  final List<String> termsSummary;
  final String? transcript;

  factory AudioQueryResponse.fromJson(Map<String, dynamic> json) {
    return AudioQueryResponse(
      success: json['success'] as bool? ?? false,
      query: json['query']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      riskLevel: json['risk_level']?.toString() ?? '',
      sources: SourceReference.listFromJson(json['sources']),
      citedSources: CitedSource.listFromJson(json['cited_sources']),
      termsSummary: _parseTermsSummary(json['terms_summary']),
      transcript: _parseTranscript(json),
    );
  }

  static List<String> _parseTermsSummary(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    if (value is String && value.isNotEmpty) {
      return [value];
    }
    return const [];
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
        termsSummary,
        transcript,
      ];
}

