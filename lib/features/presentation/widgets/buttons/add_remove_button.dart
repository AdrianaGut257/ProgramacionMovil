import 'package:flutter/material.dart';
import '../../../../config/colors.dart';

class AddRemoveButton extends StatelessWidget {
  final bool isAdd;
  final VoidCallback onPressed;

  const AddRemoveButton({
    super.key,
    required this.isAdd,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isAdd ? AppColors.success : AppColors.error,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isAdd ? Icons.add : Icons.remove,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
