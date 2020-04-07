import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/auth.dart';
import 'package:shopping/providers/cart.dart';
import 'package:shopping/providers/productmodel.dart';
import 'package:shopping/screens/productdetailsscreen.dart';

class ProductGridDetails extends StatelessWidget {
  // final String title;
  // final double price;
  // final String imageUrl;
  // ProductGridDetails({this.price, this.imageUrl, this.title});
  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context, listen: true);
    final Authenticate authData=Provider.of<Authenticate>(context,listen: false);
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProductDetails.routename, arguments: product.id);
            },
            child: Hero(
              tag: product.id,
                          child: FadeInImage(
                placeholder: AssetImage('assets/images/Loading_image.png'),

                            image: NetworkImage(
                  product.imageUrl,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          header: GridTileBar(
            backgroundColor: Colors.black54,
            leading: Icon(Icons.attach_money),
            title: Text("${product.price}"),
          ),
          footer: GridTileBar(
            title: Text(
              product.title,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black54,
            leading: Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: product.isFavourite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  product.toggleIsFavourite(authData.getToken,authData.getUserId);
                },
              ),
            ),
            trailing: Consumer<Cart>(
              builder: (ctx, cart, chd) => IconButton(
                icon: chd,
                onPressed: () {
                  cart.addItems(product.id, product.price, product.title);
                  Scaffold.of(ctx).removeCurrentSnackBar();
                  Scaffold.of(ctx).showSnackBar( SnackBar(
                    content: Text("Added to the cart"),
                    duration: Duration(seconds: 1),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: (){
                        cart.removeSingleItem(product.id);
                      },
                    ),
                    behavior: SnackBarBehavior.floating,
                  ));
                },
              ),
              child: Icon(Icons.shopping_cart),
            ),
          ),
        ),
      ),
    );
  }
}
