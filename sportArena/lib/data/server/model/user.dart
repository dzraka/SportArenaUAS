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
    this.emailVerifiedAt,
    required this.role,
    required this.phoneNumber,
    this.profilePhotoPath,
    this.createdAt,
    this.updatedAt,
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
    id: json["id"] ?? 0,
    name: json["name"]?.toString() ?? "",
    email: json["email"]?.toString() ?? "",
    emailVerifiedAt: json["email_verified_at"] != null
        ? DateTime.tryParse(json["email_verified_at"].toString())
        : null,
    role: json["role"]?.toString() ?? "user",
    phoneNumber: json["phone_number"]?.toString() ?? "-",
    profilePhotoPath: json["profile_photo_path"]?.toString(),
    createdAt: json["created_at"] != null
        ? DateTime.tryParse(json["created_at"].toString())
        : null,
    updatedAt: json["updated_at"] != null
        ? DateTime.tryParse(json["updated_at"].toString())
        : null,
    token: json["token"]?.toString(),
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
    "token": token,
  };
}
