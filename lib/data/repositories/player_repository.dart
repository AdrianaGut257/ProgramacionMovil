import '../datasources/app_database.dart';
import '../models/player.dart';

class PlayerRepository {
  final AppDatabase _database = AppDatabase.instance;

  Future<void> insertPlayers(List<Player> players) async {
    await _database.insertPlayers(players);
  }

  Future<void> insertPlayer(Player player) async {
    await _database.insertPlayers([player]);
  }
}
