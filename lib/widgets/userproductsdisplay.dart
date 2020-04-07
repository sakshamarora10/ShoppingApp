import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/productlist.dart';
import 'package:shopping/screens/editproductsscreen.dart';
class UserProductsDisplay extends StatelessWidget {
 
  final String imageUrl;
  final String title;
  final double price;
  final String id;
  UserProductsDisplay({
    this.title,
    this.price,
    this.imageUrl,
    this.id,
  });
  @override
  Widget build(BuildContext context) {
    final scaffold=Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl)
      ),
      title: Text(title),
      subtitle: Text('\$${price.toString()}'),
      trailing: Container(
        width: 100,
              child: Row(
          children: <Widget>[
            IconButton(icon: Icon(
              Icons.edit,
              color: Colors.purple,),
            onPressed: (){
              Navigator.of(context).pushNamed(EditProducts.routename,arguments:id );
            },),
            IconButton(icon: Icon(Icons.delete,color: Colors.red,),
            onPressed: () async{
              try{
              await Provider.of<ProductList>(context).removeProduct(id);
              }
              catch(err){
                scaffold.showSnackBar(SnackBar(
                  duration: Duration(
                    seconds: 1,
                  ),
                  content: Text("Could not delete product"),
                ));
              }
            },
             ) ],
        ),
      ),
    );
  }
}