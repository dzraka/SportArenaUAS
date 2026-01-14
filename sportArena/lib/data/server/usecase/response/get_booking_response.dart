import 'dart:convert';

import 'package:final_project/data/server/model/booking.dart';

class GetBookingResponse {
  final String status;
  final String message;
  final Booking data;

  GetBookingResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  GetBookingResponse copyWith({
    String? status,
    String? message,
    Booking? data,
  }) => GetBookingResponse(
    status: status ?? this.status,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory GetBookingResponse.fromJson(String str) =>
      GetBookingResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetBookingResponse.fromMap(Map<String, dynamic> json) =>
      GetBookingResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null
            ? Booking.fromMap(json["data"])
            : throw Exception("Booking data is empty or null"),
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data.toMap(),
  };
}
