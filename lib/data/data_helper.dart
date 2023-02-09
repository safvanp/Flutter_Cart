import 'package:flutter_cart/model/cart_model.dart';
import 'package:hive/hive.dart';

class DataBase extends DbHelper {
  final String boxName = 'flutter_cart';

  @override
  Future<Box> openBox() async {
    Box box = await Hive.openBox(boxName);
    return box;
  }

  @override
  List<CartModel> getCartList(Box box) {
    return box.values.toList().cast<CartModel>();
  }

  @override
  Future<void> addCart(Box box, CartModel cart) async {
    await box.put(cart.id, cart);
  }

  @override
  Future<void> clearCartList(Box box) async {
    await box.clear();
  }

  @override
  Future<void> removeCart(Box box, CartModel cart) async {
    await box.delete(cart.id);
  }
}

abstract class DbHelper {
  DbHelper();
  Future<Box> openBox();
  List<CartModel> getCartList(Box box);
  Future<void> addCart(Box box, CartModel cart);
  Future<void> removeCart(Box box, CartModel cart);
  Future<void> clearCartList(Box box);
}
