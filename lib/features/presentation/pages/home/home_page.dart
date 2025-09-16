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
                text: "Modo individual",
                icon: Icons.person,
                onPressed: () {
                  context.push('/player-register');
                },
              ),

              const SizedBox(height: 20),

              CustomButton(
                text: "Modo grupal",
                icon: Icons.group,
                onPressed: () {
                  context.push('/group-mode');
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
