import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/cart.dart';
import 'package:shopping/providers/orders.dart';
import 'package:shopping/screens/ordersscreen.dart';
import 'package:shopping/widgets/displaycartitems.dart';

class CartScreen extends StatelessWidget {
  static const routename = '/cartscreen';
  @override
  Widget build(BuildContext context) {
    var cartData = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(("Your Cart").toUpperCase()),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white, Colors.blue[400].withOpacity(0.5)]),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label:
                        Text("\$${(cartData.totalAmount).toStringAsFixed(2)}"),
                  ),
                  OrderButton(cartData: cartData)
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cartData.count,
                itemBuilder: (ctx, index) => DisplayCartItems(
                  productId: cartData.items.keys.toList()[index],
                  id: cartData.items.values.toList()[index].id,
                  price: cartData.items.values.toList()[index].price,
                  title: cartData.items.values.toList()[index].title,
                  quantity: cartData.items.values.toList()[index].quantity,
                ),
              ),
            )
          ],
        ));
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartData,
  }) : super(key: key);

  final Cart cartData;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: isLoading?CircularProgressIndicator(): Text("ORDER NOW"),
      onPressed: (widget.cartData.totalAmount <= 0||isLoading==true)
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              if (widget.cartData.items.values.toList().length != 0) {
                try{
                  await Provider.of<Orders>(context, listen: false).add(
                    widget.cartData.items.values.toList(),
                    (widget.cartData.totalAmount));
                    
                setState(() {
                  isLoading = false;
                });
                widget.cartData.removeCart();
                }
                catch(err){
                  //...
                }
              }
            },
    );
  }
}
