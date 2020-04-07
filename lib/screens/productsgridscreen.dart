import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/cart.dart';
import 'package:shopping/providers/productlist.dart';
import 'package:shopping/screens/cartscreen.dart';
import 'package:shopping/widgets/appdrawer.dart';
import 'package:shopping/widgets/badge.dart';
import 'package:shopping/widgets/productgriddisplay.dart';

class ProductsScreen extends StatefulWidget {
  static const routename = '/productsScreen';
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool init=true;
  bool isLoading=false;
  final scaffoldKey=GlobalKey<ScaffoldState>();//this is used to remove the snackbar
  @override
  void didChangeDependencies() {
    if(init){
      setState(() {
        isLoading=true;
      });
      Provider.of<ProductList>(context).fetchAndSetProducts().then((_){
        setState(() {
          isLoading=false;
        });
      });
    }
    init=false;
    super.didChangeDependencies();
  }
  bool showFavs = false;
  
  @override
  Widget build(BuildContext context) {
    var cartData = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("SHOP"),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text("All"),
                value: 0,
              ),
              PopupMenuItem(
                child: Text("Favourites"),
                value: 1,
              )
            ],
            icon: Icon(Icons.more_vert),
            onSelected: (int value) {
              setState(() {
                if (value == 1) {
                  showFavs = true;
                } else {
                  showFavs = false;
                }
              });
            },
          ),
          Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                    child: ch,
                    value: cartData.count.toString(),
                  ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  scaffoldKey.currentState.removeCurrentSnackBar();
                  Navigator.of(context).pushNamed(CartScreen.routename);
                },
              ))
        ],
      ),
      body: isLoading?Center(child: CircularProgressIndicator(),): ShowGrid(showFavs),
    );
  }
}
