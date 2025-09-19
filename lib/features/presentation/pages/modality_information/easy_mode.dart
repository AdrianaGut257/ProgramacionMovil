import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/modality_information.dart';
import '../../widgets/home_header.dart';
import 'package:go_router/go_router.dart';

class EasyMode extends StatelessWidget {
  const EasyMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const HomeHeader(),
                  const GameModeCard(
                    title: 'Modo fácil',
                    description:
                        'El modo clásico donde puedes fallar algunas veces antes de que termine la partida.',
                    badgeText: 'CLASSIC',
                    icon: Icons.play_circle_outline,
                  ),
                  const SizedBox(height: 30),
                  const StatsCards(
                    timeIcon: Icons.access_time,
                    timeTitle: 'Tiempo',
                    timeValue: '10 seg',
                    levelIcon: Icons.star_half,
                    levelTitle: 'Dificultad',
                    levelValue: 'moderado',
                    cardColor: AppColors.primary,
                  ),
                  const Spacer(),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "Jugar",
                    icon: Icons.group,
                    onPressed: () {
                      context.push('/player-register');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
