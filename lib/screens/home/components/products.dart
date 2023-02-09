import 'package:flutter/material.dart';

import 'package:flutter_cart/model/product_model.dart';
import 'package:flutter_cart/screens/home/components/product_card.dart';
import 'package:flutter_cart/widget/product_details.dart';

class Products extends StatelessWidget {
  List<ProductModel> products;
  Products({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: products.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        return ProductCard(
          title: products[index].title,
          image: products[index].image,
          price: products[index].price.toDouble(),
          press: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetails(product: products[index]),
              ),
            );
          },
        );
      },
    );
  }
}
