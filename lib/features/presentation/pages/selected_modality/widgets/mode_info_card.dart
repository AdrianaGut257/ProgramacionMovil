import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/custom_button.dart';

class ModeInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Map<String, dynamic>> features;
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback onPressed;
  final bool isSmallScreen;
  final Color accentColor;
  final List<Color> gradientColors;

  const ModeInfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.features,
    required this.buttonText,
    required this.buttonIcon,
    required this.onPressed,
    required this.isSmallScreen,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: accentColor.withAlpha(25),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: accentColor.withAlpha(50), width: 2),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withAlpha(15),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 18 : 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withAlpha(40),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        buttonIcon,
                        color: Colors.white,
                        size: isSmallScreen ? 24 : 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 19 : 22,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 12 : 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isSmallScreen ? 16 : 18),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: features.map((feature) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12 : 14,
                        vertical: isSmallScreen ? 7 : 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accentColor.withAlpha(20),
                            accentColor.withAlpha(10),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: accentColor.withAlpha(60),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            feature["icon"] as IconData,
                            size: isSmallScreen ? 14 : 16,
                            color: accentColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            feature["text"] as String,
                            style: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 12 : 13,
                              color: accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                CustomButton(
                  text: buttonText,
                  icon: buttonIcon,
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
