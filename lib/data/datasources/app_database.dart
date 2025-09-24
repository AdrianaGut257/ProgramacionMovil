import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/player.dart';

class AppDatabase {
  // Singleton
  AppDatabase._privateConstructor();
  static final AppDatabase instance = AppDatabase._privateConstructor();

  // Cambia a true solo durante desarrollo para reiniciar DB
  static const bool resetDatabaseOnStart = false;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'database_sqlite.db');

    if (resetDatabaseOnStart) {
      // Cierra la base si ya estaba abierta
      if (_db != null) {
        await _db!.close();
        _db = null;
      }
      // Borra el archivo físico de la DB
      await deleteDatabase(path);
      if (kDebugMode) {
        print('Base de datos eliminada y lista para recrear');
      }
    }

    // Abrir o crear la DB
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE players(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        score INTEGER,
        team INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE category (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE category_item (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES category (id) ON DELETE CASCADE
      )
    ''');
  }

  // Insertar múltiples jugadores
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

  // Insertar un solo jugador
  Future<int> insertPlayer(Player player) async {
    final db = await database;
    return await db.insert(
      'players',
      player.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los jugadores
  Future<List<Player>> getPlayers() async {
    final db = await database;
    final data = await db.query('player');
    return data
        .map(
          (e) => Player(
            id: e["id"] as int,
            name: e["name"] as String,
            score: e["score"] as int? ?? 0,
            team: e["team"] as int,
          ),
        )
        .toList();
  }

  Future<void> insertPlayers(List<Player> players) async {
    final db = await database;
    for (var player in players) {
      await db.insert('player', {
        'name': player.name.trim(),
        'score': player.score,
        'team': player.team, // 👈 obligatorio
      });
    }
  }

  Future<void> insertCategory(String category) async {
    final db = await database;
    await db.insert('category', {'name': category});
  }
}
