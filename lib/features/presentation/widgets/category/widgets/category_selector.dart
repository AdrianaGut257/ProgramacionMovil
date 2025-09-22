import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final bool isPredSelected;
  final Function(bool) onModeChanged;

  const CategorySelector({
    super.key,
    required this.isPredSelected,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onModeChanged(true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              decoration: BoxDecoration(
                color: isPredSelected ? Colors.teal : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'Predeterminadas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isPredSelected ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: GestureDetector(
            onTap: () => onModeChanged(false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              decoration: BoxDecoration(
                color: !isPredSelected ? Colors.teal : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'Creadas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: !isPredSelected ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
