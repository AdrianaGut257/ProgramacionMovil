import 'package:flutter/material.dart';
import 'package:programacion_movil/features/presentation/widgets/home_header.dart';
import 'widgets/board_game.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            HomeHeader(),
            SizedBox(width: 20),
            Spacer(),
          ],
        ),
      ),
      body: const BoardGame(),
    );
  }
}
