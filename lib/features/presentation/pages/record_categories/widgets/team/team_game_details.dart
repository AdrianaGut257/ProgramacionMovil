import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/pages/record_categories/utils/record_helpers.dart';

class TeamGameDetails extends StatelessWidget {
  final Map<String, dynamic> game;

  const TeamGameDetails({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final players = game['players'] as List;
    final categories = game['categories'] as List;
    final date = RecordHelpers.formatDate(game['date']);
    final winnerTeam = game['winner_team'];
    final team1Score = game['team1_score'] ?? 0;
    final team2Score = game['team2_score'] ?? 0;

    // Separar jugadores por equipo
    final team1Players = players.where((p) => p['team'] == 1).toList();
    final team2Players = players.where((p) => p['team'] == 2).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Handle de arrastre
          _buildHandle(),

          // Header
          _buildHeader(date),

          const Divider(height: 1),

          // Contenido scrolleable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resultado final
                  _buildFinalScore(winnerTeam, team1Score, team2Score),

                  if (winnerTeam == null) _buildTieIndicator(),

                  const SizedBox(height: 24),

                  // Equipo 1
                  _buildTeamSection(
                    teamNumber: 1,
                    teamPlayers: team1Players,
                    teamColor: Colors.blue,
                  ),

                  const SizedBox(height: 24),

                  // Equipo 2
                  _buildTeamSection(
                    teamNumber: 2,
                    teamPlayers: team2Players,
                    teamColor: Colors.red,
                  ),

                  const SizedBox(height: 24),

                  // Categorías jugadas
                  _buildCategories(categories),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(String date) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.groups,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Team Mode',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalScore(int? winnerTeam, int team1Score, int team2Score) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                if (winnerTeam == 1)
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 32,
                  ),
                Text(
                  'Equipo 1',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$team1Score',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                Text(
                  'puntos',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'VS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                if (winnerTeam == 2)
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 32,
                  ),
                Text(
                  'Equipo 2',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$team2Score',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[900],
                  ),
                ),
                Text(
                  'puntos',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTieIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.amber[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.handshake, color: Colors.amber),
              SizedBox(width: 8),
              Text(
                'Empate',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamSection({
    required int teamNumber,
    required List teamPlayers,
    required Color teamColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: teamColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.groups,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Equipo $teamNumber (${teamPlayers.length} jugadores)',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...teamPlayers.map((player) => _buildTeamPlayerCard(
              player: player,
              teamColor: teamColor,
            )),
      ],
    );
  }

  Widget _buildTeamPlayerCard({
    required Map<String, dynamic> player,
    required Color teamColor,
  }) {
    final name = player['player_name'] as String;
    final score = player['score'] as int;
    final position = player['position'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: teamColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: teamColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: position <= 3
                  ? RecordHelpers.getPositionColor(position)
                  : teamColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$position°',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: teamColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$score pts',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(List categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categorías Jugadas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories
              .map((cat) => RecordHelpers.buildLargeCategoryChip(
                    cat['category_name'],
                  ))
              .toList(),
        ),
      ],
    );
  }
}