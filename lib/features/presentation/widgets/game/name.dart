import 'package:flutter/material.dart';
import '../../../../config/colors.dart';

class PlayerNameWidget extends StatelessWidget {
  final String name;
  final int score;

  const PlayerNameWidget({super.key, required this.name, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "$name  $score",
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
