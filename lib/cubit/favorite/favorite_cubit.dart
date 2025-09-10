import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/product_model.dart';
class FavoriteCubit extends Cubit<List<ProductModel>> {
  FavoriteCubit() : super([]);

  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList('favorites') ?? [];
      final list = jsonList
          .map((str) => ProductModel.fromJson(json.decode(str)))
          .toList();
      emit(list);
      print('Favorites loaded: ${list.length} items');
    } catch (e) {
      print('Error loading favorites: $e');
      emit([]);
    }
  }

  Future<void> toggle(ProductModel product) async {
    final current = List<ProductModel>.from(state);
    final exists = current.any((p) => p.productId == product.productId);

    if (exists) {
      current.removeWhere((p) => p.productId == product.productId);
    } else {
      current.add(product);
    }

    emit(current);
    await _saveToPrefs(current);
  }

  Future<void> _saveToPrefs(List<ProductModel> list) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = list.map((p) => json.encode(p.toJson())).toList();
      await prefs.setStringList('favorites', jsonList);
      print('Favorites saved: ${list.length} items');
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  Future<void> remove(ProductModel product) async {
    final current = List<ProductModel>.from(state)
      ..removeWhere((p) => p.productId == product.productId);
    emit(current);
    await _saveToPrefs(current);
  }

}
