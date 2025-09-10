import 'package:flutter/material.dart';
import '../../../../config/colors.dart';
import '../buttons/add_remove_button.dart';

class PlayerInputField extends StatelessWidget {
  final int index;
  final bool isLast;
  final Function(String) onChanged;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const PlayerInputField({
    super.key,
    required this.index,
    required this.isLast,
    required this.onChanged,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(25),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primaryVariant, // color del borde inferior
                    width: 4, // grosor del borde
                  ),
                ),
              ),
              child: TextField(
                onChanged: onChanged,
                decoration: const InputDecoration(
                  hintText: 'Escribe aquí',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 10),
          AddRemoveButton(isAdd: isLast, onPressed: isLast ? onAdd : onRemove),
        ],
      ),
    );
  }
}
