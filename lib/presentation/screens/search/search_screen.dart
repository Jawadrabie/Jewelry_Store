import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/home/home_cubit.dart';
import '../../../cubit/home/home_state.dart';
import '../../../data/models/product_model.dart';
import '../../widgets/products_grid.dart';
import '../../widgets/sort_utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ProductSortState _sort = ProductSortState();
  final TextEditingController _ctrl = TextEditingController();
  Timer? _debounce;

  List<ProductModel> _results = [];
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  // Filters
  RangeValues? _priceRange;
  RangeValues? _weightRange;
  double _globalMinPrice = 0;
  double _globalMaxPrice = 1000;
  double _globalMinWeight = 0;
  double _globalMaxWeight = 100;
  int? _karatFilter; // 14, 18, 21, 22, 24

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initFilters());
  }

  void _initFilters() {
    final st = context.read<HomeCubit>().state;
    if (st is HomeLoaded) {
      final prods = st.products;

      final prices = prods.map((p) => p.price).toList();
      if (prices.isNotEmpty) {
        _globalMinPrice = prices.reduce((a, b) => a < b ? a : b);
        _globalMaxPrice = prices.reduce((a, b) => a > b ? a : b);
      }

      final weights = prods
          .map((p) => _parseWeight(p.weight))
          .where((w) => w != null)
          .map((w) => w!)
          .toList();
      if (weights.isNotEmpty) {
        _globalMinWeight = weights.reduce((a, b) => a < b ? a : b);
        _globalMaxWeight = weights.reduce((a, b) => a > b ? a : b);
      }

      setState(() {
        _priceRange = RangeValues(_globalMinPrice, _globalMaxPrice);
        _weightRange = RangeValues(_globalMinWeight, _globalMaxWeight);
      });
    }
  }

  double? _parseWeight(String w) {
    try {
      final cleaned = w
          .replaceAll(RegExp(r'[^0-9\.,]'), '')
          .replaceAll(',', '.');
      if (cleaned.isEmpty) return null;
      return double.parse(cleaned);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final q = _ctrl.text.trim();
      if (q.isEmpty) {
        setState(() {
          _showSuggestions = false;
          _results = [];
        });
      } else if (q.length < 3) {
        _updateSuggestions(q);
      } else {
        _applyFilters();
      }
    });
  }

  void _updateSuggestions(String q) {
    final st = context.read<HomeCubit>().state;
    if (st is! HomeLoaded) return;

    final prods = st.products;
    final lower = q.toLowerCase();

    final names = prods
        .map((p) => p.name)
        .where((n) => n.toLowerCase().contains(lower))
        .toList();
    final cats = prods
        .map((p) => p.categoryName)
        .where((c) => c.toLowerCase().contains(lower))
        .toSet()
        .toList();

    final combined = {...names, ...cats}.take(8).toList();

    setState(() {
      _suggestions = combined;
      _showSuggestions = true;
      _results = [];
    });
  }

  void _applyFilters() {
    final st = context.read<HomeCubit>().state;
    if (st is! HomeLoaded) return;

    final prods = st.products;
    final q = _ctrl.text.trim().toLowerCase();

    final pr = _priceRange ?? RangeValues(_globalMinPrice, _globalMaxPrice);
    final wr = _weightRange ?? RangeValues(_globalMinWeight, _globalMaxWeight);

    final filtered = prods.where((p) {
      final matchName =
          q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.categoryName.toLowerCase().contains(q);
      final matchPrice = p.price >= pr.start && p.price <= pr.end;
      final w = _parseWeight(p.weight);
      final matchWeight = w == null || (w >= wr.start && w <= wr.end);
      final matchKarat = _karatFilter == null || p.karat == _karatFilter;

      return matchName && matchPrice && matchWeight && matchKarat;
    }).toList();

    // apply shared sort state
    final sorted = buildSortedProducts(filtered, _sort);

    setState(() {
      _results = sorted;
      _showSuggestions = false;
    });
  }

  void _openAdvanced() {
    FocusScope.of(context).unfocus();
    Future.delayed(const Duration(milliseconds: 150), () {
      showGeneralDialog(
        context: context,
        barrierLabel: "بحث متقدم",
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) {
          RangeValues localPrice = _priceRange!;
          RangeValues localWeight = _weightRange!;
          int? localKarat = _karatFilter;

          return Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: StatefulBuilder(
                  builder: (context, setModalState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        Text(
                          'السعر (${localPrice.start.toStringAsFixed(0)} - ${localPrice.end.toStringAsFixed(0)})',
                        ),
                        RangeSlider(
                          values: localPrice,
                          min: _globalMinPrice,
                          max: _globalMaxPrice,
                          divisions: 100,
                          onChanged: (v) => setModalState(() => localPrice = v),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'الوزن (${localWeight.start.toStringAsFixed(1)} - ${localWeight.end.toStringAsFixed(1)})',
                        ),
                        RangeSlider(
                          values: localWeight,
                          min: _globalMinWeight,
                          max: _globalMaxWeight,
                          divisions: 100,
                          onChanged: (v) =>
                              setModalState(() => localWeight = v),
                        ),
                        const SizedBox(height: 16),
                        // العيار
                        Align(
                          alignment: Alignment.centerRight,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text('العيار:'),
                              FilterChip(
                                label: const Text('الكل'),
                                selected: localKarat == null,
                                onSelected: (_) =>
                                    setModalState(() => localKarat = null),
                              ),

                              for (final k in [18, 21])
                                FilterChip(
                                  label: Text('${k}K'),
                                  selected: localKarat == k,
                                  onSelected: (_) =>
                                      setModalState(() => localKarat = k),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _priceRange = RangeValues(
                                    _globalMinPrice,
                                    _globalMaxPrice,
                                  );
                                  _weightRange = RangeValues(
                                    _globalMinWeight,
                                    _globalMaxWeight,
                                  );
                                  _karatFilter = null;
                                  if (_ctrl.text.trim().isEmpty) {
                                    _results = [];
                                  } else {
                                    _applyFilters();
                                  }
                                });
                                Navigator.pop(context);
                              },
                              child: const Text('إعادة تعيين'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _priceRange = localPrice;
                                  _weightRange = localWeight;
                                  _karatFilter = localKarat;
                                });
                                Navigator.pop(context);
                                _applyFilters();
                              },
                              child: const Text('تم'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
        transitionBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: FadeTransition(
              opacity: CurvedAnimation(parent: anim, curve: Curves.easeIn),
              child: child,
            ),
          );
        },
      );
    });
  }

  Widget _buildSuggestionList() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: _suggestions.length,
        separatorBuilder: (_, __) => const Divider(height: 0.5),
        itemBuilder: (_, i) {
          final s = _suggestions[i];
          return ListTile(
            title: Text(s),
            onTap: () {
              _ctrl.text = s;
              _applyFilters();
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بحث'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'ترتيب',
            onPressed: () {
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
                            children: [
                              CheckboxListTile(
                                value: _sort.sortByWeight,
                                onChanged: (v) => setModalState(
                                  () => _sort.sortByWeight = v ?? false,
                                ),
                                title: const Text('الوزن (من الأصغر للأكبر)'),
                              ),
                              CheckboxListTile(
                                value: _sort.sortByPrice,
                                onChanged: (v) => setModalState(
                                  () => _sort.sortByPrice = v ?? false,
                                ),
                                title: const Text('السعر (من الأصغر للأكبر)'),
                              ),
                              CheckboxListTile(
                                value: _sort.sortByKarat,
                                onChanged: (v) => setModalState(
                                  () => _sort.sortByKarat = v ?? false,
                                ),
                                title: const Text('العيار (من الأصغر للأكبر)'),
                              ),
                              CheckboxListTile(
                                value: _sort.sortBySmithing,
                                onChanged: (v) => setModalState(
                                  () => _sort.sortBySmithing = v ?? false,
                                ),
                                title: const Text(
                                  'قيمة الصياغة% (من الأصغر للأكبر)',
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _applyFilters();
                                },
                                child: const Text('تطبيق'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'ابحث باسم المنتج أو القسم...',
                      suffixIcon: _ctrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _ctrl.clear();
                                setState(() {
                                  _results = [];
                                  _showSuggestions = false;
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _applyFilters(),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _openAdvanced,
                  child: const Text('بحث متقدم'),
                ),
              ],
            ),
            if (_showSuggestions) ...[
              const SizedBox(height: 8),
              _buildSuggestionList(),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'النتائج: ${_results.length}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _results.isEmpty
                  ? Center(
                      child: _ctrl.text.isEmpty
                          ? const Text('ابدأ بالبحث لعرض المنتجات')
                          : const Text('لا توجد نتائج'),
                    )
                  : SingleChildScrollView(
                      child: ProductsGrid(products: _results),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
