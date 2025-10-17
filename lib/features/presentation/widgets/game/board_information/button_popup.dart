import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import '../../../utils/sound_manager.dart';
import 'buttons.dart';

class ButtonPopup extends StatelessWidget {
  final VoidCallback onCorrect;
  final VoidCallback onReset;
  final String title;

  const ButtonPopup({
    super.key,
    required this.onCorrect,
    required this.onReset,
    this.title = "Valida la respuesta",
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.indigo.shade50,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icono decorativo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade100,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.quiz_rounded,
                  size: 32,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 20),

              // Título
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 5),

              // Línea decorativa
              Container(
                height: 2,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Botones del juego
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                padding: const EdgeInsets.all(16),
                child: GameButtons(
                  onCorrect: () {
                    onCorrect();
                    SoundManager.playSuccess();
                    Navigator.of(context).pop();
                  },
                  onReset: () {
                    onReset();
                    SoundManager.playError();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
