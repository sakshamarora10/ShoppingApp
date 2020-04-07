import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/productlist.dart';
import 'package:shopping/screens/editproductsscreen.dart';
import 'package:shopping/widgets/appdrawer.dart';
import 'package:shopping/widgets/userproductsdisplay.dart';

class UserProducts extends StatelessWidget {
  Future<void> refreshScreen(BuildContext context) async {
    await Provider.of<ProductList>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  static const routename = '/userproducts';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("YOUR PRODUCTS"),
        centerTitle: true,
        elevation: 10,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProducts.routename);
              })
        ],
      ),
      body: FutureBuilder(
        future: refreshScreen(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      return refreshScreen(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Consumer<ProductList>(
                        builder: (ctx,productData,_)=>ListView.builder(
                          itemBuilder: (ctx, index) {
                            return UserProductsDisplay(
                              imageUrl: productData.productList[index].imageUrl,
                              title: productData.productList[index].title,
                              price: productData.productList[index].price,
                              id: productData.productList[index].id,
                            );
                          },
                          itemCount: productData.productList.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
