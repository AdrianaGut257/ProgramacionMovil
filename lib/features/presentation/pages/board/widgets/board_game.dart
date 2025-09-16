import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BoardGame extends StatefulWidget {
  const BoardGame({super.key});

  @override
  State<BoardGame> createState() => _BoardGameState();
}

class _BoardGameState extends State<BoardGame> {
  List<String> availableLetters = [];
  List<String> currentLetters = [];
  final List<String> spanishAlphabet = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'Ñ', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
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

  List<String> _getRandomLetters(int count) {
    final random = Random();
    final List<String> randomLetters = [];
    
    for (int i = 0; i < count; i++) {
      if (availableLetters.isEmpty) break;
      
      final index = random.nextInt(availableLetters.length);
      randomLetters.add(availableLetters[index]);
      availableLetters.removeAt(index);
    }
    
    return randomLetters;
  }

  void _onLetterPressed(int index) {
    setState(() {
      final removedLetter = currentLetters.removeAt(index);
      
  
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
    return Column(
      children: [
     
        Text(
          'StopWords',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
          ),
        ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.5, end: 0),
        
        SizedBox(height: 20),
        
        // Título "Requests"
        Text(
          'Requests',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.3, end: 0),
        
        SizedBox(height: 40),
        
 
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 4; i++)
              if (i < currentLetters.length)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: _buildLetterTile(i),
                ),
          ],
        ),
        
        SizedBox(height: 20),
        
       
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 4; i < currentLetters.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: _buildLetterTile(i),
              ),
          ],
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
          color: availableLetters.isNotEmpty 
              ? Colors.blue 
              : Colors.blue.withOpacity(0.5),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
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
      .animate(
        onPlay: (controller) => controller.repeat(reverse: true),
      )
      .scale(
        begin: const Offset(1, 1),
        end: const Offset(1.05, 1.05),
        duration: 1000.ms,
        curve: Curves.easeInOut,
      )
      .then()
      .animate(
        delay: 200.ms * index, // Escalonar las animaciones
      )
      .fadeIn(duration: 500.ms)
      .slideY(begin: 0.5, end: 0, curve: Curves.easeOutBack),
    );
  }
}