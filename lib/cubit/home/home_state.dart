// lib/presentation/cubit/home/home_state.dart


import 'package:fake_store_app/data/models/product_model.dart';
import '../../data/models/category_model.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CategoryModel> categories;
  final List<ProductModel> products;

  HomeLoaded({
    required this.categories,
    required this.products,
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

