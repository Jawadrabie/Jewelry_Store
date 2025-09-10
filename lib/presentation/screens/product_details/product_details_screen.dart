import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../cubit/cart/cart_cubit.dart';
import '../../../cubit/favorite/favorite_cubit.dart';
import '../../../data/models/product_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isFavorite = context.watch<FavoriteCubit>().state.any(
      (fav) => fav.productId == product.productId,
    );
    final isInCart = context.watch<CartCubit>().state.any(
      (cartItem) => cartItem.product.productId == product.productId,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: isDark
            ? Colors.grey[900]
            : colorScheme.primary.withOpacity(0.1),
        foregroundColor: isDark ? Colors.white : colorScheme.primary,
        elevation: 0,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: isDark ? 2 : 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // زر السلة
            Expanded(
              child: GestureDetector(
                onTap: () => context.read<CartCubit>().toggle(product),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: isInCart ? Colors.red : colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isInCart ? Colors.red : colorScheme.primary,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isInCart ? Colors.red : colorScheme.primary)
                            .withOpacity(0.2),
                        blurRadius: isDark ? 2 : 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isInCart
                            ? Icons.remove_shopping_cart
                            : Icons.shopping_cart,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isInCart ? " إزالة من السلة " : "إضافة للسلة",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // زر المفضلة
            Expanded(
              child: GestureDetector(
                onTap: () => context.read<FavoriteCubit>().toggle(product),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: isFavorite
                        ? Colors.red
                        : (isDark ? Colors.grey[800] : Colors.white),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isFavorite
                          ? Colors.red
                          : (isDark ? Colors.grey[600]! : Colors.grey[300]!),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.1),
                        blurRadius: isDark ? 2 : 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? Colors.white
                            : (isDark ? Colors.grey[400] : Colors.grey[600]),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isFavorite ? "إزالة من المفضلة" : "إضافة للمفضلة",
                        style: TextStyle(
                          color: isFavorite
                              ? Colors.white
                              : (isDark ? Colors.grey[400] : Colors.grey[600]),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج مع إمكانية التكبير
            GestureDetector(
              onTap: () => _showImageDialog(context),
              child: Hero(
                tag: product.productId,
                child: Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[100],
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: product.productFile,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          memCacheWidth: 500,
                          memCacheHeight: 500,
                          maxWidthDiskCache: 800,
                          maxHeightDiskCache: 800,
                          placeholder: (context, url) => Shimmer.fromColors(
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
                          errorWidget: (context, url, error) => Container(
                            color: isDark ? Colors.grey[800] : Colors.grey[200],
                            child: Icon(
                              Icons.diamond,
                              color: colorScheme.primary,
                              size: 60,
                            ),
                          ),
                        ),
                        // أيقونة التكبير
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.zoom_in,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const SizedBox(height: 20),

            // الاسم والسعر
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // معلومات المنتج
            Container(
              padding: const EdgeInsets.all(16),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // القسم
                  Row(
                    children: [
                      Icon(
                        Icons.category,
                        color: colorScheme.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "القسم: ${product.categoryName}",
                        style: TextStyle(
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // الوزن
                  Row(
                    children: [
                      Icon(Icons.scale, color: colorScheme.primary, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        "الوزن: ${product.weight} غرام",
                        style: TextStyle(
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (product.karat != null) ...[
                        const SizedBox(width: 16),
                        Icon(Icons.grade, color: colorScheme.primary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "العيار: ${product.karat}K",
                          style: TextStyle(
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (product.smithing > 0) ...[
                    const SizedBox(height: 12),
                    // خصم الصياغة
                    Row(
                      children: [
                        Icon(Icons.local_offer, color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Builder(
                          builder: (_) {
                            final double smithingValue =
                                (product.price * (product.smithing / 100.0));
                            return Text(
                              "قيمة الصياغة: \$ ${smithingValue.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // الوصف
            if (product.description.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.description,
                          color: colorScheme.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "الوصف",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 100), // مساحة للأزرار
          ],
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            // الصورة المكبرة
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: CachedNetworkImage(
                imageUrl: product.productFile,
                fit: BoxFit.contain,
                memCacheWidth: 1000,
                memCacheHeight: 1000,
                maxWidthDiskCache: 1500,
                maxHeightDiskCache: 1500,
                placeholder: (context, url) => Container(
                  height: 400,
                  color: Colors.grey.shade300,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 400,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.diamond,
                    color: Colors.amber,
                    size: 100,
                  ),
                ),
              ),
            ),
            // زر الإغلاق
            Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
