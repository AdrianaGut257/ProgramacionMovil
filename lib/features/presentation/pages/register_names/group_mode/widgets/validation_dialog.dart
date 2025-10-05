import 'package:flutter/material.dart';
import '../../../../../../config/colors.dart';

enum ValidationType {
  unequalTeams,
  oddPlayers,
  minPlayers,
  duplicateNames,
  noPlayers,
}

class ValidationDialog extends StatelessWidget {
  final String message;
  final ValidationType type;

  const ValidationDialog({
    super.key,
    required this.message,
    required this.type,
  });

  static void show(BuildContext context, String message, ValidationType type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ValidationDialog(message: message, type: type),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case ValidationType.unequalTeams:
        return Icons.balance;
      case ValidationType.oddPlayers:
        return Icons.groups_outlined;
      case ValidationType.minPlayers:
        return Icons.person_add_alt_1;
      case ValidationType.duplicateNames:
        return Icons.content_copy;
      case ValidationType.noPlayers:
        return Icons.person_off_outlined;
    }
  }

  Color _getColor() {
    switch (type) {
      case ValidationType.unequalTeams:
      case ValidationType.oddPlayers:
        return AppColors.primary;
      case ValidationType.minPlayers:
      case ValidationType.noPlayers:
        return AppColors.secondary;
      case ValidationType.duplicateNames:
        return AppColors.errorPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final icon = _getIcon();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, size: 48, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              '¡Atención!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Entendido',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
