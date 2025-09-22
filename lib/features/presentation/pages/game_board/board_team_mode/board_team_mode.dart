import 'package:flutter/material.dart';
import 'package:programacion_movil/features/presentation/widgets/game/chronometer.dart';
import 'package:programacion_movil/features/presentation/widgets/game/buttons.dart';
import 'package:programacion_movil/features/presentation/widgets/game/name.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board/board_page.dart';
import 'package:programacion_movil/features/presentation/pages/home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:programacion_movil/features/presentation/state/game_team.dart';
import 'package:programacion_movil/config/colors.dart';

class BoardTeamModePage extends StatefulWidget {
  const BoardTeamModePage({super.key});

  @override
  State<BoardTeamModePage> createState() => _BoardTeamModePageState();
}

class _BoardTeamModePageState extends State<BoardTeamModePage> {
  int score = 0;
  int currentPlayerIndex = 0;
  Duration gameTime = const Duration(seconds: 5);

  void _increaseScore() {
    setState(() {
      score++;
    });
  }

  void _nextPlayer() {
    final players = context.read<GameTeam>().players;
    setState(() {
      currentPlayerIndex++;
      if (currentPlayerIndex >= players.length) {
        currentPlayerIndex = 0;
      }
      score = 0;
      gameTime = const Duration(seconds: 5);
    });
  }

  @override
  Widget build(BuildContext context) {
    final players = context.watch<GameTeam>().players;
    if (players.isEmpty) return const SizedBox(); // seguridad

    final currentPlayer = players[currentPlayerIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: IconButton(
                  onPressed: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const HomePage())),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  tooltip: 'Volver',
                  color: AppColors.textPrimary,
                  splashRadius: 24,
                ),
              ),
            ),

            const SizedBox(height: 50),

            // Mostrar solo el jugador actual
            PlayerNameWidget(
              name: currentPlayer.name,
              score: score,
              team: currentPlayer.team,
            ),

            const SizedBox(height: 20),

            ChronometerWidget(
              duration: gameTime,
              onTimeEnd: () {
                debugPrint("⏰ Tiempo terminado para ${currentPlayer.name}");
                _nextPlayer(); // pasa al siguiente jugador
              },
            ),

            const SizedBox(height: 20),
            Center(child: BoardPage()),
            const SizedBox(height: 20),
            GameButtons(onCorrect: _increaseScore, onReset: _nextPlayer),
          ],
        ),
      ),
    );
  }
}
