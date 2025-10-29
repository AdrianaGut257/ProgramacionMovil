import 'package:flutter/material.dart';
//import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/pages/record_categories/utils/record_helpers.dart';

class IndividualGameDetails extends StatelessWidget {
  final Map<String, dynamic> game;

  const IndividualGameDetails({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final players = game['players'] as List;
    final categories = game['categories'] as List;
    final gameMode = game['game_mode'] as String;
    final date = RecordHelpers.formatDate(game['date']);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
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
          _buildHeader(gameMode, date),

          const Divider(height: 1),

          // Contenido scrolleable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Clasificación completa
                  _buildClassification(players),

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

  Widget _buildHeader(String gameMode, String date) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                RecordHelpers.getGameModeIcon(gameMode),
                color: RecordHelpers.getGameModeColor(gameMode),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                gameMode,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: RecordHelpers.getGameModeColor(gameMode),
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

  Widget _buildClassification(List players) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Clasificación Final',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...players.map((player) => _buildPlayerCard(player)),
      ],
    );
  }

  Widget _buildPlayerCard(Map<String, dynamic> player) {
    final position = player['position'] as int;
    final name = player['player_name'] as String;
    final score = player['score'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: position <= 3
            ? RecordHelpers.getPositionColor(position).withValues(alpha: 0.1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: position <= 3
              ? RecordHelpers.getPositionColor(position).withValues(alpha: 0.3)
              : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          RecordHelpers.buildPositionBadge(position),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          RecordHelpers.buildLargeScoreBadge(score),
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