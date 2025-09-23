import 'package:flutter/material.dart';
import '../../../../config/colors.dart';

class PlayerNameWidget extends StatelessWidget {
  final String name;
  final int score;
  final int team;

  const PlayerNameWidget({
    super.key,
    required this.name,
    required this.score,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = team == 1 ? AppColors.secondary : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
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
