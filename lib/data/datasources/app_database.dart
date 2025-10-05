import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
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
    return await openDatabase(path, version: 1, onCreate: _onCreate);
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
        name TEXT NOT NULL UNIQUE
      )
    ''');

    await _runSeeders(db);
  }

  Future<void> _runSeeders(Database db) async {
    await CategorySeeder.run(db);
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
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return await db.query('category');
  }
}
