import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import '../../seeders/category_seeder.dart';

/// Gestiona todas las migraciones de la base de datos
class MigrationManager {
  /// Crea las tablas iniciales (versión 1)
  static Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE players (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        score INTEGER DEFAULT 0,
        team INTEGER DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE category (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        is_default INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE game_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        game_mode TEXT NOT NULL,
        created_at TEXT NOT NULL,
        winner_team INTEGER,
        team1_score INTEGER DEFAULT 0,
        team2_score INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE game_players (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        game_id INTEGER NOT NULL,
        player_name TEXT NOT NULL,
        score INTEGER NOT NULL,
        position INTEGER NOT NULL,
        team INTEGER,
        FOREIGN KEY (game_id) REFERENCES game_history (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE game_categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        game_id INTEGER NOT NULL,
        category_name TEXT NOT NULL,
        FOREIGN KEY (game_id) REFERENCES game_history (id) ON DELETE CASCADE
      )
    ''');

    // Ejecutar seeders
    await CategorySeeder.run(db);

    if (kDebugMode) {
      debugPrint('✅ Base de datos creada - versión $version');
    }
  }

  /// Maneja las actualizaciones de versión
  static Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (kDebugMode) {
      debugPrint('🔄 Migrando base de datos: v$oldVersion → v$newVersion');
    }

    // Migración a versión 2: Agregar columna is_default
    if (oldVersion < 2) {
      await _migrateToV2(db);
    }

    // Migración a versión 3: Marcar categorías por defecto
    if (oldVersion < 3) {
      await _migrateToV3(db);
    }

    // Migración a versión 4: Crear tablas de historial
    if (oldVersion < 4) {
      await _migrateToV4(db);
    }

    // Migración a versión 5: Agregar soporte para equipos
    if (oldVersion < 5) {
      await _migrateToV5(db);
    }

    if (kDebugMode) {
      debugPrint('✅ Migración completada a v$newVersion');
    }
  }

  /// Versión 2: Agregar columna is_default a categorías
  static Future<void> _migrateToV2(Database db) async {
    await db.execute('''
      ALTER TABLE category ADD COLUMN is_default INTEGER DEFAULT 0
    ''');

    if (kDebugMode) {
      debugPrint('  ✓ Migración v2: Columna is_default agregada');
    }
  }

  /// Versión 3: Marcar categorías predeterminadas
  static Future<void> _migrateToV3(Database db) async {
    await markDefaultCategories(db);

    if (kDebugMode) {
      debugPrint('  ✓ Migración v3: Categorías predeterminadas marcadas');
    }
  }

  /// Versión 4: Crear tablas de historial de juegos
  static Future<void> _migrateToV4(Database db) async {
    await db.execute('''
      CREATE TABLE game_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        game_mode TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE game_players (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        game_id INTEGER NOT NULL,
        player_name TEXT NOT NULL,
        score INTEGER NOT NULL,
        position INTEGER NOT NULL,
        FOREIGN KEY (game_id) REFERENCES game_history (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE game_categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        game_id INTEGER NOT NULL,
        category_name TEXT NOT NULL,
        FOREIGN KEY (game_id) REFERENCES game_history (id) ON DELETE CASCADE
      )
    ''');

    if (kDebugMode) {
      debugPrint('  ✓ Migración v4: Tablas de historial creadas');
    }
  }

  /// Versión 5: Agregar soporte para equipos
  static Future<void> _migrateToV5(Database db) async {
    await db.execute('''
      ALTER TABLE game_history ADD COLUMN winner_team INTEGER
    ''');

    await db.execute('''
      ALTER TABLE game_history ADD COLUMN team1_score INTEGER DEFAULT 0
    ''');

    await db.execute('''
      ALTER TABLE game_history ADD COLUMN team2_score INTEGER DEFAULT 0
    ''');

    await db.execute('''
      ALTER TABLE game_players ADD COLUMN team INTEGER
    ''');

    if (kDebugMode) {
      debugPrint('  ✓ Migración v5: Soporte para equipos agregado');
    }
  }

  /// Marca las categorías predeterminadas del seeder
  /// PÚBLICO para uso en fixDefaultCategories()
  static Future<void> markDefaultCategories(Database db) async {
    final seederCategories = [
      'Animales',
      'Frutas',
      'Musica',
      'Vegetales',
      'Colores',
      'Ciudades',
      'Paises',
      'Deportes',
      'Marcas',
      'Comidas',
      'Bebidas',
      'Profesiones',
      'Instrumentos',
      'Flores',
      'Ropa',
      'Juguetes',
      'Peliculas',
      'Series',
      'Libros',
      'Tecnologia',
    ];

    for (final name in seederCategories) {
      await db.update(
        'category',
        {'is_default': 1},
        where: 'name = ?',
        whereArgs: [name],
      );
    }
  }
}