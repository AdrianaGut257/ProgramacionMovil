import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: List.generate(12, (index) {
            final progress = (_controller.value + index / 12) % 1.0;
            final x = (index * 50.0 + 30) % size.width;
            final y = size.height * progress;
            final opacity = (1 - progress) * 0.5;

            return Positioned(
              left: x,
              top: y,
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 8 + (index % 2) * 4,
                  height: 8 + (index % 2) * 4,
                  decoration: BoxDecoration(
                    color: index % 3 == 0
                        ? AppColors.secondary
                        : index % 3 == 1
                            ? AppColors.tertiary
                            : AppColors.teal,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (index % 3 == 0
                                ? AppColors.secondary
                                : index % 3 == 1
                                    ? AppColors.tertiary
                                    : AppColors.teal)
                            // ignore: deprecated_member_use
                            .withOpacity(0.6),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}