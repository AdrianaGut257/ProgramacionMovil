import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board/boards_game/board_hardgame.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/chronometer.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/name.dart';
import 'package:programacion_movil/features/presentation/widgets/game/ranking/ranking_game.dart';
import 'package:programacion_movil/features/presentation/pages/game_board/board_team_mode/widgets/category_popup.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/button_popup.dart';
import 'package:programacion_movil/features/presentation/pages/game_board/board_team_mode/widgets/end_game_button.dart';
import 'package:programacion_movil/features/presentation/state/game_individual.dart';
import 'package:provider/provider.dart';

class BoardHardModePage extends StatefulWidget {
  const BoardHardModePage({super.key});

  @override
  State<BoardHardModePage> createState() => _BoardHardModePageState();
}

class _BoardHardModePageState extends State<BoardHardModePage> {
  int currentPlayerIndex = 0;
  Duration gameTime = const Duration(seconds: 5);
  bool gameEnded = false;
  Map<String, int> playerScores = {};
  bool hasSelectedLetter = false;
  List<dynamic> players = [];
  List<dynamic> activePlayers = [];
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

  void _initializePlayers() {
    final game = context.read<GameIndividual>();
    players = game.players;
    activePlayers = List.from(players);
    for (var p in players) {
      playerScores[p.name] = 0;
    }
    setState(() {});
  }

  void _showCategoryDialog() {
    final categories = context.read<GameIndividual>().categories;
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

  void _eliminateCurrentPlayer() {
    if (activePlayers.isEmpty || gameEnded) return;

    final eliminatedPlayer = activePlayers[currentPlayerIndex];
    
    setState(() {
      activePlayers.removeAt(currentPlayerIndex);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${eliminatedPlayer.name} ha sido eliminado ❌'),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 2),
        ),
      );

      // Si no quedan jugadores activos, terminar el juego
      if (activePlayers.isEmpty) {
        gameEnded = true;
        return;
      }

      // Ajustar el índice si está fuera de rango
      if (currentPlayerIndex >= activePlayers.length) {
        currentPlayerIndex = 0;
      }

      // Reiniciar turno para el siguiente jugador
      gameTime = const Duration(seconds: 5);
      hasSelectedLetter = false;
      chronometerActive = true;
    });
  }

  void _nextPlayer() {
    if (gameEnded || activePlayers.isEmpty) return;
    final categories = context.read<GameIndividual>().categories;

    setState(() {
      totalLettersSelected++;

      // Si se completaron todas las letras del alfabeto, cambiar de categoría
      if (totalLettersSelected >= totalLettersInAlphabet) {
        totalLettersSelected = 0;
        currentCategoryIndex++;
        categoryShown = false;
        chronometerActive = false;

        if (currentCategoryIndex >= categories.length) {
          gameEnded = true;
          return;
        }

        Future.delayed(const Duration(milliseconds: 300), _showCategoryDialog);
        return;
      }

      // Si hay más de un jugador, pasar al siguiente turno
      if (activePlayers.length > 1) {
        currentPlayerIndex++;
        if (currentPlayerIndex >= activePlayers.length) {
          currentPlayerIndex = 0;
        }
      }
      // Si solo queda 1 jugador, sigue jugando él solo

      gameTime = const Duration(seconds: 5);
      hasSelectedLetter = false;
      chronometerActive = true;
    });
  }

  void _increaseScore() {
    if (activePlayers.isEmpty) return;
    final currentPlayer = activePlayers[currentPlayerIndex];
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

    setState(() {
      hasSelectedLetter = true;
      chronometerActive = false;
    });

    // Esperar hasta el próximo frame antes de abrir el modal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ButtonPopup(
          onCorrect: () {
            _increaseScore();
            _nextPlayer();
            setState(() => chronometerActive = true);
          },
          onReset: () {
            // ❌ Botón ahora elimina al jugador en vez de terminar el juego
            _eliminateCurrentPlayer();
          },
        ),
      );
    });
  }

  void _onTimeEnd() {
    // Si el jugador no seleccionó letra y el juego no ha terminado, eliminarlo
    if (!hasSelectedLetter && !gameEnded) {
      _eliminateCurrentPlayer();
    }
  }

  void _endGame() => setState(() => gameEnded = true);

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
    
    // Mostrar ranking cuando el juego termina o no quedan jugadores activos
    if (gameEnded || activePlayers.isEmpty) {
      return RankingGame(playerScores: playerScores);
    }

    final currentPlayer = activePlayers[currentPlayerIndex];

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

                      /// Header: Categoría + Cronómetro
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.category_rounded,
                                      color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      categories[currentCategoryIndex]
                                          .name
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
                            key: ValueKey(
                                '${currentPlayer.id}-$totalLettersSelected'),
                            duration: gameTime,
                            onTimeEnd: _onTimeEnd,
                            isActive: chronometerActive &&
                                !gameEnded &&
                                !hasSelectedLetter,
                          ),
                        ],
                      ),

                      SizedBox(height: isSmallScreen ? 20 : 25),

                      /// Nombre del jugador + Indicador de jugadores activos
                      Column(
                        children: [
                          PlayerNameWidget(
                            name: currentPlayer.name,
                            score: playerScores[currentPlayer.name] ?? 0,
                            team: 1,
                          ),
                          const SizedBox(height: 8),
                          // Indicador de jugadores restantes
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: activePlayers.length == 1
                                  ? Colors.orange.shade100
                                  : Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.people,
                                  size: 16,
                                  color: activePlayers.length == 1
                                      ? Colors.orange.shade700
                                      : Colors.blue.shade700,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  activePlayers.length == 1
                                      ? '¡Último jugador!'
                                      : '${activePlayers.length} jugadores activos',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: activePlayers.length == 1
                                        ? Colors.orange.shade700
                                        : Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: isSmallScreen ? 25 : 35),

                      /// Tablero de juego
                      Center(
                        child: BoardGameHard(
                          key: ValueKey(
                              'hard-${categories[currentCategoryIndex].name}'),
                          onLetterSelected: _onLetterSelected,
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 25 : 55),

                      /// Botones inferiores
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (currentCategoryIndex <
                                    categories.length - 1) {
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
                              icon: const Icon(Icons.skip_next,
                                  color: Colors.white, size: 20),
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
                                    horizontal: 20, vertical: 14),
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