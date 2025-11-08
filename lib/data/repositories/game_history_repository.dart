import '../datasources/app_database.dart';

/// Repositorio para gestionar el historial de partidas
/// Sigue el patrón de acceso indirecto a través de AppDatabase
class GameHistoryRepository {
  final AppDatabase _database = AppDatabase.instance;

  /// Guarda una partida en modo INDIVIDUAL
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

  /// Guarda una partida en modo EQUIPOS
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

  /// Obtiene todo el historial de partidas
  Future<List<Map<String, dynamic>>> getAllGames() async {
    return await _database.getGameHistory();
  }

  /// Obtiene una partida específica por ID
  Future<Map<String, dynamic>?> getGameById(int gameId) async {
    return await _database.getGameById(gameId);
  }

  /// Elimina una partida específica
  Future<void> deleteGame(int gameId) async {
    await _database.deleteGameHistory(gameId);
  }

  /// Elimina todo el historial
  Future<void> clearAllHistory() async {
    await _database.clearAllHistory();
  }

  /// Cuenta el total de partidas jugadas
  Future<int> getTotalGames() async {
    final history = await getAllGames();
    return history.length;
  }

  /// Obtiene las últimas N partidas
  Future<List<Map<String, dynamic>>> getRecentGames({int limit = 10}) async {
    final allGames = await getAllGames();
    return allGames.take(limit).toList();
  }
}