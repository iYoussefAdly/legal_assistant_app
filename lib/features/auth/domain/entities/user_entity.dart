class UserEntity {
  const UserEntity({
    required this.nationalId,
    this.fullName,
    this.email,
    this.gender,
  });

  final String nationalId;
  final String? fullName;
  final String? email;
  final String? gender;
}
