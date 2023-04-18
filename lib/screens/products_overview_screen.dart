import 'package:flutter/material.dart';
import 'package:shopapp/widgets/products_grid.dart';

import '../providers/product.dart';
import 'package:shopapp/widgets/products_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  /* временный Список с товарами для дизайна виджета товаров*/


  ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заурядный маретплейс'),
      ),
      body: ProductsGrid(),
    );
  }
}
