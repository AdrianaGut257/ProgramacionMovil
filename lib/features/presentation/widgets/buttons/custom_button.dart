import 'package:flutter/material.dart';
import '../../../../config/colors.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isHovered
                ? (widget.backgroundColor ?? AppColors.secondaryVariant)
                : widget.backgroundColor ?? AppColors.secondary,
            borderRadius: BorderRadius.circular(25),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: (widget.backgroundColor ?? AppColors.secondary),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                      spreadRadius: 2,
                    ),
                    const BoxShadow(
                      color: AppColors.secondaryVariant,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                : [
                    const BoxShadow(
                      color: AppColors.secondaryVariant,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: widget.onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: _isHovered ? 18.5 : 18,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor ?? Colors.white,
                    ),
                    child: Text(widget.text),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
