import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/back_button_custom.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/information/modality_information.dart';
import '../modality_information/widgets/info_card.dart';

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          BackButtonCustom(onPressed: () => context.pop()),
                          const Spacer(),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 8 : 16),

                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withAlpha(25),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: FractionallySizedBox(
                            widthFactor: 0.85,
                            child: AspectRatio(
                              aspectRatio: 370 / 170,
                              child: Image.asset(
                                'assets/icons/logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 12 : 20),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(25),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                              spreadRadius: 0,
                            ),
                          ],
                          border: Border.all(
                            color: AppColors.primary.withAlpha(50),
                            width: 2,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: -20,
                              right: -20,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary.withAlpha(15),
                                ),
                              ),
                            ),
                            const GameModeCard(
                              title: 'Modo fácil',
                              description:
                                  'El modo fácil donde puedes fallar varias veces antes de que termine la partida.',
                              badgeText: 'EASY',
                              icon: Icons.play_circle_outline,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 16 : 24),

                      Center(
                        child: IntrinsicWidth(
                          child: Row(
                            children: [
                              InfoCard(
                                icon: Icons.timer,
                                title: 'Tiempo',
                                value: '10 seg',
                                isSmallScreen: isSmallScreen,
                              ),
                              const SizedBox(width: 12),
                              InfoCard(
                                icon: Icons.star_half,
                                title: 'Dificultad',
                                value: 'Fácil',
                                isSmallScreen: isSmallScreen,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 16 : 24),

                      InfoCard(
                        icon: Icons.group,
                        title: 'Participantes',
                        value: '2-10 jugadores',
                        subtitle: 'Mínimo 2 jugadores',
                        isSmallScreen: isSmallScreen,
                        chips: [
                          {
                            'icon': Icons.people_outline,
                            'text': '2-10 jugadores',
                          },
                          {'icon': Icons.spa_rounded, 'text': 'Sin presión'},
                        ],
                      ),

                      SizedBox(height: isSmallScreen ? 16 : 24),

                      CustomButton(
                        text: "Jugar",
                        icon: Icons.play_arrow_rounded,
                        onPressed: () {
                          context.push(
                            '/player-register',
                            extra: {'difficulty': 'easy'},
                          );
                        },
                      ),

                      SizedBox(height: isSmallScreen ? 16 : 24),
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
