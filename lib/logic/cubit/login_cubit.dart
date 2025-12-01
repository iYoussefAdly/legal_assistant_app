import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/api/qanouny_api_service.dart';
import '../states/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final QanounyApiService _apiService = QanounyApiService();
  LoginCubit() : super(LoginInitial());
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      emit(LoginLoading());
      try {
        await _apiService.login(
          nationalId: nationalIdController.text.trim(),
          password: passwordController.text.trim(),
        );
        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailure(errorMessage: e.toString()));
      }
    }
  }

  @override
  Future<void> close() {
    nationalIdController.dispose();
    passwordController.dispose();
    return super.close();
  }
}