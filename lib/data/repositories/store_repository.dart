// lib/data/repositories/store_repository.dart
import 'dart:io';
import 'package:dio/dio.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/product_upload_request.dart';

class StoreRepository {
  final Dio _dio;
  StoreRepository({Dio? dio})
    : _dio =
          dio ??
          Dio(BaseOptions(baseUrl: 'https://jawalry.mustafafares.com/api'));

  Future<List<CategoryModel>> getCategories() async {
    final response = await _dio.get('/categories');
    final data = response.data['data'] as List;
    return data.map((json) => CategoryModel.fromJson(json)).toList();
  }

  Future<List<ProductModel>> getAllProducts() async {
    final response = await _dio.get('/products');
    final data = response.data['data'] as List;
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  // Future<List<ProductModel>> fetchProductsByCategory(int categoryId) async {
  //   final all = await getAllProducts();
  //   return all.where((p) => p.categoryId == categoryId).toList();
  // }

  // Future<List<ProductModel>> getFeaturedProducts() async {
  //   final response = await _dio.get('/products');
  //   final data = response.data['data'] as List;
  //   return data
  //       .map((json) => ProductModel.fromJson(json))
  //       .where((p) => p.isFeatured)
  //       .toList();
  // }

  Future<void> addProduct({
    required ProductUploadRequest request,
    required String token,
  }) async {
    // API expects a single file only, so we take the first file
    File? fileToUpload;
    if (request.file != null) {
      fileToUpload = request.file;
    } else if (request.files.isNotEmpty) {
      fileToUpload = request.files.first;
    }

    MultipartFile? multipartFile;
    if (fileToUpload != null) {
      multipartFile = await MultipartFile.fromFile(
        fileToUpload.path,
        filename: fileToUpload.path.split('/').last,
      );
    }

    final form = FormData.fromMap({
      // Match backend field names exactly as required by Postman screenshot
      'ProductName': request.name,
      'Description': request.description,
      'ProductWeight': request.weight,
      'ProductPrice': request.price.toString(),
      // API expects a single file as 'ProductFile'
      if (multipartFile != null) 'ProductFile': multipartFile,
    });

    await _dio.post(
      '/review-requests',
      data: form,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  // Create order: API expects JSON body with specific structure
  Future<Response> addOrder({
    required List<Map<String, dynamic>> products,
    required String token,
  }) async {
    // Get current date in YYYY-MM-DD format
    final today = DateTime.now();
    final orderDate =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final orderData = {
      'UserID': 1,
      'OrderDate': orderDate,
      'Status': 'pending',
      'TotalAmount': products.fold<int>(
        0,
        (sum, product) => sum + ((product['PriceAtPurchase'] as num?)?.toInt() ?? 0),
      ),
      'ShippingAddress': 'syria',
      'PaymentMethod': 'pending',
      'Products': products
    };

    return _dio.post(
      '/addorder',
      data: orderData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
  }
}
