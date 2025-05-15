import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class StoreRepository {
  final String baseUrl = 'https://fakestoreapi.com';

  Future<List<String>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/products/categories'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception('فشل تحميل الأقسام');
    }
  }

  Future<List<ProductModel>> getAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception('فشل تحميل المنتجات');
    }
  }
}
