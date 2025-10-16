import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import '../utils/screen_config.dart';

class AnimatedTitle extends StatelessWidget {
  final ScreenConfig config;

  const AnimatedTitle({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final width = config.size.width;

    return Text(
      'RANKING',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: width * 0.075,
        fontWeight: FontWeight.w900,
        color: AppColors.tertiary,
        letterSpacing: 1.5,
        shadows: [
          Shadow(
            offset: const Offset(0, 2),
            blurRadius: 4,
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
