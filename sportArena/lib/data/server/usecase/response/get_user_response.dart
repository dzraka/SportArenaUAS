import 'dart:convert';

import 'package:final_project/data/server/model/field.dart';
import 'package:final_project/data/server/model/user.dart';

class GetUserResponse {
  final String status;
  final String message;
  final List<User> data;

  GetUserResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  GetUserResponse copyWith({
    String? status,
    String? message,
    List<User>? data,
  }) => GetUserResponse(
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
