import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shopapp/providers/orders.dart' as orders_provider;

class OrderItem extends StatefulWidget {

  final orders_provider.OrderItem order;

  const OrderItem({ required this.order,Key? key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: (){},
            ),
          ),

        ],
      ),
    );
  }
}
