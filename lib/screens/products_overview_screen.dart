import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products_provider.dart';
import 'package:shopapp/widgets/products_grid.dart';

import '../providers/product.dart';
import 'package:shopapp/widgets/products_grid.dart';

enum FilterOptions{
  Favorities,
  All,
}
// final productsContainer = Provider.of<ProductsProvider>(context, listen: false);
// productsContainer.showFavoritesOnly();
// productsContainer.showAll();

class ProductsOverviewScreen extends StatefulWidget {

  ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {

   // final productsContainer = Provider.of<ProductsProvider>(context, listen: false);


    return Scaffold(
      appBar: AppBar(
        title: Text('Заурядный маркетплейс'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue){
              setState(() {
                if(selectedValue == FilterOptions.Favorities){
                  // productsContainer.showFavoritesOnly();
                  _showOnlyFavorites = true;
                }
                else{
                  // productsContainer.showAll();
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(child: Text('Избранное'), value: FilterOptions.Favorities,),
                PopupMenuItem(child: Text('Показать всё'), value: FilterOptions.All,),
              ],
          )
        ],
      ),
      body: ProductsGrid(showOnlyFavs: _showOnlyFavorites,),
    );
  }
}
