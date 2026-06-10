import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:legal_assistant_app/core/errors/exceptions.dart';
import 'package:legal_assistant_app/core/network/api_endpoints.dart';

class DocumentRemoteDataSource {
  const DocumentRemoteDataSource(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> uploadDocument({
    required String nationalId,
    required String filePath,
    String? title,
  }) async {
    final id = nationalId.trim();
    if (id.isEmpty) {
      throw const QanounyApiException('National ID is required.');
    }
    final file = File(filePath);
    if (!file.existsSync()) {
      throw const QanounyApiException(
          'File does not exist or path is invalid.');
    }

    const maxBytes = 5 * 1024 * 1024;
    if (await file.length() > maxBytes) {
      throw const QanounyApiException(
          'File exceeds the 5MB size limit. Please pick a smaller document.');
    }

    try {
      final fileName = filePath.split(Platform.pathSeparator).last;
      final formData = FormData.fromMap({
        'NationalId': id,
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        if (title != null && title.isNotEmpty) 'title': title,
      });

      final response = await _dio.post(
        ApiEndpoints.uploadDocumentUrl,
        data: formData,
        options:
            Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        return _parseResponse(response.data, nationalId: id);
      }
      throw QanounyApiException(
          'Upload failed. Status: ${response.statusCode}');
    } on DioException catch (e) {
      developer.log('[DocumentDataSource] ${e.message}',
          name: 'DocumentRemoteDataSource');
      throw QanounyApiException(_resolveDioMessage(e));
    } on QanounyApiException {
      rethrow;
    } catch (_) {
      throw const QanounyApiException(
          'Unable to upload the file right now. Please retry.');
    }
  }

  Map<String, dynamic> _parseResponse(dynamic data,
      {required String nationalId}) {
    if (data is Map) {
      final result = data.cast<String, dynamic>();
      result['nationalId'] = nationalId;
      return result;
    }
    if (data is String) {
      if (data.trim().startsWith('{')) {
        try {
          final map =
              jsonDecode(data) as Map<String, dynamic>;
          map['nationalId'] = nationalId;
          return map;
        } catch (_) {}
      }
      return {
        'message': data,
        'status': 'success',
        'nationalId': nationalId,
      };
    }
    return {'data': data, 'status': 'success', 'nationalId': nationalId};
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
    return error.message ?? 'Upload failed. Please try again.';
  }
}
