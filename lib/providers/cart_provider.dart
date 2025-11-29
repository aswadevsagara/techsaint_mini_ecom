import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../controllers/cart_controller.dart';

class CartProvider with ChangeNotifier {
  final CartController _cartController = CartController();
  
  List<CartItem> get cartItems => _cartController.cartItems;
  int get totalItems => _cartController.totalItems;
  double get totalPrice => _cartController.totalPrice;

  Future<void> loadCart() async {
    await _cartController.loadCart();
    notifyListeners();
  }

  Future<void> addToCart(Product product) async {
    await _cartController.addToCart(product);
    notifyListeners();
  }

  Future<void> removeFromCart(Product product) async {
    await _cartController.removeFromCart(product);
    notifyListeners();
  }

  Future<void> updateQuantity(Product product, int quantity) async {
    await _cartController.updateQuantity(product, quantity);
    notifyListeners();
  }

  Future<void> clearCart() async {
    await _cartController.clearCart();
    notifyListeners();
  }

  bool isInCart(Product product) {
    return _cartController.isInCart(product);
  }

  int getProductQuantity(Product product) {
    return _cartController.getProductQuantity(product);
  }
}