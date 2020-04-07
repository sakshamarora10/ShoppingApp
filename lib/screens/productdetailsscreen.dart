import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/cart.dart';
import 'package:shopping/providers/productlist.dart';
import '../providers/productmodel.dart';

class ProductDetails extends StatelessWidget {
  static const routename = '/product-details';
  @override
  Widget build(BuildContext context) {
    var cartData = Provider.of<Cart>(context, listen: false);
    final String id = ModalRoute.of(context).settings.arguments;
    final Product product =
        Provider.of<ProductList>(context, listen: false).findByID(id);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("SHOP"),
      //   centerTitle: true,
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              centerTitle: true,
              background: Hero(
                  tag: product.id,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),),
          ),
          SliverList(delegate:SliverChildListDelegate(
            [
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  '\$${product.price.toString()}',
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(product.description,textAlign: TextAlign.center,),
              SizedBox(
                height: 10,
              ),
              SizedBox(height: 800,)//just to check scrolling feature
            ]
          ) )
        ],

      ),
    );
  }
}
