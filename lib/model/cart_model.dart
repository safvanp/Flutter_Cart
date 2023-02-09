import 'dart:convert';
import 'package:hive/hive.dart';

part 'cart_model.g.dart';

@HiveType(typeId: 0)
class CartModel {
  @HiveField(0)
  int id;
  @HiveField(1)
  String userToken;
  @HiveField(2)
  String title;
  @HiveField(3)
  double price;
  @HiveField(4)
  String description;
  @HiveField(5)
  String category;
  @HiveField(6)
  String image;

  CartModel({
    required this.id,
    required this.userToken,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  get valueListenable => 1;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userToken': userToken,
      'title,': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
        id: map['id']?.toInt() ?? 0,
        userToken: map['userToken'] ?? '',
        title: map['title'] ?? '',
        price: map['price'] ?? 0,
        description: map['description'] ?? '',
        category: map['category'] ?? '',
        image: map['image'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source));

  List<CartModel> productsFromJson(String str) =>
      List<CartModel>.from(json.decode(str).map((x) => CartModel.fromJson(x)));
}
