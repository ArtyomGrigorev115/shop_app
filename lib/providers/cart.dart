import 'package:flutter/material.dart';

class CartItem{
  final String id;
  final String title;
  final int quantity;
  final double price;

  const CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items{
    return {..._items};
  }

  int get itemCount{
    print(_items.length);
    return _items.length;
  }

  double get totalAmount{
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title){

      if(_items.containsKey(productId)){
        //Увеличить кол-во товара
        print('Увеличиваем товар');
        _items.update(
            productId,
                (existingCarItem) => CartItem(
                    id: existingCarItem.id,
                    title: existingCarItem.title,
                    quantity: existingCarItem.quantity + 1,
                    price: existingCarItem.price
                ),
        );
        print('koл-во товара ${_items[productId]?.quantity}');
    }
      else{
        print('Добавляем новый');
        _items.putIfAbsent(
            productId,
                () => CartItem(
                    id: DateTime.now().toString(),
                    title: title,
                    quantity: 1,
                    price: price)
        );
      }
    notifyListeners();
  }

  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }

  void clear(){
    _items = {};
    notifyListeners();
  }
}
