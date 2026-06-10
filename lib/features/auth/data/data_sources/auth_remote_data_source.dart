import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:legal_assistant_app/core/errors/exceptions.dart';
import 'package:legal_assistant_app/core/network/api_endpoints.dart';
import 'package:legal_assistant_app/features/auth/data/models/user_data_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<UserDataModel> login(String nationalId, String password) async {
    final trimmedId = nationalId.trim();
    final trimmedPassword = password.trim();

    if (trimmedId.isEmpty || trimmedPassword.isEmpty) {
      throw const QanounyApiException('National ID and password are required.');
    }

    try {
      final response = await _dio.post(
        ApiEndpoints.loginUrl,
        data: {'NationalId': trimmedId},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final userData = _parseUserData(response.data);
        final storedHash = userData['PasswordHash']?.toString();

        if (storedHash == null) {
          throw const QanounyApiException('User data is incomplete.');
        }

        if (trimmedPassword != storedHash) {
          throw const QanounyApiException('Incorrect password.');
        }

        return UserDataModel.fromJson(userData);
      }

      throw QanounyApiException(
        'Login failed. Status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      developer.log('[AuthDataSource] login error: ${e.message}', name: 'AuthRemoteDataSource');
      throw QanounyApiException(_resolveDioMessage(e));
    } on QanounyApiException {
      rethrow;
    } catch (_) {
      throw const QanounyApiException('Unexpected error during login.');
    }
  }

  Future<void> signup(UserDataModel model) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.signupUrl,
        data: model.toJson(),
      );

      if (response.statusCode != 200) {
        throw QanounyApiException(
          'Signup failed. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      developer.log('[AuthDataSource] signup error: ${e.message}', name: 'AuthRemoteDataSource');
      throw QanounyApiException(_resolveDioMessage(e));
    } on QanounyApiException {
      rethrow;
    } catch (_) {
      throw const QanounyApiException('Unexpected error during signup.');
    }
  }

  Map<String, dynamic> _parseUserData(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return data.cast<String, dynamic>();
    if (data is String) {
      final start = data.indexOf('{');
      final end = data.lastIndexOf('}');
      if (start != -1 && end != -1) {
        return jsonDecode(data.substring(start, end + 1))
            as Map<String, dynamic>;
      }
    }
    throw const QanounyApiException('Invalid response format from server.');
  }

  String _resolveDioMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'The server is taking too long to respond.';
    }
    if (error.type == DioExceptionType.connectionError) {
      return 'Unable to reach the server. Check your connection.';
    }
    return error.message ?? 'Request failed. Please try again.';
  }
}
