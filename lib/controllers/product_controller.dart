import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductController {
  static const String baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJsonForAdd()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      // The API returns the created product with a new ID
      return Product.fromJson(responseData);
    } else {
      throw Exception('Failed to add product. Status code: ${response.statusCode}');
    }
  }

  Future<bool> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/products/$id'));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete product');
    }
  }
}