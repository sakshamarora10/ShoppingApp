import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/auth.dart';
import 'package:shopping/screens/userproduct.dart';
import 'package:shopping/screens/ordersscreen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text("HELLO  USER..."),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: FlatButton(
              child: Text('Home'),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.toc),
            title: FlatButton(
              child: Text('Orders'),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routename);
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.mode_edit),
            title: FlatButton(
              child: Text('Manage Products'),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProducts.routename);
              },
            ),
          ),
          Divider(),
          RaisedButton(
            child: Text("LOGOUT",style: TextStyle(color: Colors.white),),
            color: Theme.of(context).primaryColor,
            onPressed: (){
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Authenticate>(context,listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}
