// lib/cubit/home/home_cubit.dart
import 'package:fake_store_app/cubit/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/store_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  final StoreRepository repository;

  HomeCubit(this.repository) : super(HomeLoading());

  Future<void> loadHomeData() async {
    try {
      emit(HomeLoading());
      final categories = await repository.getCategories();
      final products = await repository.getAllProducts();
      emit(HomeLoaded(categories: categories, products: products));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
