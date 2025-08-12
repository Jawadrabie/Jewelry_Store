import 'package:flutter/material.dart';

void showAdvancedFilterSheet({
  required BuildContext context,
  required RangeValues priceRange,
  required RangeValues weightRange,
  required double globalMinPrice,
  required double globalMaxPrice,
  required double globalMinWeight,
  required double globalMaxWeight,
  required VoidCallback onReset,
  required void Function(RangeValues, RangeValues) onApply,
}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "بحث متقدم",
    barrierDismissible: true,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (ctx, anim1, anim2) {
      RangeValues localPrice = priceRange;
      RangeValues localWeight = weightRange;

      return Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                        'السعر (${localPrice.start.toStringAsFixed(0)} - ${localPrice.end.toStringAsFixed(0)})'),
                    RangeSlider(
                      values: localPrice,
                      min: globalMinPrice,
                      max: globalMaxPrice <= globalMinPrice
                          ? globalMinPrice + 1
                          : globalMaxPrice,
                      divisions: 100,
                      labels: RangeLabels(
                        localPrice.start.toStringAsFixed(0),
                        localPrice.end.toStringAsFixed(0),
                      ),
                      onChanged: (v) {
                        setModalState(() => localPrice = v);
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                        'الوزن (${localWeight.start.toStringAsFixed(1)} - ${localWeight.end.toStringAsFixed(1)})'),
                    RangeSlider(
                      values: localWeight,
                      min: globalMinWeight,
                      max: globalMaxWeight <= globalMinWeight
                          ? globalMinWeight + 1
                          : globalMaxWeight,
                      divisions: 100,
                      labels: RangeLabels(
                        localWeight.start.toStringAsFixed(1),
                        localWeight.end.toStringAsFixed(1),
                      ),
                      onChanged: (v) {
                        setModalState(() => localWeight = v);
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            onReset();
                            Navigator.pop(ctx);
                          },
                          child: const Text('إعادة تعيين'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            onApply(localPrice, localWeight);
                            Navigator.pop(ctx);
                          },
                          child: const Text('تم'),
                        )
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
    transitionBuilder: (ctx, anim1, anim2, child) {
      final slide = Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut));

      final fade = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut));

      return SlideTransition(
        position: slide,
        child: FadeTransition(
          opacity: fade,
          child: child,
        ),
      );
    },
  );
}
