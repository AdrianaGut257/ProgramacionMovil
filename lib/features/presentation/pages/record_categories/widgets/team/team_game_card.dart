import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/pages/record_categories/utils/record_helpers.dart';
import 'package:programacion_movil/features/presentation/pages/record_categories/widgets/team/team_game_details.dart';

class TeamGameCard extends StatelessWidget {
  final Map<String, dynamic> game;
  final VoidCallback onDelete;

  const TeamGameCard({
    super.key,
    required this.game,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final players = game['players'] as List;
    final categories = game['categories'] as List;
    final date = RecordHelpers.formatDate(game['date']);
    final winnerTeam = game['winner_team'];
    final team1Score = game['team1_score'] ?? 0;
    final team2Score = game['team2_score'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con Team Mode y fecha
              _buildHeader(date),

              const Divider(height: 24),

              // Marcador de equipos
              _buildTeamScores(winnerTeam, team1Score, team2Score),

              if (winnerTeam == null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '🤝 Empate',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Top 3 jugadores
              const Text(
                'Mejores jugadores',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              ...players.take(3).map((player) => _buildPlayerRow(player)),

              if (players.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '+ ${players.length - 3} jugador(es) más',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // Categorías
              _buildCategories(categories),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.groups,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Team Mode',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF87171), Color(0xFFEF4444), Color(0xFFDC2626)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEF4444).withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onDelete(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamScores(int? winnerTeam, int team1Score, int team2Score) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: winnerTeam == 1
                    ? Colors.blue
                    : Colors.blue.withValues(alpha: 0.3),
                width: winnerTeam == 1 ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                if (winnerTeam == 1)
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 24,
                  ),
                Text(
                  'Equipo 1',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$team1Score',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'VS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: winnerTeam == 2
                    ? Colors.red
                    : Colors.red.withValues(alpha: 0.3),
                width: winnerTeam == 2 ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                if (winnerTeam == 2)
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 24,
                  ),
                Text(
                  'Equipo 2',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$team2Score',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[900],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerRow(Map<String, dynamic> player) {
    final position = player['position'] as int;
    final name = player['player_name'] as String;
    final score = player['score'] as int;
    final team = player['team'] as int?;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: RecordHelpers.getPositionColor(position).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: RecordHelpers.getPositionColor(position).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            RecordHelpers.getPositionIcon(position),
            color: RecordHelpers.getPositionColor(position),
            size: 24,
          ),
          const SizedBox(width: 12),
          if (team != null) ...[
            RecordHelpers.buildTeamBadge(team),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          RecordHelpers.buildScoreBadge(score),
        ],
      ),
    );
  }

  Widget _buildCategories(List categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: categories
              .take(3)
              .map((cat) => RecordHelpers.buildCategoryChip(
                    cat['category_name'],
                  ))
              .toList(),
        ),
        if (categories.length > 3)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              '+ ${categories.length - 3} categoría(s) más',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ),
      ],
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TeamGameDetails(game: game),
    );
  }
}