import 'package:flutter/material.dart';
import '../../../../../../config/colors.dart';
import 'package:google_fonts/google_fonts.dart';

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
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              decoration: BoxDecoration(
                color: isDetermined ? AppColors.secondary : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'Determinado',
                textAlign: TextAlign.center,
                style: GoogleFonts.rubik().copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: isDetermined ? AppColors.white : AppColors.grey,
                  letterSpacing: 0,
                  height: 1.1,
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
                color: !isDetermined
                    ? AppColors.secondary
                    : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'Aleatorio',
                textAlign: TextAlign.center,
                style: GoogleFonts.rubik().copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: !isDetermined ? AppColors.white : AppColors.grey,
                  letterSpacing: 0,
                  height: 1.1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
