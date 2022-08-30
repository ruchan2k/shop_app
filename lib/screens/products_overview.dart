import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class PorductOverview extends StatefulWidget {
    static const routeName = '/product_overview';

  @override
  State<PorductOverview> createState() => _PorductOverviewState();
}

class _PorductOverviewState extends State<PorductOverview> {
  var _showFavorite = false;

  @override
  Widget build(BuildContext context) {
    final itemCount = Provider.of<Cart>(context).itemCount.toString();

    return Scaffold(
      drawer: AppDrawer(),
      body: ProductsGrid(_showFavorite),
      appBar: AppBar(
        title: const Text('Product Overview'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showFavorite = true;
                  } else {
                    _showFavorite = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favorities'),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(child: ch ?? Text(''), value: itemCount),
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
              icon: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
    );
  }
}
