import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavourite;
  Product({
    this.description,
    this.id,
    this.imageUrl,
    this.isFavourite=false,
    this.price,
    this.title,
  });
  Future<void> toggleIsFavourite (String token,String userId) async {
    var originalValue=isFavourite;
    isFavourite=!isFavourite;
    notifyListeners();
    try{
      final url = 'https://shopapp-ae513.firebaseio.com/userfavourites/$userId/$id.json?auth=$token';
     var response= await http.put(url,body: json.encode(
       isFavourite
     ));
    if(response.statusCode>=400){
      isFavourite=originalValue;
      notifyListeners();
    }
    }
    catch(err){
      isFavourite=originalValue;
      notifyListeners();
    }
  }
}