import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveCache extends CacheProvider {
  late Box _preferences;
  final String keyName = 'flutter_cart_preferences';

  @override
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (!kIsWeb) {
      final defaultDirectory = await getApplicationDocumentsDirectory();
      Hive.init(defaultDirectory.path);
    }
    _preferences = await Hive.openBox(keyName);
  }

  Set get keys => getKeys();

  @override
  bool getBool(String key) {
    return _preferences.get(key);
  }

  @override
  double getDouble(String key) {
    return _preferences.get(key);
  }

  @override
  int getInt(String key) {
    return _preferences.get(key);
  }

  @override
  String getString(String key) {
    return _preferences.get(key);
  }

  @override
  Future<void> setBool(String key, bool value) {
    return _preferences.put(key, value);
  }

  @override
  Future<void> setDouble(String key, double value) {
    return _preferences.put(key, value);
  }

  @override
  Future<void> setInt(String key, int value) {
    return _preferences.put(key, value);
  }

  @override
  Future<void> setString(String key, String value) {
    return _preferences.put(key, value);
  }

  @override
  Future<void> setObject<T>(String key, T value) {
    return _preferences.put(key, value);
  }

  @override
  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  @override
  Set getKeys() {
    return _preferences.keys.toSet();
  }

  @override
  Future<void> remove(String key) async {
    if (containsKey(key)) {
      await _preferences.delete(key);
    }
  }

  @override
  Future<void> removeAll() async {
    final keys = getKeys();
    await _preferences.deleteAll(keys);
  }

  @override
  T getValue<T>(String key, T defaultValue) {
    var value = _preferences.get(key);
    if (value is T) {
      return value;
    }
    return defaultValue;
  }
}

abstract class CacheProvider {
  CacheProvider();

  Future<void> init();

  int getInt(String key);

  String getString(String key);

  double getDouble(String key);

  bool getBool(String key);

  Future<void> setInt(String key, int value);

  Future<void> setString(String key, String value);

  Future<void> setDouble(String key, double value);

  Future<void> setBool(String key, bool value);

  bool containsKey(String key);

  Set getKeys();

  Future<void> remove(String key);

  Future<void> removeAll();

  Future<void> setObject<T>(String key, T value);

  T getValue<T>(String key, T defaultValue);
}
