import 'dart:convert';

class Field {
  final int id;
  final String name;
  final String category;
  final int price;
  final String? imageUrl;
  final bool isAvailable;

  Field({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.imageUrl,
    required this.isAvailable,
  });

  Field copyWith({
    int? id,
    String? name,
    String? category,
    int? price,
    String? imageUrl,
    bool? isAvailable,
  }) => Field(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    price: price ?? this.price,
    imageUrl: imageUrl ?? this.imageUrl,
    isAvailable: isAvailable ?? this.isAvailable,
  );

  factory Field.fromJson(String str) => Field.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Field.fromMap(Map<String, dynamic> json) => Field(
    id: json["id"] ?? 0,
    name: json["name"]?.toString() ?? "Unknown Field",
    category: json["category"]?.toString() ?? "-",
    price:
        int.tryParse(
          (json["price"] ?? json["price_per_hour"] ?? 0).toString(),
        ) ??
        0,
    imageUrl: json["image_url"]?.toString(),
    isAvailable:
        (json["is_available"] == 1 ||
        json["is_available"] == true ||
        json["is_available"].toString() == '1'),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "category": category,
    "price": price,
    "image_url": imageUrl,
    "is_available": isAvailable,
  };
}
