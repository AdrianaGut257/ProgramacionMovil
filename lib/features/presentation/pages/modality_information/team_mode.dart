import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/back_button_custom.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/information/modality_information.dart';
import '../modality_information/widgets/info_card.dart';
import 'package:go_router/go_router.dart';

class TeamModePage extends StatelessWidget {
  const TeamModePage({super.key});

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
                              title: 'Modo Equipo',
                              description:
                                  'Juega en equipos y compite contra otros grupos. La colaboración es clave para ganar.',
                              badgeText: 'TEAM UP',
                              icon: Icons.groups,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 16 : 24),

                      Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: Row(
                          children: [
                            Expanded(
                              child: InfoCard(
                                icon: Icons.timer,
                                title: 'Tiempo',
                                value: '5 seg',
                                isSmallScreen: isSmallScreen,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InfoCard(
                                icon: Icons.star_half,
                                title: 'Dificultad',
                                value: 'Desafio',
                                isSmallScreen: isSmallScreen,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 16 : 24),

                      InfoCard(
                        icon: Icons.groups,
                        title: 'Equipos',
                        value: '2+ equipos',
                        subtitle: 'Equipos pares',
                        isSmallScreen: isSmallScreen,
                        chips: [
                          {'icon': Icons.groups_2_rounded, 'text': '2 equipos'},
                          {'icon': Icons.emoji_events, 'text': 'Competitivo'},
                        ],
                      ),

                      SizedBox(height: isSmallScreen ? 16 : 24),

                      CustomButton(
                        text: "Jugar",
                        icon: Icons.play_arrow_rounded,
                        onPressed: () {
                          context.push('/group-mode');
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
