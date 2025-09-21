import 'package:flutter/material.dart';
import 'custom_button.dart';

class PowerUpButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const PowerUpButton({
    super.key,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: enabled ? "Comodines activados" : "Comodines desactivados",
      icon: Icons.extension,
      backgroundColor: enabled ? Colors.yellow[700] : Colors.grey[700],
      textColor: Colors.white,
      borderColor: enabled ? Colors.yellow[900]! : Colors.black54,
      onPressed: onPressed,
    );
  }
}
