import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:legal_assistant_app/data/api/api_exception.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class QanounyApiService {
  QanounyApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: _baseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 20),
                responseType: ResponseType.json,
              ),
            ) {
    final hasLogger =
        _dio.interceptors.any((element) => element is PrettyDioLogger);
    if (!hasLogger) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          compact: true,
        ),
      );
    }
  }

  static const String _baseUrl = 'http://52.143.145.178:8000';

  final Dio _dio;

  Future<Map<String, dynamic>> sendTextQuery(String question) async {
    // Validate question is not empty
    final trimmedQuestion = question.trim();
    if (trimmedQuestion.isEmpty) {
      throw const QanounyApiException(
        'Question cannot be empty. Please provide a valid question.',
      );
    }

    try {
      // Backend expects url-encoded form data
      final response = await _dio.post(
        '/api/query/text',
        data: {
          'question': trimmedQuestion,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'accept': 'application/json',
          },
        ),
      );

      return _asMap(response.data);
    } on DioException catch (error) {
      throw QanounyApiException(_resolveDioMessage(error));
    } catch (e) {
      if (e is QanounyApiException) {
        rethrow;
      }
      throw QanounyApiException('Failed to send question: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> sendAudioQuery(String filePath) async {
    final fileName = filePath.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      'audio_file': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
    });
    return _execute(
      () => _dio.post('/api/query/audio', data: formData),
    );
  }
  Future<Map<String, dynamic>> sendFileQuery(
    String filePath,
    String question,
  ) async {
    final fileName = filePath.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
      'question': question,
    });
    return _execute(
      () => _dio.post('/api/query/file', data: formData),
    );
  }

  Future<Map<String, dynamic>> resetConversation() async {
    return _execute(() => _dio.post('/api/reset'));
  }

  Future<Map<String, dynamic>> _execute(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      final response = await request();
      return _asMap(response.data);
    } on DioException catch (error) {
      throw QanounyApiException(_resolveDioMessage(error));
    } catch (_) {
      throw const QanounyApiException(
        'Unexpected error occurred. Please try again later.',
      );
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return data.cast<String, dynamic>();
    throw const QanounyApiException('Invalid response from server.');
  }

  String _resolveDioMessage(DioException error) {
    final responseData = error.response?.data;
    
    // Handle validation errors (often in 'detail' field as a list)
    if (responseData is Map && responseData['detail'] != null) {
      final detail = responseData['detail'];
      if (detail is List) {
        // Format validation errors from list with user-friendly messages
        final messages = detail.map((e) {
          if (e is Map) {
            final loc = e['loc'];
            final msg = e['msg'];
            if (loc != null && msg != null) {
              final field = loc is List && loc.length > 1 ? loc.last : 'field';
              final fieldName = field.toString();
              final message = msg.toString();
              
              // Provide user-friendly error messages
              if (fieldName == 'question' && message.toLowerCase().contains('required')) {
                return 'Please enter a question before sending.';
              }
              if (message.toLowerCase().contains('required')) {
                return '${fieldName.toString().replaceAll('_', ' ').split(' ').map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1)).join(' ')} is required.';
              }
              return '${fieldName.toString()}: ${message.toString()}';
            }
          }
          return e.toString();
        }).join(', ');
        return messages.isNotEmpty ? messages : detail.toString();
      }
      return detail.toString();
    }
    
    if (responseData is Map && responseData['message'] != null) {
      return responseData['message'].toString();
    }
    
    // Handle validation errors as list in responseData
    if (responseData is List) {
      final messages = responseData.map((e) {
        if (e is Map) {
          final loc = e['loc'];
          final msg = e['msg'];
          if (loc != null && msg != null) {
            final field = loc is List && loc.length > 1 ? loc.last : 'field';
            final fieldName = field.toString();
            final message = msg.toString();
            
            // Provide user-friendly error messages
            if (fieldName == 'question' && message.toLowerCase().contains('required')) {
              return 'Please enter a question before sending.';
            }
            if (message.toLowerCase().contains('required')) {
              return '${fieldName.toString().replaceAll('_', ' ').split(' ').map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1)).join(' ')} is required.';
            }
            return '${fieldName.toString()}: ${message.toString()}';
          }
        }
        return e.toString();
      }).join(', ');
      return messages.isNotEmpty ? messages : 'Validation error occurred.';
    }
    
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'The server is taking too long to respond. Please try again shortly.';
    }
    if (error.type == DioExceptionType.connectionError) {
      return 'Unable to reach the server. Check your connection.';
    }
    if (error.message?.isNotEmpty == true) {
      return error.message!;
    }
    return 'Request failed. Please try again.';
  }
}


