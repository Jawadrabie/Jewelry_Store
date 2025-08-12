import 'package:flutter/material.dart';

class SuggestionsList extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  const SuggestionsList({
    super.key,
    required this.suggestions,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const Divider(height: 0.5),
        itemBuilder: (_, i) {
          final s = suggestions[i];
          return ListTile(
            title: Text(s, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () => onSelected(s),
          );
        },
      ),
    );
  }
}
