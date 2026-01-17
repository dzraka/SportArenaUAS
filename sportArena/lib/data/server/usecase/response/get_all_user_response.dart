import 'dart:convert';

import 'package:final_project/data/server/model/user.dart';

class GetAllUserResponse {
  final String status;
  final String message;
  final List<User> data;

  GetAllUserResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  GetAllUserResponse copyWith({
    String? status,
    String? message,
    List<User>? data,
  }) => GetAllUserResponse(
    status: status ?? this.status,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory GetAllUserResponse.fromJson(String str) =>
      GetAllUserResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAllUserResponse.fromMap(Map<String, dynamic> json) =>
      GetAllUserResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null
            ? List<User>.from(json["data"].map((x) => User.fromMap(x)))
            : [],
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}
