import 'package:flutter/material.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/home_header.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              const SizedBox(height: 20),
              const Spacer(),

              CustomButton(
                text: "Modo facil",
                icon: Icons.person,
                onPressed: () {
                  context.push('/modality-information-normal');
                },
              ),

              const SizedBox(height: 20),

              CustomButton(
                text: "Modo dificil",
                icon: Icons.person,
                onPressed: () {
                  context.push('/modality-information-hard');
                },
              ),

              const SizedBox(height: 20),

              CustomButton(
                text: "Modo grupal",
                icon: Icons.group,
                onPressed: () {
                  context.push('/modality-information-team');
                },
              ),

              const SizedBox(height: 20),
              CustomButton(
                text: "Tablero del juego",
                onPressed: () {
                  context.push('/board-game');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
