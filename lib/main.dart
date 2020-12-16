import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './screen/product_overview_screen.dart';
import './screen/product_details_screen.dart';
import './screen/cart_screen.dart';
import './screen/order_screen.dart';
import './screen/manege_products_screen.dart';
import './screen/auth_screen.dart';
import './screen/edit_products_screen.dart';
import './providers/products_provider.dart';
import './providers/cart_item_provider.dart';
import './providers/order_provider.dart';
import './providers/auth.dart';

void main() {
  // SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: null,
          update: (ctx, auth, products) => Products(auth.token, auth.userId),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartItem(),
        ),
        ChangeNotifierProxyProvider<Auth, OrderItem>(
          create: null,
          update: (ctx, auth, order) => OrderItem(auth.token, auth.userId),
        ),
      ],
      child: MaterialApp(
        title: 'Shopping App',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Raleway',
        ),
        debugShowCheckedModeBanner: false,
        home: Consumer<Auth>(
          builder: (ctx, authData, _) =>
              authData.isAuth ? ProductOverviewScreen() : AuthScreen(),
        ),
        routes: {
          ProductDetails.routeName: (ctx) => ProductDetails(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          ManegeProducts.routeName: (ctx) => ManegeProducts(),
          EditProducts.routeName: (ctx) => EditProducts(),
        },
      ),
    );
  }
}
