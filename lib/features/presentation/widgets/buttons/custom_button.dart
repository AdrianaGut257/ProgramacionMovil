import 'package:flutter/material.dart';
import '../../../../config/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../features/presentation/utils/sound_manager.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final Color? borderColor;
  final bool isEnabled;
  final double? fontSize;
  final EdgeInsets? padding;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.borderColor,
    this.isEnabled = true,
    this.fontSize,
    this.padding,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _shadowAnimation = Tween<double>(begin: 8.0, end: 4.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.isEnabled) {
      setState(() {
        _isPressed = true;
      });
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.isEnabled) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
      SoundManager.playClick();
      widget.onPressed();
    }
  }

  void _onTapCancel() {
    if (widget.isEnabled) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;

    double scale(double v) => v * (height / 800);

    final effectiveBackgroundColor = widget.isEnabled
        ? (widget.backgroundColor ?? AppColors.secondary)
        : Colors.grey[400]!;

    final effectiveTextColor = widget.isEnabled
        ? (widget.textColor ?? Colors.white)
        : Colors.grey[600]!;

    final effectiveBorderColor = widget.isEnabled
        ? (widget.borderColor ?? AppColors.secondaryVariant)
        : Colors.grey[500]!;

    return SizedBox(
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    // Sombra principal
                    BoxShadow(
                      color: effectiveBackgroundColor.withValues(alpha: 0.3),
                      blurRadius: _shadowAnimation.value,
                      offset: Offset(0, _shadowAnimation.value / 2),
                      spreadRadius: 1,
                    ),
                    // Sombra del borde
                    BoxShadow(
                      color: effectiveBorderColor.withValues(alpha: 0.2),
                      blurRadius: _shadowAnimation.value * 1.5,
                      offset: Offset(0, _shadowAnimation.value / 1.5),
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),

                    border: Border(
                      bottom: BorderSide(
                        color: effectiveBorderColor,
                        width: scale(6),
                      ),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: _isPressed
                          ? [
                              effectiveBackgroundColor.withValues(alpha: 0.8),
                              effectiveBackgroundColor,
                            ]
                          : [
                              effectiveBackgroundColor,
                              effectiveBackgroundColor.withValues(alpha: 0.9),
                            ],
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding:
                          widget.padding ??
                          const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 16,
                          ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: effectiveTextColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                widget.icon,
                                color: effectiveTextColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Flexible(
                            child: Text(
                              widget.text,
                              style: GoogleFonts.blackOpsOne().copyWith(
                                fontSize: widget.fontSize ?? 18,
                                fontWeight: FontWeight.w900,
                                color: effectiveTextColor,
                                letterSpacing: 0.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    offset: const Offset(0, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
