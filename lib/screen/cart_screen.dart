import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_item_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/cart_item.dart' as item;

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartItem>(context);
    // final order = Provider.of<OrderItem>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            elevation: 10.0,
            margin: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 6.0),
                  child: Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Spacer(),
                Chip(
                  label: Text('\$${cart.totalAmount}'),
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryTextTheme.headline6.color,
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                FlatButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<OrderItem>(context, listen: false)
                        .addOrderItems(
                      cart.items.values.toList(),
                      cart.totalAmount,
                    );
                    setState(() {
                      _isLoading = false;
                    });
                    cart.clearCart();
                  },
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text('ORDER NOW'),
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) {
                return Dismissible(
                  key: ValueKey(cart.items.keys),
                  onDismissed: (direction) {
                    cart.items.keys.forEach((id) => cart.removeCartItem(id));
                  },
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: EdgeInsets.only(right: 20.0),
                    margin: EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 4.0,
                    ),
                    color: Theme.of(context).errorColor,
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                    ),
                  ),
                  child: item.CartItem(
                    cart.items.values.toList()[i].id,
                    cart.items.values.toList()[i].title,
                    cart.items.values.toList()[i].amount,
                    cart.items.values.toList()[i].quantity,
                  ),
                  confirmDismiss: (direction) {
                    return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text(
                            'Do you want to remove the item from the cart?'),
                        actions: [
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('No'),
                          ),
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              itemCount: cart.items.length,
            ),
          ),
        ],
      ),
    );
  }
}
