import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import '../utils/screen_config.dart';

class RankingItem extends StatelessWidget {
  final int position;
  final MapEntry<String, int> player;
  final ScreenConfig config;

  const RankingItem({
    super.key,
    required this.position,
    required this.player,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = _getGradient(position);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: config.size.width * 0.04,
        vertical: config.size.height * 0.012,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(12),
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
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: config.size.width * 0.035,
            child: Text(
              '$position',
              style: TextStyle(
                color: gradient.first,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: config.size.width * 0.05),
          Expanded(
            child: Text(
              player.key,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            '${player.value}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getGradient(int index) {
    switch (index) {
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
}
