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
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    double scale(double v) => v * (height / 800);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(scale(18)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(scale(20)),
        border: Border(
          bottom: BorderSide(color: AppColors.primaryVariant, width: scale(6)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(scale(8)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(scale(12)),
                ),
                child: Icon(
                  icon ?? Icons.flash_on,
                  color: AppColors.primary,
                  size: scale(24),
                ),
              ),
              SizedBox(width: scale(12)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: scale(12),
                  vertical: scale(6),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF40E0D0),
                  borderRadius: BorderRadius.circular(scale(20)),
                ),
                child: Text(
                  badgeText ?? 'MODE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: scale(12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: scale(20)),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: scale(24),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: scale(8)),
          Text(
            description,
            style: TextStyle(
              color: Colors.white,
              fontSize: scale(14),
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
    final height = MediaQuery.of(context).size.height;
    double scale(double v) => v * (height / 800);

    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: timeIcon ?? Icons.access_time,
            title: timeTitle ?? 'Tiempo',
            value: timeValue ?? '10 seg',
            color: cardColor ?? AppColors.primary,
            scale: scale,
          ),
        ),
        SizedBox(width: scale(16)),
        Expanded(
          child: StatCard(
            icon: levelIcon ?? Icons.star_outline,
            title: levelTitle ?? 'Nivel',
            value: levelValue ?? 'Normal',
            color: cardColor ?? AppColors.primary,
            scale: scale,
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
  final double Function(double) scale;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(scale(16)),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(scale(16)),
        border: Border(
          bottom: BorderSide(color: AppColors.primaryVariant, width: scale(6)),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: scale(28)),
          SizedBox(height: scale(8)),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: scale(12),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: scale(4)),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: scale(16),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

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
    final height = MediaQuery.of(context).size.height;
    double scale(double v) => v * (height / 800);

    return Row(
      children: [
        Expanded(
          child: _ComodinCard(
            icon: leftIcon,
            assetPath: leftAssetPath,
            title: leftTitle,
            value: leftValue,
            color: cardColor,
            scale: scale,
          ),
        ),
        SizedBox(width: scale(16)),
        Expanded(
          child: _ComodinCard(
            icon: rightIcon,
            assetPath: rightAssetPath,
            title: rightTitle,
            value: rightValue,
            color: cardColor,
            scale: scale,
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
  final double Function(double) scale;

  const _ComodinCard({
    this.icon,
    this.assetPath,
    required this.title,
    required this.value,
    required this.color,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(scale(14)),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(scale(16)),
        border: Border(
          bottom: BorderSide(color: AppColors.primaryVariant, width: scale(6)),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (assetPath != null)
            Image.asset(assetPath!, height: scale(30))
          else if (icon != null)
            Icon(icon, color: Colors.white, size: scale(32)),
          SizedBox(height: scale(8)),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: scale(14),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: scale(6)),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: scale(12),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
