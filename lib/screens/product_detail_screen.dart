import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  /*final String title;
  final double price;*/

  const ProductDetailScreen({/*required this.price,required this.title,*/ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*Принимаем данные, переданные в Navigator-е из ProductItem виджета*/
    final String productId =  ModalRoute.of(context)?.settings.arguments as String;

    /*бёрём из провайдера название товара*/
    final loadedProduct = Provider
        .of<ProductsProvider>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover,),
            ),
            SizedBox(height: 10,),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(loadedProduct.description, textAlign: TextAlign.center, softWrap: true,)),

          ],
        ),
      ),
    );
  }
}
