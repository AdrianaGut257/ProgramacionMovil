import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:programacion_movil/config/colors.dart';

import '../widgets/podium_position.dart';
import '../widgets/animated_title.dart';
import '../utils/screen_config.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/custom_button.dart';

class StopWordsWinnersScreen extends StatefulWidget {
  final Map<String, int> playerScores;

  const StopWordsWinnersScreen({super.key, required this.playerScores});

  @override
  State<StopWordsWinnersScreen> createState() => _StopWordsWinnersScreenState();
}

class _StopWordsWinnersScreenState extends State<StopWordsWinnersScreen>
    with TickerProviderStateMixin {
  late List<MapEntry<String, int>> sortedScores;
  late List<MapEntry<String, int>> remainingPlayers;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    sortedScores = widget.playerScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    _calculateRemainingPlayers();
    _initAnimations();
  }

  void _calculateRemainingPlayers() {
    // Agrupar por puntaje
    final Map<int, List<MapEntry<String, int>>> scoreGroups = {};
    
    for (var entry in sortedScores) {
      if (!scoreGroups.containsKey(entry.value)) {
        scoreGroups[entry.value] = [];
      }
      scoreGroups[entry.value]!.add(entry);
    }
    
    final sortedScoreKeys = scoreGroups.keys.toList()..sort((a, b) => b.compareTo(a));
    final groups = sortedScoreKeys.map((score) => scoreGroups[score]!).toList();
    
    // Tomar los primeros 3 grupos (posiciones)
    int playersInTop = 0;
    for (int i = 0; i < groups.length && i < 3; i++) {
      playersInTop += groups[i].length;
    }
    
    // El resto de jugadores van a la lista inferior
    remainingPlayers = sortedScores.skip(playersInTop).toList();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Widget _buildRemainingPlayersList(ScreenConfig config) {
    if (remainingPlayers.isEmpty) {
      return const SizedBox.shrink();
    }

    int startPosition = sortedScores.length - remainingPlayers.length + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Otros jugadores',
            style: TextStyle(
              color: AppColors.white,
              fontSize: config.size.width * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...List.generate(remainingPlayers.length, (index) {
          final player = remainingPlayers[index];
          final position = startPosition + index;
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Container(
              height: config.size.height * 0.055,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: AppColors.primary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  // ignore: deprecated_member_use
                  color: AppColors.primary.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Posición
                    Container(
                      width: config.size.width * 0.08,
                      height: config.size.width * 0.08,
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: AppColors.primary.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$position',
                          style: TextStyle(
                            fontSize: config.size.width * 0.035,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Nombre
                    Expanded(
                      child: Text(
                        player.key,
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: config.size.width * 0.038,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    // Puntaje
                    Text(
                      '${player.value}',
                      style: TextStyle(
                        // ignore: deprecated_member_use
                        color: AppColors.white.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: config.size.width * 0.042,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = ScreenConfig(MediaQuery.of(context).size);
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final isSmallScreen = height < 700;
    
    return Scaffold(
      backgroundColor: AppColors.primaryVariant,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(config.horizontalPadding),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                AnimatedTitle(config: config),
                const SizedBox(height: 20),
                
                // Podio o lista de Top 3
                PodiumPositionGroup(
                  sortedScores: sortedScores,
                  config: config,
                ),
                
                const SizedBox(height: 25),
                
                // Lista del resto de jugadores (posición 4 en adelante)
                SlideTransition(
                  position: _slideAnimation,
                  child: _buildRemainingPlayersList(config),
                ),
                
                const SizedBox(height: 30),
                
                CustomButton(
                  text: 'Volver al inicio',
                  icon: Icons.home,
                  backgroundColor: AppColors.secondary,
                  textColor: AppColors.white,
                  borderColor: AppColors.secondaryVariant,
                  onPressed: () => context.push('/'),
                ),
                
                SizedBox(height: isSmallScreen ? 10 : 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}