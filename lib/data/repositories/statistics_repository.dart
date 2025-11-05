import '../datasources/app_database.dart';

/// Repositorio para obtener estadísticas del juego
/// Sigue el patrón de acceso indirecto a través de AppDatabase
class StatisticsRepository {
  final AppDatabase _database = AppDatabase.instance;

  /// Obtiene estadísticas generales del juego
  Future<Map<String, dynamic>> getGeneralStatistics() async {
    return await _database.getStatistics();
  }

  /// Obtiene el ranking completo de jugadores
  Future<List<Map<String, dynamic>>> getPlayerRankings() async {
    return await _database.getPlayerRankings();
  }

  /// Obtiene el top N de jugadores por victorias
  Future<List<Map<String, dynamic>>> getTopPlayers({int limit = 10}) async {
    final rankings = await getPlayerRankings();
    return rankings.take(limit).toList();
  }

  /// Obtiene estadísticas específicas de un jugador
  Future<Map<String, dynamic>?> getPlayerStats(String playerName) async {
    final rankings = await getPlayerRankings();
    try {
      return rankings.firstWhere(
        (player) => player['player_name'] == playerName,
      );
    } catch (e) {
      return null; // Jugador no encontrado
    }
  }
}