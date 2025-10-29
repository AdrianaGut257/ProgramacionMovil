import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';

class RecordHeader extends StatelessWidget {
  final Map<String, dynamic>? statistics;
  final bool hasGames;
  final VoidCallback onClearAll;

  const RecordHeader({
    super.key,
    required this.statistics,
    required this.hasGames,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Título y botón de borrar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Historial de Partidas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (hasGames)
                IconButton(
                  onPressed: onClearAll,
                  icon: const Icon(Icons.delete_sweep),
                  color: Colors.white,
                  tooltip: 'Borrar todo',
                ),
            ],
          ),

          // Estadísticas
          if (statistics != null && statistics!['total_games'] > 0)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    Icons.sports_esports,
                    '${statistics!['total_games']}',
                    'Partidas',
                  ),
                  if (statistics!['top_player'] != null)
                    _buildStatItem(
                      Icons.emoji_events,
                      statistics!['top_player'],
                      '${statistics!['top_player_wins']} victorias',
                    ),
                  if (statistics!['top_team'] != null)
                    _buildStatItem(
                      Icons.groups,
                      'Equipo ${statistics!['top_team']}',
                      '${statistics!['top_team_wins']} victorias',
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Flexible(
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}