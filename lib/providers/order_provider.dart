import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/order.dart';
import '../models/cart.dart';
import '../models/httpException.dart';

class OrderItem with ChangeNotifier {
  final String authToken;
  final String userId;

  OrderItem(this.authToken, this.userId);

  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  Future<void> fetchOrderItems() async {
    final url =
        'https://shoping-app-update.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if (extractData == null) {
        return;
      }
      extractData.forEach((orderId, orderData) {
        _items.insert(
          0,
          Order(
            id: orderId,
            total: orderData['total'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => Cart(
                    id: item['id'],
                    title: item['title'],
                    amount: item['amount'],
                    quantity: item['quantity'],
                  ),
                )
                .toList(),
          ),
        );
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrderItems(List<Cart> cartItems, double total) async {
    final url =
        'https://shoping-app-update.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final timeStamp = DateTime.now();
      final response = await http.post(
        url,
        body: json.encode({
          'total': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartItems
              .map(
                (cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'amount': cp.amount,
                  'quantity': cp.quantity,
                },
              )
              .toList(),
        }),
      );
      if (response.statusCode >= 400) {
        throw HttpException('Error occured');
      }
      // _items.insert(
      //   0,
      //   Order(
      //     id: DateTime.now().toString(),
      //     total: total,
      //     products: cartItems,
      //     dateTime: DateTime.now(),
      //   ),
      // );
      // notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
