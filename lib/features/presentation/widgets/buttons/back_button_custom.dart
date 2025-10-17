import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';

class BackButtonCustom extends StatelessWidget {
  final VoidCallback onPressed;

  const BackButtonCustom({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          bottom: BorderSide(
            color: AppColors.tertiaryVariant,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: AppColors.tertiary.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        tooltip: 'Volver',
        color: AppColors.textPrimary,
        splashRadius: 24,
      ),
    );
  }
}
