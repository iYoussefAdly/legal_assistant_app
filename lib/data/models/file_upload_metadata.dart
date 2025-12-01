enum FileUploadType { image, pdf }

class FileUploadMetadata {
  const FileUploadMetadata({
    required this.fileName,
    required this.type,
  });

  final String fileName;
  final FileUploadType type;

  bool get isPdf => type == FileUploadType.pdf;
  bool get isImage => type == FileUploadType.image;
}







