// lib/widgets/category_tile.dart
import 'package:flutter/material.dart';
import '../data/models/category_model.dart';
import '../presentation/screens/categories/categories_screen.dart';

class CategoryTile extends StatelessWidget {
  final CategoryModel category;

  const CategoryTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.network(
          category.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(category.name),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoriesScreen(categories: [category]),
            ),
          );
        },
      ),
    );
  }
}
