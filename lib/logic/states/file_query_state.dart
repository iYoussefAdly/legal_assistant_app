import 'package:equatable/equatable.dart';
import 'package:legal_assistant_app/data/models/file_query_response.dart';

abstract class FileQueryState extends Equatable {
  const FileQueryState();

  @override
  List<Object?> get props => [];
}

class FileQueryInitial extends FileQueryState {
  const FileQueryInitial();
}

class FileQueryLoading extends FileQueryState {
  const FileQueryLoading();
}

class FileQuerySuccess extends FileQueryState {
  const FileQuerySuccess(this.response);

  final FileQueryResponse response;

  @override
  List<Object?> get props => [response];
}

class FileQueryFailure extends FileQueryState {
  const FileQueryFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}


