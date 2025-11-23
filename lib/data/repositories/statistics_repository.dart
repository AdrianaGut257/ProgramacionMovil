import '../datasources/app_database.dart';

class StatisticsRepository {
  final AppDatabase _database = AppDatabase.instance;

  Future<Map<String, dynamic>> getGeneralStatistics() async {
    return await _database.getStatistics();
  }

  Future<List<Map<String, dynamic>>> getPlayerRankings() async {
    return await _database.getPlayerRankings();
  }

  Future<List<Map<String, dynamic>>> getTopPlayers({int limit = 10}) async {
    final rankings = await getPlayerRankings();
    return rankings.take(limit).toList();
  }

  Future<Map<String, dynamic>?> getPlayerStats(String playerName) async {
    final rankings = await getPlayerRankings();
    try {
      return rankings.firstWhere(
        (player) => player['player_name'] == playerName,
      );
    } catch (e) {
      return null;
    }
  }
}
