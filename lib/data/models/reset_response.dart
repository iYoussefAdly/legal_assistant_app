import 'package:equatable/equatable.dart';

class ResetResponse extends Equatable {
  const ResetResponse({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;

  factory ResetResponse.fromJson(Map<String, dynamic> json) {
    return ResetResponse(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }

  @override
  List<Object?> get props => [success, message];
}

