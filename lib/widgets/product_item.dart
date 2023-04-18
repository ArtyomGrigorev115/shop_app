import 'package:flutter/material.dart';
import 'package:shopapp/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const ProductItem(
      {required this.id, required this.title, required this.imageUrl, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        // header: GridTileBar(title: Text('ZZZZ'),),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.favorite),
            onPressed: () {},
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ),
        child: GestureDetector(
          /*По касанию переходим на экран с детальной информацией о товаре,
          * передаём необходимые данные*/
          onTap: () {
            Navigator
                .of(context)
                .pushNamed(ProductDetailScreen.routeName, arguments: id);
          },
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
