import 'dart:convert';

class AddFieldRequest {
  final String name;
  final String category;
  final int price;

  AddFieldRequest({
    required this.name,
    required this.category,
    required this.price,
  });

  AddFieldRequest copyWith({String? name, String? category, int? price}) =>
      AddFieldRequest(
        name: name ?? this.name,
        category: category ?? this.category,
        price: price ?? this.price,
      );

  factory AddFieldRequest.fromJson(String str) =>
      AddFieldRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddFieldRequest.fromMap(Map<String, dynamic> json) => AddFieldRequest(
    name: json["name"],
    category: json["category"],
    price: json["price"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "category": category,
    "price": price,
  };
}
