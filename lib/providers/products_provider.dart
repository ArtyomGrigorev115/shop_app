import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'product.dart';

class ProductsProvider with ChangeNotifier {
  /* временный Список с товарами для дизайна виджета товаров*/
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Компьютерная мышь',
      description: 'Просто мышка для ПК',
      price: 29.99,
      imageUrl:
          'https://live.staticflickr.com/65535/50124850593_c80347ae94_z.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Брюки',
      description: 'Хорошая пара брюк.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Желтый шарф',
      description: 'Теплый и уютный - именно то, что вам нужно для зимы.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Сковорода',
      description: 'Приготовьте любую еду, которую вы хотите.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  bool _showFavoritiesOnly = false;

  /*Возвращает копию списка товаров*/
  List<Product> get items {
    // if(_showFavoritiesOnly){
    //   return _items.where((productItem) => productItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((productItem) => productItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  // void showFavoritesOnly(){
  //   _showFavoritiesOnly = true;
  //   notifyListeners();
  // }
  //
  // void showAll(){
  //   _showFavoritiesOnly = false;
  //   notifyListeners();
  // }

  /*асинхронный метод всегда возвращает  объект Future */
  Future<void> addProduct(Product product) async{
    //final url = Uri.http('shopapp-67ba1-default-rtdb.europe-west1.firebasedatabase.app','/products.json');
    final Uri url = Uri.parse(
        'https://shopapp-67ba1-default-rtdb.europe-west1.firebasedatabase.app/products.json');
    try {
      final response = await http
          .post(url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),);
      print(json.decode(response.body)); //{name: -key}

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          //ункальный id, сгенерированный сервером
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners(); //Обновить слушатели
    }
    catch(error){
          print(error);
          throw error; //пробрасываем исключение в EditProductScreen
    }
       // .then((response) {
      // print(json.decode(response.body)); //{name: -key}
      //
      // final newProduct = Product(
      //     id: json.decode(response.body)['name'],
      //     //ункальный id, сгенерированный сервером
      //     title: product.title,
      //     description: product.description,
      //     price: product.price,
      //     imageUrl: product.imageUrl);
      // _items.add(newProduct);
      //_items.insert(0, newProduct);
      // notifyListeners(); //Обновить слушатели
   // }).catchError((error){

  //  });
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((product) => product.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('........');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}


