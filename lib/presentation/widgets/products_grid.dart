// lib/presentation/widgets/products_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/product_model.dart';
import '../../../cubit/favorite/favorite_cubit.dart';
import '../../../core/theme.dart';
import '../screens/product_details/product_details_screen.dart';

class ProductsGrid extends StatelessWidget {
  final List<ProductModel> products;
  final bool scrollable;

  const ProductsGrid(
      {super.key, required this.products, this.scrollable = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GridView.builder(
      padding: const EdgeInsets.all(4),
      shrinkWrap: !scrollable,
      physics: scrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return BlocBuilder<FavoriteCubit, List<ProductModel>>(
          builder: (context, favorites) {
            final isFavorite = favorites.any((fav) =>
            fav.productId == product.productId);

            return GestureDetector(
              onTap: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsScreen(product: product),
                    ),
                  ),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.1),
                      blurRadius: isDark ? 2 : 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // صورة المنتج
                        Expanded(
                          flex: 4,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: isDark ? Colors.grey[800] : Colors
                                  .grey[100],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: product.productFile,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                memCacheWidth: 300,
                                memCacheHeight: 300,
                                maxWidthDiskCache: 500,
                                maxHeightDiskCache: 500,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                      baseColor: isDark
                                          ? Colors.grey[800]!
                                          : Colors.grey[300]!,
                                      highlightColor: isDark
                                          ? Colors.grey[700]!
                                          : Colors.grey[100]!,
                                      child: Container(
                                        color: isDark
                                            ? Colors.grey[800]
                                            : Colors.grey[300],
                                      ),
                                    ),
                                errorWidget: (context, url, error) =>
                                    Container(
                                      color: isDark ? Colors.grey[800] : Colors
                                          .grey[200],
                                      child: Icon(
                                        Icons.diamond,
                                        color: colorScheme.primary,
                                        size: 32,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                        // تفاصيل المنتج
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // اسم المنتج
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    product.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white : Colors
                                          .black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // السعر
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // وزن + عيار
                                Row(
                                  children: [
                                    Icon(
                                      Icons.scale,
                                      size: 10,
                                      color: isDark ? Colors.grey[400] : Colors
                                          .grey[600],
                                    ),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: Text(
                                        '${product.weight} غرام',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isDark
                                              ? Colors.grey[400]
                                              : Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (product.karat != null) ...[
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.grade,
                                        size: 10,
                                        color: isDark
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        '${product.karat}K',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isDark
                                              ? Colors.grey[400]
                                              : Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // أيقونة المفضلة
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          context.read<FavoriteCubit>().toggle(product);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[800] : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? Colors.grey[600]! : Colors
                                  .grey[300]!,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.1),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : (isDark ? Colors
                                .grey[400] : Colors.grey[600]),
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
