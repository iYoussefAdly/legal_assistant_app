import 'package:equatable/equatable.dart';

class SourceReference extends Equatable {
  const SourceReference({required this.id, this.category, this.sourceFile});

  final String id;
  final String? category;
  final String? sourceFile;

  factory SourceReference.fromJson(Map<String, dynamic> json) => SourceReference(
        id: json['id']?.toString() ?? '',
        category: json['category']?.toString(),
        sourceFile: json['source_file']?.toString(),
      );

  static List<SourceReference> listFromJson(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => SourceReference.fromJson(e.cast<String, dynamic>()))
          .toList();
    }
    return const [];
  }

  @override
  List<Object?> get props => [id, category, sourceFile];
}

class CitedSource extends Equatable {
  const CitedSource({required this.id, required this.text, this.category});

  final String id;
  final String text;
  final String? category;

  factory CitedSource.fromJson(Map<String, dynamic> json) => CitedSource(
        id: json['id']?.toString() ?? '',
        text: json['text']?.toString() ?? '',
        category: json['category']?.toString(),
      );

  static List<CitedSource> listFromJson(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => CitedSource.fromJson(e.cast<String, dynamic>()))
          .toList();
    }
    return const [];
  }

  @override
  List<Object?> get props => [id, text, category];
}
