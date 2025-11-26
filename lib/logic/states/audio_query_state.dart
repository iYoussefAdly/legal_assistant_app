import 'package:equatable/equatable.dart';
import 'package:legal_assistant_app/data/models/audio_query_response.dart';

abstract class AudioQueryState extends Equatable {
  const AudioQueryState();

  @override
  List<Object?> get props => [];
}

class AudioQueryInitial extends AudioQueryState {
  const AudioQueryInitial();
}

class AudioQueryLoading extends AudioQueryState {
  const AudioQueryLoading();
}

class AudioQuerySuccess extends AudioQueryState {
  const AudioQuerySuccess(this.response);

  final AudioQueryResponse response;

  @override
  List<Object?> get props => [response];
}

class AudioQueryFailure extends AudioQueryState {
  const AudioQueryFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

