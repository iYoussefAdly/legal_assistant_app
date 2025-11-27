import 'package:equatable/equatable.dart';
import 'package:legal_assistant_app/data/models/legal_source.dart';

class TextQueryResponse extends Equatable {
  const TextQueryResponse({
    required this.success,
    required this.query,
    required this.answer,
    required this.riskLevel,
    required this.sources,
    required this.citedSources,
    required this.termsSummary,
  });

  final bool success;
  final String query;
  final String answer;
  final String riskLevel;
  final List<SourceReference> sources;
  final List<CitedSource> citedSources;
  final List<String> termsSummary;

  factory TextQueryResponse.fromJson(Map<String, dynamic> json) {
    return TextQueryResponse(
      success: json['success'] as bool? ?? false,
      query: json['query']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      riskLevel: json['risk_level']?.toString() ?? '',
      sources: SourceReference.listFromJson(json['sources']),
      citedSources: CitedSource.listFromJson(json['cited_sources']),
      termsSummary: _parseTermsSummary(json['terms_summary']),
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

  @override
  List<Object?> get props => [
        success,
        query,
        answer,
        riskLevel,
        sources,
        citedSources,
        termsSummary,
      ];
}

