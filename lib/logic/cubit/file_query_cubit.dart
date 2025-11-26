import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/data/repository/qanouny_repository.dart';
import 'package:legal_assistant_app/logic/states/file_query_state.dart';

class FileQueryCubit extends Cubit<FileQueryState> {
  FileQueryCubit(this._repository) : super(const FileQueryInitial());

  final QanounyRepository _repository;

  Future<void> sendFileQuery(String filePath, String question) async {
    emit(const FileQueryLoading());
    try {
      final response = await _repository.sendFileQuery(filePath, question);
      emit(FileQuerySuccess(response));
    } catch (error) {
      emit(FileQueryFailure(_extractMessage(error)));
    }
  }

  String _extractMessage(Object error) {
    if (error is QanounyRepositoryException) {
      return error.message;
    }
    return error.toString();
  }
}


