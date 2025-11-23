import 'package:flutter/material.dart';
import '../../../../../config/colors.dart';

class GameModeSelector extends StatelessWidget {
  final bool isDetermined;
  final Function(bool) onModeChanged;

  const GameModeSelector({
    super.key,
    required this.isDetermined,
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
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: isDetermined ? AppColors.teal : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'Determinado',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDetermined ? Colors.white : Colors.grey.shade600,
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
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: !isDetermined ? AppColors.teal : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'Aleatorio',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: !isDetermined ? Colors.white : Colors.grey.shade600,
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
