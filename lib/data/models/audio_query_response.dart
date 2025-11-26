import 'package:equatable/equatable.dart';

class AudioQueryResponse extends Equatable {
  const AudioQueryResponse({
    required this.success,
    required this.query,
    required this.answer,
    required this.riskLevel,
    required this.sources,
  });

  final bool success;
  final String query;
  final String answer;
  final String riskLevel;
  final List<String> sources;

  factory AudioQueryResponse.fromJson(Map<String, dynamic> json) {
    return AudioQueryResponse(
      success: json['success'] as bool? ?? false,
      query: json['query']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      riskLevel: json['risk_level']?.toString() ?? '',
      sources: _parseSources(json['sources']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'query': query,
      'answer': answer,
      'risk_level': riskLevel,
      'sources': sources,
    };
  }

  static List<String> _parseSources(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return const [];
  }

  @override
  List<Object?> get props => [success, query, answer, riskLevel, sources];
}

