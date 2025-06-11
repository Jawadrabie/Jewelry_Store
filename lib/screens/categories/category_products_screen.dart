// lib/presentation/screens/category_products/category_products_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../data/repositories/store_repository.dart';
import '../product_details/product_details_screen.dart';

class CategoryProductsScreen extends StatelessWidget {
  final CategoryModel category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
   // final storeRepository = StoreRepository();
    final repo = RepositoryProvider.of<StoreRepository>(context);

      return Scaffold(
      appBar: AppBar(title: Text('منتجات ${category.name}')),
      body: FutureBuilder<List<ProductModel>>(
      //  future: storeRepository.fetchProductsByCategory(category.id!),
        future: repo.fetchProductsByCategory(category.id),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد منتجات في هذا القسم.'));
          }

          final products = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsScreen(product: product),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
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
                          imageUrl: product.productFile,
                          fit: BoxFit.contain,
                          placeholder: (_, __) => const CircularProgressIndicator(),
                          errorWidget: (_, __, ___) => const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('\$${product.price}', style: const TextStyle(color: Colors.teal)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
