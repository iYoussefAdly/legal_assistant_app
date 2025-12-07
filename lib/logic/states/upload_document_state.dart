import 'package:equatable/equatable.dart';

abstract class UploadDocumentState extends Equatable {
  const UploadDocumentState();

  @override
  List<Object?> get props => [];
}

class UploadDocumentInitial extends UploadDocumentState {
  const UploadDocumentInitial();
}

class UploadDocumentLoading extends UploadDocumentState {
  const UploadDocumentLoading();
}

class UploadDocumentSuccess extends UploadDocumentState {
  const UploadDocumentSuccess(this.response);

  final Map<String, dynamic> response;

  @override
  List<Object?> get props => [response];
}

class UploadDocumentFailure extends UploadDocumentState {
  const UploadDocumentFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}