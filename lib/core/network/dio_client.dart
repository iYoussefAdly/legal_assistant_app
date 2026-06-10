import 'package:dio/dio.dart';
import 'package:legal_assistant_app/core/network/api_endpoints.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class DioClient {
  static Dio mainApi() => _build(ApiEndpoints.mainBaseUrl);

  static Dio azureApi() => _build(null);

  static Dio _build(String? baseUrl) {
    final options = BaseOptions(
      baseUrl: baseUrl ?? '',
      connectTimeout: const Duration(minutes: 5),
      receiveTimeout: const Duration(minutes: 5),
      sendTimeout: const Duration(minutes: 5),
      responseType: ResponseType.json,
    );
    final dio = Dio(options);
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        compact: true,
      ),
    );
    return dio;
  }
}
