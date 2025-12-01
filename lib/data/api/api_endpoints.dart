import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get signupUrl => dotenv.env['SIGNUP_URL'] ?? "";
  static String get loginUrl => dotenv.env['LOGIN_URL'] ?? "";
}