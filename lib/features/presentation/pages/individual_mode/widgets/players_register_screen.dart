import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/data/datasources/app_database.dart';
import 'package:programacion_movil/data/models/player.dart';
import '../../../widgets/Inputs/player_input_field.dart';
import '../../../widgets/buttons/custom_button.dart';
import 'package:go_router/go_router.dart';

class PlayersRegisterScreen extends StatefulWidget {
  const PlayersRegisterScreen({super.key});

  @override
  State<PlayersRegisterScreen> createState() => _PlayersRegisterScreenState();
}

class _PlayersRegisterScreenState extends State<PlayersRegisterScreen> {
  // Lista de jugadores
  List<String> players = [""];

  void _addPlayer(String name) async {
    if (name.trim().isEmpty) {
      print('El nombre está vacío');
      return;
    }

    try {
      final db = await AppDatabase.instance.database;
      await db.insert('player', {'name': name});
      print('Jugador "$name" agregado a la base de datos');
      setState(() {
        players.add(""); // agrega nuevo campo vacío
      });

      final response = await db.query('player');
      print("Jugadores guardados: $response");
    } catch (e, st) {
      print('Error al agregar jugador: $e\n$st');
    }
  }

  void _removePlayer(int index) {
    setState(() {
      if (players.length > 1) {
        players.removeAt(index);
      }
    });
  }

  void _updatePlayer(int index, String value) {
    setState(() {
      players[index] = value;
    });
  }

  void _startGame() {
    final validPlayers = players.where((p) => p.trim().isNotEmpty).toList();

    if (validPlayers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Agrega al menos un jugador")),
      );
      return;
    }

    // Navegar a la página de categorías
    context.push('/select-categories', extra: validPlayers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              Text(
                "Ingresar nombres",
                style: TextStyle(fontSize: 20, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              // Lista dinámica de campos
              Expanded(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    return PlayerInputField(
                      index: index,
                      isLast: index == players.length - 1,
                      initialValue: players[index],
                      onChanged: (value) => _updatePlayer(index, value),
                      onAdd: () => _addPlayer(players[index]),
                      onRemove: () => _removePlayer(index),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Botón jugar reutilizando CustomButton
              CustomButton(text: "Jugar 🎮", onPressed: _startGame),
            ],
          ),
        ),
      ),
    );
  }
}
