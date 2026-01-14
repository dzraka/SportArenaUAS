import 'dart:convert';

class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final String passwordConfirmation;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.passwordConfirmation,
  });

  RegisterRequest copyWith({
    String? name,
    String? email,
    String? password,
    String? phoneNumber,
    String? passwordConfirmation,
  }) => RegisterRequest(
    name: name ?? this.name,
    email: email ?? this.email,
    password: password ?? this.password,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
  );

  factory RegisterRequest.fromJson(String str) =>
      RegisterRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegisterRequest.fromMap(Map<String, dynamic> json) => RegisterRequest(
    name: json["name"],
    email: json["email"],
    password: json["password"],
    phoneNumber: json["phone_number"],
    passwordConfirmation: json["password_confirmation"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "email": email,
    "password": password,
    "phone_number": phoneNumber,
    "password_confirmation": passwordConfirmation,
  };
}
