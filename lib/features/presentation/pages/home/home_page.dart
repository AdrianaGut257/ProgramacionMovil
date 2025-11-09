import 'package:flutter/material.dart';
import '../../../presentation/pages/home/widgets/mode_info_card.dart';
import 'package:go_router/go_router.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: isSmallScreen ? 15 : 25),

                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: AspectRatio(
                          aspectRatio: 470 / 170,
                          child: Image.asset(
                            'assets/icons/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 20 : 30),

                      Text(
                        'Selecciona una modalidad',
                        style: GoogleFonts.titanOne().copyWith(
                          fontSize: isSmallScreen ? 26 : 29,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                          height: 1.2,
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 25 : 35),

                      ModeInfoCard(
                        title: "Modo Fácil",
                        subtitle: "Perfecto para comenzar",
                        features: [
                          {
                            "text": "2-10 jugadores",
                            "icon": Icons.people_rounded,
                          },
                          {"text": "Más tiempo", "icon": Icons.timer_rounded},
                          {"text": "Sin presión", "icon": Icons.spa_rounded},
                        ],
                        buttonText: "Jugar Fácil",
                        buttonIcon: Icons.sentiment_satisfied_alt_rounded,
                        onPressed: () =>
                            context.push('/modality-information-normal'),
                        isSmallScreen: isSmallScreen,
                        accentColor: AppColors.primary,
                        gradientColors: [AppColors.primary, AppColors.primary],
                      ),

                      SizedBox(height: isSmallScreen ? 20 : 25),

                      ModeInfoCard(
                        title: "Modo Difícil",
                        subtitle: "Para los más valientes",
                        features: [
                          {
                            "text": "2-10 jugadores",
                            "icon": Icons.people_rounded,
                          },
                          {
                            "text": "Tiempo limitado",
                            "icon": Icons.hourglass_bottom_rounded,
                          },
                          {
                            "text": "Cronómetro activo",
                            "icon": Icons.timer_outlined,
                          },
                        ],
                        buttonText: "Jugar Difícil",
                        buttonIcon: Icons.local_fire_department_rounded,
                        onPressed: () =>
                            context.push('/modality-information-hard'),
                        isSmallScreen: isSmallScreen,
                        accentColor: const Color(0xFFE63946),
                        gradientColors: [
                          const Color(0xFFE63946),
                          const Color(0xFFFF6B6B),
                        ],
                      ),

                      SizedBox(height: isSmallScreen ? 20 : 25),

                      ModeInfoCard(
                        title: "Modo Grupal",
                        subtitle: "Diversión en equipo",
                        features: [
                          {
                            "text": "Jugadores pares",
                            "icon": Icons.people_alt_rounded,
                          },
                          {"text": "2 equipos", "icon": Icons.groups_2_rounded},
                          {
                            "text": "Competencia",
                            "icon": Icons.emoji_events_rounded,
                          },
                        ],
                        buttonText: "Jugar en Grupo",
                        buttonIcon: Icons.groups_rounded,
                        onPressed: () =>
                            context.push('/modality-information-team'),
                        isSmallScreen: isSmallScreen,
                        accentColor: AppColors.secondary,
                        gradientColors: [
                          AppColors.secondary,
                          AppColors.secondary,
                        ],
                      ),

                      SizedBox(height: 20),
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
