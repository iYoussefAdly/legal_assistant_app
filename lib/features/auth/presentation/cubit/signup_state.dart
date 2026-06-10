sealed class SignupState {
  const SignupState();
}

final class SignupInitial extends SignupState {
  const SignupInitial();
}

final class SignupLoading extends SignupState {
  const SignupLoading();
}

final class SignupSuccess extends SignupState {
  const SignupSuccess();
}

final class SignupFailure extends SignupState {
  const SignupFailure({required this.message});
  final String message;
}
