import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/favorite/favorite_cubit.dart';
import '../../data/models/product_model.dart';
import '../product_details/product_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoriteCubit>().state;

    return Scaffold(
      appBar: AppBar(title: const Text('المفضلة')),
      body: favorites.isEmpty
          ? const Center(child: Text('لا توجد منتجات مضافة.'))
          : ListView.separated(
        itemCount: favorites.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final product = favorites[index];
          return ListTile(
            leading: Image.network(product.image, width: 60),
            title: Text(product.title),
            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                context.read<FavoriteCubit>().remove(product);
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
    );
  }
}
