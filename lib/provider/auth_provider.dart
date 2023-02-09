import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cart/utils/cache_provider.dart';
import 'package:flutter_cart/utils/constants.dart';
import 'package:http/http.dart';

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(String username, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
      'username': username,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();
    Uri url = Uri.https(baseUrl, endPointLogin);
    Response response = await post(
      url,
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      token = responseData['token'];
      CacheProvider cacheProvider = HiveCache();
      await cacheProvider.init();
      cacheProvider.setString('token', token);
      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful'};
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> register(
      String username, String password, String passwordConfirmation) async {
    final Map<String, dynamic> registrationData = {
      'username': username,
      'password': password,
      'password_confirmation': passwordConfirmation
    };

    _registeredInStatus = Status.Registering;
    notifyListeners();

    Uri url = Uri.https(baseUrl, '');
    return await post(url,
            body: json.encode(registrationData),
            headers: {'Content-Type': 'application/json'})
        .then((value) => {'message': 'success'});
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }

  FutureOr Function(Response value) onValue() {
    dynamic result = '';
    return result;
  }
}

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}
