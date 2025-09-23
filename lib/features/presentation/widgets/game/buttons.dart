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
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(45),
            border: const Border(
              bottom: BorderSide(color: AppColors.secondaryVariant, width: 6),
            ),
          ),

          child: IconButton(
            icon: const Icon(Icons.check, color: Colors.white, size: 40),
            onPressed: onCorrect,
          ),
        ),

        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.errorPrimary,
            borderRadius: BorderRadius.circular(45),
            border: const Border(
              bottom: BorderSide(color: AppColors.errorSecondary, width: 6),
            ),
          ),

          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 40),
            onPressed: onReset,
          ),
        ),
      ],
    );
  }
}
