import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final bool isTeamMode;

  const EmptyStateWidget({
    super.key,
    required this.isTeamMode,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isTeamMode ? Icons.groups : Icons.person,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isTeamMode 
                ? 'No hay partidas de equipos'
                : 'No hay partidas individuales',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Juega una partida para ver el historial',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}