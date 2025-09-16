import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LetterTile extends StatelessWidget {
  final String letter;
  final VoidCallback onTap;
  final int availableLetters;

  const LetterTile({
    super.key,
    required this.letter,
    required this.onTap,
    required this.availableLetters,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: onTap,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: availableLetters > 0 ? Colors.blue : Colors.blue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                letter,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
        // Animación de entrada con escala y suavizado
        .animate()
        .move(begin: Offset(0, 50), end: Offset(0, 0), duration: 500.ms);
  }
}
