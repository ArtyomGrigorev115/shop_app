import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/screens/orders_screen.dart';

import 'package:shopapp/screens/product_detail_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';
import 'package:shopapp/providers/products_provider.dart';
import 'package:shopapp/screens/user_products_screen.dart';
import 'package:shopapp/screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth(),),
        /*Использовал Прокси провайдер,
        для того, что бы вытащить токен аутентификации */
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
    create: (_)=> ProductsProvider("","" ,[
      // Product(
      //     id: 'p1',
      //     title: 'title',
      //     description: 'descdesc',
      //     price: 34.56,
      //     imageUrl: 'https://live.staticflickr.com/65535/50124850593_c80347ae94_z.jpg')
    ]),
    update: (ctx,auth, previousProducts) => ProductsProvider(auth.token ?? "", auth.userId ,previousProducts == null ?[] : previousProducts.items),),

        ChangeNotifierProvider(create: (ctx) => Cart(),),

        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders("", "",[]),
            update: (ctx, auth, previousOrders) => Orders(auth.token ?? "", auth.userId ,previousOrders == null ? [] : previousOrders.orders)),
    ],

      child: Consumer<Auth>(
      builder: (builderContext, auth, _) =>
          MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.purple)
                  .copyWith(secondary: Colors.deepOrange),
              fontFamily: 'Lato',
            ),
            home: auth.isAuth ? ProductsOverviewScreen() :  AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
      )

    );
  }
}

/*class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Магазин'),),
      body: Center(
        child: Text('Главный экран'),
      ),
    );
  }
}*/


