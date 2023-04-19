import 'package:flutter/material.dart';

import 'product.dart';

class ProductsProvider with ChangeNotifier{

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
  List<Product> get items{
    // if(_showFavoritiesOnly){
    //   return _items.where((productItem) => productItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((productItem) => productItem.isFavorite).toList();
  }

  Product findById(String id){
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

  void addProduct(Product product){
   // _items.add(value);
    final newProduct = Product(
        id: DateTime.now().toString(),
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl);
    _items.add(newProduct);
    //_items.insert(0, newProduct);
    notifyListeners(); //Обновить слушатели
  }

}