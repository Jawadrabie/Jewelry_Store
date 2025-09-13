import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/home/home_cubit.dart';
import '../../../cubit/home/home_state.dart';
import '../../widgets/products_grid.dart';
import '../../widgets/sort_utils.dart';

class FeaturedProductsScreen extends StatefulWidget {
  const FeaturedProductsScreen({super.key});

  @override
  State<FeaturedProductsScreen> createState() => _FeaturedProductsScreenState();
}

class _FeaturedProductsScreenState extends State<FeaturedProductsScreen> {
  final ProductSortState _sort = ProductSortState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المنتجات المميزة'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryColor == Colors.white
            ? Colors.black
            : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (ctx) {
                  return StatefulBuilder(
                    builder: (context, setModalState) {
                      return SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CheckboxListTile(
                                value: _sort.sortByWeight,
                                onChanged: (v) => setModalState(
                                  () => _sort.sortByWeight = v ?? false,
                                ),
                                title: const Text('الوزن (من الأصغر للأكبر)'),
                              ),
                              CheckboxListTile(
                                value: _sort.sortByPrice,
                                onChanged: (v) => setModalState(
                                  () => _sort.sortByPrice = v ?? false,
                                ),
                                title: const Text('السعر (من الأصغر للأكبر)'),
                              ),
                              CheckboxListTile(
                                value: _sort.sortByKarat,
                                onChanged: (v) => setModalState(
                                  () => _sort.sortByKarat = v ?? false,
                                ),
                                title: const Text('العيار (من الأصغر للأكبر)'),
                              ),
                              CheckboxListTile(
                                value: _sort.sortBySmithing,
                                onChanged: (v) => setModalState(
                                  () => _sort.sortBySmithing = v ?? false,
                                ),
                                title: const Text(
                                  'قيمة الصياغة% (من الأصغر للأكبر)',
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('تم'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeLoaded) {
            final products = buildSortedProducts(state.featuredProducts, _sort);

            if (products.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_outline, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'لا توجد منتجات مميزة حالياً',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ProductsGrid(products: products, scrollable: true);
          }

          return const Center(child: Text('خطأ في تحميل البيانات'));
        },
      ),
    );
  }
}
