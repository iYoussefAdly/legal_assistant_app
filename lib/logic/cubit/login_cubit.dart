import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/api/qanouny_api_service.dart';
import '../states/login_state.dart';
import '../../data/models/user_data.dart';

class LoginCubit extends Cubit<LoginState> {
  final QanounyApiService _apiService = QanounyApiService();
  
  UserData? _currentUser;
  UserData? get currentUser => _currentUser;
  
  LoginCubit() : super(LoginInitial());
  
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> saveUserLoginState(bool value, {UserData? userData}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
    
    if (userData != null && userData.nationalId != null) {
      await prefs.setString('nationalId', userData.nationalId!);
      await prefs.setString('fullName', userData.fullName ?? '');
      await prefs.setString('email', userData.email ?? '');
      await prefs.setString('gender', userData.gender ?? '');
    }
  }

  Future<UserData?> _loadSavedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final nationalId = prefs.getString('nationalId');
    
    if (nationalId == null) return null;
    
    return UserData(
      nationalId: nationalId,
      fullName: prefs.getString('fullName'),
      email: prefs.getString('email'),
      gender: prefs.getString('gender'),
    );
  }

  Future<void> checkLoginStatus() async {
    emit(CheckingLoginState());
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      _currentUser = await _loadSavedUserData();
      emit(LoginSuccess(userData: _currentUser));
    } else {
      emit(LoginInitial());
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('nationalId');
    await prefs.remove('fullName');
    await prefs.remove('email');
    await prefs.remove('gender');
    
    _currentUser = null;
    emit(LoginInitial());
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      emit(LoginLoading());
      try {
        final nationalId = nationalIdController.text.trim();
        
        print('🔐 Attempting login with nationalId: $nationalId');
        
        final response = await _apiService.login(
          nationalId: nationalId,
          password: passwordController.text.trim(),
        );
        
        _currentUser = UserData.fromJson(response);
        
        // ⭐⭐⭐⭐ أهم جزء: احفظ الـ nationalId في SharedPreferences ⭐⭐⭐⭐
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('nationalId', nationalId);
        print('💾 Saved nationalId to SharedPreferences: $nationalId');
        
        await saveUserLoginState(true, userData: _currentUser);
        
        emit(LoginSuccess(userData: _currentUser));
      } catch (e) {
        emit(LoginFailure(errorMessage: e.toString()));
      }
    }
  }

  String? get currentNationalId => _currentUser?.nationalId;

  @override
  Future<void> close() {
    nationalIdController.dispose();
    passwordController.dispose();
    return super.close();
  }
}