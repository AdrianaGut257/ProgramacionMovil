import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
      currentLetters = ['A', 'O', 'U', 'R', 'N', 'D'];
      for (String letter in currentLetters) {
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
    final double radius = 120; 

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

        const SizedBox(height: 50),


        SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              for (int i = 0; i < currentLetters.length; i++)
                Transform.translate(
                  offset: Offset(
                    radius * cos(2 * pi * i / currentLetters.length - pi / 2),
                    radius * sin(2 * pi * i / currentLetters.length - pi / 2),
                  ),
                  child: _buildLetterTile(i),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLetterTile(int index) {
    return GestureDetector(
      onTap: () => _onLetterPressed(index),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                      color: Colors.blue,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
        ),
        child: Center(
          child: Text(
            currentLetters[index],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      )
          // Animaciones (igual que antes)
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.05, 1.05),
            duration: 1000.ms,
            curve: Curves.easeInOut,
          )
          .then()
          .animate(
            delay: 200.ms * index, // Stagger
          )
          .fadeIn(duration: 500.ms)
          .slideY(begin: 0.5, end: 0, curve: Curves.easeOutBack),
    );
  }
}
