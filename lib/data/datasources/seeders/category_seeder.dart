import 'package:sqflite/sqflite.dart';

class CategorySeeder {
  static Future<void> run(Database db) async {
    final categories = [
      {'name': 'Animales', 'is_default': 1},
      {'name': 'Frutas', 'is_default': 1},
      {'name': 'Musica', 'is_default': 1},
      {'name': 'Vegetales', 'is_default': 1},
      {'name': 'Colores', 'is_default': 1},
      {'name': 'Ciudades', 'is_default': 1},
      {'name': 'Paises', 'is_default': 1},
      {'name': 'Deportes', 'is_default': 1},
      {'name': 'Marcas', 'is_default': 1},
      {'name': 'Comidas', 'is_default': 1},
      {'name': 'Bebidas', 'is_default': 1},
      {'name': 'Profesiones', 'is_default': 1},
      {'name': 'Instrumentos', 'is_default': 1},
      {'name': 'Flores', 'is_default': 1},
      {'name': 'Ropa', 'is_default': 1},
      {'name': 'Juguetes', 'is_default': 1},
      {'name': 'Peliculas', 'is_default': 1},
      {'name': 'Series', 'is_default': 1},
      {'name': 'Libros', 'is_default': 1},
      {'name': 'Tecnologia', 'is_default': 1},
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
