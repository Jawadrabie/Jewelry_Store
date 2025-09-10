import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../cubit/cart/cart_cubit.dart';
import '../../ddd.dart';
import '../product_details/product_details_screen.dart';
import '../auth/login_screen_.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Load cart data when screen opens
    context.read<CartCubit>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartCubit>().state;

    // حساب الوزن الإجمالي
    final totalWeight = cart.fold<double>(
      0,
      (sum, item) => sum + item.totalWeight,
    );

    // حساب السعر الإجمالي للذهب
    final goldSubtotal = cart.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );

    // حساب تكلفة الصياغة الإجمالية
    final smithingTotal = cart.fold<double>(
      0,
      (sum, item) => sum + item.totalSmithingCost,
    );

    // حساب الخصم حسب الوزن
    double discount = 0.0;
    String discountText = '';
    if (totalWeight >= 60.0) {
      discount = goldSubtotal * 0.15; // 15% خصم للوزن 60+ غرام
      discountText = 'خصم 15% للوزن 60+ غرام';
    } else if (totalWeight >= 40.0) {
      discount = goldSubtotal * 0.12; // 12% خصم للوزن 40+ غرام
      discountText = 'خصم 12% للوزن 40+ غرام';
    } else if (totalWeight >= 30.0) {
      discount = goldSubtotal * 0.10; // 10% خصم للوزن 30+ غرام
      discountText = 'خصم 10% للوزن 30+ غرام';
    }

    final grandTotal = goldSubtotal + smithingTotal - discount;

    return Scaffold(
      appBar: AppBar(title: const Text('السلة'), elevation: 0),
      body: cart.isEmpty
          ? Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 100,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withOpacity(0.6),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'سلة التسوق فارغة',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        'لم تقم بإضافة أي منتجات إلى سلة التسوق بعد',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'تصفح المنتجات',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // عرض الخصم المتاح
                if (discount > 0)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.local_offer,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                discountText,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'وفر \$${discount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: cart.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final cartItem = cart[index];
                      final product = cartItem.product;
                      final weight = double.tryParse(product.weight) ?? 0.0;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              // صورة المنتج
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: product.productFile,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  memCacheWidth: 120,
                                  memCacheHeight: 120,
                                  maxWidthDiskCache: 200,
                                  maxHeightDiskCache: 200,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                        baseColor: Theme.of(
                                          context,
                                        ).colorScheme.surfaceVariant,
                                        highlightColor: Theme.of(
                                          context,
                                        ).colorScheme.surface,
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.surfaceVariant,
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        width: 60,
                                        height: 60,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surfaceVariant,
                                        child: const Icon(
                                          Icons.error,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // تفاصيل المنتج
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)} × ${cartItem.quantity}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'الوزن: ${weight.toStringAsFixed(2)} غرام × ${cartItem.quantity}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'المجموع: \$${cartItem.totalPrice.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // عداد الكمية
                              Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove,
                                          size: 18,
                                        ),
                                        onPressed: () async {
                                          try {
                                            await context
                                                .read<CartCubit>()
                                                .updateQuantity(
                                                  cartItem,
                                                  cartItem.quantity - 1,
                                                );
                                          } catch (e) {
                                            Fluttertoast.showToast(
                                              msg: e.toString(),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                            );
                                          }
                                        },
                                        style: IconButton.styleFrom(
                                          backgroundColor: Theme.of(
                                            context,
                                          ).colorScheme.surfaceVariant,
                                          minimumSize: const Size(32, 32),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                      Container(
                                        width: 40,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Theme.of(
                                              context,
                                            ).dividerColor,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${cartItem.quantity}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add, size: 18),
                                        onPressed: () async {
                                          // التحقق من الحد الأقصى للكمية
                                          if (cartItem.quantity >=
                                              product.quantity) {
                                            Fluttertoast.showToast(
                                              msg: "لا تتوفر هذه الكمية",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                            );
                                            return;
                                          }

                                          try {
                                            await context
                                                .read<CartCubit>()
                                                .updateQuantity(
                                                  cartItem,
                                                  cartItem.quantity + 1,
                                                );
                                          } catch (e) {
                                            Fluttertoast.showToast(
                                              msg: e.toString(),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                            );
                                          }
                                        },
                                        style: IconButton.styleFrom(
                                          backgroundColor: Theme.of(
                                            context,
                                          ).colorScheme.surfaceVariant,
                                          minimumSize: const Size(32, 32),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  // زر الحذف
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      context.read<CartCubit>().remove(
                                        cartItem,
                                      );
                                    },
                                    style: IconButton.styleFrom(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.surfaceVariant,
                                      minimumSize: const Size(32, 32),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // تفاصيل الحساب
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                      top: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                  child: Column(
                    children: [
                      // سعر الذهب
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'سعر الذهب:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '\$${goldSubtotal.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // الصياغة
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'الصياغة:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '\$${smithingTotal.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // الوزن الإجمالي
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'الوزن الإجمالي:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '${totalWeight.toStringAsFixed(1)} غرام',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // الخصم (إذا كان متاحاً)
                      if (discount > 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'الخصم:',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            Text(
                              '-\$${discount.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],

                      Divider(color: Theme.of(context).dividerColor),
                      const SizedBox(height: 8),

                      // المجموع النهائي
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'المجموع النهائي:',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${grandTotal.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // زر الشراء
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ddd()),
                            );
                          },
                          child: Icon(Icons.shopping_cart, size: 30),
                          //   onPressed: _isSubmitting
                          //       ? null
                          //       : () async {
                          //           setState(() {
                          //             _isSubmitting = true;
                          //           });
                          //           try {
                          //             final response = await context
                          //                 .read<CartCubit>()
                          //                 .checkout();
                          //             if (response != null &&
                          //                 response.statusCode == 200) {
                          //               Fluttertoast.showToast(
                          //                 msg: 'تم إرسال طلب الشراء بنجاح',
                          //                 backgroundColor: Colors.green,
                          //                 textColor: Colors.white,
                          //               );
                          //             }
                          //           } catch (e) {
                          //             final isAuth = e.toString().contains(
                          //               'AUTH_REQUIRED',
                          //             );
                          //             if (isAuth) {
                          //               _showLoginRequired(context);
                          //             } else {
                          //               Fluttertoast.showToast(
                          //                 msg: e.toString().replaceFirst(
                          //                   'Exception: ',
                          //                   '',
                          //                 ),
                          //                 backgroundColor: Colors.red,
                          //                 textColor: Colors.white,
                          //               );
                          //             }
                          //           } finally {
                          //             if (mounted) {
                          //               setState(() {
                          //                 _isSubmitting = false;
                          //               });
                          //             }
                          //           }
                          //         },
                          //   style: ElevatedButton.styleFrom(
                          //     padding: const EdgeInsets.symmetric(vertical: 16),
                          //     backgroundColor: Theme.of(
                          //       context,
                          //     ).colorScheme.primary,
                          //     foregroundColor: Theme.of(
                          //       context,
                          //     ).colorScheme.onPrimary,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //   ),
                          //   child: _isSubmitting
                          //       ? SizedBox(
                          //           width: 22,
                          //           height: 22,
                          //           child: CircularProgressIndicator(
                          //             strokeWidth: 2.5,
                          //             valueColor: AlwaysStoppedAnimation(
                          //               Theme.of(context).colorScheme.onPrimary,
                          //             ),
                          //           ),
                          //         )
                          //       : const Text(
                          //           'إتمام الشراء',
                          //           style: TextStyle(
                          //             fontSize: 16,
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _showLoginRequired(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تسجيل الدخول مطلوب'),
        content: const Text('يرجى تسجيل الدخول لإتمام عملية الشراء.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('تسجيل الدخول'),
          ),
        ],
      ),
    );
  }
}
