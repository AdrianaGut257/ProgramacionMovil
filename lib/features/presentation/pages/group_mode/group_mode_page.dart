import 'package:flutter/material.dart';
import '../../../../config/colors.dart';
import 'widgets/team_section.dart';
import 'widgets/game_mode_selector.dart';
import '../../widgets/buttons/custom_button.dart';

class GroupModePage extends StatefulWidget {
  const GroupModePage({super.key});

  @override
  State<GroupModePage> createState() => _GroupModePageState();
}

class _GroupModePageState extends State<GroupModePage> {
  bool isDetermined = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Title
              const Text(
                'StopWord',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Elige una opción',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),

              const SizedBox(height: 30),

              // Game Mode Selector
              GameModeSelector(
                isDetermined: isDetermined,
                onModeChanged: (value) {
                  setState(() {
                    isDetermined = value;
                  });
                },
              ),

              const SizedBox(height: 30),

              // Player Input Fields
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (isDetermined) ...[
                        const TeamSection(
                          title: 'Equipo 1',
                          initialPlayerCount: 3,
                        ),
                        const SizedBox(height: 20),
                        const TeamSection(
                          title: 'Equipo 2',
                          initialPlayerCount: 3,
                        ),
                      ] else ...[
                        const TeamSection(
                          title: 'Ingresar nombres',
                          initialPlayerCount: 4,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Play Button
              CustomButton(text: "Jugar 🎮", onPressed: () {}),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
