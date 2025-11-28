class user_data {
  String? nationalId;
  String? fullName;
  String? email;
  String? passwordHash;
  String? gender;
  String? createdAt;

  user_data({
    this.nationalId,
    this.fullName,
    this.email,
    this.passwordHash,
    this.gender,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toUtc().toIso8601String();

  user_data.fromJson(Map<String, dynamic> json) {
    nationalId = json['NationalId'];
    fullName = json['FullName'];
    email = json['Email'];
    passwordHash = json['PasswordHash'];
    gender = json['Gender'];
    createdAt = json['CreatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'NationalId': nationalId,
      'FullName': fullName,
      'Email': email,
      'PasswordHash': passwordHash,
      'Gender': gender,
      'CreatedAt': createdAt,
    };
  }
}
