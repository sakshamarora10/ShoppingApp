import 'package:flutter/material.dart';
import 'package:shopping/providers/auth.dart';
import 'package:shopping/providers/cart.dart';
import 'package:shopping/providers/orders.dart';
import 'package:shopping/providers/productmodel.dart';
import 'package:shopping/screens/auth_screen.dart';
import 'package:shopping/screens/cartscreen.dart';
import 'package:shopping/screens/editproductsscreen.dart';
import 'package:shopping/screens/loadingscreen.dart';
import 'package:shopping/screens/userproduct.dart';
import 'package:shopping/screens/ordersscreen.dart';
import 'package:shopping/screens/productdetailsscreen.dart';
import './providers/productlist.dart';
import './screens/productsgridscreen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx)=>Authenticate(),),
        ChangeNotifierProxyProvider<Authenticate,ProductList>(
          create: (ctx)=>ProductList(null,null,[]),
          update: (ctx,auth,previousProducts)=>ProductList(auth.getToken,auth.getUserId,previousProducts==null?[]:previousProducts.products),
        ),
         ChangeNotifierProxyProvider<Authenticate,Orders>(
          create: (ctx)=>Orders(null,[],null),
          update: (ctx,auth,previousOrders)=>Orders(auth.getToken,previousOrders==null?[]:previousOrders.orders,auth.getUserId),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
      ],
      child:Consumer<Authenticate>(
        builder: (ctx,auth,child)=>MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.orange,
          fontFamily: 'Lato',
          canvasColor: Colors.grey[200],
        ),
        home:auth.getToken!=null?ProductsScreen():FutureBuilder(
        future: auth.tryAutoLogin(),
        builder: (ctx,snapshot)=>(snapshot.connectionState==ConnectionState.waiting)?Loading(): AuthScreen()
        ),
        routes: {
          ProductsScreen.routename:(ctx)=>ProductsScreen(),
          ProductDetails.routename: (ctx) => ProductDetails(),
          CartScreen.routename:(ctx)=>CartScreen(),
          OrdersScreen.routename:(ctx)=>OrdersScreen(),
          UserProducts.routename:(ctx)=>UserProducts(),
          EditProducts.routename:(ctx)=>EditProducts(),
          AuthScreen.routeName:(ctx)=>AuthScreen(),

        },
      ),
      )
    );
  }
}
