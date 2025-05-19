// lib/presentation/screens/home/home_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../cubit/home/home_cubit.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../cart/cart_screen.dart';
import '../categories/categories_screen.dart';
import '../categories/category_products_screen.dart';
import '../product_details/product_details_screen.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(RepositoryProvider.of(context))..loadHomeData(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Jewelry Store'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
              icon: const Icon(Icons.shopping_cart),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          ],
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              final categories =
                  CategoryModel.sampleCategories; // استخدام القائمة الجديدة
              final products = state.products;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الأقسام', style: TextStyle(fontSize: 18)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CategoriesScreen(categories: categories),
                              ),
                            );
                          },
                          child: const Text('عرض الكل'),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CategoryProductsScreen(
                                            category: categories[index]),
                                      ),
                                    );
                                  },
                                  child: Container(
                                      width: 100,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.teal[400],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(categories[index].icon,
                                              size: 30),
                                          const SizedBox(height: 8),
                                          Text(categories[index].name),
                                        ],
                                      )),
                                );
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CategoriesScreen(categories: categories),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('الأكثر مبيعا', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailsScreen(product: product),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
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
                                    imageUrl: product.image,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(product.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Text('\$${product.price}',
                                    style: TextStyle(color: Colors.teal)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else if (state is HomeError) {
              return Center(child: Text('خطأ: ${state.message}'));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
