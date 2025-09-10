// lib/presentation/screens/categories/category_products_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/home/home_cubit.dart';
import '../../../cubit/home/home_state.dart';
import '../../../data/models/category_model.dart';
import '../../widgets/products_grid.dart';

class CategoryProductsScreen extends StatelessWidget {
  final CategoryModel category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoaded) {
            // فلترة المنتجات من الكاش
            final categoryProducts = state.products
                .where((p) => p.categoryId == category.id)
                .toList();

            if (categoryProducts.isEmpty) {
              return const Center(child: Text("لا توجد منتجات في هذا القسم"));
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<HomeCubit>().refreshHomeData();
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  // 🟢 وصف القسم
                  if (category.description.isNotEmpty) ...[
                    Text(
                      category.description,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 🟢 المنتجات
                  ProductsGrid(products: categoryProducts),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
