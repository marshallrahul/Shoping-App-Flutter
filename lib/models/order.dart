import 'package:flutter/foundation.dart';
import './cart.dart';

class Order {
  final String id;
  final double total;
  final List<Cart> products;
  final DateTime dateTime;

  Order({
    @required this.id,
    @required this.products,
    @required this.total,
    @required this.dateTime,
  });
}
