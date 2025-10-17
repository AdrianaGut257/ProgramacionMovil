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
      currentLetters = availableLetters.take(8).toList();
      availableLetters.removeWhere((l) => currentLetters.contains(l));
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      _shuffleLetters();
    });
  }

  void _shuffleLetters() {
    setState(() {
      availableLetters.addAll(currentLetters);
      availableLetters.shuffle();
      currentLetters = availableLetters.take(8).toList();
      availableLetters.removeWhere((l) => currentLetters.contains(l));
    });
  }

  void _onLetterPressed(int index) {
    setState(() {
      currentLetters.removeAt(index);
      if (availableLetters.isNotEmpty) {
        final random = Random();
        final newIndex = random.nextInt(availableLetters.length);
        currentLetters.insert(index, availableLetters[newIndex]);
        availableLetters.removeAt(newIndex);
      }
      widget.onLetterSelected?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 140;

    return Column(
      children: [
        // Texto superior con diseño mejorado
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              // ignore: deprecated_member_use
              color: AppColors.primary.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_outlined,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Flexible(
                child:  Text(
                  "Cambia cada 7 seg",
                  style: GoogleFonts.poppins().copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),

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
                      // ignore: deprecated_member_use
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),

              // Letras distribuidas
              for (int i = 0; i < currentLetters.length; i++)
                Transform.translate(
                  offset: Offset(
                    radius * cos(2 * pi * i / currentLetters.length - pi / 2),
                    radius * sin(2 * pi * i / currentLetters.length - pi / 2),
                  ),
                  child: LetterTile(
                    letter: currentLetters[i],
                    onTap: () => _onLetterPressed(i),
                    availableLetters: availableLetters.length,
                  ),
                ),

              // Círculo central mejorado
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
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
      ],
    );
  }
}