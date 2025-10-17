import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:programacion_movil/config/colors.dart';
import '../widgets/podium_position.dart';
import '../widgets/ranking_item.dart';
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
  late AnimationController _fadeController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    sortedScores = widget.playerScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    _initAnimations();
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
                PodiumPositionGroup(sortedScores: sortedScores, config: config),
                const SizedBox(height: 25),
                SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      ...List.generate(
                        sortedScores.length,
                        (index) => Padding(
                          padding: EdgeInsets.only(bottom: config.itemSpacing),
                          child: RankingItem(
                            position: index + 1,
                            player: sortedScores[index],
                            config: config,
                          ),
                        ),
                      ),
                    ],
                  ),
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
