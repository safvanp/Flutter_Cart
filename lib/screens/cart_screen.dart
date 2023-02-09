import 'package:flutter/material.dart';
import 'package:flutter_cart/model/cart_model.dart';
import 'package:flutter_cart/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
      ),
      body: Column(
        children: [
          Expanded(child: Consumer<CartProvider>(
            builder: (context, provider, child) {
              if (provider.cart.isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.cart.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.blueGrey.shade200,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.network(
                              provider.cart[index].image,
                              height: 80,
                              width: 80,
                            ),
                            SizedBox(
                              width: 130,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    text: TextSpan(
                                        text: 'Name: ',
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade800,
                                            fontSize: 14.0),
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${provider.cart[index].title}\n',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                  ),
                                  RichText(
                                    maxLines: 1,
                                    text: TextSpan(
                                        text: 'Price: ',
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade800,
                                            fontSize: 16.0),
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${provider.cart[index].price.toStringAsFixed(2)}\n',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  provider.removeFromCart(provider.cart[index]);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade800,
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                    child: Text('Your Cart is Empty',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0)));
              }
            },
          )),
          Consumer<CartProvider>(
            builder: (BuildContext context, value, Widget? child) {
              return Column(
                children: [
                  ReusableWidget(
                      title: 'Sub-Total',
                      value: value.cart.isNotEmpty
                          ? value.totalPrice.toStringAsFixed(2)
                          : '0.00')
                ],
              );
            },
          )
        ],
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          //place order
        },
        child: Container(
          color: Colors.blue.shade600,
          alignment: Alignment.center,
          height: 50.0,
          child: const Text(
            'Place Order',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({Key? key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}
