import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/orders.dart';
import 'package:shopping/providers/productlist.dart';
import 'package:shopping/widgets/appdrawer.dart';
import 'package:shopping/widgets/displayorders.dart';

class OrdersScreen extends StatelessWidget {
  static const routename = '/Orders-screen';
  @override
  Widget build(BuildContext context) {
    var orderData = Provider.of<Orders>(context, listen: false);
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text("ORDERS"),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              if (snapShot.error != null)
                return Center(
                  child: Text("Error Occured"),
                );
              else
                return ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, index) => DisplayOrders(index),
                );
            }
          },
        ));
  }
}
