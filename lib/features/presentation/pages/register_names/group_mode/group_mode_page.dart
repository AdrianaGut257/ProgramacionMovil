import 'package:flutter/material.dart';
import 'widgets/team_section.dart';
import 'widgets/game_mode_selector.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/home_header.dart';

import 'package:provider/provider.dart';
import '../../../../../features/presentation/state/game_team.dart';
import '../../../../../data/models/player.dart' as models;

import 'package:go_router/go_router.dart';

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

    if (validPlayers.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Agrega al menos 2 jugadores")),
      );
      return;
    }

    final gameTeam = context.read<GameTeam>();

    gameTeam.clearPlayers();

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
          models.Player(id: i + 100, name: team2Players[i], score: 0, team: 2),
        );
      }
    }

    context.push('/select-categories');
  }

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

              const Text(
                'Elige una opción',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 10),

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
              const SizedBox(height: 30),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (isDetermined) ...[
                        TeamSection(
                          title: 'Equipo 1',
                          players: team1Players,
                          onUpdatePlayer: (i, v) =>
                              _updatePlayer(team1Players, i, v),
                          onAddPlayer: () => _addPlayer(team1Players),
                          onRemovePlayer: (i) => _removePlayer(team1Players, i),
                        ),
                        const SizedBox(height: 20),
                        TeamSection(
                          title: 'Equipo 2',
                          players: team2Players,
                          onUpdatePlayer: (i, v) =>
                              _updatePlayer(team2Players, i, v),
                          onAddPlayer: () => _addPlayer(team2Players),
                          onRemovePlayer: (i) => _removePlayer(team2Players, i),
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
              ),
              CustomButton(text: "Jugar", onPressed: _startGame),
            ],
          ),
        ),
      ),
    );
  }
}
