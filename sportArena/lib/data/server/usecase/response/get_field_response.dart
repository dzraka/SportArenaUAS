import 'dart:convert';

import 'package:final_project/data/server/model/field.dart';

class GetFieldResponse {
  final String status;
  final String message;
  final List<Field> data;

  GetFieldResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  GetFieldResponse copyWith({
    String? status,
    String? message,
    List<Field>? data,
  }) => GetFieldResponse(
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
            ? List<Field>.from(json["data"].map((x) => Field.fromMap(x)))
            : [],
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}
