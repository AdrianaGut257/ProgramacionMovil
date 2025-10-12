import 'package:flutter/material.dart';
import '../../../../../../config/colors.dart';
import '../../../../widgets/Inputs/player_input_field.dart';
import 'package:google_fonts/google_fonts.dart';

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
          style: GoogleFonts.titanOne().copyWith(
            fontSize: 23,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            letterSpacing: 0,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        ...players.asMap().entries.map((entry) {
          final index = entry.key;
          final isLast = index == players.length - 1;

          return PlayerInputField(
            key: Key('player_${title}_$index'),
            index: index,
            isLast: isLast,
            initialValue: players[index],
            onChanged: (value) => onUpdatePlayer(index, value),
            onAdd: onAddPlayer,
            onRemove: () => onRemovePlayer(index),
          );
        }),
      ],
    );
  }
}
