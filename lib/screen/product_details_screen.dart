import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(context).items;
    final selectedProduct = product.firstWhere((prod) => prod.id == productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedProduct.title),
      ),
      body: Column(
        children: [
          Container(
            height: 250.0,
            width: double.infinity,
            child: Image.network(
              selectedProduct.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            '\$${selectedProduct.price}',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontFamily: 'RobotoCondensed',
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Text(
              '${selectedProduct.description}',
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
