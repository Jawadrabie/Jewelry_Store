import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/product_model.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/repositories/store_repository.dart';

class CartCubit extends Cubit<List<CartItemModel>> {
  final StoreRepository _repo = StoreRepository();
  CartCubit() : super([]);

  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList('cart') ?? [];
      final cart = jsonList
          .map((str) => CartItemModel.fromJson(json.decode(str)))
          .toList();
      emit(cart);
      print('Cart loaded: ${cart.length} items');
    } catch (e) {
      print('Error loading cart: $e');
      emit([]);
    }
  }

  Future<void> toggle(ProductModel product) async {
    final current = List<CartItemModel>.from(state);
    final existingIndex = current.indexWhere(
      (item) => item.product.productId == product.productId,
    );

    if (existingIndex != -1) {
      current.removeAt(existingIndex);
    } else {
      current.add(CartItemModel(product: product, quantity: 1));
    }

    emit(current);
    await _saveToPrefs(current);
  }

  Future<void> remove(CartItemModel item) async {
    final updated = List<CartItemModel>.from(state)
      ..removeWhere(
        (cartItem) => cartItem.product.productId == item.product.productId,
      );
    emit(updated);
    await _saveToPrefs(updated);
  }

  Future<void> updateQuantity(CartItemModel item, int newQuantity) async {
    if (newQuantity <= 0) {
      await remove(item);
      return;
    }

    final current = List<CartItemModel>.from(state);
    final index = current.indexWhere(
      (cartItem) => cartItem.product.productId == item.product.productId,
    );

    if (index != -1) {
      current[index] = item.copyWith(quantity: newQuantity);
      emit(current);
      await _saveToPrefs(current);
    }
  }

  Future<void> _saveToPrefs(List<CartItemModel> list) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = list.map((item) => json.encode(item.toJson())).toList();
      await prefs.setStringList('cart', jsonList);
      print('Cart saved: ${list.length} items');
    } catch (e) {
      print('Error saving cart: $e');
    }
  }

  // Create order using token; builds TotalAmount and Products from current cart
  Future<Response?> checkout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null || token.isEmpty) {
        throw Exception('AUTH_REQUIRED');
      }

      // Total amount according to current pricing rules on UI
      final goldSubtotal = state.fold<double>(
        0,
        (sum, item) => sum + item.totalPrice,
      );
      final smithingTotal = state.fold<double>(
        0,
        (sum, item) => sum + item.totalSmithingCost,
      );
      final totalWeight = state.fold<double>(
        0,
        (sum, item) => sum + item.totalWeight,
      );

      double discount = 0.0;
      if (totalWeight >= 60.0) {
        discount = goldSubtotal * 0.15;
      } else if (totalWeight >= 40.0) {
        discount = goldSubtotal * 0.12;
      } else if (totalWeight >= 30.0) {
        discount = goldSubtotal * 0.10;
      }

      final grandTotal = goldSubtotal + smithingTotal - discount;

      // Products param: send as array of "id:qty"
      final productsArray = state
          .map((e) => '${e.product.productId}:${e.quantity}')
          .toList();

      // Debug prints
      final today = DateTime.now();
      final orderDate =
          '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      print(
        '[CHECKOUT] products=${productsArray.toString()} total=$grandTotal',
      );

      final res = await _repo.addOrder(
        totalAmount: grandTotal,
        products: productsArray,
        token: token,
        userId: '',
        status: '',
        shippingAddress: '',
        paymentMethod: '',
        orderDate: orderDate,
      );

      // Clear cart on success if backend returns 200
      if (res.statusCode == 200) {
        emit([]);
        await _saveToPrefs([]);
      }
      print('[CHECKOUT][SUCCESS] ${res.data}');
      return res;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      final msg =
          (data is Map && (data['message'] != null || data['msg'] != null))
          ? (data['message'] ?? data['msg']).toString()
          : e.message ?? 'Request failed';
      print('[CHECKOUT][ERROR][$status] $msg data=$data');
      throw Exception(msg);
    } catch (e) {
      print('[CHECKOUT][ERROR] $e');
      rethrow;
    }
  }
}
