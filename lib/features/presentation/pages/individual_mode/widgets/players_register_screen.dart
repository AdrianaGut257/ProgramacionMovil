import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/data/datasources/app_database.dart';
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

  void _addPlayer() {
    setState(() {
      players.add("");
    });
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

  Future<void> _startGame() async {
    final validPlayers = players.where((p) => p.trim().isNotEmpty).toList();

    final db = await AppDatabase.instance.database;

    final allPlayers = await db.query('player');
    if (kDebugMode) {
      print('Contenido completo de la tabla player: $allPlayers');
    }

    if (validPlayers.isEmpty) {
      if (!mounted) return; // 🔥 evita usar context si el widget ya no existe
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Agrega al menos un jugador")),
      );
      return;
    }

    try {
      // Insertar todos los jugadores válidos en la base
      await AppDatabase.instance.insertPlayers(validPlayers);

      if (kDebugMode) {
        print("Jugadores guardados en DB: $validPlayers");
      }

      // Opcional: mostrar todos los registros que quedaron guardados
      final all = await db.query('player');
      if (kDebugMode) {
        print("Contenido completo de la tabla player: $all");
      }

      // Verificamos que el widget siga montado antes de navegar
      if (!mounted) return;

      // Ahora navega a la siguiente pantalla
      //context.push('/select-categories', extra: validPlayers);

// después
      context.push('/select-categories', extra: {
        'players': validPlayers,
      });
    } catch (e, st) {
      if (kDebugMode) {
        print('Error al guardar jugadores: $e\n$st');
      }
    }
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
                      onAdd: () => _addPlayer(),
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
