import 'package:flutter/material.dart';
import 'widgets/team_section.dart';
import 'widgets/game_mode_selector.dart';
import 'widgets/validation_dialog.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/home_header.dart';

import 'package:provider/provider.dart';
import '../../../../../features/presentation/state/game_team.dart';
import '../../../../../data/models/player.dart' as models;

import 'package:go_router/go_router.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupModePage extends StatefulWidget {
  const GroupModePage({super.key});

  @override
  State<GroupModePage> createState() => _GroupModePageState();
}

class _GroupModePageState extends State<GroupModePage> {
  bool isDetermined = true;
  List<String> team1Players = List.generate(2, (_) => '');
  List<String> team2Players = List.generate(2, (_) => '');
  List<String> randomPlayers = List.generate(4, (_) => '');

  void _updatePlayer(List<String> team, int index, String value) {
    setState(() {
      team[index] = value;
    });
  }

  void _addPlayer(List<String> team) {
    setState(() {
      team.add('');
    });
  }

  void _removePlayer(List<String> team, int index) {
    if (team.length > 1) {
      setState(() {
        team.removeAt(index);
      });
    }
  }

  void _startGame() {
    List<String> currentPlayers = isDetermined
        ? [...team1Players, ...team2Players]
        : randomPlayers;

    final validPlayers = currentPlayers
        .where((p) => p.trim().isNotEmpty)
        .toList();

    if (validPlayers.isEmpty) {
      ValidationDialog.show(
        context,
        "No puedes comenzar sin jugadores, agrega mínimo 2",
        ValidationType.noPlayers,
      );
      return;
    }

    if (validPlayers.length < 2) {
      ValidationDialog.show(
        context,
        "Se necesitan al menos 2 jugadores para comenzar",
        ValidationType.minPlayers,
      );
      return;
    }

    final uniqueNames = validPlayers.map((p) => p.trim().toLowerCase()).toSet();
    if (uniqueNames.length != validPlayers.length) {
      ValidationDialog.show(
        context,
        "No puedes repetir nombres de jugadores",
        ValidationType.duplicateNames,
      );
      return;
    }

    if (isDetermined) {
      final team1Valid = team1Players
          .where((p) => p.trim().isNotEmpty)
          .toList();
      final team2Valid = team2Players
          .where((p) => p.trim().isNotEmpty)
          .toList();

      if (team1Valid.length != team2Valid.length) {
        ValidationDialog.show(
          context,
          "Los equipos deben tener la misma cantidad de jugadores",
          ValidationType.unequalTeams,
        );
        return;
      }
    } else {
      if (validPlayers.length % 2 != 0) {
        ValidationDialog.show(
          context,
          "La cantidad de jugadores debe ser un número par",
          ValidationType.oddPlayers,
        );
        return;
      }
    }

    final gameTeam = context.read<GameTeam>();
    gameTeam.clearPlayers();

    if (isDetermined) {
      for (int i = 0; i < team1Players.length; i++) {
        if (team1Players[i].trim().isNotEmpty) {
          gameTeam.addPlayer(
            models.Player(id: i + 1, name: team1Players[i], score: 0, team: 1),
          );
        }
      }

      for (int i = 0; i < team2Players.length; i++) {
        if (team2Players[i].trim().isNotEmpty) {
          gameTeam.addPlayer(
            models.Player(
              id: i + 100,
              name: team2Players[i],
              score: 0,
              team: 2,
            ),
          );
        }
      }
    } else {
      final shuffledPlayers = List<String>.from(validPlayers)..shuffle();
      final halfSize = shuffledPlayers.length ~/ 2;

      for (int i = 0; i < halfSize; i++) {
        gameTeam.addPlayer(
          models.Player(id: i + 1, name: shuffledPlayers[i], score: 0, team: 1),
        );
      }

      for (int i = halfSize; i < shuffledPlayers.length; i++) {
        gameTeam.addPlayer(
          models.Player(
            id: i + 100,
            name: shuffledPlayers[i],
            score: 0,
            team: 2,
          ),
        );
      }
    }

    context.push('/select-categories');
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
                        'Elige una opción',
                        style: GoogleFonts.titanOne().copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          letterSpacing: 0,
                          height: 1.1,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: isSmallScreen ? 8 : 10),

                      GameModeSelector(
                        isDetermined: isDetermined,
                        onModeChanged: (value) {
                          setState(() {
                            if (value == false && isDetermined == true) {
                              randomPlayers = [
                                ...team1Players.where((p) => p.isNotEmpty),
                                ...team2Players.where((p) => p.isNotEmpty),
                              ];
                              if (randomPlayers.isEmpty) randomPlayers = [''];
                            }
                            isDetermined = value;
                          });
                        },
                      ),

                      SizedBox(height: isSmallScreen ? 15 : 20),

                      ConstrainedBox(
                        constraints: BoxConstraints(minHeight: height * 0.30),
                        child: Column(
                          children: [
                            if (isDetermined) ...[
                              TeamSection(
                                title: 'Equipo 1',
                                players: team1Players,
                                onUpdatePlayer: (i, v) =>
                                    _updatePlayer(team1Players, i, v),
                                onAddPlayer: () => _addPlayer(team1Players),
                                onRemovePlayer: (i) =>
                                    _removePlayer(team1Players, i),
                              ),
                              SizedBox(height: isSmallScreen ? 15 : 20),
                              TeamSection(
                                title: 'Equipo 2',
                                players: team2Players,
                                onUpdatePlayer: (i, v) =>
                                    _updatePlayer(team2Players, i, v),
                                onAddPlayer: () => _addPlayer(team2Players),
                                onRemovePlayer: (i) =>
                                    _removePlayer(team2Players, i),
                              ),
                            ] else ...[
                              TeamSection(
                                title: 'Ingresar nombres',
                                players: randomPlayers,
                                onUpdatePlayer: (i, v) =>
                                    _updatePlayer(randomPlayers, i, v),
                                onAddPlayer: () => _addPlayer(randomPlayers),
                                onRemovePlayer: (i) =>
                                    _removePlayer(randomPlayers, i),
                              ),
                            ],
                          ],
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
