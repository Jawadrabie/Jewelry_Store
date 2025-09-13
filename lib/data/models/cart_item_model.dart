import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;

  CartItemModel({required this.product, this.quantity = 1});

  // حساب السعر الإجمالي لهذا العنصر
  double get totalPrice => product.price * quantity;

  // حساب الوزن الإجمالي لهذا العنصر
  double get totalWeight {
    final weight = double.tryParse(product.weight) ?? 0.0;
    return weight * quantity;
  }

  // حساب تكلفة الصياغة الإجمالية لهذا العنصر
  double get totalSmithingCost => product.smithing * totalWeight;

  // نسخ العنصر مع كمية جديدة
  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(product: product, quantity: quantity ?? this.quantity);
  }

  // تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {'product': product.toJson(), 'quantity': quantity};
  }

  // إنشاء من JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItemModel &&
        other.product.productId == product.productId;
  }

  @override
  int get hashCode => product.productId.hashCode;
}

