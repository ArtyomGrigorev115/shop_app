import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/providers/orders.dart' show Orders;
import 'package:shopapp/widgets/order_item.dart';

import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Заказы'),),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
          itemBuilder: (ctx, index) => OrderItem(order: orderData.orders[index])

      ),
    );
  }
}
