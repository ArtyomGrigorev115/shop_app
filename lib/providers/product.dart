import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

   Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
     this.isFavorite = false,
  });
   void _setFavoriteValue(bool newValue){
     isFavorite = newValue;
     notifyListeners();
   }


   /*Добавить товар в избранное,
   * убрать из избранного
   * Если добавить в избранное невозможно,
   * то происходит возврат в начальное состояние*/
   Future<void> toggleFavoriteStatus(String token) async {
     final oldStatus = isFavorite;
     isFavorite = !isFavorite;
     notifyListeners(); //обновить состояние

     final Uri url = Uri.parse(
         'https://shopapp-67ba1-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$token');

     /*изменяем статус избранного на сервере
     * PATCH запросом*/
     try{
       final responce = await http.patch(url, body: json.encode({
         'isFavorite': isFavorite,
       }));

       if(responce.statusCode >= 400){
         _setFavoriteValue(oldStatus);
       }
     }
     catch(error){
      //откат в начальное состояние
       _setFavoriteValue(oldStatus);
     }


   }
}
