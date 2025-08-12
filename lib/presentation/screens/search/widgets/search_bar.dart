import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdvancedPressed;
  final VoidCallback onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onAdvancedPressed,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'ابحث باسم المنتج أو القسم...',
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: onClear,
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            ),
            textInputAction: TextInputAction.search,
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: onAdvancedPressed,
          child: const Text('بحث متقدم'),
        ),
      ],
    );
  }
}
