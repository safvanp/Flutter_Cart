import 'package:flutter/material.dart';

class PlatformTheme {
  static ThemeData iOS =
      ThemeData(primaryColor: Colors.grey[100], primarySwatch: Colors.blue);

  static ThemeData android = ThemeData(
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.grey[200],
    secondaryHeaderColor: Colors.white70,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
        .copyWith(secondary: Colors.deepOrangeAccent),
  );
}
