import 'package:flutter/material.dart';
import '../../../../../config/colors.dart';
import '../../../widgets/Inputs/player_input_field.dart';

class TeamSection extends StatefulWidget {
  final String title;
  final int initialPlayerCount;

  const TeamSection({
    super.key,
    required this.title,
    required this.initialPlayerCount,
  });

  @override
  State<TeamSection> createState() => _TeamSectionState();
}

class _TeamSectionState extends State<TeamSection> {
  late List<String> players;

  @override
  void initState() {
    super.initState();
    players = List.generate(widget.initialPlayerCount, (index) => '');
  }

  void _addPlayer() {
    setState(() {
      players.add('');
    });
  }

  void _removePlayer(int index) {
    if (players.length > 1) {
      setState(() {
        players.removeAt(index);
      });
    }
  }

  void _updatePlayer(int index, String value) {
    setState(() {
      players[index] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 15),
        ...players.asMap().entries.map((entry) {
          final index = entry.key;
          final isLast = index == players.length - 1;

          return PlayerInputField(
            key: Key('player_$index'),
            index: index,
            isLast: isLast,
            onChanged: (value) => _updatePlayer(index, value),
            onAdd: _addPlayer,
            onRemove: () => _removePlayer(index),
          );
        }),
      ],
    );
  }
}
