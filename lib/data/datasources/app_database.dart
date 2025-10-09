import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import '../models/player.dart';
import 'seeders/category_seeder.dart';

class AppDatabase {
  AppDatabase._privateConstructor();
  static final AppDatabase instance = AppDatabase._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
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

    await _runSeeders(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE category ADD COLUMN is_default INTEGER DEFAULT 0
      ''');
    }

    if (oldVersion < 3) {
      await _markDefaultCategories(db);
    }
  }

  Future<void> _runSeeders(Database db) async {
    await CategorySeeder.run(db);
  }

  Future<void> _markDefaultCategories(Database db) async {
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
      final result = await db.update(
        'category',
        {'is_default': 1},
        where: 'name = ?',
        whereArgs: [name],
      );

      if (kDebugMode) {
        debugPrint("Actualizado $name: $result filas afectadas");
      }
    }
  }

  Future<void> fixDefaultCategories() async {
    final db = await database;
    await _markDefaultCategories(db);

    final defaults = await getDefaultCategories();
    if (kDebugMode) {
      debugPrint("✅ Total categorías predeterminadas: ${defaults.length}");
    }
  }

  Future<void> insertPlayers(List<Player> players) async {
    final db = await database;
    for (final player in players) {
      await db.insert(
        'players',
        player.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> insertCategory(String name) async {
    final db = await database;
    await db.insert('category', {
      'name': name,
      'is_default': 0,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return await db.query('category');
  }

  Future<List<Map<String, dynamic>>> getDefaultCategories() async {
    final db = await database;
    final result = await db.query(
      'category',
      where: 'is_default = ?',
      whereArgs: [1],
    );

    return result;
  }

  Future<List<Map<String, dynamic>>> getCustomCategories() async {
    final db = await database;
    return await db.query('category', where: 'is_default = ?', whereArgs: [0]);
  }

  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    await _database?.close();
    _database = null;

    await deleteDatabase(path);
  }
}
