import 'package:flutter/material.dart';

class GlobalIcons {
  static final Map<String, IconData> iconMap = {
    "Musica": Icons.music_note,
    "Animales": Icons.pets,
    "Paises": Icons.flag,
    "Frutas": Icons.apple,
    "Vegetales": Icons.eco,
    "Colores": Icons.palette,
    "Profesiones": Icons.work,
    "Ropa": Icons.checkroom,
    "Películas": Icons.movie,
    "Comidas": Icons.restaurant,
    "Ciudades": Icons.location_city,
    "Deportes": Icons.sports_soccer,
    "Marcas": Icons.business,
    "Bebidas": Icons.local_drink,
    "Instrumentos": Icons.piano,
    "Flores": Icons.local_florist,
    "Juguetes": Icons.toys,
    "Series": Icons.tv,
    "Libros": Icons.book,
    "Tecnología": Icons.computer,
  };

  static IconData getIcon(String category) {
    return iconMap[category] ?? Icons.label;
  }
}
