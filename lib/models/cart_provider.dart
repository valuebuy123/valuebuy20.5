import 'package:flutter/material.dart';
import 'package:valuebuyin/models/cart_item.dart';
import 'package:valuebuyin/pages/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice {
    return _items.fold(
      0,
      (sum, item) => sum + (item.product.price * item.weight),
    );
  }

  void addToCart(Product product) {
    final existingItem = _items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product),
    );

    if (_items.contains(existingItem)) {
      existingItem.weight++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateweight(String productId, int weight) {
    final item = _items.firstWhere((item) => item.product.id == productId);
    if (weight <= 0) {
      _items.remove(item);
    } else {
      item.weight = weight;
    }
    notifyListeners();
  }
}
