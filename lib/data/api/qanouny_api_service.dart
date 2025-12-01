import 'dart:convert';
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
                connectTimeout: const Duration(minutes: 5),
                receiveTimeout: const Duration(minutes: 5),
                sendTimeout: const Duration(minutes: 5),
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
  static const String _azureFunctionKey = 'nb7jrePPZdZkW_m40b-K12SRVOcGY5u1bgwXDh7ywjgoAzFuvjEF6w==';
  static const String _azureBaseUrl = 'https://sql-function-b3c7e6exa9f9acdu.francecentral-01.azurewebsites.net/api';
  final Dio _dio;
  Future<Map<String, dynamic>> login({
    required String nationalId,
    required String password,
  }) async {
    final trimmedNationalId = nationalId.trim();
    final trimmedPassword = password.trim();

    if (trimmedNationalId.isEmpty || trimmedPassword.isEmpty) {
      throw const QanounyApiException(
        'National ID and password are required.',
      );
    }

    return _execute(
      () async {
        // استخدام Dio منفصل للاتصال بـ Azure Function
        final azureDio = Dio(
          BaseOptions(
            connectTimeout: const Duration(minutes: 5),
            receiveTimeout: const Duration(minutes: 5),
            sendTimeout: const Duration(minutes: 5),
            responseType: ResponseType.json,
          ),
        );

        // إضافة Logger
        azureDio.interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseHeader: false,
            responseBody: true,
            compact: true,
          ),
        );

        // بناء الـ URL حسب كود Python في الوثيقة
        // في Python: response = requests.post(f"{BASE_URL}/read_user_data?code={FUNCTION_KEY}", json=read_data)
        final url = '$_azureBaseUrl/read_user_data?code=$_azureFunctionKey';

        print('[Login] محاولة وفقاً لكود Python: POST $url');
        print('[Login] البيانات: {"NationalId": "$trimmedNationalId"}');

        // تنفيذ طلب POST مثل كود Python تمامًا
        final Response response = await azureDio.post(
          url,
          data: {'NationalId': trimmedNationalId},
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ),
        );

        // التحقق من حالة الاستجابة
        if (response.statusCode == 200) {
          dynamic responseData = response.data;
          Map<String, dynamic> userData;

          print('[Login] استجابة من السيرفر: ${response.data}');

          // تحليل الاستجابة
          if (responseData is String) {
            // البحث عن بداية JSON في النص
            final startIndex = responseData.indexOf('{');
            final endIndex = responseData.lastIndexOf('}');
            
            if (startIndex == -1 || endIndex == -1) {
              throw const QanounyApiException('Invalid response format from server.');
            }
            
            try {
              final jsonString = responseData.substring(startIndex, endIndex + 1);
              userData = jsonDecode(jsonString);
            } catch (e) {
              print('[Login] خطأ في تحليل JSON: $e');
              throw const QanounyApiException('Failed to parse user data.');
            }
          } else if (responseData is Map) {
            userData = responseData.cast<String, dynamic>();
          } else {
            throw const QanounyApiException('Unexpected response type from server.');
          }

          // التحقق من وجود PasswordHash
          final storedPasswordHash = userData['PasswordHash']?.toString();
          if (storedPasswordHash == null) {
            print('[Login] بيانات المستخدم المستلمة: $userData');
            throw const QanounyApiException('User data is incomplete - PasswordHash missing.');
          }

          print('[Login] كلمة المرور المخزنة: $storedPasswordHash');
          print('[Login] كلمة المرور المدخلة: $trimmedPassword');

          // مقارنة كلمة المرور
          if (trimmedPassword == storedPasswordHash) {
            return Response(
              requestOptions: response.requestOptions,
              data: userData,
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              headers: response.headers,
              isRedirect: response.isRedirect,
              redirects: response.redirects,
              extra: response.extra,
            );
          } else {
            throw const QanounyApiException('Incorrect password.');
          }
        } else {
          throw QanounyApiException('Login failed. Status: ${response.statusCode}, Response: ${response.data}');
        }
      },
      endpoint: 'read_user_data',
    );
  }
  Future<Map<String, dynamic>> sendTextQuery(String question) async {
    final trimmedQuestion = question.trim();
    if (trimmedQuestion.isEmpty) {
      throw const QanounyApiException(
        'Question cannot be empty. Please provide a valid question.',
      );
    }

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

    if (responseData is Map && responseData['detail'] != null) {
      final detail = responseData['detail'];
      if (detail is List) {
        final messages = detail.map((e) {
          if (e is Map) {
            final loc = e['loc'];
            final msg = e['msg'];
            if (loc != null && msg != null) {
              final field = loc is List && loc.length > 1 ? loc.last : 'field';
              final fieldName = field.toString();
              final message = msg.toString();

              if (fieldName == 'question' &&
                  message.toLowerCase().contains('required')) {
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

    if (responseData is List) {
      final messages = responseData.map((e) {
        if (e is Map) {
          final loc = e['loc'];
          final msg = e['msg'];
          if (loc != null && msg != null) {
            final field = loc is List && loc.length > 1 ? loc.last : 'field';
            final fieldName = field.toString();
            final message = msg.toString();

            if (fieldName == 'question' &&
                message.toLowerCase().contains('required')) {
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
          '[$endpoint] Response headers: ${_formatHeaders(response.headers.map)}',
      )
      ..writeln('[$endpoint] Response data: ${response.data}');
    _recordLog(buffer.toString());
  }

  void _logDioError(String endpoint, DioException error) {
    final requestHeaders = error.requestOptions.headers;
    final buffer = StringBuffer()
      ..writeln(
          '[ERROR $endpoint] Request headers: ${_formatHeaders(requestHeaders)}')
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
    print('[QanounyApiService] $message');
  }
}