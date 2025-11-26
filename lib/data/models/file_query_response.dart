import 'package:equatable/equatable.dart';

class FileQueryResponse extends Equatable {
  const FileQueryResponse({
    required this.success,
    required this.fullText,
    required this.query,
    required this.answer,
    required this.riskLevel,
    required this.sources,
  });

  final bool success;
  final String fullText;
  final String query;
  final String answer;
  final String riskLevel;
  final List<String> sources;

  factory FileQueryResponse.fromJson(Map<String, dynamic> json) {
    return FileQueryResponse(
      success: json['success'] as bool? ?? false,
      fullText: json['full_text']?.toString() ?? '',
      query: json['query']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      riskLevel: json['risk_level']?.toString() ?? '',
      sources: _parseSources(json['sources']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'full_text': fullText,
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
  List<Object?> get props =>
      [success, fullText, query, answer, riskLevel, sources];
}


