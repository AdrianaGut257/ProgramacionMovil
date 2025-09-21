import 'package:flutter/material.dart';
import '../../../../config/colors.dart';

class GameButtons extends StatelessWidget {
  final VoidCallback onCorrect;
  final VoidCallback onReset;

  const GameButtons({
    super.key,
    required this.onCorrect,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          heroTag: "combination",
          backgroundColor: Colors.green,
          onPressed: onCorrect,
          child: const Icon(Icons.check, size: 30, color: Colors.white),
        ),
        FloatingActionButton(
          heroTag: "reset",
          backgroundColor: AppColors.errorPrimary,
          onPressed: onReset,
          child: const Icon(Icons.close, size: 30, color: Colors.white),
        ),
      ],
    );
  }
}
