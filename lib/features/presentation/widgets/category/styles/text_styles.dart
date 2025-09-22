import 'package:flutter/material.dart';

final categoryTitleStyle = TextStyle(
  fontSize: 60,
  fontWeight: FontWeight.bold,
  color: Color(0xFFFFBE54),
  shadows: [
    Shadow(
      offset: Offset(1.7, 1.7), // 📍 Desplazamiento de la sombra (x, y)
      blurRadius: 4.0, // 🌫️ Difuminado de la sombra
      color: Colors.black, // 🎨 Color de la sombra
    ),
  ],
);

final categorySubtitleStyle = categoryTitleStyle.copyWith(fontSize: 24);
