import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../controllers/product_controller.dart';

class ProductProvider with ChangeNotifier {
  final ProductController _productController = ProductController();
  
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _sortBy = 'name';
  String _selectedCategory = 'all';

  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _products;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  List<String> get categories {
    Set<String> categories = _products.map((p) => p.category).toSet();
    return ['all', ...categories.toList()];
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _productController.fetchProducts();
      _applyFilters();
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final newProduct = await _productController.addProduct(product);
      _products.add(newProduct);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      print('Error adding product: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _productController.deleteProduct(id);
      _products.removeWhere((product) => product.id == id);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }

  void searchProducts(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  void sortProducts(String sortBy) {
    _sortBy = sortBy;
    _applyFilters();
    notifyListeners();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      final matchesSearch = product.title.toLowerCase().contains(_searchQuery) ||
          product.description.toLowerCase().contains(_searchQuery);
      final matchesCategory = _selectedCategory == 'all' || 
          product.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    _filteredProducts.sort((a, b) {
      switch (_sortBy) {
        case 'price_low':
          return a.price.compareTo(b.price);
        case 'price_high':
          return b.price.compareTo(a.price);
        case 'rating':
          return b.rating.rate.compareTo(a.rating.rate);
        case 'name':
        default:
          return a.title.compareTo(b.title);
      }
    });
  }
}