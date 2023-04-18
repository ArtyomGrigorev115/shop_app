import 'package:flutter/material.dart';
import 'package:shopapp/widgets/product_item.dart';

import '../models/product.dart';

class ProductsOverviewScreen extends StatelessWidget {

  /* временный Список с товарами для дизайна виджета товаров*/
  final List<Product> loadedProducts =  [
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

   ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заурядный маретплейс'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: loadedProducts.length,
        itemBuilder: (ctx, item) => ProductItem(
            id: loadedProducts[item].id,
            title: loadedProducts[item].title,
            imageUrl: loadedProducts[item].imageUrl,
        ),

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),


      ),
    );
  }
}
