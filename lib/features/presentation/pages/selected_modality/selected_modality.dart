import 'package:flutter/material.dart';
import '../selected_modality/widgets/mode_info_card.dart';
import 'package:go_router/go_router.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    final isSmallHeight = height < 700;
    final isSmallWidth = width < 360;

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
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallWidth ? 16 : 24,
                    vertical: isSmallHeight ? 12 : 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: isSmallHeight ? 10 : 25),

                      FractionallySizedBox(
                        widthFactor: isSmallWidth ? 0.9 : 0.8,
                        child: AspectRatio(
                          aspectRatio: 470 / 170,
                          child: Image.asset(
                            'assets/icons/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      SizedBox(height: isSmallHeight ? 15 : 30),

                      Text(
                        'Selecciona una modalidad',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.titanOne().copyWith(
                          fontSize: isSmallHeight ? 20 : 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                          height: 1.2,
                        ),
                      ),

                      SizedBox(height: isSmallHeight ? 20 : 35),

                      ModeInfoCard(
                        title: "Modo Fácil",
                        subtitle: "Perfecto para comenzar",
                        features: [
                          {
                            "text": "2-10 jugadores",
                            "icon": Icons.people_rounded,
                          },
                          {"text": "Más tiempo", "icon": Icons.timer_rounded},
                        ],
                        buttonText: "Jugar Fácil",
                        buttonIcon: Icons.sentiment_satisfied_alt_rounded,
                        onPressed: () =>
                            context.push('/modality-information-normal'),
                        isSmallScreen: isSmallHeight || isSmallWidth,
                        accentColor: AppColors.primary,
                        gradientColors: [
                          AppColors.primary,
                          AppColors.primaryVariant,
                        ],
                      ),

                      SizedBox(height: isSmallHeight ? 15 : 25),

                      ModeInfoCard(
                        title: "Modo Difícil",
                        subtitle: "Para los más valientes",
                        features: [
                          {
                            "text": "2-10 jugadores",
                            "icon": Icons.people_rounded,
                          },
                          {
                            "text": "Menos tiempo",
                            "icon": Icons.hourglass_bottom_rounded,
                          },
                        ],
                        buttonText: "Jugar Difícil",
                        buttonIcon: Icons.local_fire_department_rounded,
                        onPressed: () =>
                            context.push('/modality-information-hard'),
                        isSmallScreen: isSmallHeight || isSmallWidth,
                        accentColor: AppColors.errorPrimary,
                        gradientColors: [
                          AppColors.errorPrimary,
                          AppColors.errorSecondary,
                        ],
                      ),

                      SizedBox(height: isSmallHeight ? 15 : 25),

                      ModeInfoCard(
                        title: "Modo Grupal",
                        subtitle: "Diversión en equipo",
                        features: [
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
                        isSmallScreen: isSmallHeight || isSmallWidth,
                        accentColor: AppColors.secondary,
                        gradientColors: [
                          AppColors.secondary,
                          AppColors.secondaryVariant,
                        ],
                      ),

                      SizedBox(height: isSmallHeight ? 15 : 20),
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
