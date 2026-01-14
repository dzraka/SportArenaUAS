import 'dart:convert';

import 'package:final_project/data/server/model/user.dart';

class GetUserResponse {
  final String status;
  final String message;
  final User data;

  GetUserResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  GetUserResponse copyWith({String? status, String? message, User? data}) =>
      GetUserResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory GetUserResponse.fromJson(String str) =>
      GetUserResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetUserResponse.fromMap(Map<String, dynamic> json) => GetUserResponse(
    status: json["status"],
    message: json["message"],
    data: User.fromMap(json["User"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "User": data.toMap(),
  };
}
