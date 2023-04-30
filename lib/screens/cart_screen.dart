import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/providers/cart.dart' show Cart;
import 'package:shopapp/widgets/cart_item.dart';
import 'package:shopapp/providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Всего', style: TextStyle(fontSize: 20,),),
                  //SizedBox(width: 10,),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Theme.of(context).primaryTextTheme.titleMedium?.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  // TextButton(
                  //     onPressed: cart.totalAmount <= 0 ? null : (){
                  //       Provider.of<Orders>(context, listen: false)
                  //           .addOrder(cart.items.values.toList(), cart.totalAmount,);
                  //       cart.clear();
                  //     },
                  //     child: Text('Оформить заказ')
                  // ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
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

class OrderButton extends StatefulWidget {
  final Cart cart;
  const OrderButton({required this.cart, Key? key}) : super(key: key);

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isloading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed:  (widget.cart.totalAmount <= 0 || _isloading)
            ? null
            : () async {
          setState(() {
            _isloading = true;

          });
         await Provider.of<Orders>(context, listen: false)
              .addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount,);
          setState(() {
            _isloading = false;

          });
          widget.cart.clear();
        },
        child: _isloading ? const CircularProgressIndicator() :const Text('Оформить заказ')
    );
  }
}

