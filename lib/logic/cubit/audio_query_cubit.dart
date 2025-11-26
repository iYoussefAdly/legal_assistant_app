import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/data/repository/qanouny_repository.dart';
import 'package:legal_assistant_app/logic/states/audio_query_state.dart';

class AudioQueryCubit extends Cubit<AudioQueryState> {
  AudioQueryCubit(this._repository) : super(const AudioQueryInitial());

  final QanounyRepository _repository;

  Future<void> sendAudioQuery(String filePath) async {
    emit(const AudioQueryLoading());
    try {
      final response = await _repository.sendAudioQuery(filePath);
      emit(AudioQuerySuccess(response));
    } catch (error) {
      emit(AudioQueryFailure(_extractMessage(error)));
    }
  }

  String _extractMessage(Object error) {
    if (error is QanounyRepositoryException) {
      return error.message;
    }
    return error.toString();
  }
}


