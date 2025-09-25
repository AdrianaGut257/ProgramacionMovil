// lib/data/datasources/seeders/category_seeder.dart
import 'package:sqflite/sqflite.dart';

class CategorySeeder {
  static Future<void> run(Database db) async {
    final categories = [
      {'name': 'Animales'},
      {'name': 'Frutas'},
      {'name': 'Musica'},
      {'name': 'Vegetales'},
      {'name': 'Colores'},
      {'name': 'Ciudades'},
      {'name': 'Paises'},
      {'name': 'Deportes'},
      {'name': 'Marcas'},
      {'name': 'Comidas'},
      {'name': 'Bebidas'},
      {'name': 'Profesiones'},
      {'name': 'Instrumentos'},
      {'name': 'Flores'},
      {'name': 'Ropa'},
      {'name': 'Juguetes'},
      {'name': 'Películas'},
      {'name': 'Series'},
      {'name': 'Libros'},
      {'name': 'Tecnología'},
    ];

    for (final category in categories) {
      await db.insert(
        'category',
        category,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }
}
