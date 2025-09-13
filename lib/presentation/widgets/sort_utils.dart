import '../../data/models/product_model.dart';

typedef ProductList = List<ProductModel>;

double? _parseWeight(String w) {
  try {
    final cleaned = w.replaceAll(RegExp(r'[^0-9\.,]'), '').replaceAll(',', '.');
    if (cleaned.isEmpty) return null;
    return double.parse(cleaned);
  } catch (_) {
    return null;
  }
}

class ProductSortState {
  bool sortByWeight;
  bool sortByPrice;
  bool sortByKarat;
  bool sortBySmithing;

  ProductSortState({
    this.sortByWeight = false,
    this.sortByPrice = false,
    this.sortByKarat = false,
    this.sortBySmithing = false,
  });
}

ProductList buildSortedProducts(ProductList input, ProductSortState s) {
  final list = List<ProductModel>.from(input);
  list.sort((a, b) {
    int cmp = 0;
    if (s.sortByWeight && cmp == 0) {
      final aw = _parseWeight(a.weight) ?? double.infinity;
      final bw = _parseWeight(b.weight) ?? double.infinity;
      cmp = aw.compareTo(bw);
    }
    if (s.sortByPrice && cmp == 0) {
      cmp = (a.price).compareTo(b.price);
    }
    if (s.sortByKarat && cmp == 0) {
      final ak = a.karat ?? 999;
      final bk = b.karat ?? 999;
      cmp = ak.compareTo(bk);
    }
    if (s.sortBySmithing && cmp == 0) {
      cmp = (a.smithing).compareTo(b.smithing);
    }
    return cmp;
  });
  return list;
}

