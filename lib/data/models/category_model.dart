// في ملف data/models/category_model.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final IconData icon;

  CategoryModel({required this.name, required this.icon});

  // يمكنك تغيير هذه القائمة حسب احتياجاتك
  static final List<CategoryModel> sampleCategories = [
    CategoryModel(name: "إلكترونيات", icon: Icons.electrical_services),
    CategoryModel(name: "ملابس", icon: Icons.checkroom),
    CategoryModel(name: "أطعمة", icon: Icons.fastfood),
    CategoryModel(name: "أثاث", icon: Icons.chair),
    CategoryModel(name: "كتب", icon: Icons.menu_book),
  ];
}