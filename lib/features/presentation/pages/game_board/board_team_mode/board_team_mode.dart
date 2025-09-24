import 'package:flutter/material.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/chronometer.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/buttons.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/name.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board/board_page.dart';
import 'package:programacion_movil/features/presentation/widgets/game/ranking/ranking_game.dart';
import 'package:provider/provider.dart';
import 'package:programacion_movil/features/presentation/state/game_team.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:go_router/go_router.dart';

class BoardTeamModePage extends StatefulWidget {
  const BoardTeamModePage({super.key});

  @override
  State<BoardTeamModePage> createState() => _BoardTeamModePageState();
}

class _BoardTeamModePageState extends State<BoardTeamModePage> {
  int score = 0;
  int currentPlayerIndex = 0;
  Duration gameTime = const Duration(seconds: 5);
  bool gameEnded = false;
  Map<String, int> playerScores = {};

  void _increaseScore() {
    final players = context.read<GameTeam>().players;
    final currentPlayer = players[currentPlayerIndex];

    setState(() {
      score++;
      playerScores[currentPlayer.name] = score;
    });
  }

  void _nextPlayer() {
    final players = context.read<GameTeam>().players;

    if (gameEnded) return;

    setState(() {
      // Guardar el puntaje final del jugador actual
      final currentPlayer = players[currentPlayerIndex];
      playerScores[currentPlayer.name] = score;

      currentPlayerIndex++;

      if (currentPlayerIndex >= players.length) {
        gameEnded = true;
        return;
      }

      score = 0;
      gameTime = const Duration(seconds: 5);
    });
  }

  @override
  Widget build(BuildContext context) {
    final players = context.watch<GameTeam>().players;

    if (players.isEmpty) return const SizedBox();

    if (gameEnded || currentPlayerIndex >= players.length) {
      return RankingGame(playerScores: playerScores);
    }

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
                  onPressed: () {
                    context.push('/home');
                  },
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  tooltip: 'Volver',
                  color: AppColors.textPrimary,
                  splashRadius: 24,
                ),
              ),
            ),
            const SizedBox(height: 50),

            PlayerNameWidget(
              name: currentPlayer.name,
              score: score,
              team: currentPlayer.team,
            ),

            const SizedBox(height: 20),

            ChronometerWidget(
              key: ValueKey(currentPlayer.id),
              duration: gameTime,
              onTimeEnd: () {
                debugPrint("Tiempo terminado para ${currentPlayer.name}");
                _nextPlayer();
              },
              isActive: !gameEnded,
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
