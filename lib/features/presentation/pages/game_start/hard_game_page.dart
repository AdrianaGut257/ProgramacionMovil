import 'package:flutter/material.dart';
import 'easy_game_page.dart';

/// Reutiliza EasyGamePage pero configurado a 5 segundos
class HardGamePage extends StatelessWidget {
  final List<String>? players;
  final List<String>? categories;

  const HardGamePage({
    super.key,
    this.players,
    this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return EasyGamePage(
      players: players,
      categories: categories,
      startAsEasy: false, // 👈 usamos false para que corra en 5s
    );
  }
}
