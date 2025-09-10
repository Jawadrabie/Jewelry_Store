// lib/data/repositories/store_repository.dart
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
    final files = <MultipartFile>[];
    if (request.files.isNotEmpty) {
      for (final f in request.files) {
        files.add(
          await MultipartFile.fromFile(
            f.path,
            filename: f.path.split('/').last,
          ),
        );
      }
    } else if (request.file != null) {
      files.add(
        await MultipartFile.fromFile(
          request.file!.path,
          filename: request.file!.path.split('/').last,
        ),
      );
    }

    final form = FormData.fromMap({
      // Match backend field names exactly as required by Postman screenshot
      'ProductName': request.name,
      'Description': request.description,
      'ProductWeight': request.weight,
      'ProductPrice': request.price.toString(),
      // API expects a single file as 'ProductFile'
      if (files.isNotEmpty) 'ProductFile': files.first,
    });

    await _dio.post(
      '/review-requests',
      data: form,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  // Create order: backend requires several fields; send empty strings if missing.
  Future<Response> addOrder({
    required num totalAmount,
    required List<String> products,
    required String token,
    String userId = '1',
    String status = '',
    String shippingAddress = '',
    String paymentMethod = '',
    required String orderDate,
  }) async {
    return _dio.post(
      '/addorder',
      queryParameters: {
        'UserID': userId,
        'Status': status,
        'ShippingAddress': shippingAddress,
        'PaymentMethod': paymentMethod,
        'OrderDate': orderDate,
        'TotalAmount': totalAmount,
        'Products': products, // as array
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
