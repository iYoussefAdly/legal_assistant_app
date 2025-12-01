import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_assistant_app/data/api/api_endpoints.dart';
import 'package:legal_assistant_app/data/models/user_data.dart';
import 'package:legal_assistant_app/logic/states/signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());
  Dio dio = Dio();
  Future<void> signup(UserData user) async {
    emit(SignupLoading());
    try {
      final response = await dio.post(
        ApiEndpoints.signupUrl,
        data: user.toJson(),
      );
      if (response.statusCode == 200) {
        emit(SignupSuccess());
        print(response.toString());
      }
    } catch (e) {
      emit(SignupFailure(e.toString()));
      print(e.toString());
    }
  }
}
