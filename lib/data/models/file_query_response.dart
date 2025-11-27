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
    required this.termsSummary,
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
  final List<String> termsSummary;
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
      termsSummary: _parseTermsSummary(json['terms_summary']),
      uploadedFileName: uploadedFileName,
      uploadType: uploadType,
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
        fullText,
        query,
        answer,
        riskLevel,
        sources,
        citedSources,
        termsSummary,
        uploadedFileName,
        uploadType,
      ];
}

