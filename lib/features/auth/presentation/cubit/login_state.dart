import 'package:legal_assistant_app/features/auth/domain/entities/user_entity.dart';

sealed class LoginState {
  const LoginState();
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class CheckingLoginState extends LoginState {
  const CheckingLoginState();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  const LoginSuccess({this.user});
  final UserEntity? user;
}

final class LoginFailure extends LoginState {
  const LoginFailure({required this.message});
  final String message;
}
