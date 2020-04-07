import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shopping/models/http_exceptions.dart';
import 'package:shopping/providers/productmodel.dart';
import 'package:http/http.dart' as http;

class ProductList with ChangeNotifier {
  final String _authToken;
  final String _userId;
  List<Product> products = [];
  List<Product> get productList {
    return [...products];
  }
  ProductList(this._authToken,this._userId,this.products);

  Future<void> fetchAndSetProducts([bool filter=false]) async {//arguments inside [] are optional
    var url;
    if(filter) url='https://shopapp-ae513.firebaseio.com/products.json?auth=$_authToken&orderBy="creatorId"&equalTo="$_userId"';
    else url='https://shopapp-ae513.firebaseio.com/products.json?auth=$_authToken';
    try {
      var response = await http.get(url);
      var extractedData = json.decode(response.body) as Map<String, dynamic>;
      url='https://shopapp-ae513.firebaseio.com/userfavourites/$_userId.json?auth=$_authToken';
      var favouriteResponse=await http.get(url);
      final favouriteData=json.decode(favouriteResponse.body);

      List<Product> prodList = [];
      extractedData.forEach((prodId, prod) {
        prodList.add(Product(
            id: prodId,
            description: prod['description'],
            imageUrl: prod['imageUrl'],
            price: prod['price'],
            isFavourite:favouriteData==null?false:favouriteData[prodId]??false,//?? means that if favouriteData[prodId] is also null then false would be returned
            title: prod['title']));
      });
      products = prodList;
    } catch (error) {
      throw error;
    }
  }

  Future<void> addNewProduct(Product product) async {
    final url = 'https://shopapp-ae513.firebaseio.com/products.json?auth=$_authToken';
    try {
      var response = await http.post(url,
          body: jsonEncode({
            'creatorId':_userId,
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          }));
      Product newProduct = Product(
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title,
        isFavourite: product.isFavourite,
        id: json.decode(response.body)['name'],
      );
      products.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> update(String id, Product product) async {
    final url = 'https://shopapp-ae513.firebaseio.com/products/$id.json?auth=$_authToken';

    try {
      int prodIndex = products.indexWhere((item) => item.id == id);
      var response = await http.patch(url,
          body: json.encode({
            'title': product.title,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'description': product.description
          }));
      print(response.statusCode);
      products[prodIndex] = product;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> removeProduct(String id) async {
    final url = 'https://shopapp-ae513.firebaseio.com/products/$id.json?auth=$_authToken';
    int prodIndex = products.indexWhere((item) => item.id == id);
    Product prod = products[prodIndex];
    products.removeWhere((prod) => prod.id == id);
    notifyListeners();
    try {
      var response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw HttpException('Could not delete product');
      }
    } catch (err) {
      products.insert(prodIndex, prod);
      notifyListeners();
      throw err;
    }
  }

  List<Product> get favouriteList {
    return productList.where((item) => item.isFavourite).toList();
  }

  Product findByID(String id) {
    return productList.firstWhere((item) => item.id == id);
  }
}
