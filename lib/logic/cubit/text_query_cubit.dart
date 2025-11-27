import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/data/models/init_chat_response.dart';
import 'package:legal_assistant_app/data/repository/qanouny_repository.dart';
import 'package:legal_assistant_app/logic/states/text_query_state.dart';

class TextQueryCubit extends Cubit<TextQueryState> {
  TextQueryCubit(this._repository) : super(const TextQueryInitial());

  final QanounyRepository _repository;

  Future<void> sendTextQuery(String question) async {
    emit(const TextQueryLoading());
    try {
      final response = await _repository.sendTextQuery(question);
      emit(TextQuerySuccess(response));
    } catch (error) {
      emit(TextQueryFailure(_extractMessage(error)));
    }
  }

  Future<InitChatResponse?> initializeChat({
    required String name,
    required String gender,
  }) async {
    emit(const TextQueryLoading());
    try {
      final response = await _repository.initializeChat(name, gender);
      emit(const TextQueryInitial());
      return response;
    } catch (error) {
      emit(TextQueryFailure(_extractMessage(error)));
      return null;
    }
  }

  String _extractMessage(Object error) {
    if (error is QanounyRepositoryException) {
      return error.message;
    }
    return error.toString();
  }
}


