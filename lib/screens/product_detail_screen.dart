import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  /*final String title;
  final double price;*/

  const ProductDetailScreen({/*required this.price,required this.title,*/ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*Принимаем данные, переданные в Navigator-е из ProductItem виджета*/
    final String productId =  ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('id: $productId'),
      ),
    );
  }
}
