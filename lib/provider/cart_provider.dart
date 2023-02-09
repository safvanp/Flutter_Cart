import 'package:flutter/material.dart';
import 'package:flutter_cart/data/data_helper.dart';
import 'package:flutter_cart/model/cart_model.dart';
import 'package:hive/hive.dart';

class CartProvider with ChangeNotifier {
  final DataBase dataBase;
  List<CartModel> _cart = [];
  double get totalPrice => _cart
      .map((item) => item.price)
      .reduce((value, element) => value + element);

  CartProvider({required this.dataBase});

  List<CartModel> get cart => _cart;

  Future<void> getCart() async {
    try {
      Box box = await dataBase.openBox();
      _cart = dataBase.getCartList(box);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addToCart(CartModel data) async {
    Box box = await dataBase.openBox();
    dataBase.addCart(box, data);
    _cart = [];
    getCart();
  }

  Future<void> removeFromCart(CartModel data) async {
    Box box = await dataBase.openBox();
    dataBase.removeCart(box, data);
    _cart = [];
    getCart();
  }

  Future<void> clear() async {
    Box box = await dataBase.openBox();
    dataBase.clearCartList(box);
    _cart = [];
    notifyListeners();
  }

  valueListenable(int index) {
    return _cart[index];
  }
}
