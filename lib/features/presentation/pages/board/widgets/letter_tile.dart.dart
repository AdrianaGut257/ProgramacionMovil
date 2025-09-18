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
              color: Colors.blue.shade700,
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            letter,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms) 
        .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1), curve: Curves.elasticOut, duration: 700.ms) // rebote
        .move(begin: const Offset(0, 120), end: const Offset(0, 0), curve: Curves.easeOutBack, duration: 600.ms); // caída más notoria
  }
}
