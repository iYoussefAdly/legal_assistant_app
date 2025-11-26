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
    return _execute(
      () => _dio.post(
        '/api/query/text',
        data: {'question': question},
        options: Options(contentType: Headers.jsonContentType),
      ),
    );
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
    if (responseData is Map && responseData['message'] != null) {
      return responseData['message'].toString();
    }
    if (responseData is Map && responseData['detail'] != null) {
      return responseData['detail'].toString();
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

