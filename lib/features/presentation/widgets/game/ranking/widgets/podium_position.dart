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

  // Agrupa jugadores por puntaje para detectar empates
  List<List<MapEntry<String, int>>> _groupByScore() {
    final Map<int, List<MapEntry<String, int>>> scoreGroups = {};
    
    for (var entry in sortedScores) {
      if (!scoreGroups.containsKey(entry.value)) {
        scoreGroups[entry.value] = [];
      }
      scoreGroups[entry.value]!.add(entry);
    }
    
    // Ordenar por puntaje descendente y devolver grupos
    final sortedScoreKeys = scoreGroups.keys.toList()..sort((a, b) => b.compareTo(a));
    return sortedScoreKeys.map((score) => scoreGroups[score]!).toList();
  }

  @override
  Widget build(BuildContext context) {
    final groups = _groupByScore();
    
    // Si no hay suficientes grupos o hay empates, mostrar lista
    if (groups.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // Verificar si hay empates en los primeros 3 lugares
    bool hasTopThreeTies = false;
    int podiumPositions = 0;
    
    for (int i = 0; i < groups.length && podiumPositions < 3; i++) {
      if (groups[i].length > 1) {
        hasTopThreeTies = true;
        break;
      }
      podiumPositions++;
    }
    
    // Si hay empates en top 3, mostrar vista con empates
    if (hasTopThreeTies) {
      return _buildPodiumWithTies(groups);
    }
    
    // Si no hay empates, mostrar podio normal
    return _buildNormalPodium(groups);
  }

  Widget _buildPodiumWithTies(List<List<MapEntry<String, int>>> groups) {
    int currentPosition = 1;
    List<Widget> podiumItems = [];
    
    for (int i = 0; i < groups.length && i < 3; i++) {
      final group = groups[i];
      final colors = _getColorsForPosition(currentPosition);
      
      // Agregar todos los jugadores del grupo (empate o no)
      for (var player in group) {
        podiumItems.add(
          _buildTiedPodiumItem(
            player: player,
            position: currentPosition,
            colors: colors,
          ),
        );
      }
      
      // Avanzar posición solo después de procesar todo el grupo
      currentPosition++;
    }
    
    return Column(
      children: podiumItems,
    );
  }

  Widget _buildTiedPodiumItem({
    required MapEntry<String, int> player,
    required int position,
    required List<Color> colors,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        height: config.size.height * 0.065,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: colors.first.withOpacity(0.4),
              offset: const Offset(0, 3),
              blurRadius: 8,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // Número de posición
              Container(
                width: config.size.width * 0.09,
                height: config.size.width * 0.09,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$position',
                    style: TextStyle(
                      fontSize: config.size.width * 0.045,
                      color: colors.first,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Nombre del jugador
              Expanded(
                child: Text(
                  player.key,
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: config.size.width * 0.042,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              // Puntaje
              Text(
                '${player.value}',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: config.size.width * 0.048,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNormalPodium(List<List<MapEntry<String, int>>> groups) {
    final top = groups.take(3).map((g) => g.first).toList();
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

  List<Color> _getColorsForPosition(int position) {
    switch (position) {
      case 1:
        return [AppColors.tertiary, AppColors.tertiaryVariant];
      case 2:
        return [AppColors.secondary, AppColors.secondaryVariant];
      case 3:
        return [AppColors.primary, AppColors.primaryVariant];
      default:
        return [AppColors.primary, AppColors.primaryVariant];
    }
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
      [AppColors.tertiary, AppColors.tertiaryVariant],
      [AppColors.secondary, AppColors.secondaryVariant],
      [AppColors.primary, AppColors.primaryVariant],
    ][(widget.position - 1).clamp(0, 2)];

    final playerName = widget.player.key;
    final score = widget.player.value;

    return AnimatedBuilder(
      animation: _bounce,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.position == 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.amber.shade400,
                  size: widget.config.size.width * 0.12 + (_bounce.value / 2),
                ),
              ),

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