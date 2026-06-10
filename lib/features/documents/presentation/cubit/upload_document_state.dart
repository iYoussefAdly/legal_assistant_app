sealed class UploadDocumentState {
  const UploadDocumentState();
}

final class UploadDocumentInitial extends UploadDocumentState {
  const UploadDocumentInitial();
}

final class UploadDocumentLoading extends UploadDocumentState {
  const UploadDocumentLoading();
}

final class UploadDocumentSuccess extends UploadDocumentState {
  const UploadDocumentSuccess(this.response);
  final Map<String, dynamic> response;
}

final class UploadDocumentFailure extends UploadDocumentState {
  const UploadDocumentFailure(this.message);
  final String message;
}
