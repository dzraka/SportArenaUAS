import 'dart:convert';

class GeneralResponse {
  final String status;
  final String message;

  GeneralResponse({required this.status, required this.message});

  GeneralResponse copyWith({String? status, String? message}) =>
      GeneralResponse(
        status: status ?? this.status,
        message: message ?? this.message,
      );

  factory GeneralResponse.fromJson(String str) =>
      GeneralResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GeneralResponse.fromMap(Map<String, dynamic> json) =>
      GeneralResponse(status: json["status"], message: json["message"]);

  Map<String, dynamic> toMap() => {"status": status, "message": message};
}
