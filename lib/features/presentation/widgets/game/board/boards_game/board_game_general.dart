import 'dart:math';
import 'package:flutter/material.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board/widgets/letter_tile.dart.dart';
import 'package:programacion_movil/config/colors.dart';

class BoardGame extends StatefulWidget {
  final VoidCallback? onLetterSelected;

  const BoardGame({super.key, this.onLetterSelected});

  @override
  State<BoardGame> createState() => _BoardGameState();
}

class _BoardGameState extends State<BoardGame> {
  List<String> availableLetters = [];
  List<String> currentLetters = [];

  final List<String> spanishAlphabet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'Ñ',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
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

      currentLetters = availableLetters.take(6).toList();

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
      widget.onLetterSelected?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double radius = 120; // radio del círculo

    return Column(
      children: [
        SizedBox(
          width: 360,
          height: 360,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Círculo morado de fondo
              Container(
                width: 380,
                height: 380,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
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

              // Círculo central
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
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
