import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/widgets/product_item.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavs;

  const ProductsGrid({
    required this.showOnlyFavs,
    super.key,
  });



  @override
  Widget build(BuildContext context) {

    final productsData =  Provider.of<ProductsProvider>(context);
    final products = showOnlyFavs ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, item) => ChangeNotifierProvider.value( //рекомендовано для Gridview,ListView
       // create: (BuildContext context) => products[item],
        value: products[item],
        child:  ProductItem(
        // id: products[item].id,
        // title: products[item].title,
        // imageUrl: products[item].imageUrl,
      ) , ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
