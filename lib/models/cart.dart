import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  final String id;
  final String title;
  final double amount;
  final int quantity;

  Cart({
    this.id,
    this.title,
    this.amount,
    this.quantity,
  });
}
