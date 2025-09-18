import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:programacion_movil/data/models/player.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
  static Database? _db;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'database_sqlite.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE player (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');
  }

  Future<List<Player>?> getPlayers() async {
    final db = await database;
    final data = await db.query('player');
    List<Player> players = data
        .map((e) => Player(id: e["id"] as int, name: e["name"] as String))
        .toList();
    return players;
  }
}
