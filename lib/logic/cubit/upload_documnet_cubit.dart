import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/data/repository/qanouny_repository.dart';
import 'package:legal_assistant_app/logic/states/upload_document_state.dart';

class UploadDocumentCubit extends Cubit<UploadDocumentState> {
  UploadDocumentCubit(this._repository) : super(const UploadDocumentInitial());

  final QanounyRepository _repository;

  Future<void> uploadDocument({
    required String nationalId,
    required String filePath,
    String? title,
  }) async {
    emit(const UploadDocumentLoading());
    try {
      final response = await _repository.uploadDocument(
        nationalId: nationalId,
        filePath: filePath,
        title: title,
      );
      emit(UploadDocumentSuccess(response));
    } catch (error) {
      emit(UploadDocumentFailure(_extractMessage(error)));
    }
  }
  String _extractMessage(Object error) {
    if (error is QanounyRepositoryException) {
      return error.message;
    }
    return error.toString();
  }
}