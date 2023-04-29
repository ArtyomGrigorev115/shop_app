import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shopapp/providers/cart.dart' show CartItem;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders{
    return [..._orders];
  }

  /*POST -запросом добавляем "заказы" в БД и в локальный список заказов*/
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {

    final Uri url = Uri.parse(
        'https://shopapp-67ba1-default-rtdb.europe-west1.firebasedatabase.app/orders.json');
    final timeStamp = DateTime.now();

    final response = await http.post(url, body: json.encode({
      'amount': total,
      'dateTime': timeStamp.toIso8601String(),
      'products': cartProducts.map((cartProduct) =>{
        'id': cartProduct.id,
        'title': cartProduct.title,
        'quantity': cartProduct.quantity,
        'price': cartProduct.price,
      }).toList()
    }),
    );
    print('Заказ: ${response.body}');
    /*Добавляем "заказ" в локальный список заказов,
    * где id заказа - это уникальный id, который пришёл в ответе сервера */
    _orders.insert(0, OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp)
    );
    notifyListeners();
  }
}
