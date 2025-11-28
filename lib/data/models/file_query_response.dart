import 'package:equatable/equatable.dart';
import 'package:legal_assistant_app/data/models/file_upload_metadata.dart';
import 'package:legal_assistant_app/data/models/legal_source.dart';

class FileQueryResponse extends Equatable {
  const FileQueryResponse({
    required this.success,
    required this.fullText,
    required this.query,
    required this.answer,
    required this.riskLevel,
    required this.sources,
    required this.citedSources,
    this.termSummary,
    this.uploadedFileName,
    this.uploadType,
  });

  final bool success;
  final String fullText;
  final String query;
  final String answer;
  final String riskLevel;
  final List<SourceReference> sources;
  final List<CitedSource> citedSources;
  final String? termSummary;
  final String? uploadedFileName;
  final FileUploadType? uploadType;

  factory FileQueryResponse.fromJson(
    Map<String, dynamic> json, {
    String? uploadedFileName,
    FileUploadType? uploadType,
  }) {
    return FileQueryResponse(
      success: json['success'] as bool? ?? false,
      fullText: json['full_text']?.toString() ?? '',
      query: json['query']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      riskLevel: json['risk_level']?.toString() ?? '',
      sources: SourceReference.listFromJson(json['sources']),
      citedSources: CitedSource.listFromJson(json['cited_sources']),
      termSummary: _parseTermSummary(json),
      uploadedFileName: uploadedFileName,
      uploadType: uploadType,
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

  @override
  List<Object?> get props => [
        success,
        fullText,
        query,
        answer,
        riskLevel,
        sources,
        citedSources,
        termSummary,
        uploadedFileName,
        uploadType,
      ];
}

