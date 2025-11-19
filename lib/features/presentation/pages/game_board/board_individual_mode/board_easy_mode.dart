import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/chronometer.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/name.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board/board_page.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board/boards_game/board_game_wildcards.dart';
import 'package:programacion_movil/features/presentation/pages/game_board/board_team_mode/widgets/category_popup.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/button_popup.dart';
import 'package:programacion_movil/features/presentation/pages/game_board/board_team_mode/widgets/end_game_button.dart';
import 'package:programacion_movil/features/presentation/state/game_individual.dart';
import 'package:programacion_movil/features/presentation/widgets/game/ranking/screens/stopwords_winners_screen.dart';
import 'package:provider/provider.dart';
import 'package:programacion_movil/features/presentation/utils/sound_manager.dart';
import 'package:programacion_movil/data/datasources/app_database.dart';

class BoardEasyModePage extends StatefulWidget {
  const BoardEasyModePage({super.key});

  @override
  State<BoardEasyModePage> createState() => _BoardEasyModePageState();
}

class _BoardEasyModePageState extends State<BoardEasyModePage> {
  int currentPlayerIndex = 0;
  Duration gameTime = const Duration(seconds: 10);
  bool gameEnded = false;
  Map<String, int> playerScores = {};
  bool hasSelectedLetter = false;
  List<dynamic> players = [];
  int totalLettersSelected = 0;
  int currentCategoryIndex = 0;
  bool categoryShown = false;
  bool chronometerActive = false;
  static const int totalLettersInAlphabet = 27;

  bool hasWildcards = false;
  bool chronometerPaused = false;
  bool wasBlocked = false;
  bool doublePointsActive = false;
  int extraTimeSeconds = 0;
  int boardKey = 0;

  GlobalKey<ChronometerWidgetState> _chronometerKey =
      GlobalKey<ChronometerWidgetState>();
  final GlobalKey<BoardGameWildcardsState> _boardWildcardsKey =
      GlobalKey<BoardGameWildcardsState>();

  bool _gameSaved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkWildcards();
      _initializePlayers();
      _showCategoryDialog();
    });
  }

  @override
  void dispose() {
    SoundManager.stopTimer();
    super.dispose();
  }

  void _checkWildcards() {
    final wildcards = context.read<GameIndividual>().selectedWildcards;

    setState(() {
      hasWildcards = wildcards.isNotEmpty;
    });
  }

  void _initializePlayers() {
    final game = context.read<GameIndividual>();
    players = game.players;
    for (var p in players) {
      playerScores[p.name] = 0;
    }
    setState(() {});
  }

  void _showCategoryDialog() {
    final categories = context.read<GameIndividual>().categories;
    if (currentCategoryIndex >= categories.length) {
      setState(() => gameEnded = true);
      SoundManager.stopTimer();
      _saveGameToHistory();
      return;
    }
    SoundManager.stopTimer();
    setState(() => chronometerActive = false);

    CategoryPopup.show(context, categories[currentCategoryIndex].name, () {
      setState(() {
        categoryShown = true;
        chronometerActive = true;
      });
    });
  }

  void _nextPlayer() {
    if (gameEnded || players.isEmpty) return;
    final categories = context.read<GameIndividual>().categories;
    SoundManager.stopTimer();
    setState(() {
      totalLettersSelected++;

      if (hasWildcards &&
          _boardWildcardsKey.currentState?.isBoardEmpty == true) {
        totalLettersSelected = totalLettersInAlphabet;
      }

      if (wasBlocked) {
        _boardWildcardsKey.currentState?.unlockAllLetters();
        wasBlocked = false;
      }

      final boardState = _boardWildcardsKey.currentState;
      if (boardState != null && boardState.blockedLetterIndices.isNotEmpty) {
        wasBlocked = true;
      }

      if (totalLettersSelected >= totalLettersInAlphabet) {
        totalLettersSelected = 0;
        currentCategoryIndex++;
        categoryShown = false;
        chronometerActive = false;
        hasSelectedLetter = false;

        if (currentCategoryIndex >= categories.length) {
          gameEnded = true;
          _saveGameToHistory();
          return;
        }

        if (hasWildcards) {
          _boardWildcardsKey.currentState?.initializeWildcardPool();
          _boardWildcardsKey.currentState?.initializeGame();
        }

        Future.delayed(const Duration(milliseconds: 300), _showCategoryDialog);
        return;
      }

      currentPlayerIndex++;
      if (currentPlayerIndex >= players.length) currentPlayerIndex = 0;

      gameTime = const Duration(seconds: 10);
      hasSelectedLetter = false;
      doublePointsActive = false;

      _chronometerKey = GlobalKey<ChronometerWidgetState>();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!gameEnded && chronometerActive && mounted) {}
    });
  }

  void _increaseScore() {
    if (players.isEmpty) return;
    final currentPlayer = players[currentPlayerIndex];

    setState(() {
      int pointsToAdd = doublePointsActive ? 10 : 5;
      playerScores[currentPlayer.name] =
          (playerScores[currentPlayer.name] ?? 0) + pointsToAdd;
      hasSelectedLetter = false;
      doublePointsActive = false;
    });

    context.read<GameIndividual>().updatePlayerScore(
      currentPlayer.id!,
      playerScores[currentPlayer.name]!,
    );
  }

  void _addSkipTurnPoints() {
    if (players.isEmpty) return;
    final currentPlayer = players[currentPlayerIndex];

    setState(() {
      playerScores[currentPlayer.name] =
          (playerScores[currentPlayer.name] ?? 0) + 5;
    });

    context.read<GameIndividual>().updatePlayerScore(
      currentPlayer.id!,
      playerScores[currentPlayer.name]!,
    );
  }

  void _onLetterSelected() {
    if (hasSelectedLetter) return;
    SoundManager.stopTimer();

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
      SoundManager.stopTimer();
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

  void _onWildcardActivated(WildcardType type) {}

  void _onExtraTimeGranted(int seconds) {
    _chronometerKey.currentState?.addExtraTime(seconds);
  }

  void _endGame() {
    setState(() => gameEnded = true);
    SoundManager.stopTimer();
    SoundManager.playWinners();
    _saveGameToHistory();
  }

  Future<void> _saveGameToHistory() async {
    if (_gameSaved) {
      return;
    }

    try {
      final categories = context.read<GameIndividual>().categories;
      List<String> playedCategories = [];
      for (int i = 0; i <= currentCategoryIndex && i < categories.length; i++) {
        playedCategories.add(categories[i].name);
      }

      await AppDatabase.instance.saveGameHistory(
        gameMode: 'Easy Mode',
        playerScores: playerScores,
        categories: playedCategories,
      );

      _gameSaved = true;
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final isSmallScreen = height < 700;

    final categories = context.watch<GameIndividual>().categories;
    if (categories.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No hay categorías disponibles')),
      );
    }
    if (players.isEmpty) return const SizedBox();
    if (gameEnded) {
      SoundManager.stopTimer();
      return StopWordsWinnersScreen(playerScores: playerScores);
    }

    final currentPlayer = players[currentPlayerIndex];

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
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: isSmallScreen ? 10 : 20,
                  ),
                  child: Column(
                    children: [
                      // Header
                      SizedBox(height: isSmallScreen ? 10 : 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Categoría
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
                                    color: Colors.white,
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

                      SizedBox(height: isSmallScreen ? 10 : 20),

                      PlayerNameWidget(
                        name: currentPlayer.name,
                        score: playerScores[currentPlayer.name] ?? 0,
                        team: 1,
                      ),

                      SizedBox(height: isSmallScreen ? 10 : 15),

                      Center(
                        child: hasWildcards
                            ? BoardGameWildcards(
                                key: _boardWildcardsKey,
                                selectedWildcards: context
                                    .read<GameIndividual>()
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

                      SizedBox(height: height * 0.04),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                SoundManager.stopTimer();
                                final categories = context
                                    .read<GameIndividual>()
                                    .categories;
                                if (currentCategoryIndex <
                                    categories.length - 1) {
                                  setState(() {
                                    currentCategoryIndex++;
                                    totalLettersSelected = 0;
                                    categoryShown = false;
                                    chronometerActive = false;
                                    hasSelectedLetter = false;
                                    if (hasWildcards) {
                                      _boardWildcardsKey.currentState
                                          ?.initializeWildcardPool();
                                      _boardWildcardsKey.currentState
                                          ?.initializeGame();
                                    }
                                  });
                                  _showCategoryDialog();
                                } else {
                                  _endGame();
                                }
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

                      SizedBox(height: height * 0.03),
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
