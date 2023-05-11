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
  final String authToken;
  final String userId;

  Orders(this.authToken,this.userId ,this._orders);

  List<OrderItem> get orders{
    return [..._orders];
  }

  /**/
  Future<void> fetchAndSetOrders() async {
    final Uri url = Uri.parse(
        'https://shopapp-67ba1-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken');

    final response = await http.get(url);
    print('GET Заказы: ${response.body}');

    final List<OrderItem> loadOrders = [];
    //final Map<String, dynamic> extractData = json.decode(response.body) as Map<String, dynamic>;
    Map<String, dynamic> extractData = {};
    if(json.decode(response.body) != null){
      extractData = json.decode(response.body) as Map<String, dynamic>;
    }
    else{
      print('Заков в базе нет');
      return;
    }

    // if(extractData == null){
    //   print('Заков в базе нет');
    //   return;
    // }

    extractData.forEach((orderId, orderData) {
      loadOrders.add(
          OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
              id: item['id'],
              title: item['title'],
              quantity: item['quantity'],
              price: item['price'],
          ),
          ).toList(),

          dateTime: DateTime.parse(orderData['dateTime']),
      )
      );
    });
    _orders = loadOrders.reversed.toList();
    notifyListeners();
  }


  /*POST -запросом добавляем "заказы" в БД и в локальный список заказов*/
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {

    final Uri url = Uri.parse(
        'https://shopapp-67ba1-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
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
    print('POST Заказ: ${response.body}');
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
