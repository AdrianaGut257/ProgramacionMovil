import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/data/datasources/app_database.dart';
import 'package:programacion_movil/data/models/player.dart';
import '../../../widgets/Inputs/player_input_field.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/home_header.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayersRegisterScreen extends StatefulWidget {
  const PlayersRegisterScreen({super.key});

  @override
  State<PlayersRegisterScreen> createState() => _PlayersRegisterScreenState();
}

class _PlayersRegisterScreenState extends State<PlayersRegisterScreen> {
  List<String> players = [""];

  void _addPlayer() => setState(() => players.add(""));

  void _removePlayer(int index) {
    if (players.length <= 1) return;
    setState(() => players.removeAt(index));
  }

  void _updatePlayer(int index, String value) {
    setState(() => players[index] = value);
  }

  Future<void> _startGame() async {
    if (kDebugMode) {
      print("inicio de _startGame");
    }
    if (kDebugMode) {
      print(
        "estas son las categorias: ${await AppDatabase.instance.getCategories()}",
      );
    }

    final validPlayers = players.where((p) => p.trim().isNotEmpty).toList();
    if (validPlayers.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Agrega al menos un jugador")),
      );
      return;
    }

    final playersToInsert = validPlayers
        .map((name) => Player(name: name.trim(), score: 0, team: 1))
        .toList();

    try {
      await AppDatabase.instance.insertPlayers(playersToInsert);

      final db = await AppDatabase.instance.database;
      final all = await db.query('players');
      if (kDebugMode) print("Contenido de la tabla players: $all");

      if (!mounted) return;
      context.push(
        '/select-categories',
        extra: {
          'mode': 'individual',
          'players': playersToInsert,
          'difficulty': 'easy',
        },
      );
    } catch (e, stack) {
      if (kDebugMode) {
        print("Error en _startGame: $e");
        print(stack);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final isSmallScreen = height < 700;

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
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HomeHeader(onBackPressed: () => context.pop()),

                      SizedBox(height: isSmallScreen ? 8 : 12),

                      Text(
                        "Ingresar nombres",
                        style: GoogleFonts.titanOne().copyWith(
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          letterSpacing: 0,
                          height: 1.1,
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 15 : 20),

                      ConstrainedBox(
                        constraints: BoxConstraints(minHeight: height * 0.35),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
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

                      SizedBox(height: isSmallScreen ? 20 : 30),

                      CustomButton(
                        text: "Jugar",
                        icon: Icons.gamepad,
                        onPressed: _startGame,
                      ),

                      SizedBox(height: height * 0.05),
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
