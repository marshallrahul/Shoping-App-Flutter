import 'package:flutter/material.dart';

import '../screen/cart_screen.dart';

class Cart extends StatelessWidget {
  final int value;

  Cart(this.value);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.of(context).pushNamed(CartScreen.routeName);
          },
        ),
        Positioned(
          top: 7.0,
          right: 7.0,
          child: Container(
            child: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              radius: 7.0,
              child: FittedBox(
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
