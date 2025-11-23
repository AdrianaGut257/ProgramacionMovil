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

class SelectableComodinCards extends StatelessWidget {
  final String? leftAssetPath;
  final String leftTitle;
  final String leftValue;
  final String leftKey;
  final bool leftSelected;
  final VoidCallback onLeftTap;

  final String? rightAssetPath;
  final String rightTitle;
  final String rightValue;
  final String rightKey;
  final bool rightSelected;
  final VoidCallback onRightTap;

  final Color cardColor;

  const SelectableComodinCards({
    super.key,
    this.leftAssetPath,
    required this.leftTitle,
    required this.leftValue,
    required this.leftKey,
    required this.leftSelected,
    required this.onLeftTap,
    this.rightAssetPath,
    required this.rightTitle,
    required this.rightValue,
    required this.rightKey,
    required this.rightSelected,
    required this.onRightTap,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    double scale(double v) => v * (height / 800);

    return Row(
      children: [
        Expanded(
          child: _SelectableComodinCard(
            assetPath: leftAssetPath,
            title: leftTitle,
            value: leftValue,
            color: cardColor,
            scale: scale,
            isSelected: leftSelected,
            onTap: onLeftTap,
          ),
        ),
        SizedBox(width: scale(16)),
        Expanded(
          child: _SelectableComodinCard(
            assetPath: rightAssetPath,
            title: rightTitle,
            value: rightValue,
            color: cardColor,
            scale: scale,
            isSelected: rightSelected,
            onTap: onRightTap,
          ),
        ),
      ],
    );
  }
}

class _SelectableComodinCard extends StatefulWidget {
  final String? assetPath;
  final String title;
  final String value;
  final Color color;
  final double Function(double) scale;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableComodinCard({
    this.assetPath,
    required this.title,
    required this.value,
    required this.color,
    required this.scale,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SelectableComodinCard> createState() =>
      _SelectableComodinCardState();
}

class _SelectableComodinCardState extends State<_SelectableComodinCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(widget.scale(14)),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? widget.color
                    : widget.color.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(widget.scale(16)),
                border: Border.all(
                  color: widget.isSelected
                      ? AppColors.secondary
                      : Colors.transparent,
                  width: widget.scale(4),
                ),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.secondary.withValues(alpha: 0.4),
                          blurRadius: widget.scale(12),
                          spreadRadius: widget.scale(2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: AppColors.primaryVariant.withValues(alpha: 0.3),
                          blurRadius: widget.scale(4),
                          offset: Offset(0, widget.scale(4)),
                        ),
                      ],
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.assetPath != null)
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: widget.isSelected ? 1.0 : 0.6,
                          child: Image.asset(
                            widget.assetPath!,
                            height: widget.scale(30),
                          ),
                        ),
                      SizedBox(height: widget.scale(8)),
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.scale(14),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: widget.scale(6)),
                      Text(
                        widget.value,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: widget.scale(12),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  // Indicador de selección
                  Positioned(
                    top: widget.scale(4),
                    right: widget.scale(4),
                    child: AnimatedScale(
                      scale: widget.isSelected ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.elasticOut,
                      child: Container(
                        padding: EdgeInsets.all(widget.scale(4)),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: widget.scale(4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: widget.scale(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}