import 'package:flutter/material.dart';
import '../../../../config/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final Color? borderColor; // 🔹 Nuevo parámetro para borde

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: borderColor ?? AppColors.secondaryVariant,
            width: 3,
          ),
        ),
        child: Material(
          color: backgroundColor ?? AppColors.secondary,
          borderRadius: BorderRadius.circular(25),
          elevation: 0,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(25),
            splashColor: backgroundColor ?? AppColors.secondaryVariant,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.blackOpsOne().copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: textColor ?? Colors.white,
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(icon, color: textColor ?? Colors.white),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
