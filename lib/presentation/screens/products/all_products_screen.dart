import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/home/home_cubit.dart';
import '../../../cubit/home/home_state.dart';
import '../../widgets/products_grid.dart';
import '../../widgets/sort_utils.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  final ProductSortState _sort = ProductSortState();

  // weight parser moved into shared sort utils

  List _buildSorted(List prods) => buildSortedProducts(prods.cast(), _sort);

  void _openSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ترتيب حسب',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      value: _sort.sortByWeight,
                      onChanged: (v) =>
                          setModalState(() => _sort.sortByWeight = v ?? false),
                      title: const Text('الوزن (من الأصغر للأكبر)'),
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      value: _sort.sortByPrice,
                      onChanged: (v) =>
                          setModalState(() => _sort.sortByPrice = v ?? false),
                      title: const Text('السعر (من الأصغر للأكبر)'),
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      value: _sort.sortByKarat,
                      onChanged: (v) =>
                          setModalState(() => _sort.sortByKarat = v ?? false),
                      title: const Text('العيار (من الأصغر للأكبر)'),
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      value: _sort.sortBySmithing,
                      onChanged: (v) => setModalState(
                        () => _sort.sortBySmithing = v ?? false,
                      ),
                      title: const Text('قيمة الصياغة% (من الأصغر للأكبر)'),
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _sort
                                  ..sortByWeight = false
                                  ..sortByPrice = false
                                  ..sortByKarat = false
                                  ..sortBySmithing = false;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('إعادة التعيين'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: const Text('تطبيق'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('كافة المنتجات'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'ترتيب',
            onPressed: _openSortSheet,
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeLoaded) {
            final base = state.products;
            final products = _buildSorted(base);

            if (products.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'لا توجد منتجات متاحة حالياً',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ProductsGrid(products: products.cast(), scrollable: true);
          }

          return const Center(child: Text('خطأ في تحميل البيانات'));
        },
      ),
    );
  }
}
