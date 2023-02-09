import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {Key? key,
      required this.image,
      required this.title,
      required this.price,
      required this.press})
      : super(key: key);
  final String image, title;
  final VoidCallback press;
  final double price;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Card(
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(defaultPadding / 2),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(defaultBorderRadius)),
          ),
          child: Column(
            children: [
              Container(
                width: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEFBF9),
                  borderRadius:
                      BorderRadius.all(Radius.circular(defaultBorderRadius)),
                ),
                child: Image.network(
                  image,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: defaultPadding / 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: defaultPadding / 4),
              Row(
                children: [
                  Text(
                    '$price',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
