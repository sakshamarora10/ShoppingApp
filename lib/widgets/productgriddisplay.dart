import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/productlist.dart';
import 'package:shopping/providers/productmodel.dart';
import '../widgets/productgriddetail.dart';

class ShowGrid extends StatelessWidget {
  final bool showFavs;
  ShowGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductList>(context);
    final products = showFavs?productData.favouriteList:productData.productList;
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      itemCount: products.length,
      itemBuilder: (ctx, i) {
        return ChangeNotifierProvider<Product>.value(
          value: products[i],
          child: ProductGridDetails(),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 6 / 7,
      ),
    );
  }
}
