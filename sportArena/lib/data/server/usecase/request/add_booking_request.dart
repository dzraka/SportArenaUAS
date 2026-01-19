import 'dart:convert';

class AddBookingRequest {
  final int fieldId;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final int totalPrice;

  AddBookingRequest({
    required this.fieldId,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
  });

  AddBookingRequest copyWith({
    int? fieldId,
    DateTime? bookingDate,
    String? startTime,
    String? endTime,
    int? totalPrice,
  }) => AddBookingRequest(
    fieldId: fieldId ?? this.fieldId,
    bookingDate: bookingDate ?? this.bookingDate,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    totalPrice: totalPrice ?? this.totalPrice,
  );

  factory AddBookingRequest.fromJson(String str) =>
      AddBookingRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddBookingRequest.fromMap(Map<String, dynamic> json) =>
      AddBookingRequest(
        fieldId: json["field_id"],
        bookingDate: DateTime.parse(json["booking_date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        totalPrice: json["total_Price"],
      );

  Map<String, dynamic> toMap() => {
    "field_id": fieldId,
    "booking_date":
        "${bookingDate.year.toString().padLeft(4, '0')}-${bookingDate.month.toString().padLeft(2, '0')}-${bookingDate.day.toString().padLeft(2, '0')}",
    "start_time": startTime,
    "end_time": endTime,
    "total_price": totalPrice,
  };
}
