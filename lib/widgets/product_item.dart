import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/screens/product_detail_screen.dart';

import '../providers/cart.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  const ProductItem({
    // required this.id,
    // required this.title,
    // required this.imageUrl,
    Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    print('изменение');
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        // header: GridTileBar(title: Text('ZZZZ'),),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon:  Icon( product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus(authData.token!, authData.userId);
              },
            ),

          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.shopping_cart),
            
            //cart
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
            },
          ),
        ),
        child: GestureDetector(
          /*По касанию переходим на экран с детальной информацией о товаре,
          * передаём необходимые данные*/
          onTap: () {
            Navigator
                .of(context)
                .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
