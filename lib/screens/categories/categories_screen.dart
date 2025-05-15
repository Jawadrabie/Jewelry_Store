import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import '../../widgets/category_tile.dart';


class CategoriesScreen extends StatelessWidget {
  final List<CategoryModel> categories;

  const CategoriesScreen({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("جميع الأقسام")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryTile(category: category);
        },
      ),
    );
  }
}
