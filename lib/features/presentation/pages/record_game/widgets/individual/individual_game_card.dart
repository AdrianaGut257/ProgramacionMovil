import 'package:flutter/material.dart';
import 'package:programacion_movil/features/presentation/pages/record_game/utils/record_helpers.dart';
import 'package:programacion_movil/features/presentation/pages/record_game/widgets/individual/individual_game_details.dart';
import 'package:programacion_movil/config/colors.dart';

class IndividualGameCard extends StatelessWidget {
  final Map<String, dynamic> game;
  final VoidCallback onDelete;

  const IndividualGameCard({
    super.key,
    required this.game,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final players = game['players'] as List;
    final categories = game['categories'] as List;
    final gameMode = game['game_mode'] as String;
    final date = RecordHelpers.formatDate(game['date']);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con modo de juego y fecha
              _buildHeader(gameMode, date),

              const Divider(height: 24),

              // Top 3 jugadores
              const Text(
                'Podio',
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

  Widget _buildHeader(String gameMode, String date) {
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
                    RecordHelpers.getGameModeIcon(gameMode),
                    color: RecordHelpers.getGameModeColor(gameMode),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    gameMode,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: RecordHelpers.getGameModeColor(gameMode),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    date,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

  Widget _buildPlayerRow(Map<String, dynamic> player) {
    final position = player['position'] as int;
    final name = player['player_name'] as String;
    final score = player['score'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: RecordHelpers.getPositionColor(position).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: RecordHelpers.getPositionColor(
            position,
          ).withValues(alpha: 0.3),
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
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
              .map(
                (cat) => RecordHelpers.buildCategoryChip(cat['category_name']),
              )
              .toList(),
        ),
        if (categories.length > 3)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              '+ ${categories.length - 3} categoría(s) más',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
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
      builder: (context) => IndividualGameDetails(game: game),
    );
  }
}
