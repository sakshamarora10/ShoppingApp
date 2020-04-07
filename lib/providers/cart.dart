import 'package:flutter/widgets.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  CartItem({this.id, this.price, this.quantity, this.title});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }
  void removeItem(String key){
    _items.remove(key);
    notifyListeners();
  }
  void removeCart(){
    _items={};
    notifyListeners();
  }
  void removeSingleItem(String key){
    if(!_items.containsKey(key))return;
    if(_items[key].quantity>1) {
      _items.update(key, (prevData){
        return CartItem(
          id: prevData.id,
          price: prevData.price,
          quantity: prevData.quantity-1,
          title: prevData.title,
        );
      });
    }
    else _items.remove(key);
    notifyListeners();
  }

  int get count {
    return _items.length;
  }
  double get totalAmount{
    double total=0;
    items.forEach((key,value){
      total+= value.price*value.quantity;
    });
    return total;
  }

  void addItems(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingItem) => CartItem(
                id: existingItem.id,
                price: existingItem.price,
                quantity: existingItem.quantity + 1,
                title: existingItem.title,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                price: price,
                quantity: 1,
                title: title,
              ));
    }
      notifyListeners();
  }

}
