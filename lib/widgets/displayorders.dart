import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/cart.dart';
import 'package:shopping/providers/orders.dart';
import 'package:intl/intl.dart';

class DisplayOrders extends StatefulWidget {
  final int index;
  DisplayOrders(this.index);

  @override
  _DisplayOrdersState createState() => _DisplayOrdersState();
}

class _DisplayOrdersState extends State<DisplayOrders> {
  bool showDetails = false;
  @override
  Widget build(BuildContext context) {
    var orderData = Provider.of<Orders>(context, listen: false);
    var cartData = Provider.of<Cart>(context, listen: false);
    return Card(
        elevation: 5,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                child: Text('${widget.index + 1}'),
              ),
              title: Text(
                  '\$${orderData.orders[widget.index].amount.toStringAsFixed(2)}'),
              subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                  .format(orderData.orders[widget.index].date)),
              trailing: IconButton(
                  icon: Icon(showDetails
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up),
                  onPressed: () {
                    setState(() {
                      showDetails = !showDetails;
                    });
                  }),
            ),
            if (showDetails)
              Container(
                height: min(orderData.orders[widget.index].orderDetails.length * 80.0, 240) ,
                child: ListView.builder(
                  itemCount:
                      orderData.orders[widget.index].orderDetails.length,
                  itemBuilder: (ctx, i) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.arrow_forward_ios),
                        ),
                        title: Text(orderData.orders[widget.index].orderDetails[i].title),
                        subtitle: Text(orderData.orders[widget.index].orderDetails[i].price.toString()),
                        trailing: Text("${orderData.orders[widget.index].orderDetails[i].quantity}x"),
                      )
                    );
                  },
                ),
              ),
          ],
        ));
  }
}
