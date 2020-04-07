import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/cart.dart';

class DisplayCartItems extends StatelessWidget {
  final double price;
  final String title;
  final int quantity;
  final String id;
  final String productId;
  DisplayCartItems({
    this.id,
    this.quantity,
    this.price,
    this.title,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Consumer<Cart>(
        builder: (_,cartData,child)=>Dismissible(
          confirmDismiss: (_){
            return showDialog(
              context: context,
              builder: (ctx){
                return AlertDialog(
                  title: Text("Are You Sure"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("YES"),
                      onPressed: (){
                        Navigator.of(ctx).pop(true);
                      },
                    ),
                     FlatButton(
                      child: Text("NO"),
                      onPressed: (){
                        Navigator.of(ctx).pop(false);
                      },
                    )
                  ],
                );
              }
            );
          },
          key: ValueKey(id),
          background: Container(
            margin: EdgeInsets.all(4),//to match the default margin of card ie 4
            padding: EdgeInsets.only(right: 20),
            alignment: Alignment.centerRight,
            color: Theme.of(context).errorColor,
            child: Icon(Icons.delete,size: 50,color: Colors.white,),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction){
            cartData.removeItem(productId);
          },
          child: child,
        ),
        child: Card(
            elevation: 5,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 30,
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: FittedBox(
                        child: Text(
                      '\$${price.toString()}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ))),
              ),
              title: Text(title),
              subtitle: Text("Total:${(price * quantity).toStringAsFixed(2)}"),
              trailing: Text("$quantity x"),
            ),
          ),
      ),
    );
  }
}
