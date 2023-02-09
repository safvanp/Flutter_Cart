import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: press,
      style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(defaultBorderRadius)),
          ),
          backgroundColor: Colors.white),
      child: Text(
        title,
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }
}
