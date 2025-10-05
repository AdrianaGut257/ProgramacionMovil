import 'package:flutter/material.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/chronometer.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/name.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board/board_page.dart';
import 'package:programacion_movil/features/presentation/widgets/game/ranking/ranking_game.dart';
import 'package:programacion_movil/features/presentation/pages/game_board/board_team_mode/widgets/category_popup.dart';
import 'package:provider/provider.dart';
import 'package:programacion_movil/features/presentation/state/game_team.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/button_popup.dart';

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

  List<String> categories = ['Frutas', 'Países', 'Vegetales'];
  int currentCategoryIndex = 0;
  bool categoryShown = false;

  @override
  void initState() {
    super.initState();
    categories.shuffle();
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
    if (currentCategoryIndex >= categories.length) {
      setState(() {
        gameEnded = true;
      });
      return;
    }

    CategoryPopup.show(context, categories[currentCategoryIndex], () {
      setState(() {
        categoryShown = true;
      });
    });
  }

  void _increaseScore() {
    if (orderedPlayers.isEmpty) return;
    final currentPlayer = orderedPlayers[currentPlayerIndex];

    setState(() {
      score += 5;
      playerScores[currentPlayer.name] =
          (playerScores[currentPlayer.name] ?? 0) + 5;
      hasSelectedLetter = false;
    });
  }

  void _nextPlayer() {
    if (gameEnded || orderedPlayers.isEmpty) return;

    setState(() {
      totalLettersSelected++;

      if (totalLettersSelected >= totalLettersInAlphabet) {
        totalLettersSelected = 0;
        currentCategoryIndex++;
        categoryShown = false;

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

  void _onLetterSelected() {
    if (hasSelectedLetter) return;

    setState(() {
      hasSelectedLetter = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ButtonPopup(
        onCorrect: () {
          _increaseScore();
          _nextPlayer();
        },
        onReset: () {
          _nextPlayer();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (orderedPlayers.isEmpty) return const SizedBox();

    if (gameEnded) {
      return RankingGame(playerScores: playerScores);
    }

    final currentPlayer = orderedPlayers[currentPlayerIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
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
                    categories[currentCategoryIndex].toUpperCase(),
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
              isActive: !gameEnded && !hasSelectedLetter,
            ),
            const SizedBox(height: 20),
            Center(child: BoardPage(onLetterSelected: _onLetterSelected)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
