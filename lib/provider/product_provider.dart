import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_cart/model/product_model.dart';
import 'package:flutter_cart/service/api.dart';
import 'package:flutter_cart/utils/common_util.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  bool loading = false;
  List<ProductModel> get products => _products;
  bool _isSearching = false;
  bool get isSearching => _isSearching;

  void setSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  Status get status => _status;
  Status _status = Status.none;

  void addProduct(ProductModel product) {
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(int index) {
    _products.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _products = [];
    notifyListeners();
  }

  fetchProductLimit() async {
    loading = true;
    notifyListeners();
    _products = (await getProductLimit('5'));
    loading = false;
    notifyListeners();
  }

  Future<void> fetchProduct() async {
    CommonUtil().checkInternetConnection().then((value) {
      if (value) {
        _status = Status.loading;
        notifyListeners();
        APICall().getProducts().then((response) {
          if (response.statusCode == 200) {
            _products = (json.decode(response.body) as List)
                .map((data) => ProductModel.fromMap(data))
                .toList();
            _status = Status.success;
            notifyListeners();
          } else {
            _status = Status.failed;
            notifyListeners();
          }
        });
      } else {
        _status = Status.noInternet;
        notifyListeners();
      }
    });
  }

  Future<void> fetchProductByCategory(String category) async {
    CommonUtil().checkInternetConnection().then((value) {
      if (value) {
        _status = Status.loading;
        notifyListeners();
        APICall().getProductsByCategory(category).then((response) {
          if (response.statusCode == 200) {
            _products = (json.decode(response.body) as List)
                .map((data) => ProductModel.fromMap(data))
                .toList();
            _status = Status.success;
            notifyListeners();
          } else {
            _status = Status.failed;
            notifyListeners();
          }
        });
      } else {
        _status = Status.noInternet;
        notifyListeners();
      }
    });
  }
}

class CategoryModel {
  String name;
  CategoryModel({
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));
}

enum Status { noInternet, failed, success, loading, none }
