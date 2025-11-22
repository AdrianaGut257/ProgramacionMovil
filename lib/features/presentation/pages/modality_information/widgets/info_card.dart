import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:programacion_movil/config/colors.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final bool isSmallScreen;
  final List<Map<String, dynamic>>? chips;

  const InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    required this.isSmallScreen,
    this.chips,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    /// 🌟 ESCALADO RESPONSIVE REAL
    /// 1 = pantallas grandes, 0.75 pantallas pequeñas
    final scale = (width / 400).clamp(0.70, 1.0);

    final hasChips = chips != null && chips!.isNotEmpty;
    final isCompact = !hasChips;

    return Transform.scale(
      scale: scale,
      alignment: Alignment.center,
      child: Container(
        width: isCompact ? 165 : double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(25),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: AppColors.primary.withAlpha(50),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -15,
              right: -15,
              child: Container(
                width: isCompact ? 55 : 75,
                height: isCompact ? 55 : 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withAlpha(15),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasChips)
                    _buildAdvancedContent(scale)
                  else
                    _buildCompactContent(scale),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔵 Contenido para tarjetas compactas (Tiempo / Dificultad)
  Widget _buildCompactContent(double scale) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10 * scale),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withAlpha(200),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.white,
            size: 22 * scale,
          ),
        ),
        SizedBox(width: 10 * scale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12 * scale,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey,
                ),
              ),
              SizedBox(height: 2 * scale),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 18 * scale,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 🔵 Contenido para tarjetas grandes (con chips)
  Widget _buildAdvancedContent(double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(12 * scale),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withAlpha(200),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 26 * scale,
              ),
            ),
            SizedBox(width: 12 * scale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 20 * scale,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: GoogleFonts.poppins(
                        fontSize: 13 * scale,
                        color: AppColors.grey,
                      ),
                    ),
                ],
              ),
            )
          ],
        ),

        SizedBox(height: 14 * scale),

        Wrap(
          spacing: 8 * scale,
          runSpacing: 8 * scale,
          children: chips!.map((chip) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12 * scale,
                vertical: 7 * scale,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primary.withAlpha(60),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    chip['icon'],
                    size: 14 * scale,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 6 * scale),
                  Text(
                    chip['text'],
                    style: GoogleFonts.poppins(
                      fontSize: 12 * scale,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
