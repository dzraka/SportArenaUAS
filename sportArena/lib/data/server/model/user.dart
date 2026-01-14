import 'dart:convert';

class User {
  final int id;
  final String name;
  final String email;
  final DateTime? emailVerifiedAt;
  final String role;
  final String phoneNumber;
  final String? profilePhotoPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.role,
    required this.phoneNumber,
    required this.profilePhotoPath,
    required this.createdAt,
    required this.updatedAt,
    this.token,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    DateTime? emailVerifiedAt,
    String? role,
    String? phoneNumber,
    String? profilePhotoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? token,
  }) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
    role: role ?? this.role,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    token: token ?? this.token,
  );

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"] != null
        ? DateTime.parse(json["email_verified_at"])
        : null,
    role: json["role"],
    phoneNumber: json["phone_number"],
    profilePhotoPath: json["profile_photo_path"],
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : null,
    updatedAt: json["updated_at"] != null
        ? DateTime.parse(json["updated_at"])
        : null,
    token: json["token"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt?.toIso8601String(),
    "role": role,
    "phone_number": phoneNumber,
    "profile_photo_path": profilePhotoPath,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
