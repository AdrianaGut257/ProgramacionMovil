import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board/widgets/letter_tile.dart.dart';

class BoardGameHard extends StatefulWidget {
  final VoidCallback? onLetterSelected;

  const BoardGameHard({super.key, this.onLetterSelected});

  @override
  State<BoardGameHard> createState() => _BoardGameHardState();
}

class _BoardGameHardState extends State<BoardGameHard> {
  List<String> availableLetters = [];
  List<String> currentLetters = [];
  List<String> usedLetters = [];
  Timer? _timer;

  final List<String> spanishAlphabet = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K',
    'L', 'M', 'N', 'Ñ', 'O', 'P', 'Q', 'R', 'S', 'T', 'U',
    'V', 'W', 'X', 'Y', 'Z',
  ];

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeGame() {
    setState(() {
      availableLetters = List.from(spanishAlphabet)..shuffle();
      currentLetters = availableLetters.take(6).toList();
      availableLetters.removeWhere((l) => currentLetters.contains(l));
      usedLetters.clear();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (availableLetters.isEmpty) {
        timer.cancel();
      } else {
        _shuffleLetters();
      }
    });
  }

  void _shuffleLetters() {
    setState(() {
      availableLetters.addAll(currentLetters);
      availableLetters.removeWhere((l) => usedLetters.contains(l)); // filtra usadas
      availableLetters.shuffle();

      if (availableLetters.length >= 6) {
        currentLetters = availableLetters.take(6).toList();
      } else {
        currentLetters = availableLetters;
      }

      availableLetters.removeWhere((l) => currentLetters.contains(l));
    });
  }

  void _onLetterPressed(int index) {
    if (availableLetters.isEmpty && currentLetters.isEmpty) return;

    setState(() {
      String removedLetter = currentLetters.removeAt(index);
      usedLetters.add(removedLetter);

      availableLetters.removeWhere((l) => usedLetters.contains(l)); // quita usadas

      if (availableLetters.isNotEmpty) {
        final random = Random();
        final newIndex = random.nextInt(availableLetters.length);
        currentLetters.insert(index, availableLetters[newIndex]);
        availableLetters.removeAt(newIndex);
      }

      widget.onLetterSelected?.call();
    });

    // Efecto de vibración visual leve para feedback
    _animateLetterTap();
  }

  void _animateLetterTap() {
    // Simple animación de rebote al pulsar una letra
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 140;

    return Column(
      children: [
 
        // Tablero circular
        SizedBox(
          width: 400,
          height: 400,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Fondo circular con sombra
              Container(
                width: 420,
                height: 420,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),

              // Letras distribuidas circularmente
              for (int i = 0; i < currentLetters.length; i++)
                Transform.translate(
                  offset: Offset(
                    radius * cos(2 * pi * i / currentLetters.length - pi / 2),
                    radius * sin(2 * pi * i / currentLetters.length - pi / 2),
                  ),
                  child: AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: LetterTile(
                      letter: currentLetters[i],
                      onTap: () => _onLetterPressed(i),
                      availableLetters: availableLetters.length,
                    ),
                  ),
                ),

              // Círculo central
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.yellow,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Mensaje final cuando ya no quedan letras
        if (availableLetters.isEmpty && currentLetters.isEmpty)
          Text(
            "¡No quedan más letras!",
            style: GoogleFonts.poppins().copyWith(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
      ],
    );
  }
}
