// lib/cubit/home/home_state.dart

import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CategoryModel> categories;
  final List<ProductModel> products;
  final List<ProductModel> featuredProducts;

  HomeLoaded({
    required this.categories,
    required this.products,
    required this.featuredProducts,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
