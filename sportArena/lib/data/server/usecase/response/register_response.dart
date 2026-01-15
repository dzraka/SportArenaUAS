import 'dart:convert';

import 'package:final_project/data/server/model/user.dart';

class RegisterResponse {
  final String status;
  final String message;
  final User? data;

  RegisterResponse({required this.status, required this.message, this.data});

  RegisterResponse copyWith({String? status, String? message, User? data}) =>
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
        status: json["status"] ?? "error",
        message: json["message"] ?? "",
        data: json["data"] != null ? User.fromMap(json["data"]) : null,
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data?.toMap(),
  };
}
