import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cart/data/data_helper.dart';
import 'package:flutter_cart/screens/home/components/products.dart';
import 'package:flutter_cart/service/api.dart';
import 'package:flutter_cart/utils/common_util.dart';
import 'package:flutter_cart/utils/constants.dart';
import 'package:provider/provider.dart';

import 'package:flutter_cart/model/product_model.dart';
import 'package:flutter_cart/provider/cart_provider.dart';
import 'package:flutter_cart/provider/product_provider.dart';
import 'package:flutter_cart/screens/cart_screen.dart';

import 'components/categories.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey _key = GlobalKey();
  late ProductProvider _productProvider;
  List<ProductModel> _searchList = [];
  List<ProductModel> productList = [];
  List<CategoryModel> categoryList = [];
  String _searchText = '';

  final TextEditingController _searchQuery = TextEditingController();

  @override
  initState() {
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _productProvider.fetchProduct();
    super.initState();
    initData();
  }

  initData() async {
    await fetchCategory();
  }

  Future<void> fetchCategory() async {
    List<CategoryModel> data = [];
    await CommonUtil().checkInternetConnection().then((value) {
      if (value) {
        APICall().getCategories().then((response) {
          if (response.statusCode == 200) {
            var categories = (json.decode(response.body) as List)
                .map((data) => CategoryModel(name: data))
                .toList();
            data.add(CategoryModel(name: 'All'));
            data.addAll(categories);
            setState(() {
              categoryList = data;
            });
          }
        });
      }
    });
  }

  Icon actionIcon = const Icon(
    Icons.search,
    color: Colors.white,
  );

  Widget appBarTitle = const Text(
    "Flutter Cart",
    style: TextStyle(color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    var productProvider = Provider.of<ProductProvider>(context, listen: false);
    int totalCount = 0;
    if (cartProvider.cart.isNotEmpty) {
      totalCount = cartProvider.cart.length;
    }

    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        _productProvider.setSearching(false);
        _searchText = "";
        _buildSearchList();
      } else {
        _productProvider.setSearching(true);
        _searchText = _searchQuery.text;
        _buildSearchList();
      }
    });

    return ChangeNotifierProvider<CartProvider>(
      key: _key,
      builder: (context, child) => Scaffold(
        appBar: AppBar(title: appBarTitle, centerTitle: true, actions: [
          IconButton(
            icon: actionIcon,
            onPressed: () async {
              setState(() {
                if (actionIcon.icon == Icons.search) {
                  actionIcon = const Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  appBarTitle = TextField(
                    controller: _searchQuery,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                        hintText: "Search here..",
                        hintStyle: TextStyle(color: Colors.white)),
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
                height: 150.0,
                width: 30.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartScreen(),
                      ),
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      const IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        onPressed: null,
                      ),
                      Positioned(
                          child: Stack(
                        children: <Widget>[
                          Icon(Icons.brightness_1,
                              size: 20.0, color: Colors.red[700]),
                          Positioned(
                              top: 3.0,
                              right: 7,
                              child: Center(
                                child: Text(
                                  '$totalCount',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                        ],
                      )),
                    ],
                  ),
                )),
          )
        ]),
        body: Column(mainAxisSize: MainAxisSize.min, children: [
          categoryList.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(
                  height: 60,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) => CategoryCard(
                      title: categoryList[index].name,
                      press: () {
                        _searchList = [];
                        productProvider.fetchProductByCategory(
                            index == 0 ? '' : categoryList[index].name);
                      },
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: defaultPadding),
                  )),
          Consumer<ProductProvider>(builder: (context, provider, child) {
            if (provider.status == Status.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (provider.status == Status.success) {
              productList = provider.products;
              if (_searchList.isEmpty) {
                _searchList = productList;
              }
              return Expanded(child: Products(products: _searchList));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ]),
      ),
      create: (context) => CartProvider(dataBase: DataBase()),
    );
  }

  List<ProductModel> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _searchList = productList;
    } else {
      _searchList = productList
          .where((element) =>
              element.title.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
      debugPrint('${_searchList.length}');
      return _searchList;
    }
  }

  void _handleSearchStart() {
    _productProvider.setSearching(true);
  }

  void _handleSearchEnd() {
    actionIcon = const Icon(
      Icons.search,
      color: Colors.white,
    );
    appBarTitle = const Text(
      "Flutter Cart",
      style: TextStyle(color: Colors.white),
    );
    _productProvider.setSearching(false);
    _searchQuery.clear();
  }
}
