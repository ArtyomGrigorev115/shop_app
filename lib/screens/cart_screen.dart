import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/providers/cart.dart' show Cart;
import 'package:shopapp/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Корзина'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Всего', style: TextStyle(fontSize: 20,),),
                  //SizedBox(width: 10,),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(color: Theme.of(context).primaryTextTheme.titleMedium?.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                      onPressed: (){},
                      child: Text('Оформить заказ')
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
              child: ListView.builder(
                itemCount: cart.itemCount,
                  //toDO: возможен NullPointerException
                  itemBuilder: (ctx, index) => CartItem(
                      id: cart.items.values.toList()[index].id,
                      productId: cart.items.keys.toList()[index],
                      title: cart.items.values.toList()[index].title,
                      quantity: cart.items.values.toList()[index].quantity,
                      price: cart.items.values.toList()[index].price)
              )
          ),
        ],
      ),
    );
  }
}
