import 'package:equatable/equatable.dart';

class InitChatResponse extends Equatable {
  const InitChatResponse({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;

  factory InitChatResponse.fromJson(Map<String, dynamic> json) {
    return InitChatResponse(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [success, message];
}


