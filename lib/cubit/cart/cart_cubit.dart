import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/product_model.dart';

class CartCubit extends Cubit<List<ProductModel>> {
  CartCubit() : super([]);

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('cart') ?? [];
    final cart =
    jsonList.map((e) => ProductModel.fromJson(json.decode(e))).toList();
    emit(cart);
  }

  Future<void> toggle(ProductModel product) async {
    final current = [...state];
    final exists = current.any((e) => e.id == product.id);

    if (exists) {
      current.removeWhere((e) => e.id == product.id);
    } else {
      current.add(product);
    }

    emit(current);
    await _save(current);
  }

  Future<void> _save(List<ProductModel> products) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList =
    products.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('cart', jsonList);
  }

  Future<void> remove(ProductModel product) async {
    final updated = [...state]..removeWhere((e) => e.id == product.id);
    emit(updated);
    await _save(updated);
  }
}
