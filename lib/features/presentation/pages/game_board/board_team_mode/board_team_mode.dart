import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/chronometer.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/name.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board/board_page.dart';
import 'package:programacion_movil/features/presentation/widgets/game/ranking/ranking_game.dart';
import 'package:programacion_movil/features/presentation/pages/game_board/board_team_mode/widgets/category_popup.dart';
import 'package:provider/provider.dart';
import 'package:programacion_movil/features/presentation/state/game_team.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/button_popup.dart';
import 'package:programacion_movil/features/presentation/pages/game_board/board_team_mode/widgets/end_game_button.dart';

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
  bool hasSelectedLetter = false;
  List<dynamic> orderedPlayers = [];
  int totalLettersSelected = 0;
  static const int totalLettersInAlphabet = 27;

  int currentCategoryIndex = 0;
  bool categoryShown = false;
  bool chronometerActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeOrderedPlayers();
      _showCategoryDialog();
    });
  }

  void _initializeOrderedPlayers() {
    final players = context.read<GameTeam>().players;

    final team1Players = players.where((p) => p.team == 1).toList();
    final team2Players = players.where((p) => p.team == 2).toList();

    orderedPlayers = [];
    final maxLength = team1Players.length > team2Players.length
        ? team1Players.length
        : team2Players.length;

    for (int i = 0; i < maxLength; i++) {
      if (i < team1Players.length) {
        orderedPlayers.add(team1Players[i]);
        playerScores[team1Players[i].name] = 0;
      }
      if (i < team2Players.length) {
        orderedPlayers.add(team2Players[i]);
        playerScores[team2Players[i].name] = 0;
      }
    }

    setState(() {});
  }

  void _showCategoryDialog() {
    final categories = context.read<GameTeam>().categories;

    if (currentCategoryIndex >= categories.length) {
      setState(() => gameEnded = true);
      return;
    }

    setState(() => chronometerActive = false);

    CategoryPopup.show(context, categories[currentCategoryIndex].name, () {
      setState(() {
        categoryShown = true;
        chronometerActive = true;
      });
    });
  }

  void _nextPlayer() {
    if (gameEnded || orderedPlayers.isEmpty) return;

    final categories = context.read<GameTeam>().categories;

    setState(() {
      totalLettersSelected++;

      if (totalLettersSelected >= totalLettersInAlphabet) {
        totalLettersSelected = 0;
        currentCategoryIndex++;
        categoryShown = false;
        chronometerActive = false;

        if (currentCategoryIndex >= categories.length) {
          gameEnded = true;
          return;
        }

        Future.delayed(const Duration(milliseconds: 300), () {
          _showCategoryDialog();
        });
        return;
      }

      currentPlayerIndex++;
      if (currentPlayerIndex >= orderedPlayers.length) {
        currentPlayerIndex = 0;
      }

      score = playerScores[orderedPlayers[currentPlayerIndex].name] ?? 0;
      gameTime = const Duration(seconds: 5);
      hasSelectedLetter = false;
    });
  }

  void _increaseScore() {
    if (orderedPlayers.isEmpty) return;

    final currentPlayer = orderedPlayers[currentPlayerIndex];
    final playerName = currentPlayer.name;

    setState(() {
      score += 5;
      playerScores[playerName] = (playerScores[playerName] ?? 0) + 5;
      hasSelectedLetter = false;
    });

    final gameTeam = context.read<GameTeam>();
    final player = gameTeam.players.firstWhere((p) => p.name == playerName);
    gameTeam.updatePlayerScore(player.id!, playerScores[playerName]!);
  }

  void _onLetterSelected() {
    if (hasSelectedLetter) return;

    setState(() {
      hasSelectedLetter = true;
      chronometerActive = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ButtonPopup(
        onCorrect: () {
          _increaseScore();
          _nextPlayer();
          setState(() {
            chronometerActive = true;
          });
        },
        onReset: () {
          _nextPlayer();
          setState(() {
            chronometerActive = true;
          });
        },
      ),
    );
  }

  void _endGame() {
    setState(() {
      gameEnded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<GameTeam>().categories;
    if (categories.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No hay categorías disponibles')),
      );
    }

    if (orderedPlayers.isEmpty) return const SizedBox();

    if (gameEnded) return RankingGame(playerScores: playerScores);

    final currentPlayer = orderedPlayers[currentPlayerIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 80),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF615AC7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF615AC7), width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.category_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    categories[currentCategoryIndex].name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PlayerNameWidget(
              name: currentPlayer.name,
              score: score,
              team: currentPlayer.team,
            ),
            const SizedBox(height: 20),
            ChronometerWidget(
              key: ValueKey('${currentPlayer.id}-$totalLettersSelected'),
              duration: gameTime,
              onTimeEnd: () {
                debugPrint("Tiempo terminado para ${currentPlayer.name}");
                if (!hasSelectedLetter) {
                  _nextPlayer();
                }
              },
              isActive: chronometerActive && !gameEnded && !hasSelectedLetter,
            ),
            const SizedBox(height: 20),
            Center(
              child: BoardPage(
                key: ValueKey('board-${categories[currentCategoryIndex].name}'),
                onLetterSelected: _onLetterSelected,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                final categories = context.read<GameTeam>().categories;
                setState(() {
                  if (currentCategoryIndex < categories.length - 1) {
                    currentCategoryIndex++;
                    totalLettersSelected = 0;
                    categoryShown = false;
                    chronometerActive = false;
                    _showCategoryDialog();
                  } else {
                    gameEnded = true;
                  }
                });
              },
              icon: const Icon(Icons.skip_next, color: Colors.white),
              label: const Text(
                "Siguiente categoría",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            EndGameButton(onPressed: _endGame),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
