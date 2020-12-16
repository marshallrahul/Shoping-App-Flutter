import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../widgets/drawer.dart';
import '../providers/order_provider.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _details = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<OrderItem>(context, listen: false)
          .fetchOrderItems()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderItem>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: MainDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: order.length,
              itemBuilder: (ctx, i) {
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          '\$${order[i].total}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          DateFormat.yMMMEd().format(order[i].dateTime),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            _details ? Icons.expand_more : Icons.expand_less,
                          ),
                          onPressed: () {
                            setState(() {
                              _details = !_details;
                            });
                          },
                        ),
                      ),
                      if (_details)
                        Container(
                          child: Column(
                            children: order[i]
                                .products
                                .map((el) => Container(
                                      height: 20.0,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(el.title),
                                          Text(
                                              '${el.quantity}x \$${el.amount}'),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
