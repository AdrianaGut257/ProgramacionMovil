import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/modality_information.dart';
import '../../widgets/home_header.dart';
import 'package:go_router/go_router.dart';

class HardModePage extends StatelessWidget {
  const HardModePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final isSmallScreen = height < 700;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      HomeHeader(onBackPressed: () => context.pop()),
                      SizedBox(height: isSmallScreen ? 10 : 20),
                      const GameModeCard(
                        title: 'Modo Difícil',
                        description:
                            'En este modo, si uno falla, la partida termina de inmediato.',
                        badgeText: 'HARD MODE',
                        icon: Icons.bolt,
                      ),
                      SizedBox(height: isSmallScreen ? 20 : 30),
                      const StatsCards(
                        timeIcon: Icons.timer,
                        timeTitle: 'Tiempo',
                        timeValue: '5 seg',
                        levelIcon: Icons.whatshot,
                        levelTitle: 'Dificultad',
                        levelValue: 'dificil',
                        cardColor: AppColors.primary,
                      ),
                      SizedBox(height: isSmallScreen ? 30 : 40),
                      CustomButton(
                        text: "Jugar",
                        icon: Icons.group,
                        onPressed: () {
                          context.push('/player-register');
                        },
                      ),
                      SizedBox(height: height * 0.05),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
