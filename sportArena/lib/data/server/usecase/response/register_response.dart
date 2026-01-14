import 'dart:convert';

class RegisterResponse {
  final String status;
  final String message;
  final String data;

  RegisterResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  RegisterResponse copyWith({String? status, String? message, String? data}) =>
      RegisterResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory RegisterResponse.fromJson(String str) =>
      RegisterResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegisterResponse.fromMap(Map<String, dynamic> json) =>
      RegisterResponse(
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
