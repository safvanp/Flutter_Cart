import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cart/model/product_model.dart';
import 'package:flutter_cart/utils/constants.dart';
import 'package:http/http.dart';

Future<bool> requestLogIn(username, password) async {
  String endPoint = 'auth/login';
  try {
    var url = Uri.https(baseUrl, endPoint);
    Response response = await post(url, body: {
      'username': username,
      'password': password
    }); //{'username': 'mor_2314', 'password': '83r5^_'});
    if (response.statusCode == 200) {
      var b = json.decode(response.body);
      token = b['token']; //token
      return true;
    } else {
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}

Future<List<ProductModel>> getProduct() async {
  List<ProductModel> result = [];
  Uri url = Uri.https(baseUrl, endPointProducts);
  try {
    Response response = await get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      for (var data in json) {
        var d1 = ProductModel.fromMap(data);
        result.add(d1);
      }
    } else {
      debugPrint('error respond');
    }
  } catch (e) {
    debugPrint('error');
  }
  return result;
}

Future<List<ProductModel>> getProductLimit(String limit) async {
  List<ProductModel> result = [];
  Uri url = Uri.https(baseUrl, endPointProducts, {'limit': limit});
  Response response = await get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': token,
    },
  );

  try {
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      for (var data in json) {
        var d1 = ProductModel.fromMap(data);
        result.add(d1);
      }
    } else {
      debugPrint('error');
    }
  } catch (e) {
    debugPrint('error');
  }
  return result;
}

class APICall {
  getCategories() async {
    Uri url = Uri.https(baseUrl, endPointProductsCategories);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    return await get(url, headers: headers);
  }

  getProducts() async {
    Uri url = Uri.https(baseUrl, endPointProducts);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    return await get(url, headers: headers);
  }

  getProductsByCategory(String category) async {
    Uri url = category.isNotEmpty
        ? Uri.https(baseUrl, '$endPointProductsCategory/$category')
        : Uri.https(baseUrl, endPointProducts);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    return await get(url, headers: headers);
  }
}
