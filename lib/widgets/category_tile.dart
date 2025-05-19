import 'package:flutter/material.dart';
import '../data/models/category_model.dart';
import '../screens/categories/categories_screen.dart';

// في ملف widgets/category_tile.dart
class CategoryTile extends StatelessWidget {
  final CategoryModel category;

  const CategoryTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(category.icon, size: 30, color: Colors.teal),
        title: Text(category.name),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoriesScreen(categories: CategoryModel.sampleCategories),
            ),
          );
        },
      ),
    );
  }
}