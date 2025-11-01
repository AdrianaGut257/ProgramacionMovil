import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:programacion_movil/config/colors.dart';

class RecordHelpers {
  // Formatea la fecha de ISO8601 a formato legible
  static String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  // Retorna el color según la posición del jugador
  static Color getPositionColor(int position) {
    switch (position) {
      case 1:
        return Colors.amber; // 🥇 Oro
      case 2:
        return Colors.blueGrey[300]!; // 🥈 Plata
      case 3:
        return Colors.brown[300]!; // 🥉 Bronce
      default:
        return AppColors.grey; // Otros
    }
  }

  // Retorna el icono según la posición del jugador
  static IconData getPositionIcon(int position) {
    switch (position) {
      case 1:
        return Icons.emoji_events; // Trofeo completo
      case 2:
        return Icons.emoji_events_outlined; // Trofeo outlined
      case 3:
        return Icons.emoji_events_outlined; // Trofeo outlined
      default:
        return Icons.person; // Icono genérico
    }
  }

  // Retorna el color del equipo
  static Color getTeamColor(int team) {
    return team == 1 ? Colors.blue : Colors.red;
  }

  // Retorna el icono según el modo de juego
  static IconData getGameModeIcon(String gameMode) {
    if (gameMode == 'Hard Mode') {
      return Icons.whatshot; // 🔥 Fuego para difícil
    } else if (gameMode == 'Easy Mode') {
      return Icons.emoji_emotions; // 😊 Cara feliz para fácil
    } else if (gameMode == 'Team Mode') {
      return Icons.groups; // 👥 Grupos para equipos
    } else {
      return Icons.gamepad; // 🎮 Gamepad por defecto
    }
  }

  // Retorna el color según el modo de juego
  static Color getGameModeColor(String gameMode) {
    if (gameMode == 'Hard Mode') {
      return Colors.red; // Rojo para difícil
    } else if (gameMode == 'Team Mode') {
      return AppColors.primary; // Azul para equipos
    } else {
      return AppColors.primary; // Azul por defecto (Easy Mode)
    }
  }

  // Construye el widget de posición circular
  static Widget buildPositionBadge(int position) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: position <= 3
            ? getPositionColor(position)
            : Colors.grey[400],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$position°',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // Construye el widget de posición circular pequeño
  static Widget buildSmallPositionBadge(int position) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: position <= 3
            ? getPositionColor(position)
            : Colors.grey[400],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$position°',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // Construye el badge de puntuación
  static Widget buildScoreBadge(int score, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color ?? AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$score pts',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  // Construye el badge de puntuación grande
  static Widget buildLargeScoreBadge(int score, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color ?? AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$score pts',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  // Construye el badge de equipo (T1, T2)
  static Widget buildTeamBadge(int team) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: getTeamColor(team),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'T$team',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Construye el chip de categoría
  static Widget buildCategoryChip(String categoryName) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        categoryName,
        style: TextStyle(
          fontSize: 11,
          color: AppColors.secondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Construye el chip de categoría grande (para modal)
  static Widget buildLargeCategoryChip(String categoryName) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        categoryName,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.secondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}