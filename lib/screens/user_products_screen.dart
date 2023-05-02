import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/providers/products_provider.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/user_product_item.dart';

import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({Key? key}) : super(key: key);

  /*Pull-to-Refresh паттерн*/
  Future<void> _refreshProducts(BuildContext context)  async {
    await Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {

  //  final productsData = Provider.of<ProductsProvider>(context);
  print('обновляем...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Товары'),
        actions: [
          IconButton(onPressed: (){
            //...
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          },
              icon: const Icon(Icons.add)
          )
        ],
      ),
      drawer: AppDrawer(),

      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (builderContext, snapshot) => snapshot.connectionState == ConnectionState.waiting ? const Center(child: CircularProgressIndicator(),) : RefreshIndicator( /*тянем верхний край, список обновляется*/
          onRefresh: () => _refreshProducts(context),
          
          child: Consumer<ProductsProvider>(
            builder: (builderContext, productsData, _) => Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: productsData.items.length,
                  itemBuilder: (_, index) => Column(
                    children: [
                      UserProductItem(
                        id: productsData.items[index].id,
                          title: productsData.items[index].title,
                          imageUrl: productsData.items[index].imageUrl
                      ),
                      Divider(),
                    ],
                  ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


