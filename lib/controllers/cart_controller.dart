import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class CartController {
  static const String _cartKey = 'cart';
  
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;
  
  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalPrice => _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString(_cartKey);
    
    if (cartData != null) {
      List<dynamic> data = json.decode(cartData);
      _cartItems = data.map((json) => CartItem.fromJson(json)).toList();
    }
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = json.encode(_cartItems.map((item) => item.toJson()).toList());
    await prefs.setString(_cartKey, cartData);
  }

  Future<void> addToCart(Product product) async {
    final existingIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex != -1) {
      _cartItems[existingIndex].quantity++;
    } else {
      _cartItems.add(CartItem(product: product));
    }
    
    await _saveCart();
  }

  Future<void> removeFromCart(Product product) async {
    _cartItems.removeWhere((item) => item.product.id == product.id);
    await _saveCart();
  }

  Future<void> updateQuantity(Product product, int quantity) async {
    final existingIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex != -1) {
      if (quantity <= 0) {
        _cartItems.removeAt(existingIndex);
      } else {
        _cartItems[existingIndex].quantity = quantity;
      }
    }
    
    await _saveCart();
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    await _saveCart();
  }

  bool isInCart(Product product) {
    return _cartItems.any((item) => item.product.id == product.id);
  }

  int getProductQuantity(Product product) {
    final item = _cartItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    return item.quantity;
  }
}