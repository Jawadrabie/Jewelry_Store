import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/store_repository.dart';

part 'home_state.dart';

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
