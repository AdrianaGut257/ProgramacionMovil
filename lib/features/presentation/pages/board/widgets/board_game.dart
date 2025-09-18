import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:programacion_movil/features/presentation/pages/board/widgets/letter_tile.dart.dart';
import 'package:programacion_movil/features/presentation/widgets/home_header.dart';

class BoardGame extends StatefulWidget {
  const BoardGame({super.key});

  @override
  State<BoardGame> createState() => _BoardGameState();
}

class _BoardGameState extends State<BoardGame> {
  List<String> availableLetters = [];
  List<String> currentLetters = [];

  final List<String> spanishAlphabet = [
    'A', 'B', 'C', 'D', 'E', 'F',
    'G', 'H', 'I', 'J', 'K', 'L',
    'M', 'N', 'Ñ', 'O', 'P', 'Q',
    'R', 'S', 'T', 'U', 'V', 'W',
    'X', 'Y', 'Z',
  ];

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    setState(() {
      availableLetters = List.from(spanishAlphabet);
      availableLetters.shuffle();

      // Escoger 6 letras aleatorias
      currentLetters = availableLetters.take(6).toList();

      // Quitarlas de la lista
      for (var letter in currentLetters) {
        availableLetters.remove(letter);
      }
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final double radius = 95; // radio del círculo

    return Column(
      children: [
        HomeHeader(title: "StopWords"),
        const SizedBox(height: 30),

        Text(
          'Selecciona una letra',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.3, end: 0),

        const SizedBox(height: 30),

        // Círculo de fondo + letras
        SizedBox(
          width: 290,
          height: 290,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Círculo morado de fondo
              Container(
                width: 290,
                height: 290,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 122, 115, 212),
                  shape: BoxShape.circle,
                ),
              ),

              // Letras en círculo
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

              // Círculo central decorativo
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: CircleAvatar(
                    radius: 12,
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
