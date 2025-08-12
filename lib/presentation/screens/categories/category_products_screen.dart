// lib/presentation/screens/categories/category_products_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/home/home_cubit.dart';
import '../../../cubit/home/home_state.dart';
import '../../../data/models/category_model.dart';
import '../product_details/product_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: categoryProducts.length,
                    itemBuilder: (context, index) {
                      final p = categoryProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsScreen(product: p),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: CachedNetworkImage(
                                  imageUrl: p.productFile,
                                  placeholder: (_, __) =>
                                  const CircularProgressIndicator(strokeWidth: 2),
                                  errorWidget: (_, __, ___) =>
                                  const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                p.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '\$${p.price}',
                                style: const TextStyle(color: Colors.teal),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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
