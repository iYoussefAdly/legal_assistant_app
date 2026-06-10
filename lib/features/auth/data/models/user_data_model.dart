import 'package:legal_assistant_app/features/auth/domain/entities/user_entity.dart';

class UserDataModel {
  const UserDataModel({
    required this.nationalId,
    this.fullName,
    this.email,
    this.passwordHash,
    this.gender,
    this.createdAt,
  });

  final String nationalId;
  final String? fullName;
  final String? email;
  final String? passwordHash;
  final String? gender;
  final String? createdAt;

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        nationalId: json['NationalId']?.toString() ?? '',
        fullName: json['FullName']?.toString(),
        email: json['Email']?.toString(),
        passwordHash: json['PasswordHash']?.toString(),
        gender: json['Gender']?.toString(),
        createdAt: json['CreatedAt']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'NationalId': nationalId,
        'FullName': fullName,
        'Email': email,
        'PasswordHash': passwordHash,
        'Gender': gender,
        'CreatedAt': createdAt ?? DateTime.now().toUtc().toIso8601String(),
      };

  UserEntity toEntity() => UserEntity(
        nationalId: nationalId,
        fullName: fullName,
        email: email,
        gender: gender,
        // passwordHash is intentionally stripped here
      );
}
