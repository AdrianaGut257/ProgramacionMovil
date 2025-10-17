import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/back_button_custom.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/modality_information.dart';

import 'package:go_router/go_router.dart';

class EasyMode extends StatelessWidget {
  const EasyMode({super.key});

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
                      Row(
                        children: [
                          BackButtonCustom(onPressed: () => context.pop()),
                          const Spacer(),
                        ],
                      ),
                      SizedBox(height: 2),
                     Center(
  child: FractionallySizedBox(
    widthFactor: 0.9, 
    child: AspectRatio(
      aspectRatio: 370 / 170, 
      child: Image.asset(
        'assets/icons/logo.png',
        fit: BoxFit.contain, 
      ),
    ),
  ),
),

                      SizedBox(height: isSmallScreen ? 5 : 10),
                      const GameModeCard(
                        title: 'Modo fácil',
                        description:
                            'El modo clásico donde puedes fallar algunas veces antes de que termine la partida.',
                        badgeText: 'CLASSIC',
                        icon: Icons.play_circle_outline,
                      ),
                      SizedBox(height: isSmallScreen ? 20 : 30),
                      const StatsCards(
                        timeIcon: Icons.timer,
                        timeTitle: 'Tiempo',
                        timeValue: '10 seg',
                        levelIcon: Icons.star_half,
                        levelTitle: 'Dificultad',
                        levelValue: 'moderado',
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
