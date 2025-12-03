import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/api/qanouny_api_service.dart';
import '../states/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final QanounyApiService _apiService = QanounyApiService();
  LoginCubit() : super(LoginInitial());
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

/// Save the user's login state in shared preferences
Future<void>saveUserLoginState(bool value) async {
final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
}

/// Check the user's login status from shared preferences
 Future<void> checkLoginStatus() async {
   emit(CheckingLoginState());
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      emit(LoginSuccess());
    } else {
      emit(LoginInitial());
    }
  }


/// Clear the user's login state in shared preferences
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
await prefs.remove('isLoggedIn');}


  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      emit(LoginLoading());
      try {
        await _apiService.login(
          nationalId: nationalIdController.text.trim(),
          password: passwordController.text.trim(),
        );
        await saveUserLoginState(true);
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