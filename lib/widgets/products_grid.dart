import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/widgets/product_item.dart';

import '../models/product.dart';
import '../providers/products_provider.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    super.key,

  });



  @override
  Widget build(BuildContext context) {

    final productsData =  Provider.of<ProductsProvider>(context);
    final products = productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, item) => ProductItem(
        id: products[item].id,
        title: products[item].title,
        imageUrl: products[item].imageUrl,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
