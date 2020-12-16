import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../screen/product_details_screen.dart';
import '../providers/cart_item_provider.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cartItem = Provider.of<CartItem>(context);
    final auth = Provider.of<Auth>(context);
    // print(cartItem.items);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetails.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              product.toggleFavorite(auth.userId, auth.token);
            },
          ),
          title: Text(product.title),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cartItem.addItems(product);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Add item to cart'),
                  backgroundColor: Colors.black87,
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cartItem.undoItems(product.id, product);
                    },
                  ),
                  duration: Duration(seconds: 3),
                  elevation: 10.0,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
