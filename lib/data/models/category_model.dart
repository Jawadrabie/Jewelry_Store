// lib/data/models/category_model.dart

class CategoryModel {
  final int id;
  final String name;
  final String description;
  final String image;   // maps to JSON key 'categoryFile'
  final int smithing;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.smithing,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['categoryFile'] as String,
      smithing: json['smithing'] as int,
    );
  }

  /// ترميز الكائن إلى خريطة يمكن تحويلها إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'categoryFile': image,
      'smithing': smithing,
    };
  }
}
