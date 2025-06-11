import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/cart/cart_cubit.dart';
import '../../data/models/product_model.dart';
import '../product_details/product_details_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartCubit>().state;
    final total = cart.fold<double>(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(title: const Text('السلة')),
      body: cart.isEmpty
          ? const Center(child: Text('السلة فارغة.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final product = cart[index];
                      return ListTile(
                        leading:
                        //Image.network(product.productFile, width: 60),
                        CachedNetworkImage(
                          imageUrl: '${product.productFile}',
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        title: Text(product.name),
                        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_shopping_cart),
                          onPressed: () {
                            context.read<CartCubit>().remove(product);
                          },
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailsScreen(product: product),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المجموع: \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // الشراء لاحقًا
                        },
                        child: const Text('شراء'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
