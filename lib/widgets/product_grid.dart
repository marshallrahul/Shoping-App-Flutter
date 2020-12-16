import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFav;

  ProductGrid(this.showFav);

  @override
  Widget build(BuildContext context) {
    final allProducts = Provider.of<Products>(context).items;
    final favoriteProducts = Provider.of<Products>(context).favoriteProducts;
    final products = showFav ? favoriteProducts : allProducts;
    return GridView.builder(
      padding: EdgeInsets.all(15.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      itemCount: products.length,
    );
  }
}
