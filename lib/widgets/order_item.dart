import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:shopapp/providers/orders.dart' as orders_provider;

class OrderItem extends StatefulWidget {

  final orders_provider.OrderItem order;

  const OrderItem({ required this.order,Key? key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less :  Icons.expand_more),
              onPressed: (){
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if(_expanded) Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: min(widget.order.products.length * 20.0 + 10, 100), //высота высчитывается динамически
            child: ListView.builder(
                itemCount: widget.order.products.length,
                itemBuilder: (ctx, index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text(widget.order.products[index].title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  Text('${widget.order.products[index].quantity}x \$${widget.order.products[index].price}', style: TextStyle(fontSize: 18, color: Colors.grey),),

                ],),
            ),
          )
        ],
      ),
    );
  }
}
