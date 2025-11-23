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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double fontSize = screenWidth * 0.04;
    final double verticalPadding = screenHeight * 0.015;
    final double horizontalPadding = screenWidth * 0.02;
    final double spacing = screenWidth * 0.015;

    final List<String> tabs = ['Seleccionadas', 'Predeterminadas', 'Creadas'];

    return Row(
      children: List.generate(tabs.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == tabs.length - 1 ? 0 : spacing,
            ),
            child: GestureDetector(
              onTap: () => onTabChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? AppColors.secondary
                      : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: currentIndex == index
                      ? [
                          BoxShadow(
                            color: AppColors.secondary,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    tabs[index],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w900,
                      color: currentIndex == index
                          ? AppColors.white
                          : AppColors.grey,
                      letterSpacing: 0,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
