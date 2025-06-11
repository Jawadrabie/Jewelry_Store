// في ملف data/models/category_model.dart
import 'package:flutter/material.dart';

// models/category_model.dart
class CategoryModel {
  final int id;
  final String name;
  final String image;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['category_ID'] as int,
      name: json['name'] as String,
      image: json['categoryFile'] as String,
    );
  }
}

