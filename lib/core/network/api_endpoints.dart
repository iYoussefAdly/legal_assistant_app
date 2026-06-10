import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ApiEndpoints {
  // Main FastAPI backend
  static const String mainBaseUrl = 'http://52.143.145.178:8000';

  // Azure Functions backend
  static const String azureBaseUrl =
      'https://sql-function-b3c7e6exa9f9acdu.francecentral-01.azurewebsites.net/api';

  static String get azureFunctionKey =>
      dotenv.env['AZURE_FUNCTION_KEY'] ??
      'nb7jrePPZdZkW_m40b-K12SRVOcGY5u1bgwXDh7ywjgoAzFuvjEF6w==';

  static String get signupUrl =>
      dotenv.env['SIGNUP_URL'] ?? '$azureBaseUrl/create_user?code=$azureFunctionKey';

  static String get loginUrl =>
      '$azureBaseUrl/read_user_data?code=$azureFunctionKey';

  static String get uploadDocumentUrl =>
      '$azureBaseUrl/UploadDocument?code=$azureFunctionKey';

  // Main API paths
  static const String textQuery = '/api/query/text';
  static const String audioQuery = '/api/query/audio';
  static const String fileQuery = '/api/query/file';
  static const String initChat = '/api/init';
  static const String healthCheck = '/';
}
