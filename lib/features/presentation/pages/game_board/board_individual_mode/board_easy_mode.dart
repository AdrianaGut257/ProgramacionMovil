import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/chronometer.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/name.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board/board_page.dart';
import 'package:programacion_movil/features/presentation/widgets/game/ranking/ranking_game.dart';
import 'package:programacion_movil/features/presentation/pages/game_board/board_team_mode/widgets/category_popup.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/button_popup.dart';
import 'package:programacion_movil/features/presentation/pages/game_board/board_team_mode/widgets/end_game_button.dart';
import 'package:programacion_movil/features/presentation/state/game_individual.dart';
import 'package:provider/provider.dart';
import 'package:programacion_movil/features/presentation/utils/sound_manager.dart'; 

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePlayers();
      _showCategoryDialog();
    });
  }

  // 🧹 Limpiar sonido cuando se destruya el widget
  @override
  void dispose() {
    SoundManager.stopTimer();
    super.dispose();
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
      SoundManager.stopTimer(); // 🔊 Detener sonido al terminar
      return;
    }
    
    // 🔊 Detener sonido mientras se muestra el popup de categoría
    SoundManager.stopTimer();
    setState(() => chronometerActive = false);

    CategoryPopup.show(context, categories[currentCategoryIndex].name, () {
      setState(() {
        categoryShown = true;
        chronometerActive = true;
      });
      // 🔊 Iniciar sonido cuando comienza el turno
      SoundManager.playStartRound();
    });
  }

  void _nextPlayer() {
    if (gameEnded || players.isEmpty) return;
    final categories = context.read<GameIndividual>().categories;

    setState(() {
      totalLettersSelected++;
      if (totalLettersSelected >= totalLettersInAlphabet) {
        totalLettersSelected = 0;
        currentCategoryIndex++;
        categoryShown = false;
        chronometerActive = false;
        
        // 🔊 Detener sonido al cambiar de categoría
        SoundManager.stopTimer();

        if (currentCategoryIndex >= categories.length) {
          gameEnded = true;
          return;
        }

        Future.delayed(const Duration(milliseconds: 300), _showCategoryDialog);
        return;
      }

      currentPlayerIndex++;
      if (currentPlayerIndex >= players.length) currentPlayerIndex = 0;

      gameTime = const Duration(seconds: 10);
      hasSelectedLetter = false;
    });
    
    // 🔊 Reiniciar sonido DESPUÉS de que setState se complete
    // Usar un pequeño delay para asegurar que el estado esté actualizado
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!gameEnded && chronometerActive && mounted) {
        SoundManager.playStartRound();
      }
    });
  }

  void _increaseScore() {
    if (players.isEmpty) return;
    final currentPlayer = players[currentPlayerIndex];
    setState(() {
      playerScores[currentPlayer.name] =
          (playerScores[currentPlayer.name] ?? 0) + 5;
      hasSelectedLetter = false;
    });

    context.read<GameIndividual>().updatePlayerScore(
      currentPlayer.id!,
      playerScores[currentPlayer.name]!,
    );
  }

  void _onLetterSelected() {
    if (hasSelectedLetter) return;

    // 🔊 DETENER el sonido PRIMERO (antes del setState)
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
          setState(() => chronometerActive = true);
          _nextPlayer();
          // 🔊 El sonido se reinicia en _nextPlayer() con delay
        },
        onReset: () {
          setState(() => chronometerActive = true);
          _nextPlayer();
          // 🔊 El sonido se reinicia en _nextPlayer() con delay
        },
      ),
    );
  }

  void _endGame() {
    setState(() => gameEnded = true);
    // 🔊 Detener sonido al terminar el juego
    SoundManager.stopTimer();
    SoundManager.playWinners();
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
      // 🔊 Asegurarse de detener el sonido
      SoundManager.stopTimer();
      return RankingGame(playerScores: playerScores);
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SizedBox(height: isSmallScreen ? 20 : 30),

                      // Header con categoría y cronómetro en fila
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
                                    // ignore: deprecated_member_use
                                    color: AppColors.primary.withOpacity(0.3),
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

                          // Cronómetro compacto
                          ChronometerWidget(
                            key: ValueKey(
                              '${currentPlayer.id}-$totalLettersSelected',
                            ),
                            duration: gameTime,
                            onTimeEnd: () {
                              if (!hasSelectedLetter) _nextPlayer();
                            },
                            isActive: chronometerActive &&
                                !gameEnded &&
                                !hasSelectedLetter,
                          ),
                        ],
                      ),

                      SizedBox(height: isSmallScreen ? 20 : 25),

                      // Nombre del jugador centrado
                      PlayerNameWidget(
                        name: currentPlayer.name,
                        score: playerScores[currentPlayer.name] ?? 0,
                        team: 1,
                      ),

                      SizedBox(height: isSmallScreen ? 15 : 10),

                      ChronometerWidget(
                        key: ValueKey(
                          '${currentPlayer.id}-$totalLettersSelected',
                        ),
                        duration: gameTime,
                        onTimeEnd: () {
                          if (!hasSelectedLetter) {
                            // 🔊 Detener sonido cuando se acaba el tiempo
                            SoundManager.stopTimer();
                            
                            // Pequeño delay antes de pasar al siguiente
                            Future.delayed(const Duration(milliseconds: 50), () {
                              if (mounted) {
                                _nextPlayer();
                              }
                            });
                          }
                        },
                        isActive:
                            chronometerActive &&
                            !gameEnded &&
                            !hasSelectedLetter,
                      ),

                      SizedBox(height: isSmallScreen ? 25 : 35),

                      // Tablero de juego centrado
                      Center(
                        child: BoardPage(
                          key: ValueKey(
                            'board-${categories[currentCategoryIndex].name}',
                          ),
                          onLetterSelected: _onLetterSelected,
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 120 : 100),

                      // Botones de acción en fila horizontal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Botón siguiente categoría
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                SoundManager.stopTimer();
                                if (currentCategoryIndex < categories.length - 1) {
                                  setState(() {
                                    currentCategoryIndex++;
                                    totalLettersSelected = 0;
                                    categoryShown = false;
                                    chronometerActive = false;
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

                          // Botón terminar juego
                          Expanded(
                            child: EndGameButton(onPressed: _endGame),
                          ),
                        ],
                      ),

                      SizedBox(height: isSmallScreen ? 20 : 30),
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