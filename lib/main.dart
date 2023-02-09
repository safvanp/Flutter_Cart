import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/data/data_helper.dart';
import 'package:flutter_cart/model/cart_model.dart';
import 'package:flutter_cart/provider/auth_provider.dart';
import 'package:flutter_cart/provider/cart_provider.dart';
import 'package:flutter_cart/provider/product_provider.dart';
import 'package:flutter_cart/screens/home/home.dart';
import 'package:flutter_cart/screens/login_screen.dart';
import 'package:flutter_cart/utils/cache_provider.dart';
import 'package:flutter_cart/utils/constants.dart';
import 'package:flutter_cart/utils/platform_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initPreference().then((_) {
    runApp(const MyApp());
  });
}

initPreference() async {
  CacheProvider cacheProvider = HiveCache();
  await cacheProvider.init();
  await Hive.initFlutter();
  token = cacheProvider.getValue('token', '');
  Hive.registerAdapter(CartModelAdapter());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
            create: (_) => CartProvider(dataBase: DataBase())),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'Login App',
        debugShowCheckedModeBanner: false,
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? PlatformTheme.iOS
            : PlatformTheme.android,
        home: token.isNotEmpty ? Home() : const LoginScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => Home(),
        },
      ),
    );
  }
}
