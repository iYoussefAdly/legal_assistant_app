import 'package:equatable/equatable.dart';
import 'package:legal_assistant_app/data/models/user_data.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class CheckingLoginState extends LoginState {
  const CheckingLoginState();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final UserData? userData;
  
  const LoginSuccess({this.userData});
  
  @override
  List<Object?> get props => [userData];
}

class LoginFailure extends LoginState {
  final String errorMessage;
  
  const LoginFailure({required this.errorMessage});
  
  @override
  List<Object?> get props => [errorMessage];
}