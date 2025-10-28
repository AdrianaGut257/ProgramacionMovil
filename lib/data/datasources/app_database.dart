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
      version: 5,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
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

    if (oldVersion < 4) {
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
        debugPrint("✅ Tablas de historial creadas correctamente");
      }
    }

    // 🆕 Nueva migración para soporte de equipos
    if (oldVersion < 5) {
      // Agregar columnas para equipos en game_history
      await db.execute('''
        ALTER TABLE game_history ADD COLUMN winner_team INTEGER
      ''');
      
      await db.execute('''
        ALTER TABLE game_history ADD COLUMN team1_score INTEGER DEFAULT 0
      ''');
      
      await db.execute('''
        ALTER TABLE game_history ADD COLUMN team2_score INTEGER DEFAULT 0
      ''');

      // Agregar columna de equipo en game_players
      await db.execute('''
        ALTER TABLE game_players ADD COLUMN team INTEGER
      ''');

      if (kDebugMode) {
        debugPrint("✅ Tablas actualizadas con soporte para equipos");
      }
    }
  }

  Future<void> _runSeeders(Database db) async {
    await CategorySeeder.run(db);
  }

  /// Guarda una partida en modo INDIVIDUAL
  Future<int> saveGameHistory({
    required String gameMode,
    required Map<String, int> playerScores,
    required List<String> categories,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    final gameId = await db.insert('game_history', {
      'date': now,
      'game_mode': gameMode,
      'created_at': now,
    });

    final sortedPlayers = playerScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    int position = 1;
    for (final entry in sortedPlayers) {
      await db.insert('game_players', {
        'game_id': gameId,
        'player_name': entry.key,
        'score': entry.value,
        'position': position,
      });
      position++;
    }

    for (final categoryName in categories) {
      await db.insert('game_categories', {
        'game_id': gameId,
        'category_name': categoryName,
      });
    }

    if (kDebugMode) {
      debugPrint("✅ Partida individual guardada con ID: $gameId");
    }

    return gameId;
  }

  /// 🆕 Guarda una partida en modo EQUIPOS
  Future<int> saveTeamGameHistory({
    required String gameMode,
    required Map<String, int> playerScores,
    required List<dynamic> orderedPlayers, // Lista de objetos Player con .name y .team
    required List<String> categories,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    // Calcular puntuaciones por equipo
    int team1Score = 0;
    int team2Score = 0;

    for (final player in orderedPlayers) {
      final playerName = player.name;
      final playerTeam = player.team;
      final score = playerScores[playerName] ?? 0;

      if (playerTeam == 1) {
        team1Score += score;
      } else if (playerTeam == 2) {
        team2Score += score;
      }
    }

    // Determinar equipo ganador
    int? winnerTeam;
    if (team1Score > team2Score) {
      winnerTeam = 1;
    } else if (team2Score > team1Score) {
      winnerTeam = 2;
    }
    // Si es empate, winnerTeam queda null

    // 1. Insertar el registro de la partida
    final gameId = await db.insert('game_history', {
      'date': now,
      'game_mode': gameMode,
      'created_at': now,
      'winner_team': winnerTeam,
      'team1_score': team1Score,
      'team2_score': team2Score,
    });

    // 2. Ordenar jugadores por puntuación (de mayor a menor)
    final sortedPlayers = playerScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // 3. Insertar jugadores con sus posiciones y equipos
    int position = 1;
    for (final entry in sortedPlayers) {
      // Encontrar el equipo de este jugador
      final player = orderedPlayers.firstWhere(
        (p) => p.name == entry.key,
        orElse: () => null,
      );

      await db.insert('game_players', {
        'game_id': gameId,
        'player_name': entry.key,
        'score': entry.value,
        'position': position,
        'team': player?.team,
      });
      position++;
    }

    // 4. Insertar categorías jugadas
    for (final categoryName in categories) {
      await db.insert('game_categories', {
        'game_id': gameId,
        'category_name': categoryName,
      });
    }

    if (kDebugMode) {
      debugPrint("✅ Partida de equipos guardada con ID: $gameId");
      debugPrint("   Team 1: $team1Score puntos");
      debugPrint("   Team 2: $team2Score puntos");
      debugPrint("   Ganador: ${winnerTeam != null ? 'Equipo $winnerTeam' : 'Empate'}");
    }

    return gameId;
  }

  /// Obtiene todo el historial de partidas (más recientes primero)
  Future<List<Map<String, dynamic>>> getGameHistory() async {
    final db = await database;
    
    final games = await db.query(
      'game_history',
      orderBy: 'created_at DESC',
    );

    List<Map<String, dynamic>> historyList = [];

    for (final game in games) {
      final gameId = game['id'] as int;

      final players = await db.query(
        'game_players',
        where: 'game_id = ?',
        whereArgs: [gameId],
        orderBy: 'position ASC',
      );

      final categories = await db.query(
        'game_categories',
        where: 'game_id = ?',
        whereArgs: [gameId],
      );

      historyList.add({
        'id': game['id'],
        'date': game['date'],
        'game_mode': game['game_mode'],
        'created_at': game['created_at'],
        'winner_team': game['winner_team'],
        'team1_score': game['team1_score'],
        'team2_score': game['team2_score'],
        'players': players,
        'categories': categories,
      });
    }

    return historyList;
  }

  /// Obtiene una partida específica por ID
  Future<Map<String, dynamic>?> getGameById(int gameId) async {
    final db = await database;

    final games = await db.query(
      'game_history',
      where: 'id = ?',
      whereArgs: [gameId],
    );

    if (games.isEmpty) return null;

    final game = games.first;

    final players = await db.query(
      'game_players',
      where: 'game_id = ?',
      whereArgs: [gameId],
      orderBy: 'position ASC',
    );

    final categories = await db.query(
      'game_categories',
      where: 'game_id = ?',
      whereArgs: [gameId],
    );

    return {
      'id': game['id'],
      'date': game['date'],
      'game_mode': game['game_mode'],
      'created_at': game['created_at'],
      'winner_team': game['winner_team'],
      'team1_score': game['team1_score'],
      'team2_score': game['team2_score'],
      'players': players,
      'categories': categories,
    };
  }

  /// Elimina una partida del historial
  Future<void> deleteGameHistory(int gameId) async {
    final db = await database;
    await db.delete(
      'game_history',
      where: 'id = ?',
      whereArgs: [gameId],
    );
    
    if (kDebugMode) {
      debugPrint("🗑️ Partida $gameId eliminada del historial");
    }
  }

  /// Elimina todo el historial
  Future<void> clearAllHistory() async {
    final db = await database;
    await db.delete('game_history');
    
    if (kDebugMode) {
      debugPrint("🗑️ Todo el historial ha sido eliminado");
    }
  }

  /// Obtiene estadísticas generales (actualizada con equipos)
  Future<Map<String, dynamic>> getStatistics() async {
    final db = await database;

    // Total de partidas jugadas
    final totalGames = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM game_history'),
    ) ?? 0;

    // Jugador con más victorias (posición 1)
    final winnerQuery = await db.rawQuery('''
      SELECT player_name, COUNT(*) as wins
      FROM game_players
      WHERE position = 1
      GROUP BY player_name
      ORDER BY wins DESC
      LIMIT 1
    ''');

    String? topPlayer;
    int topPlayerWins = 0;
    if (winnerQuery.isNotEmpty) {
      topPlayer = winnerQuery.first['player_name'] as String;
      topPlayerWins = winnerQuery.first['wins'] as int;
    }

    // Equipo con más victorias
    final teamWinsQuery = await db.rawQuery('''
      SELECT winner_team, COUNT(*) as wins
      FROM game_history
      WHERE winner_team IS NOT NULL
      GROUP BY winner_team
      ORDER BY wins DESC
      LIMIT 1
    ''');

    int? topTeam;
    int topTeamWins = 0;
    if (teamWinsQuery.isNotEmpty) {
      topTeam = teamWinsQuery.first['winner_team'] as int;
      topTeamWins = teamWinsQuery.first['wins'] as int;
    }

    // Categoría más jugada
    final categoryQuery = await db.rawQuery('''
      SELECT category_name, COUNT(*) as times_played
      FROM game_categories
      GROUP BY category_name
      ORDER BY times_played DESC
      LIMIT 1
    ''');

    String? topCategory;
    int categoryPlays = 0;
    if (categoryQuery.isNotEmpty) {
      topCategory = categoryQuery.first['category_name'] as String;
      categoryPlays = categoryQuery.first['times_played'] as int;
    }

    return {
      'total_games': totalGames,
      'top_player': topPlayer,
      'top_player_wins': topPlayerWins,
      'top_team': topTeam,
      'top_team_wins': topTeamWins,
      'top_category': topCategory,
      'category_plays': categoryPlays,
    };
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

  Future<void> deleteCategory(String name) async {
    final db = await database;
    await db.delete(
      'category',
      where: 'name = ?',
      whereArgs: [name],
    );
  }
}