class ProductModel {
  final int productId;
  final String name;
  final String description;
  final String weight;
  final double price;
  final String productFile;
  final bool isAvailable;
  final bool isFeatured;
  final int categoryId;

  ProductModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.weight,
    required this.price,
    required this.productFile,
    required this.isAvailable,
    required this.isFeatured,
    required this.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'] as int,
      name: json['name'] as String,
      description: json['decription'] as String,
      weight: json['weight'] as String,
      price: double.parse(json['price'] as String),
      productFile: json['ProductFile'] as String,
      isAvailable: (json['IsAvailable'] as String).toLowerCase() == 'true',
      isFeatured: (json['isFeatured'] as String).toLowerCase() == 'true',
      categoryId: json['categoryID'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'decription': description,
      'weight': weight,
      'price': price.toString(),
      'ProductFile': productFile,
      'IsAvailable': isAvailable.toString(),
      'isFeatured': isFeatured.toString(),
      'categoryID': categoryId,
    };
  }
}
