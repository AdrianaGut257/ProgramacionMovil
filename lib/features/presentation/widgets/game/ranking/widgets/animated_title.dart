import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:programacion_movil/config/colors.dart';
import '../utils/screen_config.dart';

class AnimatedTitle extends StatelessWidget {
  final ScreenConfig config;

  const AnimatedTitle({super.key, required this.config});

  @override
  Widget build(BuildContext context) {


    return Text(
                        'Ranking',
                        style: GoogleFonts.titanOne().copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: AppColors.success,
                          letterSpacing: 0,
                          height: 1.1,
                        ),
                        textAlign: TextAlign.center,
    );      
}
}