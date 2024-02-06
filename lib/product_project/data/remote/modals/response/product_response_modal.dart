// product_response_modal.dart

import 'dart:convert';

import 'package:hive/hive.dart';
part 'product_response_modal.g.dart';

List<ProductResponseModal> productResponseModalFromJson(String str) =>
    List<ProductResponseModal>.from(
        json.decode(str).map((x) => ProductResponseModal.fromJson(x)));

String productResponseModalToJson(List<ProductResponseModal> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 2)
class ProductResponseModal {
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  double price;
  @HiveField(3)
  String description;
  @HiveField(4)
  Category category;
  @HiveField(5)
  String image;
  @HiveField(6)
  Rating rating;

  ProductResponseModal({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory ProductResponseModal.fromJson(Map<dynamic, dynamic> json) =>
      ProductResponseModal(
        id: json["id"],
        title: json["title"],
        price: json["price"]?.toDouble(),
        description: json["description"],
        category: categoryValues.map[json["category"]]!,
        image: json["image"],
        rating: Rating.fromJson(json["rating"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "description": description,
        "category": categoryValues.reverse[category],
        "image": image,
        "rating": rating.toJson(),
      };
}

@HiveType(typeId: 3)
enum Category {
  @HiveField(1)
  ELECTRONICS,
  @HiveField(2)
  JEWELERY,
  @HiveField(3)
  MEN_S_CLOTHING,
  @HiveField(4)
  WOMEN_S_CLOTHING
}

final categoryValues = EnumValues({
  "electronics": Category.ELECTRONICS,
  "jewelery": Category.JEWELERY,
  "men's clothing": Category.MEN_S_CLOTHING,
  "women's clothing": Category.WOMEN_S_CLOTHING
});

@HiveType(typeId: 4)
class Rating {
  @HiveField(1)
  double rate;
  @HiveField(2)
  int count;

  Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<dynamic, dynamic> json) => Rating(
        rate: json["rate"]?.toDouble(),
        count: json["count"],
      );

  Map<dynamic, dynamic> toJson() => {
        "rate": rate,
        "count": count,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
