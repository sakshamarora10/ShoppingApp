import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shopping/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final DateTime date;
  final List<CartItem> orderDetails;
  OrderItem({
    this.id,
    this.amount,
    this.date,
    this.orderDetails,
  });
}

class Orders with ChangeNotifier {
  final String _token;
  final String _userId;
  List<OrderItem> _orders = [];
  Orders(this._token,this._orders,this._userId);
  List<OrderItem> get orders {
    return [..._orders];
  }
  Future<void> fetchAndSetOrders ()async{
     final url = 'https://shopapp-ae513.firebaseio.com/orders/$_userId.json?auth=$_token';
    try{
       List<OrderItem> extractedOrders=[];
     final response= await http.get(url);
     final extractedData=json.decode(response.body) as Map<String,dynamic>;
     if(extractedData==null) return;//to cancel the implementation of further code
     extractedData.forEach((orderId,orderData){
       extractedOrders.add(OrderItem(
         id: orderId,
         amount: orderData['amount'],
         date: DateTime.parse(orderData['date']),
         orderDetails: (orderData['orderDetails'] as List).map((item){
          return CartItem(
            id: item['id'],
            price: item['price'],
            quantity: item['quantity'],
            title: item['title'],
          );
         }).toList(),
       ));
     });
     _orders=extractedOrders;
     notifyListeners();
    }
    catch(err){
      throw err;
    }
  }

  Future<void> add(List<CartItem> items, double amount) async {
    final url = 'https://shopapp-ae513.firebaseio.com/orders/$_userId.json?auth=$_token';
    final timestamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': amount,
            'date': timestamp.toIso8601String(),
            'orderDetails': items
                .map((cartItem) => {
                      'id': cartItem.id,
                      'price': cartItem.price,
                      'quantity': cartItem.quantity,
                      'title': cartItem.title,
                    })
                .toList(),
          }));
      _orders.insert(
          0,
          OrderItem(
            amount: amount,
            date: timestamp,
            id: json.decode(response.body)['name'],
            orderDetails: items,
          ));
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
