import 'dart:io';

import 'package:legal_assistant_app/data/api/api_exception.dart';
import 'package:legal_assistant_app/data/api/qanouny_api_service.dart';
import 'package:legal_assistant_app/data/models/audio_query_response.dart';
import 'package:legal_assistant_app/data/models/file_query_response.dart';
import 'package:legal_assistant_app/data/models/reset_response.dart';
import 'package:legal_assistant_app/data/models/text_query_response.dart';

class QanounyRepository {
  QanounyRepository(this._apiService);

  final QanounyApiService _apiService;

  Future<TextQueryResponse> sendTextQuery(String question) async {
    final sanitizedQuestion = question.trim();
    if (sanitizedQuestion.isEmpty) {
      throw const QanounyRepositoryException(
        'Please type your legal question before submitting.',
      );
    }

    try {
      final payload = await _apiService.sendTextQuery(sanitizedQuestion);
      return TextQueryResponse.fromJson(payload);
    } on QanounyApiException catch (error) {
      throw QanounyRepositoryException(error.message);
    } catch (_) {
      throw const QanounyRepositoryException(
        'Unable to process your question right now. Please retry.',
      );
    }
  }

  Future<AudioQueryResponse> sendAudioQuery(String filePath) async {
    final sanitizedPath = filePath.trim();
    if (sanitizedPath.isEmpty) {
      throw const QanounyRepositoryException(
        'Please choose an audio file to upload.',
      );
    }

    final file = File(sanitizedPath);
    if (!file.existsSync()) {
      throw const QanounyRepositoryException('Selected audio file not found.');
    }
    if (!sanitizedPath.toLowerCase().endsWith('.wav')) {
      throw const QanounyRepositoryException(
        'Audio queries accept .wav files only.',
      );
    }

    try {
      final payload = await _apiService.sendAudioQuery(sanitizedPath);
      return AudioQueryResponse.fromJson(payload);
    } on QanounyApiException catch (error) {
      throw QanounyRepositoryException(error.message);
    } catch (_) {
      throw const QanounyRepositoryException(
        'Unable to transcribe your audio right now. Please try again.',
      );
    }
  }

  Future<FileQueryResponse> sendFileQuery(
    String filePath,
    String question,
  ) async {
    final sanitizedQuestion = question.trim();
    final sanitizedPath = filePath.trim();

    if (sanitizedQuestion.isEmpty) {
      throw const QanounyRepositoryException(
        'Please provide a question related to the uploaded document.',
      );
    }
    if (sanitizedPath.isEmpty) {
      throw const QanounyRepositoryException('Please select a document first.');
    }

    final file = File(sanitizedPath);
    if (!file.existsSync()) {
      throw const QanounyRepositoryException('Selected document not found.');
    }

    _validateFileExtension(sanitizedPath);
    await _validateFileSize(file);

    try {
      final payload =
          await _apiService.sendFileQuery(sanitizedPath, sanitizedQuestion);
      return FileQueryResponse.fromJson(payload);
    } on QanounyApiException catch (error) {
      throw QanounyRepositoryException(error.message);
    } catch (_) {
      throw const QanounyRepositoryException(
        'Unable to process the document right now. Please retry.',
      );
    }
  }

  Future<ResetResponse> resetConversation() async {
    try {
      final payload = await _apiService.resetConversation();
      return ResetResponse.fromJson(payload);
    } on QanounyApiException catch (error) {
      throw QanounyRepositoryException(error.message);
    } catch (_) {
      throw const QanounyRepositoryException(
        'Reset failed. Please try again in a moment.',
      );
    }
  }

  void _validateFileExtension(String path) {
    const allowedExtensions = ['png', 'jpg', 'jpeg', 'pdf'];
    final extension = path.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      throw const QanounyRepositoryException(
        'Only PNG, JPG, JPEG, or PDF files are supported.',
      );
    }
  }

  Future<void> _validateFileSize(File file) async {
    const maxBytes = 5 * 1024 * 1024; // 5MB
    final size = await file.length();
    if (size > maxBytes) {
      throw const QanounyRepositoryException(
        'File exceeds the 5MB size limit. Please pick a smaller document.',
      );
    }
  }
}

class QanounyRepositoryException implements Exception {
  const QanounyRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}

