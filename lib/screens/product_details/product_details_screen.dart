import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../data/models/product_model.dart';
import '../../cubit/favorite/favorite_cubit.dart';
import '../../cubit/cart/cart_cubit.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.watch<FavoriteCubit>().state.contains(product);
    final isInCart = context
        .watch<CartCubit>()
        .state
        .any((p) => p.productId == product.productId);
    //
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المنتج'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== صورة المنتج =====
            CachedNetworkImage(
              imageUrl: product.productFile,
              height: 250,
              fit: BoxFit.contain,
              placeholder: (_, __) => const CircularProgressIndicator(),
              errorWidget: (_, __, ___) => const Icon(Icons.error),
            ),

            const SizedBox(height: 16),

            // ===== العنوان =====
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // ===== الوصف =====
            Text(
              product.description,
              style: const TextStyle(fontSize: 16),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // ===== القسم والسعر =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('القسم: ${product.name}',
                    style: const TextStyle(color: Colors.grey)),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.teal,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // ===== زر المفضلة + السلة =====
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.shopping_cart),
                    label: Text(isInCart ? 'إزالة من السلة' : 'أضف إلى السلة'),
                    onPressed: () => context.read<CartCubit>().toggle(product),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: isInCart ? Colors.grey : Colors.teal),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.favorite),
                    label: Text(isFavorite ? 'إزالة من المفضلة' : 'أضف إلى المفضلة'),
                    onPressed: () => context.read<FavoriteCubit>().toggle(product),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: isFavorite ? Colors.red : Colors.tealAccent),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
