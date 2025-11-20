import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class TutorialTooltip extends StatelessWidget {
  final VoidCallback onDismiss;
  final VoidCallback onOpenTutorial;
  final GlobalKey? tutorialButtonKey;

  const TutorialTooltip({
    super.key,
    required this.onDismiss,
    required this.onOpenTutorial,
    this.tutorialButtonKey,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            child: CustomPaint(
              painter: SpotlightPainter(buttonKey: tutorialButtonKey),
              child: Container(),
            ),
          ),
        ),
        Positioned(
          bottom: 200,
          right: 20,
          left: 80,
          child: _buildTooltipCard(),
        ),
        Positioned(
          bottom: 90,
          right: 6,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.white,
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTooltipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.secondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '¡Bienvenido!',
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onDismiss,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha(77),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: AppColors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '✨ Te recomendamos ver el tutorial de categorías para aprovechar al máximo tu experiencia de juego. ¡Solo te tomará unos minutos!',
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class SpotlightPainter extends CustomPainter {
  final GlobalKey? buttonKey;

  SpotlightPainter({this.buttonKey});

  @override
  void paint(Canvas canvas, Size size) {
    if (buttonKey == null) {
      final darkOverlay = Paint()
        ..color = const Color(0x99000000)
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        darkOverlay,
      );
      return;
    }

    final renderBox =
        buttonKey!.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) {
      final darkOverlay = Paint()
        ..color = const Color(0x99000000)
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        darkOverlay,
      );
      return;
    }

    try {
      final position = renderBox.localToGlobal(Offset.zero);
      final buttonSize = renderBox.size;

      final spotlightRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          position.dx - 12,
          position.dy - 12,
          buttonSize.width + 24,
          buttonSize.height + 24,
        ),
        const Radius.circular(25),
      );

      final path = Path()
        ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
        ..addRRect(spotlightRect)
        ..fillType = PathFillType.evenOdd;

      final darkOverlay = Paint()
        ..color = const Color(0x99000000)
        ..style = PaintingStyle.fill;

      canvas.drawPath(path, darkOverlay);

      final glowPaint = Paint()
        ..color = AppColors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawRRect(spotlightRect, glowPaint);

      final innerBorderPaint = Paint()
        ..color = AppColors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawRRect(spotlightRect, innerBorderPaint);
    } catch (e) {
      final darkOverlay = Paint()
        ..color = const Color(0x99000000)
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        darkOverlay,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.tertiary
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);

    final shadowPaint = Paint()
      ..color = const Color(0x33000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
