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
  final String? difficulty;

  const PlayersRegisterScreen({super.key, this.difficulty});

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

  void _showCustomModal(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: AppColors.primary, size: 60),
                const SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Aceptar",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _startGame() {
    final validPlayers = players.where((p) => p.trim().isNotEmpty).toList();

    if (validPlayers.isEmpty) {
      _showCustomModal("Agrega al menos un jugador");
      return;
    }

    if (validPlayers.length < 2) {
      _showCustomModal("Debes ingresar al menos 2 jugadores para continuar");
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

    //Ahora redirige a /comodines-info
    context.push(
      '/comodines-info',
      extra: {
        'mode': 'individual',
        'players': playerObjects,
        'difficulty': widget.difficulty ?? 'easy',
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
                      const SizedBox(height: 2),
                      Center(
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: AspectRatio(
                            aspectRatio: 370 / 170,
                            child: Image.asset(
                              'assets/icons/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
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
