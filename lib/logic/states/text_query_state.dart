import 'package:equatable/equatable.dart';
import 'package:legal_assistant_app/data/models/text_query_response.dart';

abstract class TextQueryState extends Equatable {
  const TextQueryState();

  @override
  List<Object?> get props => [];
}

class TextQueryInitial extends TextQueryState {
  const TextQueryInitial();
}

class TextQueryLoading extends TextQueryState {
  const TextQueryLoading();
}

class TextQuerySuccess extends TextQueryState {
  const TextQuerySuccess(this.response);

  final TextQueryResponse response;

  @override
  List<Object?> get props => [response];
}

class TextQueryFailure extends TextQueryState {
  const TextQueryFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

