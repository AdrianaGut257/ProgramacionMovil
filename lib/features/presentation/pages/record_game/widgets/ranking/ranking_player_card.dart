import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/pages/record_game/utils/record_helpers.dart';

class RankingPlayerCard extends StatelessWidget {
  final String playerName;
  final int totalPoints;
  final int gamesPlayed;
  final int victories;
  final int position;

  const RankingPlayerCard({
    super.key,
    required this.playerName,
    required this.totalPoints,
    required this.gamesPlayed,
    required this.victories,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final isTopThree = position <= 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isTopThree
            ? RecordHelpers.getPositionColor(position).withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isTopThree
              ? RecordHelpers.getPositionColor(position).withValues(alpha: 0.3)
              : Colors.grey[300]!,
          width: isTopThree ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Posición
          _buildPositionBadge(),

          const SizedBox(width: 12),

          // Nombre del jugador
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '$gamesPlayed ${gamesPlayed == 1 ? 'partida' : 'partidas'}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Victorias
          if (victories > 0) _buildVictoriesIndicator(),

          const SizedBox(width: 12),

          // Total de puntos
          _buildPointsBadge(),
        ],
      ),
    );
  }

  Widget _buildPositionBadge() {
    final isTopThree = position <= 3;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isTopThree
            ? RecordHelpers.getPositionColor(position)
            : Colors.grey[400],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$position°',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildVictoriesIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(
            '$victories',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$totalPoints',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Text(
            'pts',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
