import 'dart:convert';

import 'package:final_project/data/server/model/user.dart';

class LoginResponse {
  final String status;
  final String message;
  final Data? data;

  LoginResponse({required this.status, required this.message, this.data});

  LoginResponse copyWith({String? status, String? message, Data? data}) =>
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
    data: json["data"] != null ? Data.fromMap(json["data"]) : null,
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data,
  };
}

class Data {
  final String token;
  final User user;

  Data({required this.token, required this.user});

  factory Data.fromMap(Map<String, dynamic> json) =>
      Data(token: json["token"], user: User.fromMap(json["user"]));

  Map<String, dynamic> toMap() => {"token": token, "user": user.toMap()};
}