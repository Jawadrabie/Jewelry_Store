// lib/data/models/product_model.dart
import 'dart:math';

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
  final double smithing;
  final int categoryId;
  final int? karat;

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
    this.karat,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final int id = json['id'] ?? 0;

    // Use a deterministic random seeded by product id to keep values stable per product
    final Random seededRandom = Random(
      id == 0 ? (json['name']?.hashCode ?? 42) : id,
    );

    // Weight: prefer API value; otherwise generate 3.0 - 18.0 grams
    String weightString = (json['weight'] ?? '').toString();
    double weightValue = double.tryParse(weightString) ?? 0.0;
    if (weightValue <= 0) {
      weightValue = 3.0 + seededRandom.nextDouble() * 15.0; // 3 - 18 g
      weightValue = double.parse(weightValue.toStringAsFixed(2));
      weightString = weightValue.toString();
    }

    // Karat: prefer API value; otherwise choose 18 or 21 deterministically
    int? karatValue = json['karat'];
    karatValue ??= (seededRandom.nextBool() ? 18 : 21);

    // Price: prefer API value; otherwise compute from weight and karat
    double priceValue = double.tryParse(json['price']?.toString() ?? '') ?? 0.0;
    if (priceValue <= 0) {
      // Simple heuristic price-per-gram by karat
      final double pricePerGram = karatValue == 21 ? 75.0 : 65.0;
      priceValue = double.parse(
        (weightValue * pricePerGram).toStringAsFixed(2),
      );
    }

    return ProductModel(
      productId: id,
      name: json['name'] ?? 'error',
      description: json['description'] ?? json['decription'] ?? '',
      weight: weightString,
      price: priceValue,
      productFile: json['productFile'] ?? json['productfile'] ?? '',
      isFeatured: (json['isFeatured'] ?? 0) == 1,
      categoryName: json['category_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      smithing:
          double.tryParse(json['smithing']?.toString() ?? '0') ??
          0.0, // Ensure smithing is always a double
      categoryId: json['categoryid'] ?? 0,
      karat: karatValue,
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
      'karat': karat,
    };
  }
}
