import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;

  const CategoryChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(blurRadius: 6, color: Colors.black.withValues(alpha: .05)),
        ],
      ),
      child: Center(
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
