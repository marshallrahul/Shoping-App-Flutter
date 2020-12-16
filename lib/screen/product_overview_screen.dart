import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_grid.dart';
import '../widgets/cart.dart';
import '../widgets/drawer.dart';
import '../providers/cart_item_provider.dart';
import '../providers/products_provider.dart';

enum FilteredValue {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context, listen: false)
          .fetchUserProducts()
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
    final cartItem = Provider.of<CartItem>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PopupMenuButton(
                onSelected: (FilteredValue value) {
                  setState(() {
                    if (value == FilteredValue.Favorite) {
                      _showOnlyFavorites = true;
                    } else {
                      _showOnlyFavorites = false;
                    }
                  });
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    child: Text('Only Favorite'),
                    value: FilteredValue.Favorite,
                  ),
                  PopupMenuItem(
                    child: Text('Show All'),
                    value: FilteredValue.All,
                  ),
                ],
                icon: Icon(Icons.more_vert),
              ),
              Cart(cartItem.totalCartItem),
            ],
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showOnlyFavorites),
    );
  }
}
