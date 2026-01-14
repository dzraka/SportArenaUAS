import 'dart:convert';

class LoginResponse {
  final String status;
  final String message;
  final String data;

  LoginResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  LoginResponse copyWith({String? status, String? message, String? data}) =>
      LoginResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory LoginResponse.fromJson(String str) =>
      LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data,
  };
}
