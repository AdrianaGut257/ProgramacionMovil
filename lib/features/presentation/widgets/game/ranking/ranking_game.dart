import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/widgets/game/ranking/utils/screen_config.dart';

class RankingGame extends StatelessWidget {
  final List<MapEntry<String, int>> sortedScores;
  final ScreenConfig config;

  const RankingGame({
    super.key,
    required this.sortedScores,
    required this.config,
  });


  List<RankingEntry> _calculateRankings() {
    if (sortedScores.isEmpty) return [];

    List<RankingEntry> rankings = [];
    int currentPosition = 1;
    int? previousScore;
    int playersAtCurrentScore = 0;

    for (int i = 0; i < sortedScores.length; i++) {
      final player = sortedScores[i];
      final score = player.value;

      // Si el puntaje es diferente al anterior, actualizamos la posición
      if (previousScore != null && score != previousScore) {
        currentPosition += playersAtCurrentScore;
        playersAtCurrentScore = 0;
      }

      playersAtCurrentScore++;
      
      // Verificar si hay empate
      bool isTied = false;
      if (i < sortedScores.length - 1 && sortedScores[i + 1].value == score) {
        isTied = true;
      }
      if (i > 0 && sortedScores[i - 1].value == score) {
        isTied = true;
      }

      rankings.add(RankingEntry(
        position: currentPosition,
        playerName: player.key,
        score: score,
        isTied: isTied,
      ));

      previousScore = score;
    }

    return rankings;
  }

  List<Color> _getGradient(int position, bool isTied) {
    if (isTied && position <= 3) {
      // Si hay empate en el podio, usar color naranja
      return [Colors.orange.shade600, Colors.orange.shade800];
    }
    
    switch (position) {
      case 1:
        return [AppColors.tertiary, AppColors.tertiaryVariant];
      case 2:
        return [AppColors.secondary, AppColors.secondaryVariant];
      case 3:
        return [AppColors.primary, AppColors.primaryVariant];
      default:
        return [AppColors.teal, AppColors.primaryVariant];
    }
  }

  @override
  Widget build(BuildContext context) {
    final rankings = _calculateRankings();

    return Column(
      children: List.generate(
        rankings.length,
        (index) {
          final entry = rankings[index];
          final gradient = _getGradient(entry.position, entry.isTied);

          return Padding(
            padding: EdgeInsets.only(bottom: config.itemSpacing),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: config.size.width * 0.04,
                vertical: config.size.height * 0.012,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(12),
                border: entry.isTied
                    ? Border.all(
                        color: Colors.orange.shade400,
                        width: 2,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: gradient.first.withAlpha(100),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Posición
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: config.size.width * 0.035,
                    child: Text(
                      '${entry.position}',
                      style: TextStyle(
                        color: gradient.first,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: config.size.width * 0.05),
                  
                  // Nombre del jugador
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            entry.playerName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (entry.isTied) ...[
                          SizedBox(width: config.size.width * 0.02),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              // ignore: deprecated_member_use
                              color: Colors.orange.shade400.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.orange.shade200,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.link,
                                  size: config.size.width * 0.03,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'EMPATE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: config.size.width * 0.025,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Puntaje
                  Text(
                    '${entry.score}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class RankingEntry {
  final int position;
  final String playerName;
  final int score;
  final bool isTied;

  RankingEntry({
    required this.position,
    required this.playerName,
    required this.score,
    required this.isTied,
  });
}