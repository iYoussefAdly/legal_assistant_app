import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:legal_assistant_app/core/errors/exceptions.dart';
import 'package:legal_assistant_app/core/network/api_endpoints.dart';
import 'package:legal_assistant_app/features/chat/data/models/audio_query_response.dart';
import 'package:legal_assistant_app/features/chat/data/models/file_query_response.dart';
import 'package:legal_assistant_app/features/chat/data/models/file_upload_metadata.dart';
import 'package:legal_assistant_app/features/chat/data/models/init_chat_response.dart';
import 'package:legal_assistant_app/features/chat/data/models/text_query_response.dart';
import 'package:mime/mime.dart';

class ChatRemoteDataSource {
  const ChatRemoteDataSource(this._dio);

  final Dio _dio;

  Future<TextQueryResponse> sendTextQuery(String question) async {
    final q = question.trim();
    if (q.isEmpty) {
      throw const QanounyApiException(
          'Question cannot be empty. Please provide a valid question.');
    }
    return _execute(
      () => _dio.post(ApiEndpoints.textQuery,
          data: FormData.fromMap({'question': q})),
      parse: TextQueryResponse.fromJson,
    );
  }

  Future<AudioQueryResponse> sendAudioQuery(String filePath) async {
    final fileName = filePath.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      'audio_file': await _multipartFromFile(filePath, fileName),
    });
    final raw = await _executeRaw(() =>
        _dio.post(ApiEndpoints.audioQuery, data: formData));
    return AudioQueryResponse.fromJson(_normalizeAudioResponse(raw));
  }

  Future<FileQueryResponse> sendFileQuery(
      String filePath, String question) async {
    final q = question.trim();
    if (q.isEmpty) {
      throw const QanounyApiException(
          'Please provide a question related to the uploaded document.');
    }
    final ext = filePath.split('.').last.toLowerCase();
    const allowed = ['png', 'jpg', 'jpeg', 'pdf'];
    if (!allowed.contains(ext)) {
      throw const QanounyApiException(
          'Only PNG, JPG, JPEG, or PDF files are supported.');
    }

    final file = File(filePath);
    if (!file.existsSync()) {
      throw const QanounyApiException('Selected document not found.');
    }
    await _validateFileSize(file);

    final fileName = filePath.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      'file': await _multipartFromFile(filePath, fileName),
      'question': q,
    });
    final raw = await _executeRaw(
        () => _dio.post(ApiEndpoints.fileQuery, data: formData));

    final uploadType = ext == 'pdf' ? FileUploadType.pdf : FileUploadType.image;
    return FileQueryResponse.fromJson(raw,
        uploadedFileName: fileName, uploadType: uploadType);
  }

  Future<InitChatResponse> initializeChat(
      String name, String gender) async {
    final formData = FormData.fromMap({
      'name': name.trim(),
      'gender': gender.trim(),
    });
    return _execute(
      () => _dio.post(ApiEndpoints.initChat, data: formData),
      parse: InitChatResponse.fromJson,
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<T> _execute<T>(
    Future<Response<dynamic>> Function() request, {
    required T Function(Map<String, dynamic>) parse,
  }) async {
    final raw = await _executeRaw(request);
    return parse(raw);
  }

  Future<Map<String, dynamic>> _executeRaw(
      Future<Response<dynamic>> Function() request) async {
    try {
      final response = await request();
      final data = _asMap(response.data);
      if (data['success'] == false) {
        throw QanounyApiException(
          data['error_message']?.toString() ??
              'An error occurred while processing your request.',
        );
      }
      return data;
    } on DioException catch (e) {
      developer.log('[ChatDataSource] ${e.message}', name: 'ChatRemoteDataSource');
      throw QanounyApiException(_resolveDioMessage(e));
    } on QanounyApiException {
      rethrow;
    } catch (_) {
      throw const QanounyApiException(
          'Unexpected error occurred. Please try again later.');
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return data.cast<String, dynamic>();
    throw const QanounyApiException('Invalid response from server.');
  }

  Future<MultipartFile> _multipartFromFile(
      String filePath, String fileName) async {
    final lowerPath = filePath.toLowerCase();
    MediaType? mediaType;
    if (lowerPath.endsWith('.wav')) {
      mediaType = MediaType('audio', 'wav');
    } else {
      final mime = lookupMimeType(filePath);
      if (mime != null) {
        final parts = mime.split('/');
        if (parts.length == 2) {
          var sub = parts[1];
          if (sub == 'x-wav') sub = 'wav';
          mediaType = MediaType(parts[0], sub);
        }
      }
    }
    return MultipartFile.fromFile(filePath,
        filename: fileName, contentType: mediaType);
  }

  Future<void> _validateFileSize(File file) async {
    const maxBytes = 5 * 1024 * 1024;
    if (await file.length() > maxBytes) {
      throw const QanounyApiException(
          'File exceeds the 5MB size limit. Please pick a smaller document.');
    }
  }

  Map<String, dynamic> _normalizeAudioResponse(Map<String, dynamic> payload) {
    final normalized = Map<String, dynamic>.from(payload);
    for (final key in ['audio', 'audio_result', 'audio_response', 'data', 'payload']) {
      final nested = payload[key];
      if (nested is Map<String, dynamic>) normalized.addAll(nested);
    }
    return normalized;
  }

  String _resolveDioMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map) {
      final detail = data['detail'];
      if (detail != null) {
        return _parseValidationDetail(detail);
      }
      if (data['message'] != null) return data['message'].toString();
    }

    if (data is List) return _parseValidationDetail(data);

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'The server is taking too long to respond. Please try again shortly.';
    }
    if (error.type == DioExceptionType.connectionError) {
      return 'Unable to reach the server. Check your connection.';
    }
    return error.message ?? 'Request failed. Please try again.';
  }

  String _parseValidationDetail(dynamic detail) {
    if (detail is List) {
      final messages = detail.map((e) {
        if (e is Map) {
          final loc = e['loc'];
          final msg = e['msg']?.toString() ?? '';
          final field = loc is List && loc.length > 1
              ? loc.last.toString()
              : 'field';
          if (field == 'question' && msg.toLowerCase().contains('required')) {
            return 'Please enter a question before sending.';
          }
          if (msg.toLowerCase().contains('required')) {
            return '${_capitalize(field)} is required.';
          }
          return '$field: $msg';
        }
        return e.toString();
      }).join(', ');
      return messages.isNotEmpty ? messages : detail.toString();
    }
    return detail.toString();
  }

  String _capitalize(String s) => s
      .replaceAll('_', ' ')
      .split(' ')
      .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
      .join(' ');
}
