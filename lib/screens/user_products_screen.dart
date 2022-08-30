import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    final items = products.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                    EditProductScreen.routeName,
                  ),
              icon: const Icon(Icons.add)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView.builder(
          itemCount: products.items.length,
          itemBuilder: (context, i) =>
              UserProductItem(items[i].id, items[i].title, items[i].imageUrl),
        ),
      ),
    );
  }
}
