import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import './edit_products_screen.dart';

class ManegeProducts extends StatelessWidget {
  static const routeName = '/manege-products';

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProducts.routeName);
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 8.0),
        child: ListView.builder(
          itemBuilder: (ctx, i) {
            return ChangeNotifierProvider.value(
              value: product.items[i],
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(product.items[i].imageUrl),
                    ),
                    title: Text(product.items[i].title),
                    trailing: Container(
                      width: 100.0,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.brush),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                EditProducts.routeName,
                                arguments: product.items[i].id,
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () {
                              product.deleteProdItems(product.items[i].id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                ],
              ),
            );
          },
          itemCount: product.items.length,
        ),
      ),
    );
  }
}
