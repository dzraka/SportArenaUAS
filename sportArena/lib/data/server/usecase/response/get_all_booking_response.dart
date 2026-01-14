import 'dart:convert';

import 'package:final_project/data/server/model/booking.dart';

class GetAllBookingResponse {
  final String status;
  final String message;
  final List<Booking> data;

  GetAllBookingResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  GetAllBookingResponse copyWith({
    String? status,
    String? message,
    List<Booking>? data,
  }) => GetAllBookingResponse(
    status: status ?? this.status,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory GetAllBookingResponse.fromJson(String str) =>
      GetAllBookingResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAllBookingResponse.fromMap(Map<String, dynamic> json) =>
      GetAllBookingResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null
            ? List<Booking>.from(json["data"].map((x) => Booking.fromMap(x)))
            : [],
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}
