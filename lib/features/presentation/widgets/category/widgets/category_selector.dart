import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChanged;

  const CategorySelector({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onTabChanged(0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 7),
              decoration: BoxDecoration(
                color: currentIndex == 0
                    ? const Color(0xFF28D4B1)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'Seleccionadas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: currentIndex == 0
                      ? Colors.white
                      : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: GestureDetector(
            onTap: () => onTabChanged(1),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 7),
              decoration: BoxDecoration(
                color: currentIndex == 1
                    ? const Color(0xFF28D4B1)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'Predeterminadas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: currentIndex == 1
                      ? Colors.white
                      : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: GestureDetector(
            onTap: () => onTabChanged(2),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 7),
              decoration: BoxDecoration(
                color: currentIndex == 2
                    ? const Color(0xFF28D4B1)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'Creadas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: currentIndex == 2
                      ? Colors.white
                      : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
