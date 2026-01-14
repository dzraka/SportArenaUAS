import 'dart:convert';

import 'package:final_project/data/server/model/field.dart';

class GetFieldResponse {
  final String status;
  final String message;
  final Field data;

  GetFieldResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  GetFieldResponse copyWith({String? status, String? message, Field? data}) =>
      GetFieldResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory GetFieldResponse.fromJson(String str) =>
      GetFieldResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetFieldResponse.fromMap(Map<String, dynamic> json) =>
      GetFieldResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null
            ? Field.fromMap(json["data"])
            : throw Exception("Field data is empty or null"),
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data.toMap(),
  };
}
