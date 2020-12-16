import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/cart.dart';
import '../models/httpException.dart';

class CartItem with ChangeNotifier {
  Map<String, Cart> _items = {};

  Map<String, Cart> get items {
    return _items;
  }

  int get totalCartItem {
    return _items == null ? 0 : _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, value) {
      total += value.amount * value.quantity;
    });
    return total;
  }

  void removeCartItem(cartId) {
    _items.remove(cartId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void addItems(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (value) => Cart(
          id: DateTime.now().toString(),
          title: product.title,
          amount: product.price,
          quantity: value.quantity + 1,
        ),
      );
      notifyListeners();
    } else {
      _items.putIfAbsent(
        product.id,
        () => Cart(
          id: DateTime.now().toString(),
          title: product.title,
          amount: product.price,
          quantity: 1,
        ),
      );
      notifyListeners();
    }
  }

  void undoItems(String productId, Product product) {
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (value) => Cart(
          id: DateTime.now().toString(),
          title: product.title,
          amount: product.price,
          quantity: value.quantity - 1,
        ),
      );
    } else if (_items[productId].quantity == 1) {
      _items.remove(productId);
    }

    notifyListeners();
  }
}
