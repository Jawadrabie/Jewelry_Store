import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/product_model.dart';
import 'package:http/http.dart' as http;

class CartCubit extends Cubit<List<ProductModel>> {
  CartCubit() : super([]);

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('cart') ?? [];
    final cart = jsonList
        .map((str) => ProductModel.fromJson(json.decode(str)))
        .toList();
    emit(cart);
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
    await _syncWithServer(product, exists ? 'remove' : 'add');
  }

  Future<void> remove(ProductModel product) async {
    final updated = List<ProductModel>.from(state)
      ..removeWhere((p) => p.productId == product.productId);
    emit(updated);
    await _saveToPrefs(updated);
    await _syncWithServer(product, 'remove');
  }


  Future<void> _saveToPrefs(List<ProductModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((p) => json.encode(p.toJson())).toList();
    await prefs.setStringList('cart', jsonList);
  }


  Future<void> _syncWithServer(ProductModel product, String action) async {
    final endpoint = action == 'add' ? 'addorder' : 'removeorder';
    final url = Uri.parse('https://jewelrystore-production.up.railway.app/api/$endpoint');
    final resp = await http.post(url, body: {
      'ProductID': product.productId.toString(),
    });
    if (resp.statusCode != 200) {
      // هنا يمكنك أخذ إجراء أو تقرير الخطأ
      print('خطأ مزامنة السلة: ${resp.statusCode}');
    }
  }
}
