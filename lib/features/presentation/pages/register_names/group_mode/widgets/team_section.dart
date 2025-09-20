import 'package:flutter/material.dart';
import '../../../../../../config/colors.dart';
import '../../../../widgets/Inputs/player_input_field.dart';

class TeamSection extends StatelessWidget {
  final String title;
  final List<String> players;
  final void Function(int index, String value) onUpdatePlayer;
  final VoidCallback onAddPlayer;
  final void Function(int index) onRemovePlayer;

  const TeamSection({
    super.key,
    required this.title,
    required this.players,
    required this.onUpdatePlayer,
    required this.onAddPlayer,
    required this.onRemovePlayer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
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
            key: Key('player_${title}_$index'),
            index: index,
            isLast: isLast,
            initialValue:
                players[index], // 🔑 sincroniza con la lista del padre
            onChanged: (value) => onUpdatePlayer(index, value),
            onAdd: onAddPlayer,
            onRemove: () => onRemovePlayer(index),
          );
        }),
      ],
    );
  }
}
