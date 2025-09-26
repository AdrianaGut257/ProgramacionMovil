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
        border: Border(
          bottom: BorderSide(color: AppColors.primaryVariant, width: 6),
        ),
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
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          bottom: BorderSide(color: AppColors.primaryVariant, width: 6),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryVariant,
            spreadRadius: 4, // grosor del borde adicional
          ),
        ],
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

/// Widget para mostrar dos comodines en fila
class ComodinCards extends StatelessWidget {
  final IconData? leftIcon;
  final String leftTitle;
  final String leftValue;
  final String? leftAssetPath;

  final IconData? rightIcon;
  final String rightTitle;
  final String rightValue;
  final String? rightAssetPath;

  final Color cardColor;

  const ComodinCards({
    super.key,
    this.leftIcon,
    this.leftAssetPath,
    required this.leftTitle,
    required this.leftValue,
    this.rightIcon,
    this.rightAssetPath,
    required this.rightTitle,
    required this.rightValue,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ComodinCard(
            icon: leftIcon,
            assetPath: leftAssetPath,
            title: leftTitle,
            value: leftValue,
            color: cardColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ComodinCard(
            icon: rightIcon,
            assetPath: rightAssetPath,
            title: rightTitle,
            value: rightValue,
            color: cardColor,
          ),
        ),
      ],
    );
  }
}

class _ComodinCard extends StatelessWidget {
  final IconData? icon;
  final String? assetPath;
  final String title;
  final String value;
  final Color color;

  const _ComodinCard({
    this.icon,
    this.assetPath,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          bottom: BorderSide(color: AppColors.primaryVariant, width: 6),
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: AppColors.primary,
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (assetPath != null)
            Image.asset(assetPath!, height: 30)
          else if (icon != null)
            Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
