import 'dart:io';

import 'package:legal_assistant_app/data/api/api_exception.dart';
import 'package:legal_assistant_app/data/api/qanouny_api_service.dart';
import 'package:legal_assistant_app/data/models/audio_query_response.dart';
import 'package:legal_assistant_app/data/models/file_query_response.dart';
import 'package:legal_assistant_app/data/models/file_upload_metadata.dart';
import 'package:legal_assistant_app/data/models/init_chat_response.dart';
import 'package:legal_assistant_app/data/models/text_query_response.dart';

class QanounyRepository {
  QanounyRepository(this._apiService);

  final QanounyApiService _apiService;

  Future<TextQueryResponse> sendTextQuery(String question) async {
    // Validate and sanitize the question
    if (question.isEmpty) {
      throw const QanounyRepositoryException(
        'Please type your legal question before submitting.',
      );
    }
    
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
    } catch (e) {
      // If it's already a repository exception, rethrow it
      if (e is QanounyRepositoryException) {
        rethrow;
      }
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
      final normalizedPayload = _normalizeAudioResponse(payload);
      return AudioQueryResponse.fromJson(normalizedPayload);
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

    final metadata = _validateFileExtension(sanitizedPath);
    await _validateFileSize(file);

    try {
      final payload =
          await _apiService.sendFileQuery(sanitizedPath, sanitizedQuestion);
      return FileQueryResponse.fromJson(
        payload,
        uploadedFileName: metadata.fileName,
        uploadType: metadata.type,
      );
    } on QanounyApiException catch (error) {
      throw QanounyRepositoryException(error.message);
    } catch (_) {
      throw const QanounyRepositoryException(
        'Unable to process the document right now. Please retry.',
      );
    }
  }

  Future<InitChatResponse> initializeChat(String name, String gender) async {
    final sanitizedName = name.trim();
    final sanitizedGender = gender.trim();
    if (sanitizedName.isEmpty || sanitizedGender.isEmpty) {
      throw const QanounyRepositoryException(
        'Name and gender are required to start a new chat.',
      );
    }

    try {
      final payload = await _apiService.initializeChat(
        name: sanitizedName,
        gender: sanitizedGender,
      );
      return InitChatResponse.fromJson(payload);
    } on QanounyApiException catch (error) {
      throw QanounyRepositoryException(error.message);
    } catch (_) {
      throw const QanounyRepositoryException(
        'Unable to reset the conversation right now. Please retry.',
      );
    }
  }

  FileUploadMetadata _validateFileExtension(String path) {
    const allowedExtensions = ['png', 'jpg', 'jpeg', 'pdf'];
    final extension = path.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      throw const QanounyRepositoryException(
        'Only PNG, JPG, JPEG, or PDF files are supported.',
      );
    }
    final fileName = path.split(Platform.pathSeparator).last;
    final type =
        extension == 'pdf' ? FileUploadType.pdf : FileUploadType.image;
    return FileUploadMetadata(fileName: fileName, type: type);
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

  Map<String, dynamic> _normalizeAudioResponse(
    Map<String, dynamic> payload,
  ) {
    final normalized = Map<String, dynamic>.from(payload);
    const candidateKeys = [
      'audio',
      'audio_result',
      'audio_response',
      'data',
      'payload',
    ];
    for (final key in candidateKeys) {
      final nested = payload[key];
      if (nested is Map<String, dynamic>) {
        normalized.addAll(nested);
      }
    }
    return normalized;
  }
}

class QanounyRepositoryException implements Exception {
  const QanounyRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}


