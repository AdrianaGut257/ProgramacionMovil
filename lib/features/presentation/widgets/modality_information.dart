import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';

class GameModeCard extends StatelessWidget {
  final String title;
  final String description;
  final String? badgeText;
  final IconData? icon;

  const GameModeCard({
    super.key,
    required this.title,
    required this.description,
    this.badgeText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon ?? Icons.flash_on,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF40E0D0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badgeText ?? 'MODE',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class StatsCards extends StatelessWidget {
  final IconData? timeIcon;
  final String? timeTitle;
  final String? timeValue;
  final IconData? levelIcon;
  final String? levelTitle;
  final String? levelValue;
  final Color? cardColor;

  const StatsCards({
    super.key,
    this.timeIcon,
    this.timeTitle,
    this.timeValue,
    this.levelIcon,
    this.levelTitle,
    this.levelValue,
    this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: timeIcon ?? Icons.access_time,
            title: timeTitle ?? 'Tiempo',
            value: timeValue ?? '10 seg',
            color: cardColor ?? AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            icon: levelIcon ?? Icons.star_outline,
            title: levelTitle ?? 'Nivel',
            value: levelValue ?? 'normal',
            color: cardColor ?? AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
