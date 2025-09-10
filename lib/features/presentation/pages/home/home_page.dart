import 'package:flutter/material.dart';
import '../../widgets/buttons/custom_button.dart';
import 'widgets/home_header.dart';
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

              // Botón para Jugar en grupo
              CustomButton(
                text: "Jugar 🎮",
                onPressed: () {
                  context.push('/group-mode');
                },
              ),

              const SizedBox(height: 20),

              // Nuevo botón para modo individual
              CustomButton(
                text: "Individual 🧍",
                onPressed: () {
                  context.push('/player-register');
                },
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
