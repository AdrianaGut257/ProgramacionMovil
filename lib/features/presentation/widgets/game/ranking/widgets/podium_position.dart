import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import '../utils/screen_config.dart';

class PodiumPositionGroup extends StatelessWidget {
  final List<MapEntry<String, int>> sortedScores;
  final ScreenConfig config;

  const PodiumPositionGroup({
    super.key,
    required this.sortedScores,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    // Toma solo los 3 primeros puntajes
    final top = sortedScores.take(3).toList();

    // Orden visual: 2 - 1 - 3
    final displayOrder = [1, 0, 2];

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / 3;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(
            3,
            (index) {
              final positionIndex = displayOrder[index];
              if (positionIndex >= top.length) {
                return SizedBox(width: itemWidth);
              }

              final player = top[positionIndex];
              final position = positionIndex + 1;

              return SizedBox(
                width: itemWidth,
                child: _AnimatedPodiumItem(
                  player: player,
                  position: position,
                  config: config,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _AnimatedPodiumItem extends StatefulWidget {
  final MapEntry<String, int> player;
  final int position;
  final ScreenConfig config;

  const _AnimatedPodiumItem({
    required this.player,
    required this.position,
    required this.config,
  });

  @override
  State<_AnimatedPodiumItem> createState() => _AnimatedPodiumItemState();
}

class _AnimatedPodiumItemState extends State<_AnimatedPodiumItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _bounce = Tween<double>(begin: 0.0, end: 6.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

double get podiumHeight {
  switch (widget.position) {
    case 1:
      return widget.config.size.height * 0.12;
    case 2:
      return widget.config.size.height * 0.10;
    case 3:
      return widget.config.size.height * 0.085;
    default:
      return widget.config.size.height * 0.08;
  }
}

  @override
  Widget build(BuildContext context) {
    final colors = [
      [AppColors.tertiary, AppColors.tertiaryVariant], // 1er lugar
      [AppColors.secondary, AppColors.secondaryVariant], // 2do lugar
      [AppColors.primary, AppColors.primaryVariant], // 3er lugar
    ][(widget.position - 1).clamp(0, 2)];

    final playerName = widget.player.key;
    final score = widget.player.value;

    return AnimatedBuilder(
      animation: _bounce,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //  Ícono especial para el primer lugar
            if (widget.position == 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.amber.shade400,
                  size: widget.config.size.width * 0.12 + (_bounce.value / 2),
                ),
              ),

            //  Nombre y puntaje del jugador
            AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: 1.0,
              child: Column(
                children: [
                  Text(
                    playerName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: widget.config.size.width * 0.038,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$score pts',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: widget.config.size.width * 0.032,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            //  Base del podio con animación
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutBack,
              height: podiumHeight + _bounce.value,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: colors.first.withOpacity(0.6),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${widget.position}',
                  style: TextStyle(
                    fontSize: widget.config.size.width * 0.07,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(1, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
