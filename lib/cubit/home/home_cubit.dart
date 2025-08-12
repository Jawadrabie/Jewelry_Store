// lib/cubit/home/home_cubit.dart

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/store_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final StoreRepository repository;

  HomeCubit(this.repository) : super(HomeLoading()) {
    _loadCacheThenRefresh(); // نحمل الكاش ثم نحدث من السيرفر
  }

  Future<void> _loadCacheThenRefresh() async {
    final prefs = await SharedPreferences.getInstance();
    final catsJson = prefs.getString('cached_cats');
    final prodsJson = prefs.getString('cached_prods');

    if (catsJson != null && prodsJson != null) {
      final cList = json.decode(catsJson) as List;
      final pList = json.decode(prodsJson) as List;

      final catsCache = cList.map((e) => CategoryModel.fromJson(e)).toList();
     final prodsCache = pList.map((e) => ProductModel.fromJson(e)).toList();
      final featured = prodsCache.where((e) => e.isFeatured).toList();

      // نعرض الكاش مباشرة
      emit(HomeLoaded(categories: catsCache, products: prodsCache, featuredProducts: featured));
    }

    // ثم نحدّث البيانات من السيرفر دون أن نخفي البيانات القديمة
    try {
      final cats = await repository.getCategories();
      final prods = await repository.getAllProducts();
      final featured = prods.where((e) => e.isFeatured).toList();

    //  final prefs = await SharedPreferences.getInstance();
      prefs.setString('cached_cats', json.encode(cats.map((e) => e.toJson()).toList()));
      prefs.setString('cached_prods', json.encode(prods.map((e) => e.toJson()).toList()));

      emit(HomeLoaded(categories: cats, products: prods,featuredProducts: featured));
    } catch (e,st) {
      // إذا كان هناك كاش، لا نظهر خطأ
      if (state is! HomeLoaded) {
        print('HomeCubit.loadData failed: $e\n$st');
        emit(HomeError('فشل تحميل البيانات'));
      }
    }
  }

  /// عند السحب للتحديث
  Future<void> refreshHomeData() async {
    try {
      final cats = await repository.getCategories();
      final prods = await repository.getAllProducts();
      final featured = prods.where((e) => e.isFeatured).toList();

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('cached_cats', json.encode(cats.map((e) => e.toJson()).toList()));
      prefs.setString('cached_prods', json.encode(prods.map((e) => e.toJson()).toList()));

      emit(HomeLoaded(categories: cats, products: prods, featuredProducts: featured));
    } catch (e) {
      // لا نغيّر الحالة، فقط نطبع الخطأ
      print('فشل التحديث: $e');
    }
  }
}
