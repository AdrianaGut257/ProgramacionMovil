import 'package:flutter/material.dart';
import '../../../../../config/colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'StopWords',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Elige una opción',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ],
    );
  }
}
