// lib/presentation/screens/categories_screen.dart
import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import 'category_products_screen.dart';

class CategoriesScreen extends StatelessWidget {
  final List<CategoryModel> categories;

  const CategoriesScreen({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("جميع الأقسام"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            elevation: 2,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryProductsScreen(category: category),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(category.icon, size: 40, color: Colors.teal),
                  const SizedBox(height: 10),
                  Text(category.name, textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
