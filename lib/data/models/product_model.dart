// lib/data/models/product_model.dart

class ProductModel {
  final int productId;
  final String name;
  final String description;
  final String weight;
  final double price;
  final String productFile;
  final bool isFeatured;
  final String categoryName;
  final int quantity;
  final int smithing;
  final int categoryId;

  ProductModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.weight,
    required this.price,
    required this.productFile,
    required this.isFeatured,
    required this.categoryName,
    required this.quantity,
    required this.smithing,
    required this.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['id'] ?? 0,
      name: json['name'] ?? 'error',
      description: json['decription'] ?? '',
      weight: json['weight'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      productFile: json['productFile'] ?? '',
      isFeatured: (json['isFeatured'] ?? 0) == 1,
      categoryName: json['category_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      smithing: json['smithing'] ?? 0,
      categoryId: json['categoryid'] ?? 0,
    );
  }

  /// ترميز الكائن إلى خريطة يمكن تحويلها إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': productId,
      'name': name,
      'decription': description,
      'weight': weight,
      'price': price.toString(),
      'productFile': productFile,
      'isFeatured': isFeatured ? 1 : 0,
      'category_name': categoryName,
      'quantity': quantity,
      'smithing': smithing,
      'categoryid': categoryId,
    };
  }
}
