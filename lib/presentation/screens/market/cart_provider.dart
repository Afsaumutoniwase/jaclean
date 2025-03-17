import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, String>> _cartItems = [];

  List<Map<String, String>> get cartItems => _cartItems;

  void addItem(String image, String name, String price) {
    _cartItems.add({'image': image, 'name': name, 'price': price});
    notifyListeners();
  }

  void removeItem(String name) {
    final index = _cartItems.indexWhere((item) => item['name'] == name);
    if (index != -1) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  bool isInCart(String name) {
    return _cartItems.any((item) => item['name'] == name);
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}