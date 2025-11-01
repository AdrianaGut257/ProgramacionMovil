import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';

class RecordTabBar extends StatelessWidget {
  final TabController controller;
  final int individualCount;
  final int teamCount;
  final int playersCount; // 🆕 Cantidad de jugadores en el ranking

  const RecordTabBar({
    super.key,
    required this.controller,
    required this.individualCount,
    required this.teamCount,
    required this.playersCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.primary,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person, size: 16),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'Individual ($individualCount)',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.groups, size: 16),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'Equipos ($teamCount)',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // 🆕 Nueva pestaña de Ranking
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.leaderboard, size: 16),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'Ranking ($playersCount)',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}