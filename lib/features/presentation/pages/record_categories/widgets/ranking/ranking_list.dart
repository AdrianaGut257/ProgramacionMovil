import 'package:flutter/material.dart';
import 'package:programacion_movil/features/presentation/pages/record_categories/widgets/ranking/ranking_player_card.dart';

class RankingList extends StatelessWidget {
  final List<Map<String, dynamic>> rankings;
  final VoidCallback onRefresh;

  const RankingList({
    super.key,
    required this.rankings,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (rankings.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: rankings.length,
        itemBuilder: (context, index) {
          final player = rankings[index];
          return RankingPlayerCard(
            playerName: player['player_name'] as String,
            totalPoints: player['total_points'] as int,
            gamesPlayed: player['games_played'] as int,
            victories: player['victories'] as int,
            position: index + 1, // Posición basada en el índice
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.leaderboard,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay jugadores aún',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Juega algunas partidas para ver el ranking',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}