import 'package:flutter/material.dart';

const categoryTitleStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Color(0xFFFFBE54),
  shadows: [
    Shadow(
      offset: Offset(2, 2), // 📍 Desplazamiento de la sombra (x, y)
      blurRadius: 4.0, // 🌫️ Difuminado de la sombra
      color: Colors.black, // 🎨 Color de la sombra
    ),
  ],
);
