import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:legal_assistant_app/data/api/api_exception.dart';
import 'package:mime/mime.dart';
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
    final trimmedQuestion = question.trim();
    if (trimmedQuestion.isEmpty) {
      throw const QanounyApiException(
        'Question cannot be empty. Please provide a valid question.',
      );
    }

    // Use FormData as per new API documentation
    final formData = FormData.fromMap({
      'question': trimmedQuestion,
    });

    _logFormData('/api/query/text', formData);
    return _execute(
      () => _dio.post(
        '/api/query/text',
        data: formData,
      ),
      endpoint: '/api/query/text',
    );
  }

  Future<Map<String, dynamic>> sendAudioQuery(String filePath) async {
    final fileName = filePath.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      'audio_file': await _multipartFromFile(filePath, fileName),
    });

    _logFormData('/api/query/audio', formData);
    return _execute(
      () => _dio.post(
        '/api/query/audio',
        data: formData,
      ),
      endpoint: '/api/query/audio',
    );
  }

  Future<Map<String, dynamic>> sendFileQuery(
    String filePath,
    String question,
  ) async {
    final trimmedQuestion = question.trim();
    if (trimmedQuestion.isEmpty) {
      throw const QanounyApiException(
        'Please provide a question related to the uploaded document.',
      );
    }
    final formData = FormData.fromMap({
      'file': await _multipartFromFile(
        filePath,
        filePath.split(Platform.pathSeparator).last,
      ),
      'question': trimmedQuestion,
    });

    _logFormData('/api/query/file', formData);
    return _execute(
      () => _dio.post(
        '/api/query/file',
        data: formData,
      ),
      endpoint: '/api/query/file',
    );
  }

  Future<Map<String, dynamic>> initializeChat({
    required String name,
    required String gender,
  }) async {
    final trimmedName = name.trim();
    final trimmedGender = gender.trim();
    if (trimmedName.isEmpty || trimmedGender.isEmpty) {
      throw const QanounyApiException(
        'Name and gender are required to initialize the chat.',
      );
    }

    // Use FormData as per new API documentation
    final formData = FormData.fromMap({
      'name': trimmedName,
      'gender': trimmedGender,
    });

    _logFormData('/api/init', formData);
    return _execute(
      () => _dio.post(
        '/api/init',
        data: formData,
      ),
      endpoint: '/api/init',
    );
  }

  Future<Map<String, dynamic>> healthCheck() async {
    return _execute(
      () => _dio.get('/'),
      endpoint: '/',
    );
  }

  Future<Map<String, dynamic>> _execute(
    Future<Response<dynamic>> Function() request, {
    required String endpoint,
  }) async {
    try {
      final response = await request();
      _logResponse(endpoint, response);
      final data = _asMap(response.data);
      
      // Check if the response indicates an error (success: false with error_message)
      if (data.containsKey('success') && data['success'] == false) {
        final errorMessage = data['error_message']?.toString() ?? 
            'An error occurred while processing your request.';
        throw QanounyApiException(errorMessage);
      }
      
      return data;
    } on DioException catch (error) {
      _logDioError(endpoint, error);
      throw QanounyApiException(_resolveDioMessage(error));
    } on QanounyApiException {
      rethrow;
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

  Future<MultipartFile> _multipartFromFile(
    String filePath,
    String fileName,
  ) async {
    final mediaType = _resolveMediaType(filePath);
    return MultipartFile.fromFile(
      filePath,
      filename: fileName,
      contentType: mediaType,
    );
  }

  MediaType? _resolveMediaType(String filePath) {
    final lowerPath = filePath.toLowerCase();
    if (lowerPath.endsWith('.wav')) {
      return MediaType('audio', 'wav');
    }

    final mimeType = lookupMimeType(filePath);
    if (mimeType == null) return null;
    final parts = mimeType.split('/');
    if (parts.length != 2) return null;
    var type = parts.first;
    var subType = parts.last;

    if (subType == 'x-wav') {
      subType = 'wav';
    }

    return MediaType(type, subType);
  }

  void _logFormData(String endpoint, FormData formData) {
    final buffer = StringBuffer()
      ..writeln('[$endpoint] Sending multipart request')
      ..writeln('Fields:');
    if (formData.fields.isEmpty) {
      buffer.writeln('  (none)');
    } else {
      for (final field in formData.fields) {
        buffer.writeln('  ${field.key}: ${field.value}');
      }
    }
    buffer.writeln('Files:');
    if (formData.files.isEmpty) {
      buffer.writeln('  (none)');
    } else {
      for (final fileEntry in formData.files) {
        final file = fileEntry.value;
        final contentType = file.contentType;
        buffer.writeln(
          '  ${fileEntry.key}: ${file.filename} '
          '(${file.length ?? 'unknown'} bytes, '
          '${contentType != null ? '${contentType.type}/${contentType.subtype}' : 'content-type: auto'})',
        );
      }
    }
    _recordLog(buffer.toString());
  }

  void _logResponse(String endpoint, Response<dynamic> response) {
    final requestHeaders = response.requestOptions.headers;
    final responseHeaders = response.headers.map;
    final buffer = StringBuffer()
      ..writeln('[$endpoint] Request headers: ${_formatHeaders(requestHeaders)}')
      ..writeln(
        '[$endpoint] Response status: ${response.statusCode} '
        '(${response.statusMessage ?? 'no-status-message'})',
      )
      ..writeln(
        '[$endpoint] Response headers: ${_formatHeaders(responseHeaders)}',
      )
      ..writeln('[$endpoint] Response data: ${response.data}');
    _recordLog(buffer.toString());
  }

  void _logDioError(String endpoint, DioException error) {
    final requestHeaders = error.requestOptions.headers;
    final buffer = StringBuffer()
      ..writeln('[ERROR $endpoint] Request headers: ${_formatHeaders(requestHeaders)}')
      ..writeln('[ERROR $endpoint] Message: ${error.message}');
    final response = error.response;
    if (response != null) {
      buffer
        ..writeln(
          '[ERROR $endpoint] Response status: ${response.statusCode} '
          '(${response.statusMessage ?? 'no-status-message'})',
        )
        ..writeln(
          '[ERROR $endpoint] Response headers: ${_formatHeaders(response.headers.map)}',
        )
        ..writeln('[ERROR $endpoint] Response data: ${response.data}');
    } else {
      buffer.writeln('[ERROR $endpoint] No response body captured.');
    }
    _recordLog(buffer.toString(), error: error);
  }

  String _formatHeaders(Map<dynamic, dynamic> headers) {
    if (headers.isEmpty) {
      return '(none)';
    }
    return headers.entries
        .map((entry) {
          final key = entry.key.toString();
          final value = entry.value;
          if (value is List) {
            return '$key: ${value.join('|')}';
          }
          return '$key: $value';
        })
        .join(', ');
  }

  void _recordLog(String message, {Object? error}) {
    developer.log(
      message,
      name: 'QanounyApiService',
      error: error,
    );
    // ignore: avoid_print
    print('[QanounyApiService] $message');
  }
}


