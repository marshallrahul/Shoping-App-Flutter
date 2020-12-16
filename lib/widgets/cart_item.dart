import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final double amount;
  final int quantity;

  CartItem(
    this.id,
    this.title,
    this.amount,
    this.quantity,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 2.0,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: FittedBox(
              child: Text(
                '\$$amount',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        title: Text(title),
        subtitle: Text('Total: ${amount * quantity}'),
        trailing: Text('$quantity x'),
      ),
    );
  }
}
