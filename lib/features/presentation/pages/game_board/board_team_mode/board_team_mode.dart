import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/chronometer.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/name.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board/board_page.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board/boards_game/board_game_wildcards.dart';
import 'package:programacion_movil/features/presentation/widgets/game/ranking/ranking_game.dart';
import 'package:programacion_movil/features/presentation/pages/game_board/board_team_mode/widgets/category_popup.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/button_popup.dart';
import 'package:programacion_movil/features/presentation/pages/game_board/board_team_mode/widgets/end_game_button.dart';
import 'package:programacion_movil/features/presentation/state/game_team.dart';
import 'package:provider/provider.dart';

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
  bool hasWildcards = false;
  int chronometerKey = 0;
  int chronometerUpdateKey = 0;
  bool chronometerPaused = false;
  int boardKey = 0;
  bool shouldUnblockLetters = false;
  bool wasBlocked = false;
  bool doublePointsActive = false;
  int extraTimeSeconds = 0;
  GlobalKey<ChronometerWidgetState> _chronometerKey =
      GlobalKey<ChronometerWidgetState>();

  final GlobalKey<BoardGameWildcardsState> _boardWildcardsKey =
      GlobalKey<BoardGameWildcardsState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkWildcards();
      _initializeOrderedPlayers();
      _showCategoryDialog();
    });
  }

  void _checkWildcards() {
    final wildcards = context.read<GameTeam>().selectedWildcards;

    setState(() {
      hasWildcards = wildcards.isNotEmpty;
    });
    debugPrint('Comodines cargados: $wildcards');
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

      if (wasBlocked) {
        _boardWildcardsKey.currentState?.unlockAllLetters();
        wasBlocked = false;
      }

      final boardState = _boardWildcardsKey.currentState;
      if (boardState != null && boardState.blockedLetterIndices.isNotEmpty) {
        wasBlocked = true;
      }

      if (totalLettersSelected >= totalLettersInAlphabet) {
        currentCategoryIndex++;
        categoryShown = false;
        chronometerActive = false;
        hasSelectedLetter = false;

        if (currentCategoryIndex >= categories.length) {
          gameEnded = true;
          return;
        }

        if (hasWildcards) {
          _boardWildcardsKey.currentState?.initializeWildcardPool();
          _boardWildcardsKey.currentState?.initializeGame();
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

      _chronometerKey = GlobalKey<ChronometerWidgetState>();
      hasSelectedLetter = false;
      doublePointsActive = false;
    });
  }

  void _increaseScore() {
    if (orderedPlayers.isEmpty) return;

    final currentPlayer = orderedPlayers[currentPlayerIndex];
    final playerName = currentPlayer.name;

    setState(() {
      int pointsToAdd = doublePointsActive ? 10 : 5;
      score += pointsToAdd;
      playerScores[playerName] = (playerScores[playerName] ?? 0) + pointsToAdd;
      hasSelectedLetter = false;
      doublePointsActive = false;
    });

    final gameTeam = context.read<GameTeam>();
    final player = gameTeam.players.firstWhere((p) => p.name == playerName);
    gameTeam.updatePlayerScore(player.id!, playerScores[playerName]!);
  }

  void _addSkipTurnPoints() {
    if (orderedPlayers.isEmpty) return;

    final currentPlayer = orderedPlayers[currentPlayerIndex];
    final playerName = currentPlayer.name;

    setState(() {
      score += 5;
      playerScores[playerName] = (playerScores[playerName] ?? 0) + 5;
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
            boardKey++;
          });
        },
        onReset: () {
          _nextPlayer();
          setState(() {
            chronometerActive = true;
            boardKey++;
          });
        },
      ),
    );
  }

  void _pauseChronometer() {
    setState(() {
      chronometerActive = false;
      chronometerPaused = true;
    });
  }

  void _resumeChronometer() {
    setState(() {
      chronometerActive = true;
      chronometerPaused = false;
    });
  }

  void _onWildcardActivated(WildcardType type) {
    debugPrint('Comodín activado: $type');
  }

  void _onExtraTimeGranted(int seconds) {
    _chronometerKey.currentState?.addExtraTime(seconds);
  }

  void _endGame() {
    setState(() {
      gameEnded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final isSmallScreen = height < 700;

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SizedBox(height: isSmallScreen ? 20 : 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.category_rounded,
                                    color: AppColors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      categories[currentCategoryIndex].name
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          ChronometerWidget(
                            key: _chronometerKey,
                            duration: Duration(
                              seconds: gameTime.inSeconds + extraTimeSeconds,
                            ),

                            onTimeEnd: () {
                              debugPrint(
                                "Tiempo terminado para ${currentPlayer.name}",
                              );
                              if (!hasSelectedLetter) {
                                _nextPlayer();
                              }
                            },
                            isActive:
                                chronometerActive &&
                                !gameEnded &&
                                !hasSelectedLetter,
                          ),
                        ],
                      ),

                      SizedBox(height: isSmallScreen ? 20 : 25),

                      PlayerNameWidget(
                        name: currentPlayer.name,
                        score: score,
                        team: currentPlayer.team,
                      ),

                      SizedBox(height: isSmallScreen ? 25 : 35),

                      Center(
                        child: hasWildcards
                            ? BoardGameWildcards(
                                key: _boardWildcardsKey,
                                selectedWildcards: context
                                    .read<GameTeam>()
                                    .selectedWildcards,
                                onLetterSelected: _onLetterSelected,
                                onWildcardActivated: _onWildcardActivated,
                                onExtraTimeGranted: _onExtraTimeGranted,
                                onSkipTurn: _nextPlayer,
                                onSkipTurnPoints: _addSkipTurnPoints,
                                onDoublePointsActivated: () {
                                  setState(() {
                                    doublePointsActive = true;
                                  });
                                },
                                onPauseChronometer: _pauseChronometer,
                                onResumeChronometer: _resumeChronometer,
                              )
                            : BoardPage(
                                key: ValueKey(
                                  'board-${categories[currentCategoryIndex].name}',
                                ),
                                onLetterSelected: _onLetterSelected,
                              ),
                      ),

                      SizedBox(height: isSmallScreen ? 120 : 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                final categories = context
                                    .read<GameTeam>()
                                    .categories;
                                setState(() {
                                  if (currentCategoryIndex <
                                      categories.length - 1) {
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
                              icon: const Icon(
                                Icons.skip_next,
                                color: Colors.white,
                                size: 20,
                              ),
                              label: const Text(
                                "Siguiente",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 3,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(child: EndGameButton(onPressed: _endGame)),
                        ],
                      ),

                      SizedBox(height: isSmallScreen ? 80 : 90),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
