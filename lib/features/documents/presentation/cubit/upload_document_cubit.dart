import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/core/utils/api_result.dart';
import 'package:legal_assistant_app/features/documents/domain/use_cases/upload_document_use_case.dart';
import 'package:legal_assistant_app/features/documents/presentation/cubit/upload_document_state.dart';

class UploadDocumentCubit extends Cubit<UploadDocumentState> {
  UploadDocumentCubit(this._uploadDocument)
      : super(const UploadDocumentInitial());

  final UploadDocumentUseCase _uploadDocument;

  Future<void> uploadDocument({
    required String nationalId,
    required String filePath,
    String? title,
  }) async {
    emit(const UploadDocumentLoading());
    final result = await _uploadDocument(
      nationalId: nationalId,
      filePath: filePath,
      title: title,
    );
    switch (result) {
      case ApiSuccess(:final data):
        emit(UploadDocumentSuccess(data));
      case ApiError(:final failure):
        emit(UploadDocumentFailure(failure.message));
    }
  }
}
