import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartItem({
    required this.id,
    this.productId = '',
    required this.price,
    required this.quantity,
    required this.title,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {



    return Dismissible(
      key: ValueKey<String>(id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('точно удалить?'),
              content: Text('Удалить элемент из корзины?'),
              actions: [
                TextButton(onPressed: ()=>Navigator.of(ctx).pop(false), child: Text('Нет'),),
                TextButton(onPressed: ()=> Navigator.of(ctx).pop(true), child: Text('Да'),),
              ],
            ),);
      },
      onDismissed: (direction){
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },

      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Всего: \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
