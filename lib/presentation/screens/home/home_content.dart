// lib/presentation/screens/home/home_content.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../cubit/home/home_cubit.dart';
import '../../../cubit/home/home_state.dart';
import '../cart/cart_screen.dart';
import '../categories/categories_screen.dart';
import '../categories/category_products_screen.dart';
import '../product_details/product_details_screen.dart';
import '../search/search_screen.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jewelry Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().refreshHomeData(),
            child: _buildBody(state, context),
          );
        },
      ),
    );
  }

  Widget _buildBody(HomeState state, BuildContext ctx) {
    if (state is HomeLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is HomeLoaded) {
      final cats = state.categories;
      final prods = state.products;
      final featured = state.featuredProducts;

      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الأقسام
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('الأقسام', style: TextStyle(fontSize: 18)),
                TextButton(
                  onPressed: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) => CategoriesScreen(categories: cats),
                    ),
                  ),
                  child: const Text('عرض الكل'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cats.length,
                itemBuilder: (_, i) {
                  final c = cats[i];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      ctx,
                      MaterialPageRoute(
                        builder: (_) => CategoryProductsScreen(category: c),
                      ),
                    ),
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                            imageUrl: c.image,
                            width: 40,
                            height: 40,
                            placeholder: (_, __) =>
                            const CircularProgressIndicator(strokeWidth: 2),
                            errorWidget: (_, __, ___) => const Icon(Icons.error),
                          ),
                          const SizedBox(height: 6),
                          Text(c.name,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
            const Text('الأكثر مبيعاً', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: featured.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (_, i) {
                final p = featured[i];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsScreen(product: p),
                    ),
                  ),
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
                        Text(p.name,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('\$${p.price}',
                            style: const TextStyle(color: Colors.teal)),
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

    if (state is HomeError) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 100),
          Center(child: Text('خطأ: ${state.message}')),
        ],
      );
    }

    return const SizedBox();
  }
}
