import 'dart:convert';

import 'package:final_project/data/server/model/field.dart';
import 'package:final_project/data/server/model/user.dart';

class Booking {
  final int id;
  final User user;
  final Field field;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final int totalPrice;
  final String status;
  final String? createdAt;
  final String? createdAgo;

  Booking({
    required this.id,
    required this.user,
    required this.field,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
    this.createdAt,
    this.createdAgo,
  });

  Booking copyWith({
    int? id,
    User? user,
    Field? field,
    String? bookingDate,
    String? startTime,
    String? endTime,
    int? totalPrice,
    String? status,
    String? createdAt,
    String? createdAgo,
  }) => Booking(
    id: id ?? this.id,
    user: user ?? this.user,
    field: field ?? this.field,
    bookingDate: bookingDate ?? this.bookingDate,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    totalPrice: totalPrice ?? this.totalPrice,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    createdAgo: createdAgo ?? this.createdAgo,
  );

  factory Booking.fromJson(String str) => Booking.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Booking.fromMap(Map<String, dynamic> json) => Booking(
    id: json["id"],
    user: User.fromMap(json["user"]),
    field: Field.fromMap(json["field"]),
    bookingDate: json["booking_date"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    totalPrice: int.tryParse(json["total_price"].toString()) ?? 0,
    status: json["status"],
    createdAt: json["created_at"],
    createdAgo: json["created_ago"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user": user.toMap(),
    "field": field.toMap(),
    "booking_date": bookingDate,
    "start_time": startTime,
    "end_time": endTime,
    "total_price": totalPrice,
    "status": status,
    "created_at": createdAt,
    "created_ago": createdAgo,
  };
}
