import 'package:flutter/material.dart';
import 'widgets/board_game.dart';

class BoardPage extends StatelessWidget {
  final VoidCallback? onLetterSelected;

  const BoardPage({super.key, this.onLetterSelected});

  @override
  Widget build(BuildContext context) {
    return BoardGame(onLetterSelected: onLetterSelected);
  }
}
