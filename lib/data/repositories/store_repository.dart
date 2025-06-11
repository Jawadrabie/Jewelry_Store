import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/product_model.dart';

class StoreRepository {
  static const String baseUrl = 'https://jewelrystore-production.up.railway.app/api';

  Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } else {
      throw Exception('فشل تحميل الأقسام');
    }
  }

  Future<List<ProductModel>> getAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('فشل تحميل جميع المنتجات');
    }
  }

  Future<List<ProductModel>> fetchProductsByCategory(int categoryId) async {
    final response = await http.get(Uri.parse('$baseUrl/products/category/$categoryId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('فشل تحميل منتجات القسم $categoryId (Status: ${response.statusCode})');
    }
  }
}
