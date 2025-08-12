// lib/data/repositories/store_repository.dart
import 'package:dio/dio.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/product_upload_request.dart';

class StoreRepository {
  final Dio _dio;
  StoreRepository({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: 'https://jawalry.mustafafares.com/api'));

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
    final form = FormData.fromMap({
      'name': request.name,
      'price': request.price.toString(),
      'description': request.description,
      'weight': request.weight,
      'file': await MultipartFile.fromFile(
        request.file.path,
        filename: request.file.path.split('/').last,
      ),
    });

    await _dio.post(
      '/review-requests',
      data: form,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
