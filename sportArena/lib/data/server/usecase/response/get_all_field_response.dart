import 'dart:convert';

import 'package:final_project/data/server/model/field.dart';

class GetAllFieldResponse {
  final String status;
  final String message;
  final List<Field> data;

  GetAllFieldResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  GetAllFieldResponse copyWith({
    String? status,
    String? message,
    List<Field>? data,
  }) => GetAllFieldResponse(
    status: status ?? this.status,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory GetAllFieldResponse.fromJson(String str) =>
      GetAllFieldResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAllFieldResponse.fromMap(Map<String, dynamic> json) =>
      GetAllFieldResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null
            ? List<Field>.from(json["data"].map((x) => Field.fromMap(x)))
            : [],
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}
