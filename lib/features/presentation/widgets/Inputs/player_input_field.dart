import 'package:flutter/material.dart';
import '../../../../config/colors.dart';
import '../buttons/add_remove_button.dart';

class PlayerInputField extends StatefulWidget {
  final int index;
  final bool isLast;
  final String initialValue;
  final Function(String) onChanged;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const PlayerInputField({
    super.key,
    required this.index,
    required this.isLast,
    required this.initialValue,
    required this.onChanged,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<PlayerInputField> createState() => _PlayerInputFieldState();
}

class _PlayerInputFieldState extends State<PlayerInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(PlayerInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: AppColors.primaryVariant,
        borderRadius: BorderRadius.circular(25),
        border: Border(
          bottom: BorderSide(color: AppColors.primaryVariant, width: 4),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(25),
          border: Border(
            bottom: BorderSide(color: AppColors.primaryVariant, width: 3),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: widget.onChanged,
                decoration: const InputDecoration(
                  hintText: 'Escribe aquí',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 9),
              child: AddRemoveButton(
                isAdd: widget.isLast,
                onPressed: widget.isLast ? widget.onAdd : widget.onRemove,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
