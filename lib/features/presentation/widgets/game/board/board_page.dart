import 'package:flutter/material.dart';
import 'boards_game/board_game_general.dart';

class BoardPage extends StatelessWidget {
  final VoidCallback? onLetterSelected;

  const BoardPage({super.key, this.onLetterSelected});

  @override
  Widget build(BuildContext context) {
    return BoardGame(onLetterSelected: onLetterSelected);
  }
}
