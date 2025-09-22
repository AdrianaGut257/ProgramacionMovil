import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/data/datasources/app_database.dart';
import 'package:programacion_movil/data/models/player.dart';
import '../../../widgets/Inputs/player_input_field.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/home_header.dart';
import 'package:go_router/go_router.dart';

class PlayersRegisterScreen extends StatefulWidget {
  const PlayersRegisterScreen({super.key});

  @override
  State<PlayersRegisterScreen> createState() => _PlayersRegisterScreenState();
}

class _PlayersRegisterScreenState extends State<PlayersRegisterScreen> {
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

    if (validPlayers.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Agrega al menos un jugador")),
      );
      return;
    }

    final playersToInsert = validPlayers.asMap().entries.map((e) {
      return Player(
        id: 0, // SQLite autoincrementará
        name: e.value.trim(),
        score: 0,
        team: 1, // o asigna 2 si quieres diferenciar equipos
      );
    }).toList();

    final db = await AppDatabase.instance.database;
    await AppDatabase.instance.insertPlayers(playersToInsert);

    final all = await db.query('player');
    if (kDebugMode) {
      print("Contenido completo de la tabla player: $all");
    }

    if (!mounted) return;
    context.push('/select-categories', extra: playersToInsert);
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
              const HomeHeader(),
              Text(
                "Ingresar nombres",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
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

              CustomButton(text: "Jugar", onPressed: _startGame),
            ],
          ),
        ),
      ),
    );
  }
}
