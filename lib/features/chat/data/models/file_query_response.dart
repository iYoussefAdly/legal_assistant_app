import 'package:equatable/equatable.dart';
import 'package:legal_assistant_app/features/chat/data/models/file_upload_metadata.dart';
import 'package:legal_assistant_app/features/chat/data/models/legal_source_model.dart';

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
  }) =>
      FileQueryResponse(
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

  @override
  List<Object?> get props => [
        success, fullText, query, answer, riskLevel, sources,
        citedSources, termSummary, uploadedFileName, uploadType,
      ];
}
