import 'package:flutter/material.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/back_button_custom.dart';
import 'package:provider/provider.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/data/models/player.dart';
import '../../../widgets/Inputs/player_input_field.dart';
import '../../../widgets/buttons/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../features/presentation/state/game_individual.dart';

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

  void _startGame() {
    final validPlayers = players.where((p) => p.trim().isNotEmpty).toList();

    if (validPlayers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Agrega al menos un jugador")),
      );
      return;
    }

    final gameIndividual = context.read<GameIndividual>();
    gameIndividual.clearPlayers();

    List<Player> playerObjects = [];
    for (int i = 0; i < validPlayers.length; i++) {
      final player = Player(
        id: i + 1,
        name: validPlayers[i].trim(),
        score: 0,
        team: 1,
      );
      gameIndividual.addPlayer(player);
      playerObjects.add(player);
    }

    if (!mounted) return;

    context.push(
      '/select-categories',
      extra: {
        'mode': 'individual',
        'players': playerObjects,
        'difficulty': 'easy',
      },
    );
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
                      Row(
                        children: [
                          BackButtonCustom(onPressed: () => context.pop()),
                          const Spacer(),
                        ],
                      ),
                      SizedBox(height: 2),
                     Center(
                    child: Image.asset(
                      'assets/icons/logo.png',
                      width: 370,
                      height: 170,
                      fit: BoxFit.cover,
                    ),
                  ),

                      SizedBox(height: isSmallScreen ? 5 : 10),

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
                              onAdd: _addPlayer,
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
