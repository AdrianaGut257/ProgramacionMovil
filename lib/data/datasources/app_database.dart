import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import '../models/player.dart';
import 'migrations/migration_manager.dart';

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
      onCreate: MigrationManager.onCreate,
      onUpgrade: MigrationManager.onUpgrade,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    await _database?.close();
    _database = null;

    await deleteDatabase(path);

    if (kDebugMode) {
      debugPrint('🗑️ Base de datos reiniciada');
    }
  }

  // ==================== MÉTODOS DE CATEGORÍAS ====================

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
    return await db.query('category', where: 'is_default = ?', whereArgs: [1]);
  }

  Future<List<Map<String, dynamic>>> getCustomCategories() async {
    final db = await database;
    return await db.query('category', where: 'is_default = ?', whereArgs: [0]);
  }

  Future<void> deleteCategory(String name) async {
    final db = await database;
    await db.delete('category', where: 'name = ?', whereArgs: [name]);
  }

  // ==================== MÉTODOS DE JUGADORES ====================

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

  // ==================== MÉTODOS DE HISTORIAL ====================

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
      debugPrint('✅ Partida individual guardada con ID: $gameId');
    }

    return gameId;
  }

  Future<int> saveTeamGameHistory({
    required String gameMode,
    required Map<String, int> playerScores,
    required List<dynamic> orderedPlayers,
    required List<String> categories,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

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

    int? winnerTeam;
    if (team1Score > team2Score) {
      winnerTeam = 1;
    } else if (team2Score > team1Score) {
      winnerTeam = 2;
    }

    final gameId = await db.insert('game_history', {
      'date': now,
      'game_mode': gameMode,
      'created_at': now,
      'winner_team': winnerTeam,
      'team1_score': team1Score,
      'team2_score': team2Score,
    });

    final sortedPlayers = playerScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    int position = 1;
    for (final entry in sortedPlayers) {
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

    for (final categoryName in categories) {
      await db.insert('game_categories', {
        'game_id': gameId,
        'category_name': categoryName,
      });
    }

    if (kDebugMode) {
      debugPrint('✅ Partida de equipos guardada con ID: $gameId');
      debugPrint('   Team 1: $team1Score puntos');
      debugPrint('   Team 2: $team2Score puntos');
      debugPrint(
        '   Ganador: ${winnerTeam != null ? 'Equipo $winnerTeam' : 'Empate'}',
      );
    }

    return gameId;
  }

  Future<List<Map<String, dynamic>>> getGameHistory() async {
    final db = await database;

    final games = await db.query('game_history', orderBy: 'created_at DESC');

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

  Future<void> deleteGameHistory(int gameId) async {
    final db = await database;
    await db.delete('game_history', where: 'id = ?', whereArgs: [gameId]);

    if (kDebugMode) {
      debugPrint('🗑️ Partida $gameId eliminada del historial');
    }
  }

  Future<void> clearAllHistory() async {
    final db = await database;
    await db.delete('game_history');

    if (kDebugMode) {
      debugPrint('🗑️ Todo el historial ha sido eliminado');
    }
  }

  // ==================== MÉTODOS DE ESTADÍSTICAS ====================

  Future<Map<String, dynamic>> getStatistics() async {
    final db = await database;

    final totalGames =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM game_history'),
        ) ??
        0;

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

  Future<List<Map<String, dynamic>>> getPlayerRankings() async {
    final db = await database;

    final rankings = await db.rawQuery('''
      SELECT 
        player_name,
        SUM(score) as total_points,
        COUNT(*) as games_played,
        SUM(CASE WHEN position = 1 THEN 1 ELSE 0 END) as victories
      FROM game_players
      GROUP BY player_name
      ORDER BY total_points DESC
    ''');

    if (kDebugMode) {
      debugPrint('📊 Ranking cargado: ${rankings.length} jugadores');
    }

    return rankings;
  }

  // ==================== MÉTODOS DE UTILIDAD ====================

  Future<void> fixDefaultCategories() async {
    final db = await database;
    await MigrationManager.markDefaultCategories(db);

    if (kDebugMode) {
      final defaults = await getDefaultCategories();
      debugPrint('✅ Total categorías predeterminadas: ${defaults.length}');
    }
  }
}
