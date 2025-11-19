import '../datasources/app_database.dart';

class GameHistoryRepository {
  final AppDatabase _database = AppDatabase.instance;

  Future<int> saveIndividualGame({
    required String gameMode,
    required Map<String, int> playerScores,
    required List<String> categories,
  }) async {
    return await _database.saveGameHistory(
      gameMode: gameMode,
      playerScores: playerScores,
      categories: categories,
    );
  }

  Future<int> saveTeamGame({
    required String gameMode,
    required Map<String, int> playerScores,
    required List<dynamic> orderedPlayers,
    required List<String> categories,
  }) async {
    return await _database.saveTeamGameHistory(
      gameMode: gameMode,
      playerScores: playerScores,
      orderedPlayers: orderedPlayers,
      categories: categories,
    );
  }

  Future<List<Map<String, dynamic>>> getAllGames() async {
    return await _database.getGameHistory();
  }

  Future<Map<String, dynamic>?> getGameById(int gameId) async {
    return await _database.getGameById(gameId);
  }

  Future<void> deleteGame(int gameId) async {
    await _database.deleteGameHistory(gameId);
  }

  Future<void> clearAllHistory() async {
    await _database.clearAllHistory();
  }

  Future<int> getTotalGames() async {
    final history = await getAllGames();
    return history.length;
  }

  Future<List<Map<String, dynamic>>> getRecentGames({int limit = 10}) async {
    final allGames = await getAllGames();
    return allGames.take(limit).toList();
  }
}
