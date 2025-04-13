import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final List<String> selected;
  final Function(String) onTap;
  const CategorySelector({super.key, required this.categories, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: categories.map((cat) {
        final selectedStatus = selected.contains(cat);
        return FilterChip(
          label: Text(cat),
          selected: selectedStatus,
          onSelected: (_) => onTap(cat),
        );
      }).toList(),
    );
  }
}