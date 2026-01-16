import 'dart:convert';
import 'dart:io';

class AddFieldRequest {
  final String name;
  final String category;
  final int price;
  final bool isAvailable;
  final File? image;

  AddFieldRequest({
    required this.name,
    required this.category,
    required this.price,
    this.isAvailable = true,
    this.image,
  });

  AddFieldRequest copyWith({
    String? name,
    String? category,
    int? price,
    bool? isAvailable,
    File? image,
  }) => AddFieldRequest(
    name: name ?? this.name,
    category: category ?? this.category,
    price: price ?? this.price,
    isAvailable: isAvailable ?? this.isAvailable,
    image: image ?? this.image,
  );

  factory AddFieldRequest.fromJson(String str) =>
      AddFieldRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddFieldRequest.fromMap(Map<String, dynamic> json) => AddFieldRequest(
    name: json["name"],
    category: json["category"] ?? json["type"] ?? "",
    price: json["price"] ?? json["price_per_hour"] ?? 0,
    isAvailable: json["is_available"] == 1 || json["is_available"] == true,
    image: null,
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "type": category,
    "price_per_hour": price,
    "is_available": isAvailable ? 1 : 0,
    "image": image != null ? base64Encode(image!.readAsBytesSync()) : null,
  };
}
