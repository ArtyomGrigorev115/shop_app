import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products_provider.dart';
import 'package:shopapp/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem({required this.id ,required this.title, required this.imageUrl, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: ()  {
                Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
            ),
            IconButton(
              onPressed: () async {
                try{
                  await Provider.of<ProductsProvider>(context, listen: false).deleteProduct(id);
                }
                catch(error){
                  scaffoldMessenger
                      .showSnackBar(SnackBar(content: Text('Нельзя удалить', textAlign: TextAlign.center,)));
                }

              },
              icon: const Icon(
                Icons.delete),
              color: Theme.of(context).colorScheme.error,
            )
          ],
        ),
      ),
    );
  }
}
