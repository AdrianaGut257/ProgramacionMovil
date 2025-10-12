import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:google_fonts/google_fonts.dart';

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
                    ? AppColors.secondary
                    : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'Seleccionadas',
                textAlign: TextAlign.center,
                style: GoogleFonts.rubik().copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: currentIndex == 0 ? AppColors.white : AppColors.grey,
                  letterSpacing: 0,
                  height: 1.1,
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
                    ? AppColors.secondary
                    : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'Predeterminadas',
                textAlign: TextAlign.center,
                style: GoogleFonts.rubik().copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: currentIndex == 1 ? AppColors.white : AppColors.grey,
                  letterSpacing: 0,
                  height: 1.1,
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
                    ? AppColors.secondary
                    : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'Creadas',
                textAlign: TextAlign.center,
                style: GoogleFonts.rubik().copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: currentIndex == 2 ? AppColors.white : AppColors.grey,
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
