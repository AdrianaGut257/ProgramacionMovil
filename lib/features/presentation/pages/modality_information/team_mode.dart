import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/modality_information.dart';
import '../../widgets/home_header.dart';
import 'package:go_router/go_router.dart';

class TeamModePage extends StatelessWidget {
  const TeamModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const HomeHeader(),
              const GameModeCard(
                title: 'Modo Equipo',
                description:
                    'Juega en equipos y compite contra otros grupos. La colaboración es clave para ganar.',
                badgeText: 'TEAM UP',
                icon: Icons.groups,
              ),
              const SizedBox(height: 30),
              const StatsCards(
                timeIcon: Icons.timer_10,
                timeTitle: 'Tiempo',
                timeValue: '5 seg',
                levelIcon: Icons.diversity_3,
                levelTitle: 'Jugadores',
                levelValue: '2-8',
                cardColor: AppColors.primary,
              ),
              const Spacer(),
              const SizedBox(height: 20),
              CustomButton(
                text: "Jugar",
                icon: Icons.group,
                onPressed: () {
                  context.push('/group-mode');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
